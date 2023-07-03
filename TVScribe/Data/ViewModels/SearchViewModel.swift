//
//  SearchViewModel.swift
//  TVScribe
//
//  Created by Peter Sun on 4/1/23.
//

import Foundation

class SearchViewModel: ObservableObject {
    @Published var query = ""
    @Published var scope: SearchScope = .all
    @Published private(set) var fetchState: FetchState = .waiting
    @Published private(set) var searchItems = [SearchItem]()
    @Published private(set) var noResultsFound = false
    @Published private(set) var previousQuery = ""
    @Published private(set) var error: Error?
    
    private var page = 1
    private var totalPages = Int.max
    private let fetchThreshold = 5
    
    @MainActor
    func performSearch(searchFetchable: SearchFetchable) async {
        guard fetchState != .fetching, page <= totalPages else { return }
        
        previousQuery = query
        
        do {
            fetchState = .fetching
            let searchResult = try await searchFetchable.search(query: query, page: page, type: scope.endpoint)
            page = searchResult.page + 1
            totalPages = searchResult.totalPages
            
            let duplicateItems = searchResult.results.filter { !searchItems.contains($0) }
            searchItems += duplicateItems
            
            noResultsFound = searchItems.isEmpty
            
            fetchState = .finished
        } catch {
            self.error = error
            print(error)
        }
    }
    
    @MainActor
    func fetchNextPageIfNecessary(at searchItem: SearchItem, searchFetchable: SearchFetchable) async {
        guard let index = searchItems.firstIndex(of: searchItem) else { return }
        let thresholdIndex = searchItems.index(searchItems.endIndex, offsetBy: -fetchThreshold)
        
        if index == thresholdIndex {
            await performSearch(searchFetchable: searchFetchable)
        }
    }
    
    func reset() {
        page = 1
        totalPages = Int.max
        noResultsFound = false
        searchItems = []
        fetchState = .waiting
    }
}
