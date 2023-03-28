//
//  VideoViewModel.swift
//  TVScribe
//
//  Created by Peter Sun on 3/22/23.
//

import Foundation

class VideoViewModel {
    
    let video: VideoItem
    
    init(video: VideoItem) {
        self.video = video
    }
    
    var name: String {
        video.name
    }
    
    var type: String {
        video.type
    }
    
    var site: String {
        video.site
    }
    
    var url: URL! {
        let siteURL: String
        
        if video.site.lowercased() == "youtube" {
            siteURL = "https://www.youtube.com/watch?v=\(video.key)"
        } else {
            siteURL = "https://vimeo.com/\(video.key)"
        }
        
        return URL(string: siteURL)
    }
}
