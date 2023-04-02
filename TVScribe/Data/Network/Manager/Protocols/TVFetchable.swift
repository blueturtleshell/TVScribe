//
//  TVFetchable.swift
//  TVScribe
//
//  Created by Peter Sun on 3/28/23.
//

import Foundation

protocol TVFetchable {
    func fetchTVShows(at endpoint: TVEndpoint, page: Int) async throws -> MediaFetchResult
    func fetchTVDetails(for id: Int) async throws -> TVShowDetails
    func fetchSeasonDetails(for showID:Int, season seasonNumber: Int) async throws -> SeasonDetails
} 
