//
//  OnBordingEndPointes.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 19/07/2026.
//

import Foundation


enum OnBordingEndPointes: APIEndpoint{

    case getAllTrackes
    case updateUserProfile(updateProfileRequestDTO: UpdateProfileRequestDTO)
    
    var baseURL: String {
        return "https://afd9-196-130-248-12.ngrok-free.app"
    }
    
    var path: String{
        switch self {
        case.getAllTrackes:
            return "/api/v1/tracks"
        case.updateUserProfile:
            return "/api/v1/profile"
        }
    }

    var method: HTTPMethod{
        switch self{
        case.getAllTrackes:
            return .get
        case.updateUserProfile:
            return .patch
        }
    }
    
    var body: Data? {
           switch self {
           case .getAllTrackes: return nil
           case .updateUserProfile(let updateProfileDTO): return Self.encode(updateProfileDTO)
           }
       }
    
    var requiresAuthentication: Bool {
            switch self {
            case .getAllTrackes:  return true
            case .updateUserProfile:  return true
            }
        }
    
    var headers: [String: String] {
        ["Content-Type": "application/json"]
    }
    
}
