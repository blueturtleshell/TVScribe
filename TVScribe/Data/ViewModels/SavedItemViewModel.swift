//
//  SavedItemViewModel.swift
//  TVScribe
//
//  Created by Peter Sun on 4/13/23.
//

import Foundation

class SavedItemViewModel {
    
    private let savedItem: SavedItem
    
    init(savedItem: SavedItem) {
        self.savedItem = savedItem
    }
    
    var id: Int {
        Int(savedItem.moviedbID!)!
    }
    
    var name: String {
        savedItem.name ?? ""
    }
    
    var type: String {
        savedItem.type ?? "movie"
    }
    
    var imageURL: URL? {
        guard let path = savedItem.imagePath, !path.isEmpty else { return nil }
        
        return URL(string: path)
    }
}
