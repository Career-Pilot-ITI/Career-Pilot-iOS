//
//  FrameObservation.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 13/08/2026.
import Foundation

/// x/y are normalized 0...1, Vision's convention: origin bottom-left, y increasing upward.
/// (Not UIKit's top-left/y-down convention — worth remembering wherever these get consumed.)
struct NormalizedPoint: Equatable, Sendable {
    let x: Double
    let y: Double
    let confidence: Float
}

/// Same bottom-left-origin, y-up convention as `NormalizedPoint`.
struct NormalizedRect: Equatable, Sendable {
    let x: Double
    let y: Double
    let width: Double
    let height: Double
}

enum BodyJoint: String, Equatable, Sendable, CaseIterable {
    case nose, neck
    case leftShoulder, rightShoulder
    case leftElbow, rightElbow
    case leftWrist, rightWrist
    case leftHip, rightHip
}

enum HandChirality: String, Equatable, Sendable {
    case left, right, unknown
}

struct FaceObservation: Equatable, Sendable {
    let boundingBox: NormalizedRect
    /// Radians. Available depending on device/Vision version — nil when Vision didn't report it.
    let yaw: Double?
    let roll: Double?
    let pitch: Double?
    let leftEyePosition: NormalizedPoint?
    let rightEyePosition: NormalizedPoint?
    let noseTipPosition: NormalizedPoint?
    let confidence: Float
}

struct BodyObservation: Equatable, Sendable {
    let joints: [BodyJoint: NormalizedPoint]
    let confidence: Float
}

struct HandObservation: Equatable, Sendable {
    let chirality: HandChirality
    let wristPosition: NormalizedPoint?
    let indexTipPosition: NormalizedPoint?
    let confidence: Float
}

/// Everything Vision could extract from a single sampled frame. `face`/`body` are nil, and
/// `hands` is empty, when nothing was detected in that frame — that's a normal, expected
/// outcome (someone glanced off-frame, hands were out of shot), not an error.
struct FrameObservation: Equatable, Sendable {
    let timestamp: TimeInterval
    let face: FaceObservation?
    let body: BodyObservation?
    let hands: [HandObservation]
}

/// Outcome of analyzing a full batch of captured frames.
struct VisualAnalysisBatchResult: Equatable, Sendable {
    let observations: [FrameObservation]
    let framesAnalyzed: Int
    let framesSkipped: Int
}
