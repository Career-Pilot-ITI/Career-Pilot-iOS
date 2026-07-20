//
//  NetworkServiceProtocol.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 20/07/2026.
//

protocol NetworkService {
    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws ->  T where T: Decodable
    func request(_ endpoint: APIEndpoint) async throws // For post
}
