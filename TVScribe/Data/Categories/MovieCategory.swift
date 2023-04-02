//
//  MovieCategory.swift
//  TVScribe
//
//  Created by Peter Sun on 4/2/23.
//

import Foundation

enum MovieCategory: CaseIterable {
    case nowPlaying
    case popular
    case upcoming
    case topRated
    
    var name: String {
        switch self {
        case .nowPlaying: return "Now Playing"
        case .popular: return "Popular"
        case .upcoming: return "Upcoming"
        case .topRated: return "Top Rated"
        }
    }
    
    var endpoint: MovieEndpoint {
        switch self {
        case .nowPlaying: return .nowPlaying
        case .popular: return .popular
        case .upcoming: return .upcoming
        case .topRated: return .topRated
        }
    }
}

