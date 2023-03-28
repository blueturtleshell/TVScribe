//
//  ViewItemView.swift
//  TVScribe
//
//  Created by Peter Sun on 3/22/23.
//

import SwiftUI

struct ViewItemView: View {
    
    let videoViewModel: VideoViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(videoViewModel.name)
                .multilineTextAlignment(.leading)
                .font(.headline)
            
            Divider()
            HStack {
                Text(videoViewModel.type)
                    .font(.subheadline)
                
                Spacer()
                
                Text(videoViewModel.site)
                    .foregroundColor(.white)
                    .padding(4)
                    .background {
                        videoViewModel.site.lowercased() == "youtube" ? Color.red : Color.blue
                    }
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(.thinMaterial)
        .mask(RoundedRectangle(cornerRadius: 8))
        .shadow(radius: 4)
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}
