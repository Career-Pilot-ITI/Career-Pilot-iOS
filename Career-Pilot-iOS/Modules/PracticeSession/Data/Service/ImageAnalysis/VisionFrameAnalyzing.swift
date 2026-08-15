//
//  VisionFrameAnalyzing.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 13/08/2026.
import Foundation


protocol VisionFrameAnalyzing {
    func analyze(frames: [CapturedFrame]) async -> VisualAnalysisBatchResult
}
