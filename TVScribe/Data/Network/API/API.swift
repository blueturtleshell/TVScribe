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
    
    enum Genre: Int, CaseIterable {
        case action = 28
        case adventure = 12
        case animation = 16
        case comedy = 35
        case crime = 80
        case documentary = 99
        case drama = 18
        case family = 10751
        case fantasy = 14
        case history = 36
        case horror = 27
        case music = 10402
        case mystery = 9648
        case romance = 10749
        case scienceFiction = 878
        case tvMovie = 10770
        case thriller = 53
        case war = 10752
        case western = 37
        
        var name: String {
            switch self {
            case .action:
                return "Action"
            case .adventure:
                return "Adventure"
            case .animation:
                return "Animation"
            case .comedy:
                return "Comedy"
            case .crime:
                return "Crime"
            case .documentary:
                return "Documentary"
            case .drama:
                return "Drama"
            case .family:
                return "Family"
            case .fantasy:
                return "Fantasy"
            case .history:
                return "History"
            case .horror:
                return "Horror"
            case .music:
                return "Music"
            case .mystery:
                return "Mystery"
            case .romance:
                return "Romance"
            case .scienceFiction:
                return "Science Fiction"
            case .tvMovie:
                return "TV Movie"
            case .thriller:
                return "Thriller"
            case .war:
                return "War"
            case .western:
                return "Western"
            }
        }

        static func getGenreName(forCode code: Int) -> String {
            guard let genre = Genre(rawValue: code) else { return "" }
            return genre.name
        }
    }
}
