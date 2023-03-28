//
//  MediaFetchResult.swift
//  TVScribe
//
//  Created by Peter Sun on 3/16/23.
//

import Foundation

struct MediaFetchResult: Codable {
    let page: Int
    let results: [MediaItem]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
