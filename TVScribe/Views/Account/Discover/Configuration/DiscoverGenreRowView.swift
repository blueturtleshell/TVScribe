//
//  DiscoverGenreRowView.swift
//  TVScribe
//
//  Created by Peter Sun on 4/22/23.
//

import SwiftUI

struct DiscoverGenreRowView: View {
    
    let genre: API.Genre
    let selected: Bool
    
    var body: some View {
        HStack {
            Text(genre.name)
                .foregroundColor(selected ? .green : .primary)
            
            Spacer()
            
            if selected {
                Image(systemName: "checkmark")
            }
        }
    }
}
