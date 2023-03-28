//
//  GenreView.swift
//  TVScribe
//
//  Created by Peter Sun on 3/19/23.
//

import SwiftUI

struct GenreView: View {
    
    let genres: [String]
    
    var body: some View {
        if genres.isEmpty {
            Text("Genres unavailable")
                .padding()
        } else {
            LazyHGrid(rows: [GridItem(.flexible())]) {
                ForEach(genres, id: \.self) { genre in
                    GenreItem(text: genre)
                }
            }
            .accessibilityLabel("Genres for the movie / tv show")
        }
    }
}

struct GenreItem: View {
    let text: String
    
    var body: some View {
        Text(text)
            .padding(.horizontal, 4)
            .padding(4)
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
    }
}
