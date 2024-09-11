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
import DeepAR

@MainActor
class FiltersService: NSObject, ObservableObject {
    @Published var filtersActive = false
    @Published var selectedEffect: Effect = Effect.allCases.first!
    
    private var deepAR: DeepAR!
    var deepARFilter: VideoFilter!
    
    var currentProcessedImage: CIImage?
    
    override init() {
        super.init()
        
        // Initialize Deep AR
        self.deepAR = DeepAR()
        self.deepAR.setLicenseKey("4b222222f9ad410448a8827871c827872e3f5e637742934bbede7bb5c8683870b7da1baa6c1e343a")
        self.deepAR.delegate .self
        self.deepAR.changeLiveMode(false)
        
        // Createa filter for DeepAR and add it to supported filter
        deepARFilter = createDeepARFilter(deepAR: self.deepAR)
    }
    
    func createDeepARFilter(deepAR: DeepAR) -> VideoFilter {
        
        //  allows us to add filter over current image
        // Stream video SDK makes sure its applied and camera frames are processed
        let deepARVideoFilter = VideoFilter(id: "deep", name: "DeepAR") { [weak self] image in
            print("Image type: \(type(of: image))")

            if let uiImage = image as? UIImage,
               let ciImage = CIImage(image: uiImage) {
                let rotatedImage = ciImage.oriented(forExifOrientation: 6) // Apply 90-degree rotation
                
                if self?.deepAR.renderingInitialized == false {
                    self?.deepAR.initializeOffscreen(
                        withWidth: Int(rotatedImage.extent.width),
                        height: Int(rotatedImage.extent.height)
                    )
                    
                    guard let path = self?.selectedEffect.path else {
                        return rotatedImage // Fallback return value
                    }
                    
                    self?.deepAR.switchEffect(withSlot: "effect", path: path)
                }
                
                return rotatedImage // Return the processed image
                
            } else {
                print("Error: Unable to cast VideoFilter.Input to UIImage or convert UIImage to CIImage.")
                return CIImage() // Return an empty CIImage as a fallback
            }
        }
        return deepARVideoFilter
    }
}
