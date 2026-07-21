//
//  UserDataEndPoint.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 17/07/2026.
//

import Foundation

enum FileTypes: String{
    case CVs = "cvs", Avatars = "avatars", Resumes = "resumes"
}

enum UserDataEndPointes: APIEndpoint{
    
    case uploadFile(file: Data, fileType: FileTypes)
    
    var baseURL: String{
        return "https://career-pilot-iti.github.io/Career-Pilot-Backend/"
    }
    
    var path: String{
        switch self{
        case.uploadFile( _, _):
            return "api/v1/files/upload"
        }
    }
    
    var method: HTTPMethod{
        switch self{
        case.uploadFile(_,_):
            return .post
        }
    }
    
    var body: Data?{
        switch self{
        case.uploadFile(let file, let fileType):
            let base64FileString = file.base64EncodedString()
            
            let jsonParameters: [String: Any] = [
                        "file": base64FileString,
                        "type": fileType.rawValue
                    ]
            
            return try? JSONSerialization.data(withJSONObject: jsonParameters, options: [])
        }
    }
    
    var headers: [String: String] {
        ["Content-Type": "application/json"]
    }
}
