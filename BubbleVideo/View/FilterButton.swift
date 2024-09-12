//
//  FilterButton.swift
//  BubbleVideo
//
//  Created by Vedant Shah on 9/11/24.
//

import SwiftUI
import StreamVideoSwiftUI

struct FilterButton: View {
    // import call View model and filterService
    
    @ObservedObject var viewModel: CallViewModel
    @ObservedObject var filtersService: FiltersService
    
    var body: some View {
        //Toggle that enables or disables the speech bubble
        HStack {
            Toggle("Apply filter", isOn: $filtersService.filtersActive)
                .onChange(of: filtersService.filtersActive, perform: { newValue in
                    
                    // If filter is applied
                    if newValue {
                        // enable the video filter
                        viewModel.setVideoFilter(filtersService.bubbleFilter)
                    } else {
                        viewModel.setVideoFilter(nil)
                    }
                })
                .frame(width: 150)
        }
        .padding()
        .background(
            .thinMaterial,
            in: RoundedRectangle(cornerRadius: 10, style: .continuous)
        )
        .padding(.horizontal)
    }
}

struct FilterButton_Previews: PreviewProvider {
    static var previews: some View {
        FilterButton(
            viewModel: CallViewModel(),
            filtersService: FiltersService()
        )
    }
}
