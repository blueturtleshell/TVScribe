//
//  TVShowDetailsViewModel.swift
//  TVScribe
//
//  Created by Peter Sun on 3/28/23.
//

import Foundation

class TVShowDetailsViewModel: ObservableObject {
    
    @Published private(set) var fetching = false
    @Published private var tvShowDetails: TVShowDetails?
    @Published private var seasonDetails: SeasonDetails?
    @Published var regionCode = "US"
    
    var dataManager: DataManager?
    
    var id: Int {
        tvShowDetails?.id ?? 0
    }
    
    var name: String {
        tvShowDetails?.name ?? ""
    }
    
    var posterURL: URL? {
        guard let posterPath = tvShowDetails?.posterPath, !posterPath.isEmpty else { return nil }
        return ImageEndpoint.poster(size: .w342, path: posterPath).url()
    }
    
    var genres: [String] {
        tvShowDetails?.genres.map { $0.name } ?? []
    }
    
    var type: String {
        guard let showType = tvShowDetails?.type, !showType.isEmpty else { return "N/A" }
        return showType
    }
    
    var country: String {
        guard let country = tvShowDetails?.originCountry, !country.isEmpty else { return "N/A" }
        return country.joined(separator: ", ")
    }
    
    var languages: String {
        guard let languages = tvShowDetails?.spokenLanguages, !languages.isEmpty else { return "N/A" }
        return languages.map { $0.englishName }.joined(separator: ", ")
    }
    
    var airDate: String {
        guard let airDate = tvShowDetails?.firstAirDate, !airDate.isEmpty else { return "N/A" }
        
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
        guard let totalMinutes = tvShowDetails?.episodeRunTime.first else { return "N/A" }
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    var score: String {
        String(format: "%.1f", tvShowDetails?.voteAverage ?? 0.0)
    }
    
    var rated: String {
        guard let contentRatings = tvShowDetails?.contentRatings.results, !contentRatings.isEmpty else { return "N/A" }
        return contentRatings.first(where: { $0.iso3166_1 == regionCode })?.rating ?? "N/A"
    }
    
    var overview: String {
        guard let overview = tvShowDetails?.overview, !overview.isEmpty else { return "Overview not available" }
        return overview
    }
    
    var seasons: [Season] {
        tvShowDetails?.seasons ?? []
    }
    
    var seasonName: String {
        guard let name = seasonDetails?.name, !name.isEmpty else { return "Season" }
        return name
    }
    
    var seasonOverview: String {
        guard let overview = seasonDetails?.overview, !overview.isEmpty else { return "Overview not available" }
        return overview
    }
    
    var episodes: [Episode] {
        seasonDetails?.episodes ?? []
    }
    
    func episode(for episodeNumber: Int) -> Episode? {
        guard let index = episodes.firstIndex(where: { $0.episodeNumber == episodeNumber }) else { return nil }
        return episodes[index]
    }
    
    func episodeOverview(for episodeNumber: Int) -> String {
        guard let episode = episode(for: episodeNumber) else { return "Overview not available" }
        guard let overview = episode.overview, !overview.isEmpty else { return "Overview not available" }
        return overview
    }
    
    var cast: [Credit] {
        tvShowDetails?.credits.cast ?? []
    }
    
    var crew: [Credit] {
        tvShowDetails?.credits.crew ?? []
    }
    
    var recommendations: [MediaItem] {
        tvShowDetails?.recommendations.results ?? []
    }
    
    var reviews: [Review] {
        tvShowDetails?.reviews.results ?? []
    }
    
    var videos: [VideoItem] {
        tvShowDetails?.videos.results ?? []
    }
    
    var regionProviders: RegionWatchProviders {
        return tvShowDetails?.watchProviders.results["US"] ?? RegionWatchProviders(link: nil, subscription: [], rent: [], buy: [])
    }
    
    // MARK: - Core Data
    
    var favoriteIcon: String {
        guard let tvShowDetails else { return "heart" }
        
        if let item = dataManager?.fetchSavedItem(with: String(tvShowDetails.id)) {
            return "heart\(item.isFavorite ? ".fill" : "")"
        }
        
        return "heart"
    }
    
    var bookmarkIcon: String {
        guard let tvShowDetails else { return "bookmark" }
        
        if let item = dataManager?.fetchSavedItem(with: String(tvShowDetails.id)) {
            return "bookmark\(item.isBookmark ? ".fill" : "")"
        }
        
        return "bookmark"
    }
    
    func favorite() {
        guard let tvShowDetails, let dataManager else { return }
        objectWillChange.send()
        
        if let item = dataManager.fetchSavedItem(with: String(tvShowDetails.id)) {
            dataManager.toggleFavorite(for: item)
        } else {
            dataManager.createSavedItem(id: id, name: name, posterURL: posterURL, type: .tv, favorited: true)
        }
    }
    
    func bookmark() {
        guard let tvShowDetails, let dataManager else { return }
        objectWillChange.send()
        
        if let item = dataManager.fetchSavedItem(with: String(tvShowDetails.id)) {
            dataManager.toggleBookmark(for: item)
        } else {
            dataManager.createSavedItem(id: id, name: name, posterURL: posterURL, type: .tv, bookmarked: true)
        }
    }
    
    // MARK: - Fetching
    
    @MainActor
    func fetchDetails(for tvShowID: Int, tvFetchable: TVFetchable) async {
        guard !fetching else { return }
        do {
            fetching = true
            tvShowDetails = try await tvFetchable.fetchTVDetails(for: tvShowID)
            fetching = false
        } catch {
            print(error)
        }
    }
    
    @MainActor
    func fetchSeasonDetails(for tvShowID: Int, seasonNumber: Int, tvFetchable: TVFetchable) async {
        guard !fetching else { return }
        do {
            fetching = true
            seasonDetails = try await tvFetchable.fetchSeasonDetails(for: tvShowID, season: seasonNumber)
            fetching = false
        } catch {
            print(error)
        }
    }
}
