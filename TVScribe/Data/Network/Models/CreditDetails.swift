//
//  CreditDetails.swift
//  TVScribe
//
//  Created by Peter Sun on 3/22/23.
//

import Foundation

struct CreditDetails: Codable {
    let id: Int
    let name: String?
    let profilePath: String?
    let biography: String?
    let birthday: String?
    let deathday: String?
    let combinedCredits: CombinedCredits

    enum CodingKeys: String, CodingKey {
        case name, biography, birthday, deathday, id
        case profilePath = "profile_path"
        case combinedCredits = "combined_credits"
    }
}

// MARK: - CombinedCredits
struct CombinedCredits: Codable {
    let cast: [CastCredit]
    let crew: [CrewCredit]
}

// MARK: - CastCredit
struct CastCredit: Codable {
    var specialID: String { "Cast\(id)\(character ?? "")" }
    let id: Int
    let title: String?
    let name: String?
    let overview: String?
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let character: String?
    let voteAverage: Double
    let mediaType: String

    enum CodingKeys: String, CodingKey {
        case id, title, character, name, overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case mediaType = "media_type"
    }
}

extension CastCredit: Comparable {
    static func < (lhs: Self, rhs: Self) -> Bool {
        let nameA = lhs.title ?? lhs.name ?? ""
        let nameB = rhs.title ?? rhs.name ?? ""
        return nameA.localizedCompare(nameB) == .orderedAscending
    }
}

// MARK: - CrewCredit
struct CrewCredit: Codable {
    var specialID: String { "Crew\(id)\(job ?? department ?? "")" }
    let id: Int
    let name: String?
    let title: String?
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let overview: String?
    let department: String?
    let job: String?
    let voteAverage: Double
    let mediaType: String

    enum CodingKeys: String, CodingKey {
        case id, department, job, name, title, overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case mediaType = "media_type"
    }
}

extension CrewCredit: Comparable {
    static func < (lhs: Self, rhs: Self) -> Bool {
        let nameA = lhs.title ?? lhs.name ?? ""
        let nameB = rhs.title ?? rhs.name ?? ""
        return nameA.localizedCompare(nameB) == .orderedAscending
    }
}
