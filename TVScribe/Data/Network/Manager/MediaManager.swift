//
//  MediaManager.swift
//  TVScribe
//
//  Created by Peter Sun on 3/16/23.
//

import SwiftUI

class MediaManager: ObservableObject, MovieFetchable {
    
    private let urlSession: URLSession
    private let jsonParser: JSONParseable
    
    init(urlSession: URLSession = .shared, jsonParser: JSONParseable) {
        self.urlSession = urlSession
        self.jsonParser = jsonParser
    }
    
    func fetchMovies(at endpoint: MovieEndpoint, page: Int) async throws -> MediaFetchResult {
        guard let url = endpoint.url(additionalParams: ["page": String(page)]) else { throw MediaManagerError.invalidURL }
        return try await jsonParser.parse(url: url)
    }
    
    func fetchMovieDetails(for id: Int) async throws -> MovieDetails {
        guard let url = DetailEndpoint.movie(id: id).url() else { throw MediaManagerError.invalidURL }
        return try await jsonParser.parse(url: url)
    }
}

extension MediaManager: CreditFetchable {
    func fetchPersonDetails(for personID: Int) async throws -> CreditDetails {
        guard let url = DetailEndpoint.person(id: personID).url() else { throw MediaManagerError.invalidURL }
        return try await jsonParser.parse(url: url)
    }
}
