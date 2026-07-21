//
//  InterviewRepositoryImp.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 21/07/2026.
//

import Foundation

final class InterviewRepositoryImp: InterviewRepository{
    func startInterview(configuration: InterviewConfiguration) async throws -> InterviewSession {
        <#code#>
    }
    
    func submitAnswer(sessionId: String, questionId: String, audioReference: AudioReference, duration: TimeInterval) async throws -> SubmitAnswerOutcome {
        <#code#>
    }
    
    func resumeInterview(sessionId: String) async throws -> InterviewSession {
        <#code#>
    }
    
    func finishInterview(sessionId: String) async throws -> InterviewFeedback {
        <#code#>
    }
    
    func cancelInterview(sessionId: String) async throws {
        <#code#>
    }
    
    
}
