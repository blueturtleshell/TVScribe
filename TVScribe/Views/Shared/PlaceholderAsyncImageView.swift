//
//  PlaceholderAsyncImageView.swift
//  TVScribe
//
//  Created by Peter Sun on 3/19/23.
//

import SwiftUI

struct PlaceholderAsyncImageView: View {
    
    let url: URL?
    
    var body: some View {
        Group {
            if let url {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(8)
                    
                } placeholder: {
                    ProgressView()
                        .frame(maxHeight: .infinity)
                }
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.thinMaterial)
                    .overlay {
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                    }
            }
        }
    }
}
