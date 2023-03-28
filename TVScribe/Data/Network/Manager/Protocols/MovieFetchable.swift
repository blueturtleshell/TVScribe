//
//  MovieFetchable.swift
//  TVScribe
//
//  Created by Peter Sun on 3/16/23.
//

import Foundation

protocol MovieFetchable {
    func fetchMovies(at endpoint: MovieEndpoint, page: Int) async throws -> MediaFetchResult
    func fetchMovieDetails(for id: Int) async throws -> MovieDetails
}
