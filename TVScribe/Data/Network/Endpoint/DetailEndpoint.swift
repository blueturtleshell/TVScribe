//
//  DetailEndpoint.swift
//  TVScribe
//
//  Created by Peter Sun on 3/17/23.
//

import Foundation

enum DetailEndpoint: Endpoint {
    case movie(id: Int)
    case tv(id: Int)
    case season(showID: Int, seasonNumber: Int)
    case person(id: Int)
    
    var path: String {
        switch self {
        case .movie(let id):
            return "/3/movie/\(id)"
        case .tv(let id):
            return "/3/tv/\(id)"
        case .season(let showID, let seasonNumber):
            return "/3/tv/\(showID)/season/\(seasonNumber)"
        case .person(let id):
            return "/3/person/\(id)"
        }
    }
    
    var params: [String : String] {
        switch self {
        case .movie:
            return ["api_key": API.apiKey, "append_to_response": "recommendations,credits,reviews,videos,release_dates,watch/providers"]
        case .tv:
            return ["api_key": API.apiKey, "append_to_response": "recommendations,credits,reviews,videos,content_ratings"]
        case .season:
            return ["api_key": API.apiKey]
        case .person:
            return ["api_key": API.apiKey, "append_to_response": "combined_credits"]
        }
    }
}
