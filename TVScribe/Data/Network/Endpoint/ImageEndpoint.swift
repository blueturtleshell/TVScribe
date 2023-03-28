//
//  ImageEndpoint.swift
//  TVScribe
//
//  Created by Peter Sun on 3/17/23.
//

import Foundation

enum ImageEndpoint: Endpoint {
    
    case backdrop(size: API.ImageSizes.Backdrop, path: String)
    case poster(size: API.ImageSizes.Poster, path: String)
    case logo(size: API.ImageSizes.Logo, path: String)
    case profile(size: API.ImageSizes.Profile, path: String)
    case still(size: API.ImageSizes.Still, path: String)
    
    //https://image.tmdb.org/t/p/w500/kqjL17yufvn9OVLyXYpvtyrFfak.jpg
    
    var host: String {
        API.imageHost
    }
    
    var path: String {
        let size: String
        let path: String
        
        switch self {
        case .backdrop(let backdropSize, let backdropPath):
            size = backdropSize.rawValue
            path = backdropPath
        case .poster(let posterSize, let posterPath):
            size = posterSize.rawValue
            path = posterPath
        case .logo(let logoSize, let posterPath):
            size = logoSize.rawValue
            path = posterPath
        case .profile(let profileSize, let profilePath):
            size = profileSize.rawValue
            path = profilePath
        case .still(let stillSize, let stillPath):
            size = stillSize.rawValue
            path = stillPath
        }
        
        return "/t/p/\(size)\(path)"
    }
    
    var params: [String : String] {
        [:]
    }
}
