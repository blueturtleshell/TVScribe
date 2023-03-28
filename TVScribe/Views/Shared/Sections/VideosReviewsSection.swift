//
//  VideosReviewsSection.swift
//  TVScribe
//
//  Created by Peter Sun on 3/24/23.
//

import SwiftUI

struct VideosReviewsSection: View {
    
    private let allVideoReviewSectionTypes = VideoReviewSectionType.allCases
    
    var videos: [VideoItem]
    var reviews: [Review]
    
    @Binding var videosReviewsSelection: VideoReviewSectionType
    @Binding var selectedVideo: VideoItem?

    var body: some View {
        VStack {
            Picker("Videos or Reviews", selection: $videosReviewsSelection.animation()) {
                ForEach(allVideoReviewSectionTypes, id: \.self) { section in
                    Text(section.name)
                }
            }
            .pickerStyle(.segmented)
            .padding([.top, .horizontal])
            .padding(.bottom, 4)
            
            ScrollView {
                if videosReviewsSelection == .videos {
                    VideosView(videos: videos, selectedVideo: $selectedVideo)
                        .padding(.top, 4)
                        .transition(.move(edge: .trailing))
                    
                } else {
                    ReviewsView(reviews: reviews)
                        .padding(.top, 4)
                        .transition(.move(edge: .leading))
                }
            }
            .frame(height: videosReviewsSelection == .videos ? videos.isEmpty ? 80 : 450 : reviews.isEmpty ? 80 : 450)
        }
    }
}

enum VideoReviewSectionType: String, CaseIterable {
    case videos, reviews
    
    var name: String {
        return rawValue.capitalized
    }
}
