//
//  BubbleVideoApp.swift
//  BubbleVideo
//
//  Created by Vedant Shah on 9/6/24.
//

import SwiftUI
import StreamVideo
import StreamVideoSwiftUI

@main
struct VideoCallApp: App {
    
    @State var streamVideo: StreamVideoUI?
    
    private func setupStreamVideo(
        with apiKey: String,
        userCredentials: UserCredentials
    ) {
        streamVideo = StreamVideoUI (
            apiKey: apiKey,
            user: userCredentials.user,
            token: userCredentials.token,
            tokenProvider: { result in
                result(.success(userCredentials.token))
            }
        )
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    setupStreamVideo(with: "23rd9c8c88cu", userCredentials: .demoUser)
                }
        }
    }
    
}


