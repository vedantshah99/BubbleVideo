//
//  BubbleVideoApp.swift
//  BubbleVideo
//
//  Created by Vedant Shah on 9/6/24.
//

import SwiftUI

@main
struct BubbleVideoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
