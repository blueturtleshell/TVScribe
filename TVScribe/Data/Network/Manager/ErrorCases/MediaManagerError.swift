//
//  MediaManagerError.swift
//  TVScribe
//
//  Created by Peter Sun on 3/16/23.
//

import Foundation

enum MediaManagerError: LocalizedError {
    case invalidURL
    case unexpectedResponse
    case decodingError
    case specificError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "An error occurred due to an invalid URL."
        case .unexpectedResponse:
            return "An error occurred due to an unexpected response from the server."
        case .decodingError:
            return "An error occurred while decoding the data returned from the server."
        case .specificError(let error):
            return error.localizedDescription
        }
    }
}
