//
//  TVScribeApp.swift
//  TVScribe
//
//  Created by Peter Sun on 3/23/23.
//

import SwiftUI

@main
struct TVScribeApp: App {
    
    @StateObject var mediaManager = MediaManager(jsonParser: JSONParser())
    
    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(mediaManager)
        }
    }
}
