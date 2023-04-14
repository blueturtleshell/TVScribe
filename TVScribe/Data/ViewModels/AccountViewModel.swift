//
//  AccountViewModel.swift
//  TVScribe
//
//  Created by Peter Sun on 4/13/23.
//

import CoreData
import Combine

class AccountViewModel: ObservableObject {
    
    var dataManager: DataManager?
    
    private var allItems = [SavedItem]()
    @Published var accountCategory: AccountCategory = .favorite
    @Published var type: SavedType = .movie
    
    private var notificationSubscription: AnyCancellable?
    
    var currentFilteredItems: [SavedItem] {
        switch accountCategory {
        case .favorite:
            return allItems
                .filter { $0.isFavorite }
                .filter { $0.type == type.name.lowercased() }
                .sorted { $0.name ?? "" < $1.name ?? "" }
        case .bookmark:
            return allItems
                .filter { $0.isBookmark }
                .filter { $0.type == type.name.lowercased() }
                .sorted { $0.name ?? "" < $1.name ?? "" }
        }
    }
    
    var isEmpty: Bool {
        allItems.isEmpty
    }
    
    init() {
        notificationSubscription = NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
            .sink { [weak self] notification in
                
                guard let self, let userInfo = notification.userInfo else { return }
                let inserted = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject> ?? []
                let updated = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject> ?? []
                let deleted = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject> ?? []
                
                handleInsertedItems(items: inserted)
                handleUpdatedItems(items: updated)
                handleDeletedItems(items: deleted)
            }
    }
    
    func fetchAllSavedItems() {
        objectWillChange.send()
        allItems = dataManager?.fetchAllSavedItems() ?? []
    }
    
    private func handleInsertedItems(items: Set<NSManagedObject>) {
        for object in items {
            if let savedItem = object as? SavedItem {
                allItems.append(savedItem)
            }
        }
    }
    
    // if an item is already bookmarked and favorites is toggled on
    private func handleUpdatedItems(items: Set<NSManagedObject>) {
        for object in items {
            if let savedItem = object as? SavedItem, let index = allItems.firstIndex(of: savedItem) {
                allItems[index] = savedItem
            }
        }
    }
    
    private func handleDeletedItems(items: Set<NSManagedObject>) {
        for object in items {
            if let savedItem = object as? SavedItem, let index = allItems.firstIndex(where: { $0.moviedbID == savedItem.moviedbID }) {
                allItems.remove(at: index)
            }
        }
    }
}

enum SavedType: String, CaseIterable {
    case movie, tv, person
    
    var name: String {
        if self == .tv {
            return rawValue.uppercased()
        }
        
        return rawValue.capitalized
    }
    
    var icon: String {
        switch self {
        case .movie:
            return "film"
        case .tv:
            return "tv"
        case .person:
            return "person"
        }
    }
}
