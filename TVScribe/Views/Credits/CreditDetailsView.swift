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
                            CastCreditSectionView(headerText: "Cast", credits: viewModel.movieCastCredits) { id in
                                navigationManager.showMovie(with: id)
                            }
                            
                            CrewCreditSectionView(headerText: "Crew", credits: viewModel.movieCrewCredits) { id in
                                navigationManager.showMovie(with: id)
                            }
                            
                        } else {
                            CastCreditSectionView(headerText: "Cast", credits: viewModel.tvCastCredits) { id in
                                navigationManager.showTVShow(with: id)
                            }
                            
                            CrewCreditSectionView(headerText: "Crew", credits: viewModel.tvCrewCredits) { id in
                                navigationManager.showTVShow(with: id)
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
            
            if viewModel.fetchState == .fetching {
                ProgressView()
            }
        }
        .navigationTitle(viewModel.name)
        .task {
            await viewModel.fetchDetails(for: personID, creditFetchable: mediaManager)
        }
        .alert(isPresented: $viewModel.hasError, error: viewModel.error) {
            Button("OK") {}
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
