//
//  CreditFetchable.swift
//  TVScribe
//
//  Created by Peter Sun on 3/22/23.
//

import Foundation

protocol CreditFetchable {
    func fetchPersonDetails(for personID: Int) async throws -> CreditDetails
}
