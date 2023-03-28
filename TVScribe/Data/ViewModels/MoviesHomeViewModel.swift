//
//  MoviesHomeViewModel.swift
//  TVScribe
//
//  Created by Peter Sun on 3/22/23.
//

import Foundation
import Combine

class MoviesHomeViewModel: ObservableObject {
    @Published var category: MovieCategory = .nowPlaying
    @Published private(set) var movies: [MediaItem] = []
    @Published var fetching = false
    private let fetchThreshold = 5
    
    private var page = 1
    private var totalPages = Int.max
    
    @MainActor
    func fetchMovies(mediaManager: MovieFetchable) async {
        guard !fetching, page <= totalPages else { return }
        
        do {
            fetching = true
            let fetchedResult = try await mediaManager.fetchMovies(at: category.endpoint, page: page)
            page = fetchedResult.page + 1
            totalPages = fetchedResult.totalPages
            movies += fetchedResult.results
            fetching = false
        } catch {
            print(error)
        }
    }
    
    @MainActor
    func fetchNextPageIfNecessary(at mediaItem: MediaItem, mediaManager: MovieFetchable) async {
        guard let index = movies.firstIndex(of: mediaItem) else { return }
        let thresholdIndex = movies.index(movies.endIndex, offsetBy: -fetchThreshold)
        
        if index == thresholdIndex {
            await fetchMovies(mediaManager: mediaManager)
        }
    }
    
    func reset() {
        page = 1
        totalPages = Int.max
        movies = []
    }
}
