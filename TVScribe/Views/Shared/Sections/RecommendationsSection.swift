//
//  RecommendationsSection.swift
//  TVScribe
//
//  Created by Peter Sun on 3/19/23.
//

import SwiftUI

struct RecommendationsSection: View {
    
    var title = "Recommendations"
    let recommendations: [MediaItem]
    @Binding var selectedMediaItem: MediaItem?
    
    var body: some View {
        Group {
            Text(title)
                .headerStyle()
                .padding([.top, .horizontal])
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(recommendations, id: \.self.id) { mediaItem in
                        RecommendationPosterView(viewModel: MediaItemViewModel(mediaItem: mediaItem))
                            .frame(width: 200, height: 320)
                            .onTapGesture {
                                selectedMediaItem = mediaItem
                            }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
