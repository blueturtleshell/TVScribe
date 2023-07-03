//
//  UserDefault+Discovery.swift
//  TVScribe
//
//  Created by Peter Sun on 4/21/23.
//

import Foundation

extension UserDefaults {
    var favoriteGenres: [API.Genre] {
        get {
            enumArray(forKey: "favorite_genres")
        }
        
        set {
            set(newValue.map { $0.rawValue }, forKey: "favorite_genres")
        }
    }
    
    var favoritePeopleIDs: [String] {
        get {
            stringArray(forKey: "favorite_peopleIDs") ?? []
        }
        
        set {
            set(newValue, forKey: "favorite_peopleIDs")
        }
    }
    
    private func enumArray<T: RawRepresentable>(forKey key: String) -> [T] where T.RawValue == Int {
        return (array(forKey: key) as? [Int])?.compactMap { T(rawValue: $0) } ?? []
    }
}
