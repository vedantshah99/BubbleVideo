//
//  ContentView.swift
//  BubbleVideo
//
//  Created by Vedant Shah on 9/6/24.
//

import SwiftUI
import CoreData
import StreamVideo
import StreamVideoSwiftUI

struct ContentView: View {
    
    // inject stream video object
    @Injected(\.streamVideo) var streamVideo
    
    @ObservedObject var filtersService: FiltersService
    
    // import call view model (will handle all call functionality for us
    @StateObject var callViewModel = CallViewModel()
    @State var callId = ""

    var body: some View {
        // Video Call Display
        ZStack(alignment: .top) {
            VStack {
                TextField("Insert a call id", text: $callId)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                
                Button {
                    resignFirstResponder()
                    callViewModel.startCall(
                        callType: "default",
                        callId: callId,
                        members: []
                    )
                } label: {
                    Text("start call")
                }
            }
            .padding()
            // modify UI of call
            .modifier(CallModifier(viewModel: callViewModel))
        }
        
        // Filter Button
        if callViewModel.callingState == .inCall {
            FilterButton(viewModel: callViewModel, filtersService: filtersService)
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(filtersService: FiltersService())
    }
}
