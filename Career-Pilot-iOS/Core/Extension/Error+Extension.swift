//
//  Error+Extension.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 16/08/2026.
//

import Foundation

extension Error {
    var userFriendlyMessage: String {
        if let networkError = self as? NetworkError {
            switch networkError {
            case .noInternet:
                return "Please check your internet connection and try again."
            case .unauthorized:
                return "Your session has expired. Please log in again."      
            default:
                return localizedDescription
            }
        }
        return localizedDescription
    }
}


