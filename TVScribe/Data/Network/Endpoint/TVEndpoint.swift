//
//  TVEndpoint.swift
//  TVScribe
//
//  Created by Peter Sun on 3/28/23.
//

import Foundation


enum TVEndpoint: Endpoint, CaseIterable {
    case airingToday, onTheAir, popular, topRated
    
    var path: String {
        let endpointPath: String
        switch self {
        case .airingToday:
            endpointPath = "airing_today"
        case .onTheAir:
            endpointPath = "on_the_air"
        case .popular:
            endpointPath = "popular"
        case .topRated:
            endpointPath = "top_rated"
        }
        
        return "/3/tv/\(endpointPath)"
    }
    
    var params: [String : String] {
        return ["api_key": API.apiKey]
    }
}
