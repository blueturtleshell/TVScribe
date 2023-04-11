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
    @Published var accountNavigationPath = NavigationPath()
    
    func showMovie(with id: Int) {
        tabSelection = 0
        
        movieNavigationPath = NavigationPath()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.movieNavigationPath.append(id)
        }
    }
    
    func showTVShow(with id: Int) {
        tabSelection = 1
        tvNavigationPath = NavigationPath()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.tvNavigationPath.append(id)
        }
    }
    
    func showCreditFromSearch(with id: Int) {
        searchNavigationPath = NavigationPath()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.searchNavigationPath.append(id)
        }
    }
    
    func showCreditFromAccount(with id: Int) {
        accountNavigationPath = NavigationPath()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.accountNavigationPath.append(id)
        }
    }
}
