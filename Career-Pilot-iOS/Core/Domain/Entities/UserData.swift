//
//  UserData.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 15/07/2026.
//

import Foundation

struct UserData {
    var email: String
    var title: String
    var experienceLevel: String
    var skills: [String]
    
    var firstName: String
    var lastName: String
    
    var cv: URL?
    var selectedTrack: Track?
    
    var fullName: String {
        get {
            return "\(firstName) \(lastName)"
        }
        set(newValue) {
            let components = newValue.components(separatedBy: " ")
            firstName = components.first ?? ""
            lastName = components.dropFirst().joined(separator: " ")
        }
    }
}
