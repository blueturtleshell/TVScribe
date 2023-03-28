//
//  ReviewsView.swift
//  TVScribe
//
//  Created by Peter Sun on 3/22/23.
//

import SwiftUI

struct ReviewsView: View {
    
    let reviews: [Review]
    
    var body: some View {
        if reviews.isEmpty {
            Text("No reviews found")
                .padding()
        } else {
            LazyVStack {
                ForEach(reviews) { review in
                    ReviewItemView(reviewViewModel: ReviewViewModel(review: review))
                }
            }
        }
    }
}
