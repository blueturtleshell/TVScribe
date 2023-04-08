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
    @StateObject var dataManager = DataManager()
    @StateObject var navigationManager = NavigationManager()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(mediaManager)
                .environmentObject(dataManager)
                .environmentObject(navigationManager)
        }
    }
}
