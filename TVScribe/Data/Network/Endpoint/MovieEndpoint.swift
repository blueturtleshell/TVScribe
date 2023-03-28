//
//  MovieEndpoint.swift
//  TVScribe
//
//  Created by Peter Sun on 3/16/23.
//

import Foundation

enum MovieEndpoint: Endpoint, CaseIterable {
    
    case nowPlaying, popular, topRated, upcoming
    
    var path: String {
        let endpointPath: String
        switch self {
        case .nowPlaying:
            endpointPath = "now_playing"
        case .popular:
            endpointPath = "popular"
        case .topRated:
            endpointPath = "top_rated"
        case .upcoming:
            endpointPath = "upcoming"
        }
        return "/3/movie/\(endpointPath)"
    }
    
    var params: [String : String] {
        return ["api_key": API.apiKey]
    }
    
    var title: String {
        switch self {
        case .nowPlaying:
            return "Now Playing"
        case .popular:
            return "Popular"
        case .topRated:
            return "Top Rated"
        case .upcoming:
            return "Upcoming"
        }
    }
}
