//
//  CreditDetailsViewModel.swift
//  TVScribe
//
//  Created by Peter Sun on 3/23/23.
//

import Foundation

class CreditDetailsViewModel: ObservableObject {
    
    @Published private(set) var fetching = false
    private var creditDetails: CreditDetails?
    
    var profileImageURL: URL? {
        guard let profilePath = creditDetails?.profilePath, !profilePath.isEmpty else { return nil }
        return ImageEndpoint.profile(size: .h632, path: profilePath).url()
    }
    
    var name: String {
        creditDetails?.name ?? ""
    }
    
    var biography: String {
        guard let biography = creditDetails?.biography, !biography.isEmpty else { return "N/A" }
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
    
    @MainActor
    func fetchDetails(for personID: Int, creditFetchable: CreditFetchable) async {
        guard !fetching else { return }
        do {
            fetching = true
            creditDetails = try await creditFetchable.fetchPersonDetails(for: personID)
            fetching = false
        } catch {
            print(error)
        }
    }
}
