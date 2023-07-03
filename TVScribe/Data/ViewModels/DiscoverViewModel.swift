//
//  DiscoverViewModel.swift
//  TVScribe
//
//  Created by Peter Sun on 4/22/23.
//

import Foundation
import Combine


class DiscoverViewModel: ObservableObject {
    
    var discoverFetchable: DiscoveryFetchable?
    
    @Published var discoverType: DiscoverType = .movie
    @Published var discoveryItems: [MediaItem] = []
    
    @Published var selectedGenres: [API.Genre] = [] {
        didSet {
            UserDefaults.standard.favoriteGenres = selectedGenres
        }
    }
    
    @Published var selectedPeopleIDs: [String] = [] {
        didSet {
            UserDefaults.standard.favoritePeopleIDs = selectedPeopleIDs
        }
    }
    
    @Published private(set) var fetchState: FetchState = .waiting
    @Published private(set) var hasError = false
    @Published private(set) var error: Error?
    
    private var page = 1
    private var totalPages = Int.max
    private let fetchThreshold = 5
    
    private var genres: String {
        selectedGenres.map{ $0.name }.joined(separator: ",")
    }
    
    private var peopleIDs: String {
        selectedPeopleIDs.joined(separator: ",")
    }
    
    private var discoverSubscription: AnyCancellable?
    
    init() {
        UserDefaults.standard.register(defaults: ["favorite_genres": API.Genre.allCases.map { $0.rawValue }])

        selectedGenres = UserDefaults.standard.favoriteGenres
        selectedPeopleIDs = UserDefaults.standard.favoritePeopleIDs
        
        discoverSubscription = Publishers.CombineLatest($selectedGenres, $selectedPeopleIDs)
            .sink { [weak self] _ in
                guard let self else { return }
                
                self.reset()
                
                Task {
                    await self.discover()
                }
            }
    }
    
    @MainActor
    func discover() async {
        guard let discoverFetchable, fetchState != .fetching, page <= totalPages else { return }
                
        do {
            fetchState = .fetching
            let fetchedResult = try await discoverFetchable.discover(for: discoverType.endpoint, page: page,
                                                                     genres: genres, peopleIDs: peopleIDs)
            page = fetchedResult.page + 1
            totalPages = fetchedResult.totalPages
            discoveryItems += fetchedResult.results
            fetchState = .finished
        } catch {
            fetchState = .finished
            self.error = MediaManagerError.specificError(error)
            hasError = true
        }
    }
    
    func fetchNextPageIfNecessary(at mediaItem: MediaItem) async {
        guard let index = discoveryItems.firstIndex(of: mediaItem) else { return }
        let thresholdIndex = discoveryItems.index(discoveryItems.endIndex, offsetBy: -fetchThreshold)
        
        if index == thresholdIndex {
            await discover()
        }
    }
    
    func reset() {
        page = 1
        totalPages = Int.max
        discoveryItems = []
    }
}
