//
//  SearchItemView.swift
//  TVScribe
//
//  Created by Peter Sun on 3/31/23.
//

import SwiftUI

struct SearchItemView: View {
    
    let viewModel: SearchItemViewModel
    
    var body: some View {
        VStack {
            PlaceholderAsyncImageView(url: viewModel.imageURL)
            .shadow(radius: 4)

            VStack(alignment: .leading) {
                Text(viewModel.headline)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                Text(viewModel.subheadline)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 8)
        }
    }
}

class SearchItemViewModel {
    private let _id: Int
    private var imagePath: String?
    private var _headline: String?
    private var _subheadline: String?
    private let _mediaType: String?
    
    init(searchItem: SearchItem, searchScope: String) {
        _id = searchItem.id
        
        switch searchScope {
        case "all":
            _mediaType = searchItem.mediaType

            if searchItem.mediaType == "person" {
                imagePath = searchItem.profilePath
                _headline = searchItem.name
                _subheadline = "Person"
                
            } else {
                imagePath = searchItem.posterPath
                _headline = searchItem.name ?? searchItem.title
                _subheadline = self.releaseYear(from: searchItem)
            }
        case "person":
            imagePath = searchItem.profilePath
            _headline = searchItem.name
            _mediaType = searchScope
            _subheadline = "Person"
        default:
            imagePath = searchItem.posterPath
            _headline = searchItem.name ?? searchItem.title
            _mediaType = searchScope
            _subheadline = self.releaseYear(from: searchItem)
        }
    }
    
    var id: Int {
        _id
    }
    
    var imageURL: URL? {
        guard let imagePath = imagePath, !imagePath.isEmpty else { return nil }
        if mediaType.lowercased() == "person" {
            return ImageEndpoint.profile(size: .w185, path: imagePath).url()
        } else {
            return ImageEndpoint.poster(size: .w154, path: imagePath).url()
        }
    }
    
    var headline: String {
        guard let headline = _headline, !headline.isEmpty else { return "N/A" }
        return headline
    }
    
    var subheadline: String {
        guard let subheadline = _subheadline, !subheadline.isEmpty else { return "N/A" }
        return subheadline
    }
    
    var mediaType: String {
        _mediaType ?? "Unknown"
    }
    
    private func releaseYear(from searchItem: SearchItem) -> String {
        if let releaseDate = searchItem.releaseDate, !releaseDate.isEmpty {
            return String(searchItem.releaseDate?.split(separator: "-").first ?? "-")
        } else {
            return String(searchItem.firstAirDate?.split(separator: "-").first ?? "-")
        }
    }
}
