//
//  RegionWatchProvidersViewModel.swift
//  TVScribe
//
//  Created by Peter Sun on 3/25/23.
//

import Foundation

class RegionWatchProvidersViewModel {
    
    let watchProviderRegion: RegionWatchProviders
    
    init(watchProviderRegion: RegionWatchProviders) {
        self.watchProviderRegion = watchProviderRegion
    }
    
    var buy: [WatchProvider] {
        watchProviderRegion.buy ?? []
    }
    
    var rent: [WatchProvider] {
        watchProviderRegion.rent ?? []
    }
    
    var subscription: [WatchProvider] {
        watchProviderRegion.subscription ?? []
    }
    
    var link: URL? {
        guard let link = watchProviderRegion.link, !link.isEmpty else { return nil }
        return URL(string: link)
    }
}

