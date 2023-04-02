//
//  MovieDetailsViewModel.swift
//  TVScribe
//
//  Created by Peter Sun on 3/17/23.
//

import Foundation

class MovieDetailsViewModel: ObservableObject {
    
    @Published private(set) var fetchState: FetchState = .waiting
    @Published private var movieDetails: MovieDetails?
    @Published var hasError = false
    @Published var error: MediaManagerError?
    
    private var regionCode = "US"
    
    var id: Int {
        movieDetails?.id ?? 0
    }
    
    var name: String {
        guard let title = movieDetails?.title, !title.isEmpty else { return "N/A" }
        return title
    }
    
    private var regionReleaseDateInfo: ReleaseDate? {
        let theatreReleaseType = [3, 4]

        return movieDetails?.releaseDates.results.filter { $0.iso3166_1 == regionCode }.first?
            .releaseDates.filter { theatreReleaseType.contains($0.type) }.first
    }
    
    var releaseDate: String {
        guard let regionReleaseDate = regionReleaseDateInfo?.releaseDate, !regionReleaseDate.isEmpty else { return "N/A" }
        
        let dateSubstring = String(regionReleaseDate.prefix(10))

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
    
    var posterURL: URL? {
        guard let posterPath = movieDetails?.posterPath, !posterPath.isEmpty else { return nil }
        return ImageEndpoint.poster(size: .w342, path: posterPath).url()
    }
    
    var genres: [String] {
        movieDetails?.genres.map { $0.name } ?? []
    }
    
    var overview: String {
        guard let overview = movieDetails?.overview, !overview.isEmpty else { return "Overview not provided" }
        return overview
    }
    
    var score: String {
        String(format: "%.1f", movieDetails?.voteAverage ?? 0.0)
    }
        
    var regionRating: String {
        if let regionRating = regionReleaseDateInfo?.certification, !regionRating.isEmpty {
            return regionRating
        }
        
        return "N/A"
    }
    
    var runtime: String {
        guard let totalMinutes = movieDetails?.runtime else { return "N/A" }
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        return "\(hours)h \(minutes)m"
    }
    
    var cast: [Credit] {
        movieDetails?.credits.cast ?? []
    }
    
    var crew: [Credit] {
        movieDetails?.credits.crew ?? []
    }
    
    var regionProviders: RegionWatchProviders {
        return movieDetails?.watchProviders.results["US"] ?? RegionWatchProviders(link: nil, subscription: [], rent: [], buy: [])
    }
    
    var recommendations: [MediaItem] {
        movieDetails?.recommendations.results ?? []
    }
    
    var videos: [VideoItem] {
        movieDetails?.videos.results ?? []
    }
    
    var reviews: [Review] {
        movieDetails?.reviews.results ?? []
    }
    
    @MainActor
    func fetchDetails(for movieID: Int, movieFetchable: MovieFetchable) async {
        guard fetchState != .fetching else { return }
        do {
            fetchState = .fetching
            movieDetails = try await movieFetchable.fetchMovieDetails(for: movieID)
            fetchState = .finished
        } catch {
            fetchState = .finished
            self.error = .specificError(error)
            hasError = true
        }
    }
}
