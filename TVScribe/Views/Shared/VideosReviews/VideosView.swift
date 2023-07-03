//
//  VideosView.swift
//  TVScribe
//
//  Created by Peter Sun on 3/22/23.
//

import SwiftUI

struct VideosView: View {
    
    let videos: [VideoItem]
    @Binding var selectedVideo: VideoItem?
    
    var body: some View {
        if videos.isEmpty {
            Text("No videos found")
                .padding()
        } else {
            LazyVStack {
                ForEach(videos) { video in
                    VideoItemView(videoViewModel: VideoViewModel(video: video))
                        .onTapGesture {
                            selectedVideo = video
                        }
                }
            }
        }
    }
}
