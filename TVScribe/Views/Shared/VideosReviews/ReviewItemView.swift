//
//  ReviewItemView.swift
//  TVScribe
//
//  Created by Peter Sun on 3/22/23.
//

import SwiftUI

struct ReviewItemView: View {
    
    let reviewViewModel: ReviewViewModel
    @State private var expand = false

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                PlaceholderAsyncImageView(url: reviewViewModel.avatarURL)
                    .frame(width: 20, height: 20)
                    .clipShape(Circle())
                
                Text(reviewViewModel.authorName)
                    .font(.headline)
                
                Spacer()
                
                Text(reviewViewModel.score)
            }
            
            Divider()
            
            Text(reviewViewModel.content)
                .font(.body)
                .lineSpacing(6)
                .lineLimit(expand ? nil : 2)
            
            HStack {
                Spacer()
                
                Text(reviewViewModel.creationDate)
                    .font(.subheadline)
            }
        }
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 4))
        .onTapGesture {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                expand.toggle()
            }
        }
    }
}

class ReviewViewModel {
    
    let review: Review
    
    init(review: Review) {
        self.review = review
    }
    
    var avatarURL: URL? {
        guard var avatarPath = review.authorDetails.avatarPath else { return nil }
        
        if avatarPath.contains("gravatar") {
            avatarPath.remove(at: avatarPath.startIndex)
            return URL(string: avatarPath)
        }
        
        return ImageEndpoint.profile(size: .w45, path: avatarPath).url()
    }
    
    var authorName: String {
        review.author
    }
    
    var content: String {
        review.content
    }
    
    var score: String {
        String(format: "%.1f", review.authorDetails.rating ?? 0.0)
    }
    
    var creationDate: String {
        guard let date = review.createdAt, !date.isEmpty else { return "N/A" }
        
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd"
        let inputDate = inputDateFormatter.date(from: String(date.prefix(10)))!

        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "MMMM d yyyy"
        return outputDateFormatter.string(from: inputDate)
    }
}
