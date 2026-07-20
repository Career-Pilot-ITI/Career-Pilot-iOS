//
//  OnBordingEndPointes.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 19/07/2026.
//

import Foundation


enum OnBordingEndPointes: APIEndpoint{

    case getAllTrackes
    case updateProfile(profile: UserProfileDTO)
    
    var baseURL: String{
        "http://192.168.1.8:8080"
    }
    
    var path: String{
        switch self {
        case.getAllTrackes:
            return "api/v1/tracks"
        case.updateProfile:
            return "api/v1/profile"
        }
    }
    
    
    var method: HTTPMethod{
        switch self{
        case.getAllTrackes:
            return.get
        case.updateProfile:
            return.patch
        }
    }
    
    var body: Data? {
           switch self {
           case .getAllTrackes: return nil
           case .updateProfile(let profile): return Self.encode(profile)
           }
       }
    
    var requiresAuthentication: Bool {
            switch self {
            case .getAllTrackes:  return false
            case .updateProfile:  return true
            }
        }
    
}
