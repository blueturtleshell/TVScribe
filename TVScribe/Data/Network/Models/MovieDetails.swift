//
//  MovieDetails.swift
//  TVScribe
//
//  Created by Peter Sun on 3/17/23.
//

import Foundation

struct MovieDetails: Codable {
    
    let id: Int
    let title: String?
    let posterPath: String?
    let backdropPath: String?
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let popularity: Double
    let firstAirDate: String?
    let voteAverage: Double
    let genres: [Genre]
    let runtime: Int?
    let spokenLanguages: [SpokenLanguage]
    let tagline: String?
    let credits: Credits
    let recommendations: MediaFetchResult
    let reviews: Reviews
    let videos: Videos
    let releaseDates: ReleaseDates
    let watchProviders: WatchProvidersResponse

    enum CodingKeys: String, CodingKey {
        case id, title, overview, popularity, genres, runtime, tagline, credits, recommendations, reviews, videos
        case backdropPath = "backdrop_path"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case firstAirDate = "first_air_date"
        case voteAverage = "vote_average"
        case spokenLanguages = "spoken_languages"
        case releaseDates = "release_dates"
        case watchProviders = "watch/providers"
    }
}

// MARK: - Credits
struct Credits: Codable {
    let cast: [Credit]
    let crew: [Credit]
}

// MARK: - Credit
struct Credit: Codable, Hashable {
    let id: Int
    let name: String
    let originalName: String
    let profilePath: String?
    let character: String?
    let order: Int?
    let department: String?
    let job: String?
    
    var specialID: String { "\(id) \(character ?? job ?? name)" }

    enum CodingKeys: String, CodingKey {
        case id, name, character, order, department, job
        case originalName = "original_name"
        case profilePath = "profile_path"
    }
}

// MARK: - Genre
struct Genre: Codable {
    let id: Int
    let name: String
}

// MARK: - Reviews
struct Reviews: Codable {
    let page: Int
    let results: [Review]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Review
struct Review: Codable, Identifiable {
    let id: String
    let author: String
    let authorDetails: AuthorDetails
    let content: String
    let createdAt: String?
    let url: String

    enum CodingKeys: String, CodingKey {
        case author
        case authorDetails = "author_details"
        case content
        case createdAt = "created_at"
        case id
        case url
    }
}
// MARK: - AuthorDetails
struct AuthorDetails: Codable {
    let name: String
    let username: String
    let avatarPath: String?
    let rating: Double?

    enum CodingKeys: String, CodingKey {
        case name, username
        case avatarPath = "avatar_path"
        case rating
    }
}

// MARK: - SpokenLanguage
struct SpokenLanguage: Codable {
    let englishName: String
    let iso639_1: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso639_1 = "iso_639_1"
        case name
    }
}

struct ReleaseDates: Codable {
    let results: [ReleaseDatesResult]
}

// MARK: - ReleaseDatesResult
struct ReleaseDatesResult: Codable {
    let iso3166_1: String
    let releaseDates: [ReleaseDate]

    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case releaseDates = "release_dates"
    }
}

// MARK: - ReleaseDate

struct ReleaseDate: Codable {
    let certification: String
    let iso639_1: String?
    let note: String?
    let releaseDate: String?
    let type: Int

    enum CodingKeys: String, CodingKey {
        case certification
        case iso639_1 = "iso_639_1"
        case note
        case releaseDate = "release_date"
        case type
    }
}

// MARK: - Videos

struct Videos: Codable {
    let results: [VideoItem]
}

// MARK: - Video

struct VideoItem: Codable, Identifiable {
    let id: String
    let iso639_1: String
    let iso3166_1: String
    let key: String
    let name: String
    let site: String
    let type: String

    enum CodingKeys: String, CodingKey {
        case id
        case iso639_1 = "iso_639_1"
        case iso3166_1 = "iso_3166_1"
        case key, name, site, type
    }
}

struct WatchProvidersResponse: Codable {
    let results: [String: RegionWatchProviders]
}

struct RegionWatchProviders: Codable {
    let link: String?
    let subscription: [WatchProvider]?
    let rent: [WatchProvider]?
    let buy: [WatchProvider]?
    
    enum CodingKeys: String, CodingKey {
        case subscription = "flatrate"
        case rent, buy, link
    }
}

struct WatchProvider: Codable, Identifiable {
    let id: Int
    let providerName: String
    let logoPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "provider_id"
        case providerName = "provider_name"
        case logoPath = "logo_path"
    }
}
