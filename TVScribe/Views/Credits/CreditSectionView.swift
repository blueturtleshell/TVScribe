//
//  CreditSectionView.swift
//  TVScribe
//
//  Created by Peter Sun on 4/2/23.
//

import SwiftUI

struct CastCreditSectionView: View {
    
    let headerText: String
    let credits: [CastCredit]
    var tapAction: (Int) -> Void
    
    var body: some View {
        Section {
            if credits.isEmpty {
                Text("Credits were not available")
                    .padding()
                    .background(.thinMaterial)
            } else {
                LazyVStack {
                    ForEach(credits, id: \.self.specialID) { credit in
                        CreditDetailItemView(viewModel: CreditDetailItemViewModel(castCredit: credit))
                            .onTapGesture {
                                tapAction(credit.id)
                            }
                    }
                }
            }
        } header: {
            Text(headerText)
        }
    }
}

struct CrewCreditSectionView: View {
    
    let headerText: String
    let credits: [CrewCredit]
    var tapAction: (Int) -> Void
    
    var body: some View {
        Section {
            if credits.isEmpty {
                Text("Credits were not available")
                    .padding()
                    .background(.thinMaterial)
            } else {
                LazyVStack {
                    ForEach(credits, id: \.self.specialID) { credit in
                        CreditDetailItemView(viewModel: CreditDetailItemViewModel(crewCredit: credit))
                            .onTapGesture {
                                tapAction(credit.id)
                            }
                    }
                }
            }
        } header: {
            Text(headerText)
        }
    }
}
