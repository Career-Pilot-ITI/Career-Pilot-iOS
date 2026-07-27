//
//  UserInforrmation.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 17/07/2026.
//
import Foundation
class UserInformation {
    var email: String 
    var title: String
    var phoneNumber : String
    var firstName: String
    var lastName: String
    var track : String
    var tittleRole : String
    var experienceLevel: String
    var skills: [String]
    var userCV : String
    init(email: String, title: String, phoneNumber: String, firstName: String, lastName: String, track: String, tittleRole: String, experienceLevel: String, skills: [String], userCV: String) {
        self.email = email
        self.title = title
        self.phoneNumber = phoneNumber
        self.firstName = firstName
        self.lastName = lastName
        self.track = track
        self.tittleRole = tittleRole
        self.experienceLevel = experienceLevel
        self.skills = skills
        self.userCV = userCV
    }
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
