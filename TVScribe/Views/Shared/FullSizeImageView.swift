//
//  FullSizeImageView.swift
//  TVScribe
//
//  Created by Peter Sun on 4/2/23.
//

import SwiftUI

struct FullSizeImageView: View {
    
    let url: URL?
    
    var body: some View {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            ProgressView()
        }
    }
}
