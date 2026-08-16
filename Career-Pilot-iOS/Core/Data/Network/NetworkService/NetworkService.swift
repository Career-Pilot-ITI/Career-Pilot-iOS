//
//  NetworkService.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 14/07/2026.
//

import Foundation

final class URLSessionNetworkService: NetworkService {
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared, decoder: JSONDecoder = URLSessionNetworkService.makeDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    private static func makeDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()

        let fmtFraction: DateFormatter = {
            let f = DateFormatter()
            f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
            f.locale = Locale(identifier: "en_US_POSIX")
            f.timeZone = TimeZone(secondsFromGMT: 0)
            return f
        }()
        let fmtPlain: DateFormatter = {
            let f = DateFormatter()
            f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            f.locale = Locale(identifier: "en_US_POSIX")
            f.timeZone = TimeZone(secondsFromGMT: 0)
            return f
        }()
        let iso8601WithFraction: ISO8601DateFormatter = {
            let f = ISO8601DateFormatter()
            f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            return f
        }()
        let iso8601Plain: ISO8601DateFormatter = {
            let f = ISO8601DateFormatter()
            f.formatOptions = [.withInternetDateTime]
            return f
        }()

        decoder.dateDecodingStrategy = .custom { dec in
            let container = try dec.singleValueContainer()
            let string = try container.decode(String.self)
            if let date = iso8601WithFraction.date(from: string) { return date }
            if let date = iso8601Plain.date(from: string) { return date }
            if let date = fmtFraction.date(from: string) { return date }
            if let date = fmtPlain.date(from: string) { return date }
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Cannot decode date string: \(string)"
            )
        }

        return decoder
    }
    
    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        let data = try await performRequest(endpoint)
        do {
            let decoded = try decoder.decode(T.self, from: data)
            print("✅ [DECODE SUCCESS] Successfully parsed response to -> \(T.self)\n")
            return decoded
        } catch let decodingError as DecodingError {
            logDecodingError(decodingError, targetType: T.self)
            logRawJSON(data, label: "Response Body")
            throw NetworkError.decodingFailed(decodingError)
        } catch {
            print("❌ [DECODE ERROR] Unexpected error decoding \(T.self): \(error.localizedDescription)\n")
            logRawJSON(data, label: "Response Body")
            throw NetworkError.decodingFailed(error)
        }
    }
    
    func request(_ endpoint: APIEndpoint) async throws {
        _ = try await performRequest(endpoint)
    }
    
    @discardableResult
    private func performRequest(_ endpoint: APIEndpoint) async throws -> Data {
        guard let url = endpoint.url else {
            print("❌ [REQUEST ERROR] Invalid URL for endpoint: \(endpoint)")
            throw NetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue
        urlRequest.httpBody = endpoint.body
        endpoint.headers.forEach { urlRequest.setValue($1, forHTTPHeaderField: $0) }
        
        // Log Request
        print("----------------------------------------------------------------------")
        print("🚀 [REQUEST] \(urlRequest.httpMethod ?? "GET") -> \(url.absoluteString)")
        if !endpoint.headers.isEmpty {
            var safeHeaders = endpoint.headers
            if safeHeaders["Authorization"] != nil {
                safeHeaders["Authorization"] = "Bearer <redacted>"
            }
            print("🔹 [HEADERS] \(safeHeaders)")
        }
        if let body = endpoint.body {
            logRawJSON(body, label: "Request Body")
        }
        print("----------------------------------------------------------------------")
        
        do {
            let (data, response) = try await session.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ [RESPONSE ERROR] Non-HTTP response received: \(response)")
                throw NetworkError.unknown(URLError(.badServerResponse))
            }
            
            let statusIcon = (200...299).contains(httpResponse.statusCode) ? "📥" : "⚠️"
            print("\(statusIcon) [RESPONSE] Status \(httpResponse.statusCode) <- \(url.absoluteString)")
            
            guard (200...299).contains(httpResponse.statusCode) else {
                logRawJSON(data, label: "Server Error Body")
                let errorResponse = try? decoder.decode(APIErrorResponse.self, from: data)
                let message = errorResponse?.message?.trimmingCharacters(in: .whitespacesAndNewlines)
                throw NetworkError.serverError(
                    statusCode: httpResponse.statusCode,
                    data: data,
                    message: message?.isEmpty == false ? message : nil
                )
            }
            
            return data
        } catch let error as NetworkError {
            print("❌ [NETWORK ERROR] \(error)")
            throw error
        } catch let urlError as URLError where urlError.code == .notConnectedToInternet {
            print("❌ [NETWORK ERROR] No internet connection")
            throw NetworkError.noInternet
        } catch let urlError as URLError where urlError.code == .timedOut {
            print("❌ [NETWORK ERROR] Request timed out")
            throw NetworkError.requestTimeout
        } catch {
            print("❌ [UNKNOWN ERROR] \(error.localizedDescription)")
            throw NetworkError.unknown(error)
        }
    }
    
    // MARK: - Logging Helpers
    
//    private func logRawJSON(_ data: Data, label: String) {
//        if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
//           let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
//           let prettyString = String(data: prettyData, encoding: .utf8) {
//            print("📦 [\(label)]:\n\(prettyString)")
//        } else if let rawString = String(data: data, encoding: .utf8), !rawString.isEmpty {
//            print("📦 [\(label) (Raw)]:\n\(rawString)")
//        } else {
//            print("📦 [\(label)]: <Empty Body>")
//        }
//    }
    
    private func logRawJSON(_ data: Data, label: String) {
        let options: JSONSerialization.WritingOptions = [
            .prettyPrinted,
            .withoutEscapingSlashes // Prevents '/' from being escaped as '\/'
        ]
        
        if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
           let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: options),
           let prettyString = String(data: prettyData, encoding: .utf8) {
            print("📦 [\(label)]:\n\(prettyString)")
        } else if let rawString = String(data: data, encoding: .utf8), !rawString.isEmpty {
            print("📦 [\(label) (Raw)]:\n\(rawString)")
        } else {
            print("📦 [\(label)]: <Empty Body>")
        }
    }
    private func logDecodingError<T>(_ error: DecodingError, targetType: T.Type) {
        print("❌ [DECODE ERROR] Failed decoding \(targetType)")
        switch error {
        case .keyNotFound(let key, let context):
            print("   👉 Missing Key: '\(key.stringValue)' | Path: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
        case .typeMismatch(let type, let context):
            print("   👉 Type Mismatch: Expected \(type) | Path: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
        case .valueNotFound(let type, let context):
            print("   👉 Value Null/NotFound: Expected non-null \(type) | Path: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
        case .dataCorrupted(let context):
            print("   👉 Data Corrupted: \(context.debugDescription)")
        @unknown default:
            print("   👉 Unknown Decoding Error: \(error.localizedDescription)")
        }
    }
}
