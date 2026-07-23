//
//  UserData.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 15/07/2026.
//

import Foundation
import UIKit

struct UserData {
    var email: String
    var title: String
    var avatarUrl: String?
    var avatarFileId: Int?
    var gender: String?
    var experienceLevel: String
    var skills: [Skill]
    var profileImageData : Data?
    var firstName: String
    var lastName: String
    var cv: URL?
    var selectedTrack: Track?
    var profileImage: UIImage? {
          get {
              guard let data = profileImageData else { return nil }
              return UIImage(data: data)
          }
          set {
              profileImageData = newValue?.jpegData(compressionQuality: 0.8)
          }
      }
    var fullName: String {
        get {
            if(firstName.isEmpty && lastName.isEmpty){
                return ""
            }
            else{
                return "\(firstName) \(lastName)"
            }
        }
        set(newValue) {
            let components = newValue.components(separatedBy: " ")
            firstName = components.first ?? ""
            lastName = components.dropFirst().joined(separator: " ")
        }
    }
}
