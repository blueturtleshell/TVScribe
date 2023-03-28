//
//  TitleStyle.swift
//  TVScribe
//
//  Created by Peter Sun on 3/19/23.
//

import SwiftUI

private struct TitleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .lineLimit(2)
            .multilineTextAlignment(.center)
            .fontWeight(.bold)
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(TitleStyle())
    }
}
