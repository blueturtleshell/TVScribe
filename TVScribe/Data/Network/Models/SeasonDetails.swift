//
//  SeasonDetails.swift
//  TVScribe
//
//  Created by Peter Sun on 3/29/23.
//

import Foundation

// MARK: - SeasonDetails
struct SeasonDetails: Codable {
    let id: Int
    let name: String?
    let overview: String?
    let airDate: String?
    let episodes: [Episode]
    let posterPath: String?
    let seasonNumber: Int

    enum CodingKeys: String, CodingKey {
        case id, episodes, name, overview
        case airDate = "air_date"
        case posterPath = "poster_path"
        case seasonNumber = "season_number"
    }
}

// MARK: - Episode
struct Episode: Codable, Identifiable, Hashable {
    let episodeNumber: Int
    let id: Int
    let name: String?
    let overview: String?
    let airDate: String?
    let runtime: Int?
    let seasonNumber: Int
    let showID: Int
    let stillPath: String?
    let voteAverage: Double
    let crew: [Credit]
    let guestStars: [Credit]

    enum CodingKeys: String, CodingKey {
        case id, name, overview, crew, runtime
        case airDate = "air_date"
        case episodeNumber = "episode_number"
        case seasonNumber = "season_number"
        case showID = "show_id"
        case stillPath = "still_path"
        case voteAverage = "vote_average"
        case guestStars = "guest_stars"
    }
}
