//
//  GetAllTracks+Mapping.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 19/07/2026.
//

import Foundation

extension TrackDTO{
    func toDomain() -> Track{
        return Track(id: id, title: name, description: description, isActive: isActive)
    }
}
