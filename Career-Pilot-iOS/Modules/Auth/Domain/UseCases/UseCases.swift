//
//  UseCases.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 14/07/2026.
//

import Foundation

protocol UseCase {
    associatedtype Input
    associatedtype Output
    
    func execute(_ input: Input) async throws -> Output
}

class SendOTPUseCase : UseCase {
    private let repository: AuthRemoteDataSourceProtocol
    
    init(repository: AuthRemoteDataSourceProtocol) {
        self.repository = repository
    }
    
    func execute(_ input: String) async throws {
        try await repository.sendOTP(for: input)
    }
    
}
