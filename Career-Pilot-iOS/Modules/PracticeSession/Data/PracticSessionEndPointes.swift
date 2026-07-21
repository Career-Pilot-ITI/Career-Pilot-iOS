//
//  SessionEndPointes.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 20/07/2026.
//

import Foundation

enum PracticSessionEndPointes: APIEndpoint{
    case StartSession(InterviewConfiguration), SubmitAnswer(SubmitAnswerRequest), FinishInterview(FinishInterviewRequest)
    
    var baseURL: String{
        return ""
    }
    
    var path: String{
        switch self{
            
        case .StartSession(_):
            <#code#>
        case .SubmitAnswer(_):
            <#code#>
        case .FinishInterview(_):
            <#code#>
        }
    }
    
    var method: HTTPMethod{
        switch self{
            
        case .StartSession(_):
            <#code#>
        case .SubmitAnswer(_):
            <#code#>
        case .FinishInterview(_):
            <#code#>
        }
    }
    
    
}

