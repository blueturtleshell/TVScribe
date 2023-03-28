//
//  MediaItem.swift
//  TVScribe
//
//  Created by Peter Sun on 3/16/23.
//

import Foundation

struct MediaItem: Codable, Identifiable {
    let id: Int
    let title: String?
    let name: String?
    let posterPath: String?
    let backdropPath: String?
    let genreIDS: [Int]
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let popularity: Double
    let releaseDate: String?
    let firstAirDate: String?
    let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case id, title, name, overview, popularity
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case firstAirDate = "first_air_date"
        case voteAverage = "vote_average"
    }
}

extension MediaItem: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title ?? name)
    }
}

#if DEBUG
extension MediaItem {
    
    static var preview: MediaItem {
        MediaItem(id: 545611, title: "Everything Everywhere All at Once",
                  name: nil,
                  posterPath: "/w3LxiVYdWWRvEVdn5RYq6jIqkb1.jpg",
                  backdropPath: "/tt79dbOPd9Z9ykEOpvckttgYXwH.jpg",
                  genreIDS: [28, 12, 878],
                  originalLanguage: "en",
                  originalTitle: "Everything Everywhere All at Once",
                  overview: "An aging Chinese immigrant is swept up in an insane adventure, where she alone can save what's important to her by connecting with the lives she could have led in other universes.",
                  popularity: 1335.103,
                  releaseDate: "2022-03-24",
                  firstAirDate: nil,
                  voteAverage: 7.942)
    }
}
#endif
