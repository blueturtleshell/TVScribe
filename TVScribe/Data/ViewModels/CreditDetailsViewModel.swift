//
//  CreditDetailsViewModel.swift
//  TVScribe
//
//  Created by Peter Sun on 3/23/23.
//

import Foundation

class CreditDetailsViewModel: ObservableObject {
    
    @Published private(set) var fetchState: FetchState = .waiting
    @Published var hasError = false
    @Published var error: MediaManagerError?
    
    var dataManager: DataManager?
    
    private var creditDetails: CreditDetails?
    
    var id: Int {
        creditDetails?.id ?? 0
    }
    
    var profileImageURL: URL? {
        guard let profilePath = creditDetails?.profilePath, !profilePath.isEmpty else { return nil }
        return ImageEndpoint.profile(size: .h632, path: profilePath).url()
    }
    
    var name: String {
        creditDetails?.name ?? ""
    }
    
    var biography: String {
        guard let biography = creditDetails?.biography, !biography.isEmpty else { return "Biography is not available" }
        return biography
    }
    
    var movieCastCredits: [CastCredit] {
        creditDetails?.combinedCredits.cast.filter { $0.mediaType == "movie" }.sorted() ?? []
    }
    
    var movieCrewCredits: [CrewCredit] {
        creditDetails?.combinedCredits.crew.filter { $0.mediaType == "movie" }.sorted() ?? []
    }
    
    var tvCastCredits: [CastCredit] {
        creditDetails?.combinedCredits.cast.filter { $0.mediaType == "tv" }.sorted() ?? []
    }
    
    var tvCrewCredits: [CrewCredit] {
        creditDetails?.combinedCredits.crew.filter { $0.mediaType == "tv" }.sorted() ?? []
    }
    
    // MARK: - Core Data
    
    var favoriteIcon: String {
        guard let creditDetails else { return "heart" }
        
        if let item = dataManager?.fetchSavedItem(with: String(creditDetails.id)) {
            return "heart\(item.isFavorite ? ".fill" : "")"
        }
        
        return "heart"
    }
    
    var bookmarkIcon: String {
        guard let creditDetails else { return "bookmark" }
        
        if let item = dataManager?.fetchSavedItem(with: String(creditDetails.id)) {
            return "bookmark\(item.isBookmark ? ".fill" : "")"
        }
        
        return "bookmark"
    }
    
    func favorite() {
        guard let creditDetails, let dataManager else { return }
        objectWillChange.send()
        
        if let item = dataManager.fetchSavedItem(with: String(creditDetails.id)) {
            dataManager.toggleFavorite(for: item)
        } else {
            dataManager.createSavedItem(id: id, name: name, posterURL: profileImageURL,type: .person, favorited: true)
        }
    }
    
    func bookmark() {
        guard let creditDetails, let dataManager else { return }
        objectWillChange.send()
        
        if let item = dataManager.fetchSavedItem(with: String(creditDetails.id)) {
            dataManager.toggleBookmark(for: item)
        } else {
            dataManager.createSavedItem(id: id, name: name, posterURL: profileImageURL, type: .person, bookmarked: true)
        }
    }
    
    // MARK: - Fetching
    
    @MainActor
    func fetchDetails(for personID: Int, creditFetchable: CreditFetchable) async {
        guard fetchState != .fetching else { return }
        do {
            fetchState = .fetching
            creditDetails = try await creditFetchable.fetchPersonDetails(for: personID)
            fetchState = .finished
        } catch {
            fetchState = .finished
            self.error = .specificError(error)
            self.hasError = true
        }
    }
}
