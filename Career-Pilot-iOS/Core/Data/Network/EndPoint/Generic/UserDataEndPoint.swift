//
//  UserDataEndPoint.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 17/07/2026.
//

import Foundation

enum FileTypes: String {
    case CVs = "cvs", Avatars = "avatars", Resumes = "resumes", Audio = "audio"
}

enum UserDataEndpoints: APIEndpoint {

    case analyseCV(URL, boundary: String)
    case uploadFile(URL, FileTypes, boundary: String)

    private var boundary: String {
        switch self {
        case .analyseCV(_, let boundary):
            return boundary
        case .uploadFile(_, _, let boundary):
            return boundary
        }
    }

    var requiresAuthentication: Bool{
        true
    }

    var path: String {
        switch self {
        case .analyseCV:
            return "api/v1/profile/cv/analyze"
        case .uploadFile:
            return "api/v1/files/upload"
        }
    }

    var method: HTTPMethod {
        return .post
    }

    var body: Data? {
        let builder = MultipartFormDataBuilder(boundary: boundary)
        switch self {
        case .analyseCV(let url, _):
            return try? builder
                .addFile(name: "file", fileURL: url)
                .build()
        case .uploadFile(let url, let type, _):
            return try? builder
                .addText(name: "type", value: type.rawValue)
                .addFile(name: "file", fileURL: url)
                .build()
        }
    }

    var headers: [String: String] {
        let tokenString: String
        do {
            
            if let tokens = try KeychainAuthTokenStore().loadTokens() {
                tokenString = tokens.accessToken
                
            } else {
                tokenString = ""
                print("Token is not found")

            }
        } catch {
            tokenString = ""
        }
       return [
            "Content-Type": "multipart/form-data; boundary=\(boundary)",
            "Authorization": "Bearer \(tokenString)"
        ]
    }
}


