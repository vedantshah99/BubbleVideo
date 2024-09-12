//
//  FiltersService.swift
//  BubbleVideo
//
//  Created by Vedant Shah on 9/9/24.
//

import Foundation
import SwiftUI
import StreamVideo
import CoreImage
import Vision

@MainActor
class FiltersService: NSObject, ObservableObject {
    @Published var filtersActive = false
    
    var bubbleFilter: VideoFilter!
    
    // the original image in case the filtered one doesn't work
    var currentProcessedImage: CIImage?
    
    override init() {
        super.init()
        
        bubbleFilter = createBubbleFilter()
    }
    
    let bubbleImage = UIImage(systemName: "bubble.fill")!
    
    func detectFaces(image: CIImage) async throws -> CGRect {
        return try await withCheckedThrowingContinuation { continuation in
            let detectFaceRequest = VNDetectFaceRectanglesRequest { (request, error) in
                if let result = request.results?.first as? VNFaceObservation {
                    continuation.resume(returning: result.boundingBox)
                } else {
                    continuation.resume(throwing: ClientError.Unknown())
                }
            }
            let vnImage = VNImageRequestHandler(ciImage: image, orientation: .downMirrored)
            try? vnImage.perform([detectFaceRequest])
        }
    }
    
    func convert(ciImage: CIImage) -> UIImage {
        let context = CIContext(options: nil)
        let cgImage = context.createCGImage(ciImage, from: ciImage.extent)!
        let image = UIImage(cgImage: cgImage, scale: 1, orientation: .up)
        return image
    }

    @MainActor
    func drawImageIn(_ image: UIImage, size: CGSize, _ logo: UIImage, inRect: CGRect) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        format.opaque = true
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        return renderer.image { context in
            image.draw(in: CGRect(origin: CGPoint.zero, size: size))
            logo.draw(in: inRect)
        }
    }
    
    func createBubbleFilter() -> VideoFilter {
        
        let stream: VideoFilter = {
            let stream = VideoFilter(id: "stream", name: "Stream") { input in
                // 1. detect, where the face is located (if there's any)
                guard let faceRect = try? await self.detectFaces(image: input.originalImage) else { return input.originalImage }
                let converted = self.convert(ciImage: input.originalImage)
                let bounds = input.originalImage.extent
                let convertedRect = CGRect(
                    x: faceRect.minX * bounds.width - 80,
                    y: faceRect.minY * bounds.height,
                    width: faceRect.width * bounds.width,
                    height: faceRect.height * bounds.height
                )
                // 2. Overlay the rectangle onto the original image
                let overlayed = self.drawImageIn(converted, size: bounds.size, self.bubbleImage, inRect: convertedRect)

                // 3. convert the created image to a CIImage
                let result = CIImage(cgImage: overlayed.cgImage!)
                return result
            }
            return stream
        }()
        return stream
    }
}
