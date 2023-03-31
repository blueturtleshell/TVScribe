//
//  EpisodeViewModel.swift
//  TVScribe
//
//  Created by Peter Sun on 3/29/23.
//

import Foundation

class EpisodeViewModel {
    private let episode: Episode
    
    init(episode: Episode) {
        self.episode = episode
    }
    
    var stillImageURL: URL? {
        guard let stillImagePath = episode.stillPath, !stillImagePath.isEmpty else { return nil }
        return ImageEndpoint.still(size: .w300, path: stillImagePath).url()
    }
    
    var name: String {
        guard let name = episode.name, !name.isEmpty else { return "N/A" }
        return name
    }
    
    var overview: String {
        guard let overview = episode.overview, !overview.isEmpty else { return "Overview not available" }
        return overview
    }
    
    var guestStars: [Credit] {
        episode.guestStars
    }
    
    var crew: [Credit] {
        episode.crew
    }
    
    var airDate: String {
        guard let airDate = episode.airDate, !airDate.isEmpty else { return "N/A" }
        
        let dateSubstring = String(airDate.prefix(10))

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        if let date = formatter.date(from: dateSubstring) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MMMM d yyyy"
            return outputFormatter.string(from: date)
        } else {
            return "N/A"
        }
    }
    
    var runtime: String {
        guard let totalMinutes = episode.runtime else { return "N/A" }
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    var score: String {
        String(format: "%.1f", episode.voteAverage)
    }
    
    var seasonNumber: String {
        String(episode.seasonNumber)
    }
    
    var episodeNumber: String {
        String(episode.episodeNumber)
    }
}
