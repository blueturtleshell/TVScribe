//
//  DiscoveryEndpoint.swift
//  TVScribe
//
//  Created by Peter Sun on 4/18/23.
//

import Foundation

enum DiscoveryEndpoint: Endpoint {

    case movie
    case tv
    
    var path: String {
        let endpointPath: String
        
        switch self {
        case .movie:
            endpointPath = "movie"
        case .tv:
            endpointPath = "tv"
        }
        
        return "/3/discover/\(endpointPath)"
    }
    
    var params: [String : String] {
        ["api_key": API.apiKey]
    }
}
