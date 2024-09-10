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
    var currentProcessedImage: CIImage?
    
    override init() {
        super.init()
    }
}
