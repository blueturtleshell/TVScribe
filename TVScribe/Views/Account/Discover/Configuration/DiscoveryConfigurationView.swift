//
//  DiscoverConfigurationView.swift
//  TVScribe
//
//  Created by Peter Sun on 4/19/23.
//

import SwiftUI

struct DiscoverConfigurationView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var accountViewModel: AccountViewModel
    
    @ObservedObject var discoveryViewModel: DiscoverViewModel
    
    @State private var useGenres = true
    @State private var usePeople = true
    @State private var useYears = true
    
    @State private var localGenres: [API.Genre] = UserDefaults.standard.favoriteGenres
    @State private var localPeople: [SavedItem] = []
    
    var body: some View {
        Form {
            Section {
                Toggle("Use Genres", isOn: $useGenres.animation())
                
                if useGenres {
                    List {
                        ForEach(API.Genre.allCases, id: \.self) { genre in
                            DiscoverGenreRowView(genre: genre,
                                                  selected: localGenres.contains(genre))
                            .onTapGesture {
                                if localGenres.contains(genre) {
                                    localGenres.removeAll { $0 == genre }
                                } else {
                                    localGenres.append(genre)
                                }
                            }
                        }
                    }
                }
            } header: {
                HStack {
                    Text("Genres")
                    
                    Spacer()
                    
                    Button(localGenres.count == API.Genre.allCases.count ? "Remove All" : "Select All") {
                        withAnimation {
                            if localGenres.count == API.Genre.allCases.count {
                                localGenres = []
                            } else {
                                localGenres = API.Genre.allCases
                            }
                        }
                    }
                    .font(.caption)
                }
            }
            
            Section {
                Toggle("Use Actors and Crew Members", isOn: $usePeople)
                
                List {
                    ForEach(accountViewModel.favoritePeople, id: \.self) { person in
                        DiscoverPersonRowView(savedItemViewModel: SavedItemViewModel(savedItem: person),
                                               selected: localPeople.contains(person))
                        .onTapGesture {
                            if localPeople.contains(person) {
                                localPeople.removeAll { $0 == person }
                            } else {
                                localPeople.append(person)
                            }
                        }
                    }
                }
                
            } header: {
                HStack {
                    Text("People")
                    
                    Spacer()
                    
                    Button("Select All") {
                        
                    }
                    .font(.caption)
                }
            }
            
            Section {
                Toggle("Use Release Year", isOn: $useYears)
                
                VStack {
                    DatePicker("Minimum Date", selection: .constant(.now), displayedComponents: .date)
                    DatePicker("Maximum Date", selection: .constant(.now), displayedComponents: .date)
                }
            } header: {
                Text("Release year")
            }
            
        }
        .onAppear {
            localPeople = accountViewModel.favoritePeople
        }
        .navigationTitle("Discovery Settings")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    
                    if useGenres {
                        discoveryViewModel.selectedGenres = localGenres
                    } else {
                        discoveryViewModel.selectedGenres = []
                    }
                    
                    if usePeople {
                        discoveryViewModel.selectedPeopleIDs = localPeople.map { $0.moviedbID ?? "" }
                    } else {
                        discoveryViewModel.selectedPeopleIDs = []
                    }
                                        
                    dismiss()
                }
            }
        }
    }
}

struct DiscoverConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DiscoverConfigurationView(discoveryViewModel: DiscoverViewModel())
                .environmentObject(AccountViewModel())
        }
    }
}



