//
//  OnBordingEndPointes.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 19/07/2026.
//

import Foundation


enum OnBordingEndPointes: APIEndpoint{
    private static let boundary = "Boundary-\(UUID().uuidString)"


    case getAllTrackes
    
    var baseURL: String{
        "https://4a32-196-138-187-117.ngrok-free.app/"
    }
    
    var path: String{
        switch self{
        case.getAllTrackes:
            return "api/v1/tracks"
        }
    }
    
    var method: HTTPMethod{
        switch self{
        case.getAllTrackes:
            return.get
        }
    }
    
    var headers: [String: String] {
        return [
            "Content-Type": "multipart/form-data; boundary=\(Self.boundary)",
            "accept": "application/json",
            "Authorization": " Bearer eyJhbGciOiJIUzI1NiJ9.eyJyb2xlcyI6WyJST0xFX1VTRVIiXSwiaWQiOjEsInN1YiI6InVzZXJfODU4MzM4IiwiaWF0IjoxNzg0NTQxODIyLCJleHAiOjE3ODQ1NDU0MjJ9.i6FLXunKRul3t9vR-Go2Dm132DfopNAUoDSMPtWpHOs"
        ]
    }
    
}
