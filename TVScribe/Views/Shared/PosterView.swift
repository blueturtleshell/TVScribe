//
//  PosterView.swift
//  TVScribe
//
//  Created by Peter Sun on 3/16/23.
//

import SwiftUI

struct PosterView: View {
    
    let viewModel: MediaItemViewModel
    
    var body: some View {
        VStack {
            PlaceholderAsyncImageView(url: viewModel.posterURL)
            .shadow(radius: 4)

            VStack(alignment: .leading) {
                Text(viewModel.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                Text(viewModel.releaseYear)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 8)
        }
    }
}
