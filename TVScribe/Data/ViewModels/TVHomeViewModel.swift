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
    @Published var fetching = false
    private let fetchThreshold = 5
    
    private var page = 1
    private var totalPages = Int.max
    
    @MainActor
    func fetchTVShows(mediaManager: TVFetchable) async {
        guard !fetching, page <= totalPages else { return }
        
        do {
            fetching = true
            let fetchedResult = try await mediaManager.fetchTVShows(at: category.endpoint, page: page)
            page = fetchedResult.page + 1
            totalPages = fetchedResult.totalPages
            tvShows += fetchedResult.results
            fetching = false
        } catch {
            print(error)
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
