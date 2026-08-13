//
//  InterviewPresenceScore.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 13/08/2026.
//
import Foundation

// MARK: - Tunable configuration

struct VisualMetricsConfiguration: Sendable {

    // MARK: Eye contact / head orientation
    /// How far off-camera (yaw) still counts as "looking at camera".
    var eyeContactYawThresholdDegrees: Double = 20
    /// How far off-camera (pitch — looking up/down) still counts as "looking at camera".
    var eyeContactPitchThresholdDegrees: Double = 17

    // MARK: Posture
    /// Shoulder-line tilt beyond this starts costing posture score.
    var postureShoulderTiltThresholdDegrees: Double = 8
    /// Head horizontal offset from shoulder-center (as a fraction of shoulder width) beyond
    /// this starts costing posture score.
    var postureHeadOffsetThreshold: Double = 0.15

    // MARK: Movement (head / hands / body)
    /// Minimum yaw change between consecutive frames (within a segment) to count as a
    /// discrete "head movement" event.
    var headMovementDeltaThresholdDegrees: Double = 6
    /// Minimum normalized displacement between consecutive detections of the same hand to
    /// count as a discrete "hand movement" event (and to not count as "still").
    var handMovementDeltaThreshold: Double = 0.03
    /// Minimum aggregate joint displacement between consecutive body observations to count
    /// as a discrete "body movement" event.
    var bodyMovementDeltaThreshold: Double = 0.05
    /// Aggregate body displacement above this counts as an "excessive movement" event.
    var bodyExcessiveMovementThreshold: Double = 0.12

    // MARK: Segmenting
    /// A gap between consecutive frame timestamps larger than this (or a timestamp that
    /// doesn't increase — e.g. a new question restarted the capture session) breaks
    /// continuity: no inter-frame delta is computed across it.
    var maxGapForContinuitySeconds: TimeInterval = 10

    // MARK: Scoring bands (natural / acceptable ranges, in events per minute)
    var headMovementNaturalBandPerMinute: Double = 10
    var handMovementNaturalBandPerMinute: (min: Double, max: Double) = (4, 24)
    var handInactivityPenaltyThreshold: Double = 0.85

    // MARK: Overall score weights (should sum to 1.0)
    var eyeContactWeight: Double = 0.30
    var postureWeight: Double = 0.25
    var headMovementWeight: Double = 0.15
    var handMovementWeight: Double = 0.15
    var bodyMovementWeight: Double = 0.15

    static let `default` = VisualMetricsConfiguration()
}

// MARK: - Per-signal metrics

struct EyeContactMetrics: Equatable, Sendable {
    /// framesLookingAtCamera / framesFaceVisible. 0 when no face was ever visible.
    let ratio: Double
    let framesFaceVisible: Int
    let framesLookingAtCamera: Int
    let score: Int
}

struct PostureMetrics: Equatable, Sendable {
    /// Mean absolute shoulder-line tilt, degrees.
    let averageShoulderTiltDegrees: Double
    /// Mean absolute head horizontal offset from shoulder-center, as a fraction of shoulder width.
    let averageHeadOffset: Double
    /// 0...100 — higher means the above two values stayed consistent frame to frame.
    let stabilityScore: Int
    let framesEvaluated: Int
    let score: Int
}

struct HeadMovementMetrics: Equatable, Sendable {
    let averageAbsoluteYawDegrees: Double
    let movementFrequencyPerMinute: Double
    /// Count of transitions from "within eye-contact range" to "outside it".
    let lookingAwayEventCount: Int
    let score: Int
}

struct HandMovementMetrics: Equatable, Sendable {
    let movementFrequencyPerMinute: Double
    /// Mean displacement magnitude (normalized units) across detected movement events.
    let averageAmplitude: Double
    /// Fraction of consecutive hand-position pairs where displacement was below the
    /// "still" threshold. High values (>~0.85) suggest hands stayed mostly static.
    let inactivityRatio: Double
    let score: Int
}

struct BodyMovementMetrics: Equatable, Sendable {
    let movementFrequencyPerMinute: Double
    let averageJointDisplacement: Double
    let excessiveMovementEventCount: Int
    let score: Int
}

struct FaceVisibilityMetrics: Equatable, Sendable {
    /// framesFaceVisible / totalFrames.
    let visibleRatio: Double
    let totalFrames: Int
    let framesFaceVisible: Int
}

// MARK: - Aggregate

struct InterviewPresenceScore: Equatable, Sendable {
    let overallScore: Int
    let eyeContact: EyeContactMetrics
    let posture: PostureMetrics
    let headMovement: HeadMovementMetrics
    let handMovement: HandMovementMetrics
    let bodyMovement: BodyMovementMetrics
    let faceVisibility: FaceVisibilityMetrics
}
