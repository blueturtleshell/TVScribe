//
//  CreditDetailItemViewModel.swift
//  TVScribe
//
//  Created by Peter Sun on 3/27/23.
//

import Foundation

class CreditDetailItemViewModel {
    
    private var mediaRolePosterPath: String?
    private var mediaName: String?
    private var mediaRole: String?
    
    init(castCredit: CastCredit) {
        mediaRolePosterPath = castCredit.posterPath
        mediaName = castCredit.title ?? castCredit.name
        mediaRole = castCredit.character
    }
    
    init(crewCredit: CrewCredit) {
        mediaRolePosterPath = crewCredit.posterPath
        mediaName = crewCredit.title ?? crewCredit.name
        mediaRole = crewCredit.job ?? crewCredit.department
    }
    
    var posterURL: URL? {
        guard let mediaRolePosterPath, !mediaRolePosterPath.isEmpty else { return nil }
        return ImageEndpoint.poster(size: .w154, path: mediaRolePosterPath).url()
    }
    
    var name: String {
        guard let mediaName, !mediaName.isEmpty else { return "N/A" }
        return mediaName
    }
    
    var role: String {
        guard let mediaRole, !mediaRole.isEmpty else { return "N/A" }
        return mediaRole
    }
}
