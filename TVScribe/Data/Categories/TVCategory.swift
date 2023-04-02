//
//  TVCategory.swift
//  TVScribe
//
//  Created by Peter Sun on 4/2/23.
//

import Foundation

enum TVCategory: CaseIterable {
    case airingToday
    case onTheAir
    case popular
    case topRated
    
    var name: String {
        switch self {
        case .airingToday: return "Today"
        case .onTheAir: return "Week"
        case .popular: return "Popular"
        case .topRated: return "Top Rated"
        }
    }
    
    var endpoint: TVEndpoint {
        switch self {
        case .airingToday: return .airingToday
        case .onTheAir: return .onTheAir
        case .popular: return .popular
        case .topRated: return .topRated
        }
    }
}
