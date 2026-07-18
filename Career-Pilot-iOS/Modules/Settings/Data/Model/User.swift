//
//  User.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 17/07/2026.
//

import Foundation
class User {
    var email: String
    var title: String
    var experienceLevel: String
    var skills: [String]
    var firstName: String
    var lastName: String
    init(email: String, title: String, experienceLevel: String, skills: [String], firstName: String, lastName: String) {
        self.email = email
        self.title = title
        self.experienceLevel = experienceLevel
        self.skills = skills
        self.firstName = firstName
        self.lastName = lastName
    }
}

