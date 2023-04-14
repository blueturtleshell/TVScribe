//
//  MoviesHomeView.swift
//  TVScribe
//
//  Created by Peter Sun on 3/16/23.
//

import SwiftUI

struct MoviesHomeView: View {
    
    @EnvironmentObject var mediaManager: MediaManager
    @StateObject var viewModel = MoviesHomeViewModel()
    let columns = [GridItem(.adaptive(minimum: 180, maximum: 200), spacing: 8)]
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.thinMaterial)
                .ignoresSafeArea()
            
            ScrollView {
                movieList
                .padding(.horizontal, 8)
            }
            .task {
                await fetchMovies()
            }
            
            if viewModel.fetchState == .fetching {
                ProgressView()
            }
        }
        .navigationTitle("TVScribe")
        .navigationDestination(for: MediaItem.self) { mediaItem in
            MovieDetailsView(movieID: mediaItem.id)
        }
        .navigationDestination(for: Int.self) { movieID in
            MovieDetailsView(movieID: movieID)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Picker("Movie Categories", selection: $viewModel.category) {
                    ForEach(MovieCategory.allCases, id: \.self) { category in
                        Text(category.name)
                    }
                }
                .pickerStyle(.segmented)
            }
        }
        .alert(isPresented: $viewModel.hasError, error: viewModel.error) {
            Button("OK") {}
        }
        .onChange(of: viewModel.category, perform: { _ in
            viewModel.reset()
            Task {
                await fetchMovies()
            }
        })
    }
    
    var movieList: some View {
        LazyVGrid(columns: columns, spacing: 24) {
            ForEach(viewModel.movies) { movie in
                NavigationLink(value: movie) {
                    PosterView(viewModel: MediaItemViewModel(mediaItem: movie))
                        .frame(width: 200, height: 320)
                }
                .onAppear {
                    Task {
                        await viewModel.fetchNextPageIfNecessary(at: movie, mediaManager: mediaManager)
                    }
                }
            }
        }
    }
    
    func fetchMovies() async {
        await viewModel.fetchMovies(mediaManager: mediaManager)
    }
}
