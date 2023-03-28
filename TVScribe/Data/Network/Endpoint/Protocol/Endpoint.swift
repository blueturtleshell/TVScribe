//
//  Endpoint.swift
//  TVScribe
//
//  Created by Peter Sun on 3/16/23.
//

import Foundation

protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var httpMethod: String { get }
    var params: [String: String] { get }
    
    func url(additionalParams: [String: String]) -> URL?
}

extension Endpoint {
    var scheme: String {
        "https"
    }
    
    var host: String {
        API.host
    }
    
    var httpMethod: String {
        "GET"
    }
    
    func url(additionalParams: [String: String] = [:]) -> URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        
        var queryItems = [URLQueryItem]()
        for (key, value) in params {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        
        for (key, value) in additionalParams {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        
        components.queryItems = queryItems
        
        return components.url
    }
}
