//
//  MediaManagerError.swift
//  TVScribe
//
//  Created by Peter Sun on 3/16/23.
//

import Foundation

enum MediaManagerError: Error {
    case invalidURL
    case unexpectedResponse
    case decodingError
    case specificError(Error)
}
