//
//  EpisodeDetailsView.swift
//  TVScribe
//
//  Created by Peter Sun on 3/29/23.
//

import SwiftUI

struct EpisodeDetailsView: View {
    
    let viewModel: EpisodeViewModel
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    PlaceholderAsyncImageView(url: viewModel.stillImageURL)
                        .frame(width: 300, height: 420)
                        .shadow(radius: 4)
                    
                    Grid {
                        GridRow {
                            Text("Air date")
                            Text("Season")
                            Text("Episode Number")
                            Text("Score")
                        }
                        
                        Divider()
                        
                        GridRow {
                            Text(viewModel.airDate)
                            Text(viewModel.seasonNumber)
                            Text(viewModel.episodeNumber)
                            Text(viewModel.score)
                        }
                    }
                    .padding()
                    
                    OverviewSection(overview: viewModel.overview)
                    
                    CreditSection(title: "Guest Stars", credits: viewModel.guestStars)
                    CreditSection(title: "Crew", credits: viewModel.crew)
                }
            }
            .background(.thinMaterial)
            .background(PlaceholderAsyncImageView(url: viewModel.stillImageURL))
        }
        .navigationTitle(viewModel.name)
        .navigationDestination(for: Credit.self) { credit in
            CreditDetailsView(personID: credit.id)
        }
    }
}
