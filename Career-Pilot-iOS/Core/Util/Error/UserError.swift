//
//  UserError.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 22/07/2026.
//

import Foundation
enum UseCaseError: Error {
    case invalidEmail
    
    var userMessage: String{
        switch self{
        case.invalidEmail:
            return"Invalid Email"
        }
    }
}
