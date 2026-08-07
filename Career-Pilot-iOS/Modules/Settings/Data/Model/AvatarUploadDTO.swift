//
//  AvatarUploadDTO.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 30/07/2026.
//

import Foundation
struct AvatarUploadDTO : Encodable {
    var imageData : Data
    var fileType : String
    var boundry : String
}
