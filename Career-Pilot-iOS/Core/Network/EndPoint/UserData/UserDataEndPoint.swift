//
//  UserDataEndPoint.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 17/07/2026.
//

import Foundation

enum FileTypes: String {
    case CVs = "cvs", Avatars = "avatars", Resumes = "resumes"
}

enum UserDataEndPointes: APIEndpoint {

    case analyseCv(cvURL: URL)
    case uplodeFile(fileURL: URL, fileType: FileTypes)

    private static let boundary = "Boundary-\(UUID().uuidString)"

    var baseURL: String {
        return "https://a32c-102-188-63-78.ngrok-free.app/swagger-ui/index.html"
    }

    var path: String {
        switch self {
        case .analyseCv:
            return "api/v1/profile/cv/analyze"
        case .uplodeFile:
            return "api/v1/files/upload"
        }
    }

    var method: HTTPMethod {
        return .post
    }

    var headers: [String: String] {
        return [
            "Content-Type": "multipart/form-data; boundary=\(Self.boundary)",
            "accept": "application/json"
        ]
    }

    var body: Data? {
        switch self {
        case .analyseCv(let cvURL):
            return Self.multipartBody(fileFieldName: "file", fileURL: cvURL, boundary: Self.boundary)
        case .uplodeFile(let fileURL, let fileType):
            return Self.multipartBody(
                fileFieldName: "file",
                fileURL: fileURL,
                boundary: Self.boundary,
                textFields: ["type": fileType.rawValue]
            )
        }
    }

    private static func multipartBody(
        fileFieldName: String,
        fileURL: URL,
        boundary: String,
        textFields: [String: String] = [:]
    ) -> Data? {
        guard let fileData = try? Data(contentsOf: fileURL) else { return nil }

        let filename = fileURL.lastPathComponent
        let mime = mimeType(for: fileURL)
        let lineBreak = "\r\n"

        var body = Data()

        // Plain text fields (e.g. "type") come before the file part.
        for (name, value) in textFields {
            body.appendString("--\(boundary)\(lineBreak)")
            body.appendString("Content-Disposition: form-data; name=\"\(name)\"\(lineBreak)\(lineBreak)")
            body.appendString("\(value)\(lineBreak)")
        }

        body.appendString("--\(boundary)\(lineBreak)")
        body.appendString("Content-Disposition: form-data; name=\"\(fileFieldName)\"; filename=\"\(filename)\"\(lineBreak)")
        body.appendString("Content-Type: \(mime)\(lineBreak)\(lineBreak)")
        body.append(fileData)
        body.appendString(lineBreak)
        body.appendString("--\(boundary)--\(lineBreak)")

        return body
    }

    private static func mimeType(for url: URL) -> String {
        switch url.pathExtension.lowercased() {
        case "pdf": return "application/pdf"
        case "doc": return "application/msword"
        case "docx": return "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        case "jpg", "jpeg": return "image/jpeg"
        case "png": return "image/png"
        default: return "application/octet-stream"
        }
    }
}

private extension Data {
    mutating func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
