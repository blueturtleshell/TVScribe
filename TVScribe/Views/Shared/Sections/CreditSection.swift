//
//  CreditSection.swift
//  TVScribe
//
//  Created by Peter Sun on 3/19/23.
//

import SwiftUI

struct CreditSection: View {
    
    let title: String
    let credits: [Credit]
    
    var body: some View {
        if credits.isEmpty {
            VStack {
                Text(title)
                    .headerStyle()
                    .padding([.top, .horizontal])
                
                Text("Credits not available")
                    .padding()
            }
        } else {
            Group {
                Text(title)
                    .headerStyle()
                    .padding([.top, .horizontal])
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(credits, id: \.self.specialID) { credit in
                            NavigationLink(value: credit) {
                                ProfileCreditView(viewModel: CreditViewModel(credit: credit))
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}
