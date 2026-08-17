//
//  profileErrorMapping.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 09/08/2026.
//


import Foundation

enum ProfileValidationError: LocalizedError {
    case emptyFullName
    case emptyEmail
    case invalidEmail
    case emptyJobTitle
    case exprinceLevel
    case multiple([ProfileValidationError])

    var errorDescription: String? {
        switch self {
        case .emptyFullName: return "Full name can't be empty."
        case .emptyEmail: return "Email can't be empty."
        case .invalidEmail: return "Please enter a valid email address."
        case .emptyJobTitle: return "Current role / title can't be empty."
        case .exprinceLevel : return "ExprinceLevel can not empty."
        case .multiple(let errors): return errors.compactMap { $0.errorDescription }.joined(separator: "\n")
        }
    }
}

enum ProfileValidator {
    static func validate(_ user: UserSettingsDomain) throws {
        var errors: [ProfileValidationError] = []
        
        if !Validator.isNotEmpty(user.displayName) {
            errors.append(.emptyFullName)
        }
        
        let trimmedEmail = user.email.trimmingCharacters(in: .whitespaces)
        if trimmedEmail.isEmpty {
            errors.append(.emptyEmail)
        } else if !Validator.isValidEmail(trimmedEmail) {
            errors.append(.invalidEmail)
        }
        
//        if !Validator.isNotEmpty(user.currentJobTitle) {
//            errors.append(.emptyJobTitle)
//        }
        
        if !errors.isEmpty {
            throw errors.count == 1 ? errors[0] : ProfileValidationError.multiple(errors)
        }
    }
}
extension ProfileValidator {
    static func validateOnboard(_ user: User) throws {
        var errors: [ProfileValidationError] = []
        
        if !Validator.isNotEmpty(user.profile.displayName) {
            errors.append(.emptyFullName)
        }
        
        let trimmedEmail = user.profile.email.trimmingCharacters(in: .whitespaces)
        if trimmedEmail.isEmpty {
            errors.append(.emptyEmail)
        } else if !Validator.isValidEmail(trimmedEmail) {
            errors.append(.invalidEmail)
        }
        
        if !Validator.isNotEmpty(user.profile.targetRole) {
            errors.append(.emptyJobTitle)
        }
        
        if !Validator.isNotEmpty(user.profile.experienceLevel){
            errors.append(.exprinceLevel)
        }
        
        if !errors.isEmpty {
            throw errors.count == 1 ? errors[0] : ProfileValidationError.multiple(errors)
        }
    }
}
