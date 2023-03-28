//
//  WatchProviderSection.swift
//  TVScribe
//
//  Created by Peter Sun on 3/24/23.
//

import SwiftUI

struct WatchProviderSection: View {
    
    @Binding var providerMethodSelection: ProviderMethod
    private let allWhereToWatchSections = ProviderMethod.allCases
    
    let viewModel: RegionWatchProvidersViewModel
    
    init(viewModel: RegionWatchProvidersViewModel, providerMethodSelection: Binding<ProviderMethod>) {
        self.viewModel = viewModel
        _providerMethodSelection = providerMethodSelection
    }
    
    var body: some View {
        VStack {
            Picker("Watch provider methods", selection: $providerMethodSelection.animation()) {
                ForEach(allWhereToWatchSections, id: \.self) { providerMethod in
                    Text(providerMethod.name)
                }
            }
            .pickerStyle(.segmented)
            .padding([.top, .horizontal])
            .padding(.bottom, 4)
            
            Section {
                switch providerMethodSelection {
                case .buy:
                    WatchProviderSectionCategoryView(providers: viewModel.buy)
                case .rent:
                    WatchProviderSectionCategoryView(providers: viewModel.rent)
                case .subscription:
                    WatchProviderSectionCategoryView(providers: viewModel.subscription)
                }
            } footer: {
                VStack {
                    Text("Results provided by JustWatch")
                        .font(.footnote)
                    
                    if let link = viewModel.link {
                        Link(destination: link) {
                            Text("Click here for more information")
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
            .padding(.vertical)
        }
    }
}

enum ProviderMethod: String, CaseIterable {
    case buy, rent, subscription
    
    var name: String {
        return rawValue.capitalized
    }
}

struct WatchProviderSectionCategoryView: View {
    
    let providers: [WatchProvider]
    
    var body: some View {
        if providers.isEmpty {
            Text("Providers not found")
                .padding()
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 10) {
                    ForEach(providers) { provider in
                        let watchProviderViewModel = WatchProviderViewModel(watchProvider: provider)
                        VStack {
                            PlaceholderAsyncImageView(url: watchProviderViewModel.imageURL)
                                .frame(width: 40, height: 40)
                            Text(watchProviderViewModel.name)
                                .font(.caption)
                                .minimumScaleFactor(0.5)
                                .multilineTextAlignment(.center)
                        }
                        .frame(width: 60)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

