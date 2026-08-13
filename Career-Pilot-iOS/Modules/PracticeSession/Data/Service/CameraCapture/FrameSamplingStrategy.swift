//
//  FrameSamplingStrategy.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 13/08/2026.
//

import Foundation

/// Governs how often a frame is kept from the ~30fps camera stream.
///
/// Kept deliberately simple (a minimum time gap) rather than hardcoding a frames/minute
/// constant, so the strategy can be swapped later (e.g. adaptive sampling, burst-on-motion)
/// without touching the capture service.
struct FrameSamplingStrategy {
    /// Minimum number of seconds that must elapse between two kept frames.
    let minimumInterval: TimeInterval

    /// ~30 frames/minute. Eye-contact "looking away" events are typically 1-3s long — at
    /// 8 frames/minute (one every 7.5s) those get missed or over-counted. 2s spacing gives
    /// enough temporal resolution for eye contact while still being cheap to run Vision
    /// requests against after the interview (a handful of frames per question, not per second).
    static let `default` = FrameSamplingStrategy(minimumInterval: 2.0)

    static func framesPerMinute(_ count: Double) -> FrameSamplingStrategy {
        FrameSamplingStrategy(minimumInterval: 60.0 / count)
    }
}
