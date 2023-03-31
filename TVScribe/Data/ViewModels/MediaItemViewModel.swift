//
//  MediaItemViewModel.swift
//  TVScribe
//
//  Created by Peter Sun on 3/17/23.
//

import Foundation

class MediaItemViewModel {
    
    let mediaItem: MediaItem
    
    init(mediaItem: MediaItem) {
        self.mediaItem = mediaItem
    }
    
    var id: Int {
        mediaItem.id
    }
    
    var name: String {
        mediaItem.name ?? mediaItem.title ?? "N/A"
    }
    
    var releaseYear: String {
        if let releaseDate = mediaItem.releaseDate, !releaseDate.isEmpty {
            return String(mediaItem.releaseDate?.split(separator: "-").first ?? "-")
        } else {
            return String(mediaItem.firstAirDate?.split(separator: "-").first ?? "-")
        }
    }
    
    var releaseDate: String {
        guard let date = mediaItem.releaseDate, !date.isEmpty else { return "N/A" }
        
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd"
        let inputDate = inputDateFormatter.date(from: date)!

        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "MMMM d yyyy"
        return outputDateFormatter.string(from: inputDate)
    }
    
    var posterURL: URL? {
        guard let posterPath = mediaItem.posterPath, !posterPath.isEmpty else { return nil }
        return ImageEndpoint.poster(size: .w342, path: posterPath).url()
    }
    
    var genres: [String] {
        mediaItem.genreIDS.map { API.getGenreName(forCode: $0) }
    }
    
    var overview: String {
        mediaItem.overview ?? ""
    }
    
    var score: String {
        String(format: "%.1f", mediaItem.voteAverage)
    }
}
