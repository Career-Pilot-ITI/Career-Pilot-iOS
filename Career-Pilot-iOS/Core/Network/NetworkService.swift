//
//  NetworkService.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 14/07/2026.
//

import Foundation

	    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws ->  T where T: Decodable
    func request(_ endpoint: APIEndpoint) async throws // For post
}

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
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }
    
    func request(_ endpoint: APIEndpoint) async throws {
        _ = try await performRequest(endpoint)
    }
    
    @discardableResult
    private func performRequest(_ endpoint: APIEndpoint) async throws -> Data {
        guard let url = endpoint.url else {
            throw NetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue
        urlRequest.httpBody = endpoint.body
        endpoint.headers.forEach { urlRequest.setValue($1, forHTTPHeaderField: $0) }
        
        
        do {
            let (data, response) = try await session.data(for: urlRequest)
            print("Respoonse: \(response)")
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.unknown(URLError(.badServerResponse))
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.serverError(statusCode: httpResponse.statusCode, data: data)
            }
            print("1Response data : \(data)" )
            return data
        } catch let error as NetworkError {
            print("2Response data : \(error)" )
            throw error
        } catch let urlError as URLError where urlError.code == .notConnectedToInternet {
            print("3Response data : \(urlError)" )
            throw NetworkError.noInternet
        } catch {
            print("4Response data : \(error)" )
            throw NetworkError.unknown(error)
        }
    }
}
