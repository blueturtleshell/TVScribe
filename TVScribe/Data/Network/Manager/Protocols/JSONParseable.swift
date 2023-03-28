//
//  JSONParseable.swift
//  TVScribe
//
//  Created by Peter Sun on 3/16/23.
//

import Foundation

protocol JSONParseable {
    
    func parse<T: Codable>(url: URL) async throws -> T
}
