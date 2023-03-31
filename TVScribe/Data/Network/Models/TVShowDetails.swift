//
//  TVShowDetails.swift
//  TVScribe
//
//  Created by Peter Sun on 3/28/23.
//

import Foundation

struct TVShowDetails: Codable {
    let id: Int
    let name: String?
    let posterPath: String?
    let originalLanguage: String?
    let overview: String?
    let popularity: Double
    let firstAirDate: String?
    let voteAverage: Double
    let genres: [Genre]
    let createdBy: [CreatedBy]
    let episodeRunTime: [Int]
    let languages: [String]
    let lastAirDate: String?
    let networks: [Network]
    let numberOfEpisodes: Int
    let numberOfSeasons: Int
    let originCountry: [String]
    let spokenLanguages: [SpokenLanguage]
    let status: String?
    let tagline: String?
    let type: String?
    let seasons: [Season]
    let credits: Credits
    let reviews: Reviews
    let videos: Videos
    let recommendations: MediaFetchResult
    let contentRatings: ContentRatings

    enum CodingKeys: String, CodingKey {
        case id, name, overview, popularity, languages, genres, networks, status, tagline, type, seasons, credits, recommendations, reviews, videos
        case posterPath = "poster_path"
        case createdBy = "created_by"
        case episodeRunTime = "episode_run_time"
        case firstAirDate = "first_air_date"
        case lastAirDate = "last_air_date"
        case numberOfEpisodes = "number_of_episodes"
        case numberOfSeasons = "number_of_seasons"
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case spokenLanguages = "spoken_languages"
        case voteAverage = "vote_average"
        case contentRatings = "content_ratings"
    }
}

// MARK: - CreatedBy
struct CreatedBy: Codable {
    let id: Int
    let name: String
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case profilePath = "profile_path"
    }
}

// MARK: - Network
struct Network: Codable {
    let id: Int
    let name: String?
    let logoPath: String?
    let originCountry: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case logoPath = "logo_path"
        case originCountry = "origin_country"
    }
}

// MARK: - Season
struct Season: Codable, Identifiable {
    let id: Int
    let name: String?
    let overview: String?
    let posterPath: String?
    let seasonNumber: Int
    let episodeCount: Int
    let airDate: String?

    enum CodingKeys: String, CodingKey {
        case id, name, overview
        case airDate = "air_date"
        case episodeCount = "episode_count"
        case posterPath = "poster_path"
        case seasonNumber = "season_number"
    }
}

// MARK: - ContentRatings
struct ContentRatings: Codable {
    let results: [ContentRatingsResult]
}

// MARK: - ContentRatingsResult
struct ContentRatingsResult: Codable {
    let iso3166_1, rating: String

    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case rating
    }
}
