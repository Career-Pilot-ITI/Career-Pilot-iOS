//
//  UserDataEndPoint.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 17/07/2026.
//

//import Foundation
//
//enum FileTypes: String {
//    case CVs = "cvs", Avatars = "avatars", Resumes = "resumes", Audio = "audios"
//}
//
//enum UserDataEndpoints: APIEndpoint {
//
//    case analyseCV(URL)
//    case uploadFile(URL, FileTypes)
//
//    private var boundary: String {
//        "Boundary-\(UUID().uuidString)"
//    }
//
//    private var multipartBuilder: MultipartFormDataBuilder{
//        MultipartFormDataBuilder(boundary: boundary)
//    }
//
//    var baseURL: String {
//        return "https://dfa0-41-41-134-165.ngrok-free.app"
//    }
//
//    var path: String {
//        switch self {
//        case .analyseCV(_):
//            return "/api/v1/profile/cv/analyze"
//        case .uploadFile(_, _):
//            return "/api/v1/files/upload"
//        }
//    }
//
//    var method: HTTPMethod {
//        return .post
//    }
//
//    var body: Data? {
//        let boundary = self.boundary
//        let builder = MultipartFormDataBuilder(boundary: boundary)
//        switch self {
//        case .analyseCV(let url):
//            return try? builder.addFile(name: "file", fileURL: url).build()
//        case .uploadFile(let url, let type):
//            return try? builder
//                .addText(name: "type", value: type.rawValue)
//                .addFile(name: "file", fileURL: url)
//                .build()
//        }
//    }
//
//    var headers: [String: String] {
//        [
//            "Content-Type": "multipart/form-data; boundary=\(boundary)",   // ⚠️ still a fresh UUID here, different from body's!
//            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJyb2xlcyI6WyJST0xFX1VTRVIiXSwiaWQiOjEsImVtYWlsIjoiRXlhZHc4N0BnbWFpbC5jb20iLCJzdWIiOiJFeWFkdzg3IiwiaWF0IjoxNzg1MDc2NjU4LCJleHAiOjE3ODU0MzY2NTh9.OdAp3AWlrzCmjKCYk_UQnXWtq8PLeOnGyeNKMbYoJvw"
//        ]
//    }
//
//
//}
//
//  UserDataEndPoint.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 17/07/2026.
//
import Foundation

enum FileTypes: String {
    case CVs = "cvs", Avatars = "avatars", Resumes = "resumes", Audio = "audios"
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

    var baseURL: String {
        return "https://dfa0-41-41-134-165.ngrok-free.app"
    }

    var path: String {
        switch self {
        case .analyseCV:
            return "/api/v1/profile/cv/analyze"
        case .uploadFile:
            return "/api/v1/files/upload"
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
        [
            "Content-Type": "multipart/form-data; boundary=\(boundary)",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJyb2xlcyI6WyJST0xFX1VTRVIiXSwiaWQiOjEsImVtYWlsIjoiRXlhZHc4N0BnbWFpbC5jb20iLCJzdWIiOiJFeWFkdzg3IiwiaWF0IjoxNzg1MDc2NjU4LCJleHAiOjE3ODU0MzY2NTh9.OdAp3AWlrzCmjKCYk_UQnXWtq8PLeOnGyeNKMbYoJvw"
            // ⚠️ swap TokenStorage.shared.token for wherever your app actually stores the JWT after login
        ]
    }
}


