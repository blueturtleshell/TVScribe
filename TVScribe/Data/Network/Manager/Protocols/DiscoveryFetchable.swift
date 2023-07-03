//
//  DiscoveryFetchable.swift
//  TVScribe
//
//  Created by Peter Sun on 4/18/23.
//

import Foundation

protocol DiscoveryFetchable {
    
    func discover(for endpoint: DiscoveryEndpoint, page: Int, genres: String?, peopleIDs: String?) async throws -> MediaFetchResult
}
