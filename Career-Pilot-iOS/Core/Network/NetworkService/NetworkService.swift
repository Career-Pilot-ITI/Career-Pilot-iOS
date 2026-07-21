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
    
    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }
    
    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws ->  T where T: Decodable {
        let data = try await performRequest(endpoint)
        do {
            let decoded = try decoder.decode(T.self, from: data)
            print("✅ [Decode] Successfully decoded \(T.self)")
            return decoded
        } catch {
            print("❌ [Decode] Failed to decode \(T.self): \(error)")
            if let raw = String(data: data, encoding: .utf8) {
                print("📦 [Decode] Raw response body:\n\(raw)")
            }
            throw NetworkError.decodingFailed(error)
        }
    }
    
    func request(_ endpoint: APIEndpoint) async throws {
        _ = try await performRequest(endpoint)
    }
    
    @discardableResult
    private func performRequest(_ endpoint: APIEndpoint) async throws -> Data {
        guard let url = endpoint.url else {
            print("❌ [Request] Invalid URL for endpoint: \(endpoint)")
            throw NetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue
        urlRequest.httpBody = endpoint.body
        endpoint.headers.forEach { urlRequest.setValue($1, forHTTPHeaderField: $0) }
        
        print("➡️ [Request] \(urlRequest.httpMethod ?? "?") \(url.absoluteString)")
        print("➡️ [Request] Headers: \(endpoint.headers)")
        if let body = endpoint.body, let bodyString = String(data: body, encoding: .utf8) {
            print("➡️ [Request] Body: \(bodyString)")
        }
        
        do {
            let (data, response) = try await session.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ [Response] Not an HTTPURLResponse: \(response)")
                throw NetworkError.unknown(URLError(.badServerResponse))
            }
            
            print("⬅️ [Response] Status \(httpResponse.statusCode) for \(url.absoluteString)")
            
            guard (200...299).contains(httpResponse.statusCode) else {
                if let raw = String(data: data, encoding: .utf8) {
                    print("❌ [Response] Server error body:\n\(raw)")
                }
                throw NetworkError.serverError(statusCode: httpResponse.statusCode, data: data)
            }
            
            return data
        } catch let error as NetworkError {
            print("❌ [Request] NetworkError rethrown: \(error)")
            throw error
        } catch let urlError as URLError where urlError.code == .notConnectedToInternet {
            print("❌ [Request] No internet connection")
            throw NetworkError.noInternet
        } catch {
            print("❌ [Request] Unknown error: \(error)")
            throw NetworkError.unknown(error)
        }
    }
}
