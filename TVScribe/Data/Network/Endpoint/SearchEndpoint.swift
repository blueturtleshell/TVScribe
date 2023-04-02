//
//  SearchEndpoint.swift
//  TVScribe
//
//  Created by Peter Sun on 3/31/23.
//

import Foundation

enum SearchEndpoint: Endpoint {
    case all, person, movie, tv
    
    var path: String {
        
        let endpointPath: String
        switch self {
        case .all:
            endpointPath = "multi"
        case .person:
            endpointPath = "person"
        case .movie:
            endpointPath = "movie"
        case .tv:
            endpointPath = "tv"
        }
        
        return "/3/search/\(endpointPath)"
    }
    
    var params: [String : String] {
        return ["api_key": API.apiKey]
    }
}
