//
//  OverviewSection.swift
//  TVScribe
//
//  Created by Peter Sun on 3/19/23.
//

import SwiftUI

struct OverviewSection: View {
    
    let overview: String
    
    var body: some View {
        Group {
            Text("Overview")
                .headerStyle()
                .padding([.top, .horizontal])
            
            Text(overview)
                .font(.body)
                .lineSpacing(6)
                .padding()
                .background(.thinMaterial)
        }
    }
}
