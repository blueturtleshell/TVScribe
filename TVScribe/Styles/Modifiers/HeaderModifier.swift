//
//  TVScribe.swift
//  CineLogSUI
//
//  Created by Peter Sun on 3/19/23.
//

import SwiftUI

private struct HeaderModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title3)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

extension View {
    func headerStyle() -> some View {
        modifier(HeaderModifier())
    }
}
