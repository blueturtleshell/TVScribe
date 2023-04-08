//
//  AccountView.swift
//  TVScribe
//
//  Created by Peter Sun on 4/4/23.
//

import SwiftUI

struct AccountView: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var dataManager: DataManager
    @StateObject var viewModel = AccountViewModel()
    let columns = [GridItem(.adaptive(minimum: 180, maximum: 200), spacing: 8)]
    
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack {
                    VStack {
                        Picker("Show favorites or bookmark", selection: $viewModel.accountCategory) {
                            ForEach(AccountCategory.allCases, id: \.self) { category in
                                Text(category.name)
                            }
                        }
                        .pickerStyle(.segmented)
                        
                        Picker("Show movies, tv shows, or people", selection: $viewModel.type) {
                            ForEach(SavedType.allCases, id: \.self) { category in
                                Text(category.name)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    .padding()
                    .background(.thinMaterial)
                    .cornerRadius(8)
                    .padding()
                    
                    Section {
                        if viewModel.currentFilteredItems.isEmpty {
                            Text("No \(viewModel.accountCategory.name) \(viewModel.type.name)")
                                .frame(maxHeight: .infinity)
                        } else {
                            currentFilteredItemsList
                                .frame(maxHeight: .infinity, alignment: .top)
                                .padding(.horizontal, 8)
                        }
                    }
                    
                    Spacer()
                }
                
            }
        }
        .navigationTitle("Account")
        .onAppear {
            viewModel.dataManager = dataManager
            viewModel.fetchAllSavedItems()
        }
    }
    
    var currentFilteredItemsList: some View {
        LazyVGrid(columns: columns, spacing: 24) {
            ForEach(viewModel.currentFilteredItems) { item in
                let savedItemViewModel = SavedItemViewModel(savedItem: item)
                VStack {
                    PlaceholderAsyncImageView(url: savedItemViewModel.imageURL)
                        .shadow(radius: 4)
                    
                    VStack(alignment: .leading) {
                        Text(savedItemViewModel.name)
                            .font(.headline)
                            .foregroundColor(.primary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.75)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 8)
                }
                .onTapGesture {
                    switch savedItemViewModel.type {
                    case "movie":
                        navigationManager.showMovie(with: savedItemViewModel.id)
                    case "tv":
                        navigationManager.showTVShow(with: savedItemViewModel.id)
                    case "person":
                        navigationManager.showCredit(with: savedItemViewModel.id)
                    default: return
                    }
                }
            }
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AccountView()
                .environmentObject(DataManager())
                .environmentObject(NavigationManager())
        }
    }
}

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

enum AccountCategory: String, CaseIterable {
    case favorite, bookmark
    
    var name: String {
        rawValue.capitalized
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
}

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
