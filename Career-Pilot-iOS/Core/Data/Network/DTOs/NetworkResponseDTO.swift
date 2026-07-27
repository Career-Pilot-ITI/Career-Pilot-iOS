//
//  NetworkResponseDTO.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 27/07/2026.
//

import Foundation

struct NetworkResponseDTO<T: Decodable>: Decodable{
    let message: String
    let success: Bool
    let timestamp: String
    let data: T
}
