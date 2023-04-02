//
//  NavigationManager.swift
//  TVScribe
//
//  Created by Peter Sun on 3/27/23.
//

import Foundation
import SwiftUI

class NavigationManager: ObservableObject {
    
    @Published var tabSelection: Int = 0
    @Published var movieNavigationPath = NavigationPath()
    @Published var tvNavigationPath = NavigationPath()
    @Published var searchNavigationPath = NavigationPath()
    
    func showMovie(with id: Int) {
        tabSelection = 0
        movieNavigationPath = NavigationPath()
        movieNavigationPath.append(id)
    }
    
    func showTVShow(with id: Int) {
        tabSelection = 1
        tvNavigationPath = NavigationPath()
        tvNavigationPath.append(id)
    }
    
    func showCredit(with id: Int) {
        searchNavigationPath.append(id)
    }
}
