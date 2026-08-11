//
//  ATSRepositoryProtocol.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 11/08/2026.
//

import Foundation

protocol ATSRepositoryProtocol {
    func getJobByURL(from url: String) async throws -> JobEntity
}
