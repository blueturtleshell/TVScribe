//
//  SearchResult.swift
//  TVScribe
//
//  Created by Peter Sun on 3/31/23.
//

import Foundation

struct SearchResult: Codable {
    let page: Int
    let results: [SearchItem]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - SearchItem
struct SearchItem: Codable, Equatable {
    var specialID: String { "\(id)\(mediaType)" }
    let id: Int
    let title: String?
    let name: String?
    let posterPath: String?
    let mediaType: String
    let profilePath: String?
    let releaseDate: String?
    let firstAirDate: String?

    enum CodingKeys: String, CodingKey {
        case id, title, name
        case mediaType = "media_type"
        case profilePath = "profile_path"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case firstAirDate = "first_air_date"
    }
}
