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
    
    func createBubbleFilter() -> VideoFilter {
        
        //  allows us to add filter over current image
        // Stream video SDK makes sure its applied and camera frames are processed
        let deepARVideoFilter = VideoFilter(id: "deep", name: "DeepAR") { [weak self] image in
            print("Image type: \(type(of: image))")
            return CIImage()
//
//            if let uiImage = image as? UIImage,
//               let ciImage = CIImage(image: uiImage) {
//                let rotatedImage = ciImage.oriented(forExifOrientation: 6) // Apply 90-degree rotation
//                
//                if self?.deepAR.renderingInitialized == false {
//                    self?.deepAR.initializeOffscreen(
//                        withWidth: Int(rotatedImage.extent.width),
//                        height: Int(rotatedImage.extent.height)
//                    )
//                    
//                    guard let path = self?.selectedEffect.path else {
//                        return rotatedImage // Fallback return value
//                    }
//                    
//                    self?.deepAR.switchEffect(withSlot: "effect", path: path)
//                }
//                
//                return rotatedImage // Return the processed image
//                
//            } else {
//                print("Error: Unable to cast VideoFilter.Input to UIImage or convert UIImage to CIImage.")
//                return CIImage() // Return an empty CIImage as a fallback
//            }
        }
        return deepARVideoFilter
    }
}
