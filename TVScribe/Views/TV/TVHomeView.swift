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
                tvList
                .padding(.horizontal, 8)
            }
            .task {
                await fetchTVShows()
            }
            
            if viewModel.fetchState == .fetching {
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
        .alert(isPresented: $viewModel.hasError, error: viewModel.error) {
            Button("OK") {}
        }
    }
    
    var tvList: some View {
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
    
    // MARK: - fetching function
    
    func fetchTVShows() async {
        await viewModel.fetchTVShows(mediaManager: mediaManager)
    }
}
