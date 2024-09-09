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
    @State var call: Call
    @ObservedObject var state: CallState
    @State var callCreated: Bool = false

    private var client: StreamVideo

    private let apiKey: String = "mmhfdzb5evj2"
    private let token: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJodHRwczovL3Byb250by5nZXRzdHJlYW0uaW8iLCJzdWIiOiJ1c2VyL0NvdW50X0Rvb2t1IiwidXNlcl9pZCI6IkNvdW50X0Rvb2t1IiwidmFsaWRpdHlfaW5fc2Vjb25kcyI6NjA0ODAwLCJpYXQiOjE3MjU5MDk1NzksImV4cCI6MTcyNjUxNDM3OX0.NLbfUmfCY03yHH5QmliaHicxQAWWub5etOuzAwJ2ucc"
    private let userId: String = "Count_Dooku"
    private let callId: String = "Ht24dSWFN3Ui"

    init() {
        let user = User(
            id: userId,
            name: "Martin", // name and imageURL are used in the UI
            imageURL: .init(string: "https://getstream.io/static/2796a305dd07651fcceb4721a94f4505/a3911/martin-mitrevski.webp")
        )

        // Initialize Stream Video client
        self.client = StreamVideo(
            apiKey: apiKey,
            user: user,
            token: .init(stringLiteral: token)
        )

        // Initialize the call object
        let call = client.call(callType: "default", callId: callId)

        self.call = call
        self.state = call.state
    }

    var body: some Scene {
        WindowGroup {
            VStack {
                if callCreated {
                    Text("Call \(call.callId) has \(call.state.participants.count) participants")
                        .font(.system(size: 30))
                        .foregroundColor(.blue)
                } else {
                    Text("loading...")
                }
            }.onAppear {
                Task {
                    guard !callCreated else { return }
                    try await call.join(create: true)
                    callCreated = true
                }
            }
        }
    }
    
    
    /// Changes the track visibility for a participant (not visible if they go off-screen).
    /// - Parameters:
    ///  - participant: the participant whose track visibility would be changed.
    ///  - isVisible: whether the track should be visible.
    private func changeTrackVisibility(_ participant: CallParticipant?, isVisible: Bool) {
        guard let participant else { return }
        Task {
            await call.changeTrackVisibility(for: participant, isVisible: isVisible)
        }
    }
}


