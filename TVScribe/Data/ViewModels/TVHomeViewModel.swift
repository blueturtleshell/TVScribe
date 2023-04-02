//
//  TVHomeViewModel.swift
//  TVScribe
//
//  Created by Peter Sun on 3/28/23.
//

import Foundation

class TVHomeViewModel: ObservableObject {
    @Published var category: TVCategory = .airingToday
    @Published private(set) var tvShows: [MediaItem] = []
    @Published var fetchState: FetchState = .waiting
    @Published var hasError = false
    @Published var error: MediaManagerError?

    private let fetchThreshold = 5
    
    private var page = 1
    private var totalPages = Int.max
    
    @MainActor
    func fetchTVShows(mediaManager: TVFetchable) async {
        guard fetchState != .fetching, page <= totalPages else { return }
        
        do {
            fetchState = .fetching
            let fetchedResult = try await mediaManager.fetchTVShows(at: category.endpoint, page: page)
            page = fetchedResult.page + 1
            totalPages = fetchedResult.totalPages
            tvShows += fetchedResult.results
            fetchState = .finished
        } catch {
            fetchState = .finished
            self.error = MediaManagerError.specificError(error)
            hasError = true
        }
    }
    
    @MainActor
    func fetchNextPageIfNecessary(at mediaItem: MediaItem, mediaManager: TVFetchable) async {
        guard let index = tvShows.firstIndex(of: mediaItem) else { return }
        let thresholdIndex = tvShows.index(tvShows.endIndex, offsetBy: -fetchThreshold)
        
        if index == thresholdIndex {
            await fetchTVShows(mediaManager: mediaManager)
        }
    }
    
    func reset() {
        page = 1
        totalPages = Int.max
        tvShows = []
    }
}
