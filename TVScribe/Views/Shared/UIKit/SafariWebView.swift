//
//  SafariWebView.swift
//  TVScribe
//
//  Created by Peter Sun on 3/22/23.
//

import SwiftUI
import SafariServices

struct SafariWebView: UIViewControllerRepresentable {
    
    let url: URL
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
