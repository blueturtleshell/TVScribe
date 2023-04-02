//
//  SearchView.swift
//  TVScribe
//
//  Created by Peter Sun on 3/31/23.
//

import SwiftUI

struct SearchView: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var mediaManager: MediaManager
    @StateObject private var viewModel = SearchViewModel()
    let columns = [GridItem(.adaptive(minimum: 180, maximum: 200), spacing: 8)]
    
    var body: some View {
        VStack {
            if viewModel.fetchState == .finished && viewModel.noResultsFound {
                Text("No Results found for '\(viewModel.previousQuery)'")
            }
            else  {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 24) {
                        ForEach(viewModel.searchItems, id: \.self.specialID) { item in
                            let searchItemViewModel = SearchItemViewModel(searchItem: item)
                            SearchItemView(viewModel: searchItemViewModel)
                                .frame(width: 200, height: 320)
                                .onTapGesture {
                                    switch searchItemViewModel.mediaType.lowercased() {
                                    case "person":
                                        navigationManager.showCredit(with: searchItemViewModel.id)
                                    case "movie":
                                        navigationManager.showMovie(with: searchItemViewModel.id)
                                    case "tv":
                                        navigationManager.showTVShow(with: searchItemViewModel.id)
                                    default:
                                        return
                                    }
                                }
                                .onAppear {
                                    Task {
                                        await viewModel.fetchNextPageIfNecessary(at: item, searchFetchable: mediaManager)
                                    }
                                }
                        }
                    }
                }
            }
        }
        .searchable(text: $viewModel.query,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: Text("Movie, TV Show, Actor..."))
        .searchScopes($viewModel.scope) {
            ForEach(SearchScope.allCases, id: \.self) { scope in
                Text(scope.name)
            }
        }
        .onSubmit(of: .search, {
            viewModel.reset()
            
            Task {
                await search()
            }
        })
        .onChange(of: viewModel.scope, perform: { _ in
            viewModel.reset()
            
            Task {
                await search()
            }
        })
        .navigationDestination(for: Int.self) { personID in
            CreditDetailsView(personID: personID)
        }
    }
    
    private func search() async {
        await viewModel.performSearch(searchFetchable: mediaManager)
    }
}

enum SearchScope: String, CaseIterable {
    case all, tv, movie, person
    
    var name: String {
        switch self {
        case .tv:
            return "TV"
        default:
            return rawValue.capitalized
        }
    }
    
    var endpoint: SearchEndpoint {
        switch self {
        case .all:
            return .all
        case .tv:
            return .tv
        case .movie:
            return .movie
        case .person:
            return .person
        }
    }
}


