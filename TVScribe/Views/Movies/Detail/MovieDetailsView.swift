//
//  MovieDetailsView.swift
//  TVScribe
//
//  Created by Peter Sun on 3/17/23.
//

import SwiftUI

struct MovieDetailsView: View {
    
    @EnvironmentObject var mediaManager: MediaManager
    @EnvironmentObject var dataManager: DataManager
    
    @StateObject var movieDetailsViewModel = MovieDetailsViewModel()

    @State private var selectedMovie: MediaItem?
    @State private var selectedVideo: VideoItem?
    @State private var selectedCredit: Credit?
    @State private var videosReviewsSelection: VideoReviewSectionType = .videos
    @State private var watchProviderSelection: ProviderMethod = .buy
    @State private var previousMovies = [(id: Int, name: String?)]()
    @State private var scrollToTop = false
    
    private var movieID: Int
    
    init(movieID: Int) {
        self.movieID = movieID
    }
    
    var body: some View {
        ZStack {
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
                        
                        if !previousMovies.isEmpty {
                            previousMovieButton
                                .padding()
                        }
                        
                        Group { // top movie info section - poster, name, info, genres
                            PlaceholderAsyncImageView(url: movieDetailsViewModel.posterURL)
                                .frame(width: 200, height: 320)
                                .shadow(radius: 4)

                            MovieInfoSection(releaseDate: movieDetailsViewModel.releaseDate,
                                             rating: movieDetailsViewModel.regionRating,
                                             runtime: movieDetailsViewModel.runtime,
                                             score: movieDetailsViewModel.score)
                                .padding(.vertical)
                            
                            GenreView(genres: movieDetailsViewModel.genres)
                                .padding(.bottom)
                        }
                        
                        Group { // scrollable info section - cast, crew, recommendations
                            OverviewSection(overview: movieDetailsViewModel.overview)
                            
                            CreditSection(title: "Cast", credits: movieDetailsViewModel.cast)
                            
                            CreditSection(title: "Crew", credits: movieDetailsViewModel.crew)
                            
                            RecommendationsSection(recommendations: movieDetailsViewModel.recommendations, selectedMediaItem: $selectedMovie)
                                .onChange(of: selectedMovie) { newMovie in
                                    guard let newMovie else { return }
                                    changeMovie(to: newMovie.id)
                                }
                            
                            VideosReviewsSection(videos: movieDetailsViewModel.videos,
                                                 reviews: movieDetailsViewModel.reviews,
                                                 videosReviewsSelection: $videosReviewsSelection,
                                                 selectedVideo: $selectedVideo)
                            
                            WatchProviderSection(viewModel: RegionWatchProvidersViewModel(watchProviderRegion: movieDetailsViewModel.regionProviders),
                                                 providerMethodSelection: $watchProviderSelection)
                        }
                    }
                }
                .background(.thickMaterial)
                .background(FullSizeImageView(url: movieDetailsViewModel.posterURL))
            }
            
            if movieDetailsViewModel.fetchState == .fetching {
                ProgressView()
            }
        }
        .onAppear {
            movieDetailsViewModel.dataManager = dataManager
        }
        .navigationTitle(movieDetailsViewModel.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    movieDetailsViewModel.favorite()
                } label: {
                    Image(systemName: movieDetailsViewModel.favoriteIcon)
                        .tint(.red)
                }

                Button {
                    movieDetailsViewModel.bookmark()
                } label: {
                    Image(systemName: movieDetailsViewModel.bookmarkIcon)
                        .tint(.teal)
                }
            }
        }
        .task {
            await fetchDetails(for: movieID)
        }
        .sheet(item: $selectedVideo) { video in
            SafariWebView(url: VideoViewModel(video: video).url)
                .presentationDetents([.medium, .large])
        }
        .navigationDestination(for: Credit.self) { credit in
            CreditDetailsView(personID: credit.id)
        }
        
    }
    
    var previousMovieButton: some View {
        Button {
            guard !previousMovies.isEmpty else { return }
            let previousMovie = previousMovies.removeLast()
            changeMovie(to: previousMovie.id, addToHistory: false)
        } label: {
            HStack {
                Image(systemName: "arrow.clockwise.circle")
                Text(previousMovies.last?.name ?? "")
            }
        }
        .buttonStyle(.bordered)
    }
    
    // MARK: - fetching functions
    
    private func fetchDetails(for id: Int) async {
        scrollToTop.toggle()
        await movieDetailsViewModel.fetchDetails(for: id, movieFetchable: mediaManager)
    }
    
    private func changeMovie(to movieID: Int, addToHistory: Bool = true) {
        if addToHistory {
            previousMovies.append((id: movieDetailsViewModel.id, name: movieDetailsViewModel.name))
        }
        
        Task {
            await fetchDetails(for: movieID)
        }
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    
    @Namespace static var namespace
    
    static var previews: some View {
        NavigationStack {
            MovieDetailsView(movieID: MediaItem.preview.id)
        }
        .environmentObject(MediaManager(jsonParser: JSONParser()))
        .environmentObject(NavigationManager())
        .environmentObject(DataManager())
    }
}
