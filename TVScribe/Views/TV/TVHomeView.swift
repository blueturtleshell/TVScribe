//
//  TVHomeView.swift
//  TVScribe
//
//  Created by Peter Sun on 3/28/23.
//

import SwiftUI

struct TVHomeView: View {
    
    @EnvironmentObject var mediaManager: MediaManager
    @StateObject var viewModel = TVHomeViewModel()
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
                await fetchTVShows()
            }
            
            if viewModel.fetching {
                ProgressView()
            }
        }
        .navigationTitle("TVScribe")
        .navigationDestination(for: MediaItem.self) { mediaItem in
            TVShowDetailsView(tvShowID: mediaItem.id)
        }
        .navigationDestination(for: Int.self) { tvID in
            TVShowDetailsView(tvShowID: tvID)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Picker("TV Categories", selection: $viewModel.category) {
                    ForEach(TVCategory.allCases, id: \.self) { category in
                        Text(category.name)
                    }
                }
                .pickerStyle(.segmented)
            }
        }
        .onChange(of: viewModel.category, perform: { _ in
            viewModel.reset()
            Task {
                await fetchTVShows()
            }
        })
    }
    
    var movieList: some View {
        LazyVGrid(columns: columns, spacing: 24) {
            ForEach(viewModel.tvShows) { tvShow in
                NavigationLink(value: tvShow) {
                    PosterView(viewModel: MediaItemViewModel(mediaItem: tvShow))
                        .frame(width: 200, height: 320)
                }
                .onAppear {
                    Task {
                        await viewModel.fetchNextPageIfNecessary(at: tvShow, mediaManager: mediaManager)
                    }
                }
            }
        }
    }
    
    func fetchTVShows() async {
        await viewModel.fetchTVShows(mediaManager: mediaManager)
    }
}

enum TVCategory: CaseIterable {
    case airingToday
    case onTheAir
    case popular
    case topRated
    
    var name: String {
        switch self {
        case .airingToday: return "Today"
        case .onTheAir: return "Week"
        case .popular: return "Popular"
        case .topRated: return "Top Rated"
        }
    }
    
    var endpoint: TVEndpoint {
        switch self {
        case .airingToday: return .airingToday
        case .onTheAir: return .onTheAir
        case .popular: return .popular
        case .topRated: return .topRated
        }
    }
}
