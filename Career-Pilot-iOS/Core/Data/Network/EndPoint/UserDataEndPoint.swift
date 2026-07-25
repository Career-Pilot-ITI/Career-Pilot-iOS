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
    
    case analyseCV(URL)
    case uploadFile(URL, FileTypes)
    
    private var boundary: String {
        "Boundary-\(UUID().uuidString)"
    }
    
    
    var baseURL: String {
        return "https://192.168.84.1:8080"
    }

    var path: String {
        switch self {
        case .analyseCV(_):
            return "/api/v1/profile/cv/analyze"
        case .uploadFile(_, _):
            return "/api/v1/files/upload"
        }
    }

    var method: HTTPMethod {
        return .post
    }

    var body: Data? {

        let builder = MultipartFormDataBuilder()

        switch self {

        case .analyseCV(let url):

            return try? builder
                .addFile(name: "file", fileURL: url)
                .build()

        case .uploadFile(let url, let type):

            return try? builder
                .addText(name: "type", value: type.rawValue)
                .addFile(name: "file", fileURL: url)
                .build()
        }
    }

    var headers: [String : String] {
        [
            "Content-Type": "multipart/form-data; boundary=\(boundary)"
        ]
    }
}
