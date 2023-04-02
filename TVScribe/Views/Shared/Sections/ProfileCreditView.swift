//
//  ProfileCreditView.swift
//  TVScribe
//
//  Created by Peter Sun on 3/17/23.
//

import SwiftUI

struct ProfileCreditView: View {
    
    let viewModel: CreditViewModel
    
    var body: some View {
        VStack {
            PlaceholderAsyncImageView(url: viewModel.profileURL)
                .frame(width: 120, height: 180)
            
            VStack(spacing: 10) {
                Text(viewModel.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                Text(viewModel.role)
                    .font(.subheadline)
                    .minimumScaleFactor(0.75)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
