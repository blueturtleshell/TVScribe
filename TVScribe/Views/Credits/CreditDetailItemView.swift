//
//  CreditDetailItemView.swift
//  TVScribe
//
//  Created by Peter Sun on 4/2/23.
//

import SwiftUI

struct CreditDetailItemView: View {
    
    let viewModel: CreditDetailItemViewModel
    
    var body: some View {
        HStack {
            PlaceholderAsyncImageView(url: viewModel.posterURL)
                .frame(width: 95, height: 140)
            
            VStack(alignment: .leading, spacing: 10) {
                Text(viewModel.name)
                    .font(.headline)
                Text(viewModel.role)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
}
