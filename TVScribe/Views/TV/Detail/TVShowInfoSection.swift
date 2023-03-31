//
//  TVShowInfoSection.swift
//  TVScribe
//
//  Created by Peter Sun on 3/30/23.
//

import SwiftUI

struct TVShowInfoSection: View {
    
    let airDate: String
    let rated: String
    let runtime: String
    let score: String
    
    let type: String
    let country: String
    let languages: String
    let seasons: String
    
    var body: some View {
        Group {
            Grid(horizontalSpacing: 16, verticalSpacing: 8) {
                GridRow {
                    Text("First Aired")
                    Text("Rated")
                    Text("Run time")
                    Text("Score")
                }
                .font(.headline)
                .minimumScaleFactor(0.75)
                .fontWeight(.semibold)
                .lineLimit(1)
                
                Divider()
                
                GridRow {
                    Text(airDate)
                    Text(rated)
                    Text(runtime)
                    Text(score)
                }
                .font(.subheadline)
                .minimumScaleFactor(0.75)
                .lineLimit(1)
            }
            .padding()
            
            Grid(verticalSpacing: 10) {
                GridRow {
                    Text("Type")
                    Text("Country")
                    Text("Languages")
                    Text("Seasons")
                }
                .font(.headline)
                .minimumScaleFactor(0.75)
                .fontWeight(.semibold)
                .lineLimit(1)
                
                Divider()
                
                GridRow {
                    Text(type)
                    Text(country)
                    Text(languages)
                        .multilineTextAlignment(.center)
                    
                    Text(seasons)
                }
            }
            .padding()
        }
    }
}
