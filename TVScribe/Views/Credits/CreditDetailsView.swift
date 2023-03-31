//
//  CreditDetailsView.swift
//  TVScribe
//
//  Created by Peter Sun on 3/23/23.
//

import SwiftUI

struct CreditDetailsView: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var mediaManager: MediaManager

    let personID: Int
    @StateObject var viewModel = CreditDetailsViewModel()
    
    @State private var castCreditSelection: MovieTVSection = .movies
    private let allCastCreditSections = MovieTVSection.allCases
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    PlaceholderAsyncImageView(url: viewModel.profileImageURL)
                        .frame(width: 200, height: 200)
                    
                    Group {
                        Text("Biography")
                            .headerStyle()
                            .padding([.top, .horizontal])
                        
                        Text(viewModel.biography)
                            .font(.body)
                            .lineSpacing(6)
                            .padding()
                            .background(.thinMaterial)
                    }

                    segmentedHeader
                    
                    Group {
                        if castCreditSelection == .movies {
                            Section {
                                if viewModel.movieCastCredits.isEmpty {
                                    Text("Movie cast credits were not found")
                                        .padding()
                                        .background(.thinMaterial)
                                } else {
                                    LazyVStack {
                                        ForEach(viewModel.movieCastCredits, id: \.self.specialID) { credit in
                                            CreditDetailItemView(viewModel: CreditDetailItemViewModel(castCredit: credit))
                                                .onTapGesture {
                                                    navigationManager.showMovie(with: credit.id)
                                                }
                                        }
                                    }
                                }
                            } header: {
                                Text("Cast")
                            }
                            
                            Section {
                                if viewModel.movieCrewCredits.isEmpty {
                                    Text("Movie crew credits were not found")
                                        .padding()
                                        .background(.thinMaterial)
                                } else {
                                    LazyVStack {
                                        ForEach(viewModel.movieCrewCredits, id: \.self.specialID) { credit in
                                            CreditDetailItemView(viewModel: CreditDetailItemViewModel(crewCredit: credit))
                                                .onTapGesture {
                                                    navigationManager.showMovie(with: credit.id)
                                                }
                                        }
                                    }
                                }
                            } header: {
                                Text("Crew")
                            }
                            
                        } else {
                            Section {
                                if viewModel.tvCastCredits.isEmpty {
                                    Text("TV cast credits were not found")
                                        .padding()
                                        .background(.thinMaterial)
                                } else {
                                    LazyVStack {
                                        ForEach(viewModel.tvCastCredits, id: \.self.specialID) { credit in
                                            CreditDetailItemView(viewModel: CreditDetailItemViewModel(castCredit: credit))
                                                .onTapGesture {
                                                    navigationManager.showTVShow(with: credit.id)
                                                }
                                        }
                                    }
                                }
                            } header: {
                                Text("Cast")
                            }
                            
                            Section {
                                if viewModel.tvCrewCredits.isEmpty {
                                    Text("TV crew credits were not found")
                                        .padding()
                                        .background(.thinMaterial)
                                } else {
                                    LazyVStack {
                                        ForEach(viewModel.tvCrewCredits, id: \.self.specialID) { credit in
                                            CreditDetailItemView(viewModel: CreditDetailItemViewModel(crewCredit: credit))
                                                .onTapGesture {
                                                    navigationManager.showTVShow(with: credit.id)
                                                }
                                        }
                                    }
                                }
                            } header: {
                                Text("Crew")
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
            
            if viewModel.fetching {
                ProgressView()
            }
        }
        .navigationTitle(viewModel.name)
        .task {
            await viewModel.fetchDetails(for: personID, creditFetchable: mediaManager)
        }
    }
    
    var segmentedHeader: some View {
        Picker("Show Movies or TV credits", selection: $castCreditSelection.animation()) {
            ForEach(allCastCreditSections, id: \.self) { section in
                Text(section.name)
            }
        }
        .pickerStyle(.segmented)
        .padding([.top, .horizontal])
        .padding(.bottom, 4)
    }
}

enum MovieTVSection: String, CaseIterable {
    case movies, tv
    
    var name: String {
        switch self {
        case .movies:
            return "Movies"
        case .tv:
            return "TV"
        }
    }
}

struct CreditDetailItemView: View {
    
    let viewModel: CreditDetailItemViewModel
    
    var body: some View {
        HStack {
            PlaceholderAsyncImageView(url: viewModel.posterURL)
                .frame(width: 95, height: 140)
            
            VStack(alignment: .leading, spacing: 10) {
                Text(viewModel.name)
                    .font(.headline)
                Text(viewModel.role)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
}
