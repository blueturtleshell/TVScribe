//
//  MovieInfoSection.swift
//  TVScribe
//
//  Created by Peter Sun on 3/19/23.
//

import SwiftUI

struct MovieInfoSection: View {
        
    let releaseDate: String
    let rating: String
    let runtime: String
    let score: String
    
    var body: some View {
        Grid(horizontalSpacing: 16, verticalSpacing: 8) {
            GridRow {
                Text("Release Date")
                
                Text("Rated")
                
                Text("Run time")
                
                Text("Rating")
            }
            .fontWeight(.semibold)
            
            Divider()
            
            GridRow {
                Text(releaseDate)
                
                Text(rating)
                
                Text(runtime)
                
                Text(score)
            }
        }
    }
}
