//
//  WatchProviderViewModel.swift
//  TVScribe
//
//  Created by Peter Sun on 3/25/23.
//

import Foundation

class WatchProviderViewModel {
    let watchProvider: WatchProvider
    
    init(watchProvider: WatchProvider) {
        self.watchProvider = watchProvider
    }
    
    var name: String {
        watchProvider.providerName
    }
    
    var imageURL: URL? {
        guard let logoPath = watchProvider.logoPath, !logoPath.isEmpty else { return nil }
        return ImageEndpoint.logo(size: .w45, path: logoPath).url()
    }
}
