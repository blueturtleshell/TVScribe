//
//  CreditViewModel.swift
//  TVScribe
//
//  Created by Peter Sun on 3/17/23.
//

import Foundation

class CreditViewModel {
    
    private let credit: Credit
    
    init(credit: Credit) {
        self.credit = credit
    }
    
    var name: String {
        credit.name
    }
    
    var role: String {
        credit.character ?? credit.job ?? "N/A"
    }
    
    var profileURL: URL? {
        guard let profileURL = credit.profilePath, !profileURL.isEmpty else { return nil }
        return ImageEndpoint.profile(size: .w185, path: profileURL).url()
    }
}
