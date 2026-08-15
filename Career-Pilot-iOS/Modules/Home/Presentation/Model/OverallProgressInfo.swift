//
//  OverallProgressInfo.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 14/08/2026.
//

import Foundation

struct OverallProgressInfo {
    let currentScore: Int
    let scoreDifference: Int
    
    var title: String {
        switch currentScore {
        case 90...100: return "Excellent Progress"
        case 75...89:  return "Good Progress"
        case 50...74:  return "Moderate Progress"
        default:       return "Needs Improvement"
        }
    }
    
    var comparisonText: String {
        if scoreDifference > 0 {
            return "▲ +\(scoreDifference) from last week"
        } else if scoreDifference < 0 {
            return "▼ \(scoreDifference) from last week"
        } else {
            return "• Same as last week"
        }
    }
    
    var isPositive: Bool? {
        if scoreDifference > 0 { return true }
        if scoreDifference < 0 { return false }
        return nil
    }
}

extension Array where Element == ReportsInterviewSession {
    
    func calculateOverallProgress() -> OverallProgressInfo {
        let calendar = Calendar.current
        let now = Date()
        
        guard let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: now),
              let twoWeeksAgo = calendar.date(byAdding: .day, value: -14, to: now) else {
            return OverallProgressInfo(currentScore: 0, scoreDifference: 0)
        }
        
        let thisWeekSessions = self.filter { $0.createdAt >= oneWeekAgo }
        let lastWeekSessions = self.filter { $0.createdAt >= twoWeeksAgo && $0.createdAt < oneWeekAgo }
        
        let currentAvg = computeAverage(for: thisWeekSessions, fallback: self)
        let lastWeekAvg = computeAverage(for: lastWeekSessions, fallback: thisWeekSessions)
        
        let diff = currentAvg - lastWeekAvg
        
        return OverallProgressInfo(currentScore: currentAvg, scoreDifference: diff)
    }
    
    private func computeAverage(for sessions: [ReportsInterviewSession], fallback: [ReportsInterviewSession]) -> Int {
        let targetList = sessions.isEmpty ? fallback : sessions
        
        let validScores = targetList.compactMap { $0.overallScore }
        
        guard !validScores.isEmpty else { return 0 }
        
        let total = validScores.reduce(0.0, +)
        let average = total / Double(validScores.count)
        
        return Int(average.rounded())
    }
}
