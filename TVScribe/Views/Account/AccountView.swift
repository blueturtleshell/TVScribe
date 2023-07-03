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
    @State private var showDiscover = false
    @State private var showEmptyAlert = false
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack {
                    VStack {
                        Picker("Show favorites or bookmark", selection: $viewModel.accountCategory) {
                            ForEach(AccountCategory.allCases, id: \.self) { category in
                                Image(systemName: category.icon)
                                    .symbolVariant(category == viewModel.accountCategory ? .fill : .none)
                            }
                        }
                        .pickerStyle(.segmented)
                        
                        Picker("Show movies, tv shows, or people", selection: $viewModel.type) {
                            ForEach(SavedType.allCases, id: \.self) { category in
                                Image(systemName: category.icon)
                                    .symbolVariant(category == viewModel.type ? .fill : .none)
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
        .onAppear {
            viewModel.dataManager = dataManager
            viewModel.fetchAllSavedItems()
        }
        .navigationTitle("Account")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
//                    guard !viewModel.isEmpty else {
//                        showEmptyAlert = true
//                        return
//                    }
                    
                    showDiscover = true
                } label: {
                    Image(systemName: "binoculars.fill")
                }
            }
        }
        .navigationDestination(for: Int.self) { personID in
            CreditDetailsView(personID: personID)
        }
        .navigationDestination(isPresented: $showDiscover) {
            DiscoverView()
                .environmentObject(viewModel)
        }
        .alert("No Favorites", isPresented: $showEmptyAlert) {
            Button("OK") { }
        } message: {
            Text("To get started, ❤️ your favorite movies, tv shows, and people.")
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
                        navigationManager.showCreditFromAccount(with: savedItemViewModel.id)
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

enum AccountCategory: String, CaseIterable {
    case favorite, bookmark
    
    var name: String {
        rawValue.capitalized
    }
    
    var icon: String {
        switch self {
        case .favorite: return "heart"
        case .bookmark: return "bookmark"
        }
    }
}

