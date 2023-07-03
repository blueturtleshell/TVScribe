//
//  DiscoverPersonRowView.swift
//  TVScribe
//
//  Created by Peter Sun on 4/22/23.
//

import SwiftUI

struct DiscoverPersonRowView: View {
    
    let savedItemViewModel: SavedItemViewModel
    let selected: Bool
    
    var body: some View {
        HStack {
            PlaceholderAsyncImageView(url: savedItemViewModel.imageURL)
                .frame(width: 60, height: 60)
            
            Text(savedItemViewModel.name)
            
            Spacer()
            
            if selected {
                Image(systemName: "checkmark")
            }
        }
    }
}
