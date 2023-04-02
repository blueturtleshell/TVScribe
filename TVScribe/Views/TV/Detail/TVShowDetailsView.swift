//
//  TVShowDetailsView.swift
//  TVScribe
//
//  Created by Peter Sun on 3/28/23.
//

import SwiftUI


struct TVShowDetailsView: View {
    @EnvironmentObject var mediaManager: MediaManager
    @StateObject var viewModel = TVShowDetailsViewModel()
    private var tvShowID: Int
    
    @State private var currentSeason = 1
    @State private var currentEpisode = 1
    
    @State private var selectedTVShow: MediaItem?
    @State private var previousTVShows = [(id: Int, name: String?)]()
    @State private var scrollToTop = false
    
    init(tvShowID: Int) {
        self.tvShowID = tvShowID
    }
    
    var body: some View {
        ScrollViewReader { reader in
            ScrollView(showsIndicators: false) {
                VStack {
                    Spacer(minLength: 1)
                        .id("Top")
                        .onChange(of: scrollToTop) { _ in
                            withAnimation {
                                reader.scrollTo("Top", anchor: .top)
                            }
                        }
                    
                    if !previousTVShows.isEmpty {
                        previousTVShowButton
                            .padding()
                    }
                    
                    PlaceholderAsyncImageView(url: viewModel.posterURL)
                        .frame(width: 200, height: 320)
                        .shadow(radius: 4)
                    
                    TVShowInfoSection(airDate: viewModel.airDate, rated: viewModel.rated,
                                      runtime: viewModel.runtime, score: viewModel.score,
                                      type: viewModel.type, country: viewModel.country,
                                      languages: viewModel.languages, seasons: String(viewModel.seasons.count))
                    
                    GenreView(genres: viewModel.genres)
                    
                    OverviewSection(overview: viewModel.overview)
                    
                    Group {
                        Text("\(viewModel.seasonName) Information")
                            .headerStyle()
                            .padding([.top, .horizontal])

                        ScrollView(.horizontal) {
                            Picker("Season number", selection: $currentSeason) {
                                ForEach(viewModel.seasons) { season in
                                    Text(season.seasonNumber, format: .number)
                                        .tag(season.seasonNumber)
                                }
                            }
                            .pickerStyle(.segmented)
                            .padding()
                        }
                        
                        OverviewSection(overview: viewModel.seasonOverview)
                        
                        
                        Text("Episode \(currentEpisode) Information")
                            .headerStyle()
                            .padding([.top, .horizontal])
                        
                        ScrollView(.horizontal) {
                            Picker("Episode number", selection: $currentEpisode) {
                                ForEach(viewModel.episodes) { episode in
                                    Text(episode.episodeNumber, format: .number)
                                        .tag(episode.episodeNumber)
                                }
                            }
                            .pickerStyle(.segmented)
                            .padding()
                        }
                        
                        NavigationLink(value: viewModel.episode(for: currentEpisode)) {
                            HStack {
                                Text(viewModel.episodeOverview(for: currentEpisode))
                                    .multilineTextAlignment(.leading)
                                    .lineSpacing(6)
                                    .foregroundColor(.primary)
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(.thinMaterial)
                        }
                    }
                    
                    Group {
                        CreditSection(title: "Cast", credits: viewModel.cast)
                        
                        CreditSection(title: "Crew", credits: viewModel.crew)
                        
                        RecommendationsSection(recommendations: viewModel.recommendations, selectedMediaItem: $selectedTVShow)
                            .onChange(of: selectedTVShow) { newTVShow in
                                guard let newTVShow else { return }
                                changeTVShow(to: newTVShow.id)
                            }
                    }
                }
            }
            .background(.thinMaterial)
            .background(FullSizeImageView(url: viewModel.posterURL))
        }
        .navigationTitle(viewModel.name)
        .task {
            scrollToTop.toggle()
            await fetchTVShowDetails(for: tvShowID)
            await fetchSeasonDetails(for: tvShowID)
        }
        .onChange(of: currentSeason) { _ in
            Task {
                await fetchSeasonDetails(for: tvShowID)
            }
        }
        .navigationDestination(for: Episode.self) { episode in
            EpisodeDetailsView(viewModel: EpisodeViewModel(episode: episode))
        }
        .navigationDestination(for: Credit.self) { credit in
            CreditDetailsView(personID: credit.id)
        }
    }
    
    var previousTVShowButton: some View {
        Button {
            guard !previousTVShows.isEmpty else { return }
            let previousTVShow = previousTVShows.removeLast()
            changeTVShow(to: previousTVShow.id, addToHistory: false)
        } label: {
            HStack {
                Image(systemName: "arrow.clockwise.circle")
                Text(previousTVShows.last?.name ?? "")
            }
        }
        .buttonStyle(.bordered)
    }
    
    // MARK: - fetching functions
    
    private func fetchTVShowDetails(for tvShowID: Int) async {
        await viewModel.fetchDetails(for: tvShowID, tvFetchable: mediaManager)
    }
    
    private func fetchSeasonDetails(for tvShowID: Int) async {
        await viewModel.fetchSeasonDetails(for: tvShowID, seasonNumber: currentSeason, tvFetchable: mediaManager)
        currentEpisode = viewModel.episodes.first?.episodeNumber ?? 1
    }
    
    private func changeTVShow(to tvShowID: Int, addToHistory: Bool = true) {
        if addToHistory {
            previousTVShows.append((id: viewModel.id, name: viewModel.name))
        }
        
        scrollToTop.toggle()
        
        Task {
            await fetchTVShowDetails(for: tvShowID)
            await fetchSeasonDetails(for: tvShowID)
        }
    }
}

struct TVShowDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        TVShowDetailsView(tvShowID: 1100)
            .environmentObject(MediaManager(jsonParser: JSONParser()))
    }
}
