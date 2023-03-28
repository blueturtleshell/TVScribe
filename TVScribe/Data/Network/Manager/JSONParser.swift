//
//  JSONParser.swift
//  TVScribe
//
//  Created by Peter Sun on 3/16/23.
//

import Foundation

class JSONParser: JSONParseable {
    
    let urlSession: URLSession
        
    private lazy var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func parse<T: Codable>(url: URL) async throws -> T {
        do {
            let (data, response) = try await urlSession.data(from: url)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                throw MediaManagerError.unexpectedResponse
            }

            let parsedResult = try jsonDecoder.decode(T.self, from: data)
            return parsedResult
            
        } catch {
            throw MediaManagerError.specificError(error)
        }
    }
}
