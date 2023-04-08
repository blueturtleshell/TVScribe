//
//  DataManager.swift
//  TVScribe
//
//  Created by Peter Sun on 4/2/23.
//

import Foundation
import CoreData


class DataManager: ObservableObject {
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "Main")
        container.loadPersistentStores { description, error in
            if let error {
                print(error)
            }
        }
    }
    
    func createSavedItem(id: Int, name: String, posterURL: URL?, type: SavedType, bookmarked: Bool = false, favorited: Bool = false) {
        let savedItem = SavedItem(context: container.viewContext)
        savedItem.moviedbID = String(id)
        savedItem.imagePath = posterURL?.absoluteString ?? ""
        savedItem.isBookmark = bookmarked
        savedItem.isFavorite = favorited
        savedItem.name = name
        savedItem.type = type.rawValue
        savedItem.dateAdded = .now
        
        save()
    }
    
    func fetchAllSavedItems() -> [SavedItem] {
        let fetchRequest: NSFetchRequest<SavedItem> = SavedItem.fetchRequest()
        do {
            let results = try container.viewContext.fetch(fetchRequest)
            return results
        } catch {
            print("Error fetching saved items: \(error.localizedDescription)")
            return []
        }
    }
    
    func fetchSavedItem(with id: String) -> SavedItem? {
        let fetchRequest = SavedItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "moviedbID = %@", id)
        return try? container.viewContext.fetch(fetchRequest).first
    }
    
    func toggleBookmark(for savedItem: SavedItem) {
        savedItem.isBookmark.toggle()
        save()
        
        if !savedItem.isBookmark {
            deleteUnusedItems()
        }
    }
    
    func toggleFavorite(for savedItem: SavedItem) {
        savedItem.isFavorite.toggle()
        save()
        
        if !savedItem.isFavorite {
            deleteUnusedItems()
        }
    }
    
    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }
    
    func deleteUnusedItems() {
        let fetchRequest: NSFetchRequest<SavedItem> = SavedItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isFavorite == false AND isBookmark == false")
        
        do {
            let itemsToDelete = try container.viewContext.fetch(fetchRequest)
            for item in itemsToDelete {
                container.viewContext.delete(item)
            }
            try container.viewContext.save()
        } catch {
            print("Error deleting unused items: \(error.localizedDescription)")
        }
    }
    
    func save() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print(error)
            }
        }
    }
    
    func delete(_ object: NSManagedObject) {
        guard !object.isDeleted else { return }
        container.viewContext.delete(object)
    }
}
