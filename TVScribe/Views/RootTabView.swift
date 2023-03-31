//
//  RootTabView.swift
//  TVScribe
//
//  Created by Peter Sun on 3/23/23.
//

import SwiftUI

struct RootTabView: View {
    
    @StateObject var navigationManager = NavigationManager()

    var body: some View {
        TabView(selection: $navigationManager.tabSelection) {
            NavigationStack(path: $navigationManager.movieNavigationPath) {
                MoviesHomeView()
            }
            .tabItem {
                Label("Movies", systemImage: "film")
            }
            .tag(0)
                
            NavigationStack(path: $navigationManager.tvNavigationPath) {
                TVHomeView()
            }
            .tabItem {
                Label("TV Shows", systemImage: "tv")
            }
            .tag(1)
        }
        .environmentObject(navigationManager)
    }
}

struct RootTabView_Previews: PreviewProvider {
    static var previews: some View {
        RootTabView()
            .environmentObject(MediaManager(jsonParser: JSONParser()))
    }
}
