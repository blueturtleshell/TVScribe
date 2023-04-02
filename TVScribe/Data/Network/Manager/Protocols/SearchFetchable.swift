//
//  SearchFetchable.swift
//  TVScribe
//
//  Created by Peter Sun on 3/31/23.
//

import Foundation

protocol SearchFetchable {
    
    func search(query: String, page: Int, type: SearchEndpoint) async throws -> SearchResult
}
