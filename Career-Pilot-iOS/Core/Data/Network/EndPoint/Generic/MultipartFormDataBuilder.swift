
//
//  MultipartFormDataBuilder.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 26/07/2026.
//
import Foundation

final class MultipartFormDataBuilder {
    let boundary: String
    private var body = Data()

    init(boundary: String = "Boundary-\(UUID().uuidString)") {
        self.boundary = boundary
    }

    func addText(name: String, value: String) -> Self {
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n")
        body.appendString("\(value)\r\n")
        return self
    }

    func addFile(
        name: String,
        fileURL: URL,
        mimeType: String? = nil
    ) throws -> Self {
        // 1. Gain access to security-scoped user files
        let hasAccess = fileURL.startAccessingSecurityScopedResource()
        defer {
            if hasAccess {
                fileURL.stopAccessingSecurityScopedResource()
            }
        }
        
        // 2. Read contents safely
        let fileData = try Data(contentsOf: fileURL)
        let mime = mimeType ?? MimeTypeResolver.mimeType(for: fileURL)

        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileURL.lastPathComponent)\"\r\n")
        body.appendString("Content-Type: \(mime)\r\n\r\n")
        body.append(fileData)
        body.appendString("\r\n")
        return self
    }

    func build() -> Data {
        var result = body
        result.appendString("--\(boundary)--\r\n")
        return result
    }
}

enum MimeTypeResolver {
    static func mimeType(for url: URL) -> String {
        switch url.pathExtension.lowercased() {
        case "pdf":
            return "application/pdf"
        case "jpg", "jpeg":
            return "image/jpeg"
        case "png":
            return "image/png"
        case "mp3":
            return "audio/mpeg"
        case "wav":
            return "audio/wav"
        case "m4a":
            return "audio/mp4"
        case "aac":
            return "audio/aac"
        default:
            return "application/octet-stream"
        }
    }
}

extension Data {
    mutating func appendString(_ string: String) {
        append(string.data(using: .utf8)!)
    }
}


