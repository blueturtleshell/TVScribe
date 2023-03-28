//
//  API.swift
//  TVScribe
//
//  Created by Peter Sun on 3/16/23.
//

import Foundation

struct API {
    static let host = "api.themoviedb.org"
    static let imageHost = "image.tmdb.org"
    static let apiKey = Secrets.apiKey
    
    struct ImageSizes {
        enum Backdrop: String {
            case w300, w780, w1280, original
        }

        enum Logo: String {
            case w45, w92, w154, w185, w300, w500, original
        }
         
        enum Poster: String {
            case w92, w154, w185, w342, w500, w780, original
        }

        enum Profile: String {
            case w45, w185, h632, original
        }

        enum Still: String {
            case w92, w185, w300, original
        }
    }

    static func getGenreName(forCode code: Int) -> String {
        switch code {
        case 28:
            return "Action"
        case 12:
            return "Adventure"
        case 16:
            return "Animation"
        case 35:
            return "Comedy"
        case 80:
            return "Crime"
        case 99:
            return "Documentary"
        case 18:
            return "Drama"
        case 10751:
            return "Family"
        case 14:
            return "Fantasy"
        case 36:
            return "History"
        case 27:
            return "Horror"
        case 10402:
            return "Music"
        case 9648:
            return "Mystery"
        case 10749:
            return "Romance"
        case 878:
            return "Science Fiction"
        case 10770:
            return "TV Movie"
        case 53:
            return "Thriller"
        case 10752:
            return "War"
        case 37:
            return "Western"
        default:
            return ""
        }
    }
}
