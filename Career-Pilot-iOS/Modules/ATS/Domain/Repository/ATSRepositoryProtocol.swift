//
//  ATSRepositoryProtocol.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 11/08/2026.
//

import Foundation

protocol ATSRepositoryProtocol {
    func getJobByURL(from url: String) async throws -> JobEntity
    func scoreCvAgainstJob(for id: Int) async throws -> JobMatchEntity
    func generateCoverLetter(for id: Int) async throws -> CoverLetterEntity
    func triggerCvOptimize(workspaceId: Int) async throws -> AiJobEntity
    func pollCvOptimizeJobStatus(workspaceId: Int, jobId: Int) async throws -> AiJobEntity
}
