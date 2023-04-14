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
    @Published var fetchState: FetchState = .waiting
    @Published var hasError = false
    @Published var error: MediaManagerError?
    
    private var page = 1
    private var totalPages = Int.max
    private let fetchThreshold = 5

    @MainActor
    func fetchMovies(mediaManager: MovieFetchable) async {
        guard fetchState != .fetching, page <= totalPages else { return }
                
        do {
            fetchState = .fetching
            let fetchedResult = try await mediaManager.fetchMovies(at: category.endpoint, page: page)
            page = fetchedResult.page + 1
            totalPages = fetchedResult.totalPages
            movies += fetchedResult.results
            fetchState = .finished
        } catch {
            fetchState = .finished
            self.error = MediaManagerError.specificError(error)
            hasError = true
        }
    }
    
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
