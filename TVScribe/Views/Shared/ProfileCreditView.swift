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
            Group {
                if let profileURL = viewModel.profileURL {
                    AsyncImage(url: profileURL) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .cornerRadius(10)
                        
                    } placeholder: {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                } else {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.thinMaterial)
                        .overlay {
                            Image(systemName: "photo")
                                .font(.largeTitle)
                                .fontWeight(.semibold)
                        }
                }
            }
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

//struct ProfileCreditView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileCreditView()
//    }
//}
