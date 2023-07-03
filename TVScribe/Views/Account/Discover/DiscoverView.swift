//
//  DiscoverView.swift
//  TVScribe
//
//  Created by Peter Sun on 4/14/23.
//

import SwiftUI

struct DiscoverView: View {
    
    @EnvironmentObject var accountViewModel: AccountViewModel
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var mediaManager: MediaManager
    
    @StateObject var viewModel = DiscoverViewModel()
    @State private var showDiscoverConfig = false
    let columns = [GridItem(.adaptive(minimum: 180, maximum: 200), spacing: 8)]
        
    var body: some View {
        ScrollView {
            VStack {
                Picker("Discover types", selection: $viewModel.discoverType) {
                    ForEach(DiscoverType.allCases, id: \.self) { type in
                        Text(type.name)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.discoveryItems) { item in
                        PosterView(viewModel: MediaItemViewModel(mediaItem: item))
                            .frame(width: 200, height: 320)
                            .onTapGesture {
                                switch viewModel.discoverType {
                                case .movie:
                                    navigationManager.showMovie(with: item.id)
                                case .tv:
                                    navigationManager.showTVShow(with: item.id)
                                }
                            }
                            .onAppear {
                                Task {
                                    await viewModel.fetchNextPageIfNecessary(at: item)
                                }
                            }
                    }
                }
                .padding(.horizontal, 8)
                .onAppear {
                    viewModel.discoverFetchable = mediaManager
                }
                .task {
                    await viewModel.discover()
                }
            }
        }
        .navigationTitle("Discovery")
        .sheet(isPresented: $showDiscoverConfig) {
            NavigationStack {
                DiscoverConfigurationView(discoveryViewModel: viewModel)
                    .environmentObject(accountViewModel)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showDiscoverConfig = true
                } label: {
                    Image(systemName: "gear")
                }
            }
        }
        .onChange(of: viewModel.discoverType, perform: { _ in
            viewModel.reset()
            Task {
                await viewModel.discover()
            }
        })
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DiscoverView()
                .environmentObject(MediaManager(jsonParser: JSONParser()))
                .environmentObject(NavigationManager())
        }
    }
}

enum DiscoverType: String, CaseIterable {
    case movie, tv
    
    var name: String {
        switch self {
        case .movie:
            return rawValue.capitalized
        case .tv:
            return rawValue.uppercased()
        }
    }
    
    var endpoint: DiscoveryEndpoint {
        switch self {
        case .movie:
            return .movie
        case .tv:
            return .tv
        }
    }
}

