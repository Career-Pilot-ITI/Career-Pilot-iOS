//
//  APIEndpoint.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 14/07/2026.
//

import Foundation


protocol APIEndpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryParameters: [URLQueryItem]? { get }
    var body: Data? { get }
    var headers: [String: String] { get }
    var requiresAuthentication: Bool { get }
}

extension APIEndpoint {
    var baseURL: String {
        "https://career-pilot-backend-production.up.railway.app/"
    }
    var requiresAuthentication: Bool { false }
    var queryParameters: [URLQueryItem]? { nil }
    var body: Data? { nil }
    var headers: [String: String] { [:] }

    var url: URL? {
        var components = URLComponents(string: baseURL + path)
        components?.queryItems = queryParameters
        return components?.url
    }

    /// Convenience for building a payload endpoint without hand-rolling JSONEncoder calls everywhere.
    static func encode<T: Encodable>(_ value: T, encoder: JSONEncoder = JSONEncoder()) -> Data? {
        try? encoder.encode(value)
    }
     
    static func decode<T: Decodable>(_ data: Data, decoder: JSONDecoder = JSONDecoder()) throws -> T {
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }
}
