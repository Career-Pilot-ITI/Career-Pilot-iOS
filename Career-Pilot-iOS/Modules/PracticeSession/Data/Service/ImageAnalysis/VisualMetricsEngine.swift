//
//  VisualMetricsEngine.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 13/08/2026.
//

import Foundation

protocol VisualMetricsEngineProtocol {
    /// Returns nil only when there's nothing to compute from (empty input).
    func calculateMetrics(from observations: [FrameObservation]) -> InterviewPresenceScore?
}

struct VisualMetricsEngine: VisualMetricsEngineProtocol {

    let configuration: VisualMetricsConfiguration

    init(configuration: VisualMetricsConfiguration = .default) {
        self.configuration = configuration
    }

    func calculateMetrics(from observations: [FrameObservation]) -> InterviewPresenceScore? {
        guard !observations.isEmpty else { return nil }
        let sorted = observations.sorted { $0.timestamp < $1.timestamp }
        let segments = Self.segment(sorted, maxGap: configuration.maxGapForContinuitySeconds)

        let faceVisibility = calculateFaceVisibility(sorted)
        let eyeContact = calculateEyeContact(sorted)
        let posture = calculatePosture(sorted)
        let headMovement = calculateHeadMovement(segments)
        let handMovement = calculateHandMovement(segments)
        let bodyMovement = calculateBodyMovement(segments)

        let overall = weightedOverallScore(
            eyeContact: eyeContact,
            posture: posture,
            headMovement: headMovement,
            handMovement: handMovement,
            bodyMovement: bodyMovement
        )

        return InterviewPresenceScore(
            overallScore: overall,
            eyeContact: eyeContact,
            posture: posture,
            headMovement: headMovement,
            handMovement: handMovement,
            bodyMovement: bodyMovement,
            faceVisibility: faceVisibility
        )
    }

    // MARK: - Segmenting

    /// Groups frames into runs where consecutive timestamps are strictly increasing and no
    /// more than `maxGap` apart. A capture-session restart (new question) or any timestamp
    /// irregularity starts a new segment, so movement/velocity math never spans a seam it
    /// shouldn't.
    static func segment(_ observations: [FrameObservation], maxGap: TimeInterval) -> [[FrameObservation]] {
        guard let first = observations.first else { return [] }
        var segments: [[FrameObservation]] = [[first]]

        for i in 1..<observations.count {
            let previous = observations[i - 1]
            let current = observations[i]
            let gap = current.timestamp - previous.timestamp
            if gap > 0 && gap <= maxGap {
                segments[segments.count - 1].append(current)
            } else {
                segments.append([current])
            }
        }
        return segments
    }
}

// MARK: - Face visibility

private extension VisualMetricsEngine {
    func calculateFaceVisibility(_ observations: [FrameObservation]) -> FaceVisibilityMetrics {
        let visible = observations.filter { $0.face != nil }.count
        let ratio = observations.isEmpty ? 0 : Double(visible) / Double(observations.count)
        return FaceVisibilityMetrics(visibleRatio: ratio, totalFrames: observations.count, framesFaceVisible: visible)
    }
}

// MARK: - Eye contact

private extension VisualMetricsEngine {
    func isLookingAtCamera(_ face: FaceObservation) -> Bool {
        let yawDegrees = (face.yaw ?? 0).radiansToDegrees
        let pitchDegrees = (face.pitch ?? 0).radiansToDegrees
        return abs(yawDegrees) <= configuration.eyeContactYawThresholdDegrees
            && abs(pitchDegrees) <= configuration.eyeContactPitchThresholdDegrees
    }

    func calculateEyeContact(_ observations: [FrameObservation]) -> EyeContactMetrics {
        let facesVisible = observations.compactMap { $0.face }
        let lookingCount = facesVisible.filter(isLookingAtCamera).count
        let ratio = facesVisible.isEmpty ? 0 : Double(lookingCount) / Double(facesVisible.count)

        return EyeContactMetrics(
            ratio: ratio,
            framesFaceVisible: facesVisible.count,
            framesLookingAtCamera: lookingCount,
            score: Int((ratio * 100).rounded())
        )
    }
}

// MARK: - Posture

private extension VisualMetricsEngine {
    /// A single frame's posture reading: shoulder tilt (degrees) and head horizontal offset
    /// (fraction of shoulder width). Nil when the frame doesn't have enough body landmarks.
    func postureReading(for body: BodyObservation) -> (tiltDegrees: Double, headOffset: Double)? {
        guard let left = body.joints[.leftShoulder], let right = body.joints[.rightShoulder] else {
            return nil
        }
        let shoulderWidth = right.distance(to: left)
        guard shoulderWidth > 0.001 else { return nil }

        let tiltRadians = atan2(right.y - left.y, right.x - left.x)
        let tiltDegrees = abs(tiltRadians.radiansToDegrees)

        guard let head = body.joints[.nose] else {
            return (tiltDegrees, 0)
        }
        let shoulderCenterX = (left.x + right.x) / 2
        let headOffset = abs(head.x - shoulderCenterX) / shoulderWidth
        return (tiltDegrees, headOffset)
    }

    func calculatePosture(_ observations: [FrameObservation]) -> PostureMetrics {
        let readings = observations.compactMap { $0.body }.compactMap(postureReading)
        guard !readings.isEmpty else {
            return PostureMetrics(averageShoulderTiltDegrees: 0, averageHeadOffset: 0, stabilityScore: 0, framesEvaluated: 0, score: 0)
        }

        let tilts = readings.map(\.tiltDegrees)
        let offsets = readings.map(\.headOffset)
        let averageTilt = tilts.average
        let averageOffset = offsets.average

        // Stability: lower variance in tilt/offset across the interview means a steadier
        // posture. Variance is unbounded, so it's compressed into 0...100 via a decay curve
        // rather than a raw linear penalty (keeps a single outlier frame from tanking the
        // whole score).
        let tiltVariance = tilts.variance
        let offsetVariance = offsets.variance
        let stability = 100 * exp(-(tiltVariance / 40 + offsetVariance / 0.02))
        let stabilityScore = Int(stability.rounded().clamped(to: 0...100))

        let tiltPenalty = max(0, averageTilt - configuration.postureShoulderTiltThresholdDegrees) * 3
        let offsetPenalty = max(0, averageOffset - configuration.postureHeadOffsetThreshold) * 150
        let score = Int((100 - tiltPenalty - offsetPenalty).rounded().clamped(to: 0...100))

        return PostureMetrics(
            averageShoulderTiltDegrees: averageTilt,
            averageHeadOffset: averageOffset,
            stabilityScore: stabilityScore,
            framesEvaluated: readings.count,
            score: score
        )
    }
}

// MARK: - Head movement

private extension VisualMetricsEngine {
    func calculateHeadMovement(_ segments: [[FrameObservation]]) -> HeadMovementMetrics {
        var yawValues: [Double] = []
        var movementEvents = 0
        var lookingAwayEvents = 0
        var totalDuration: TimeInterval = 0

        for segment in segments {
            let facedFrames = segment.filter { $0.face != nil }
            guard let first = segment.first, let last = segment.last, last.timestamp > first.timestamp else { continue }
            totalDuration += last.timestamp - first.timestamp

            var previousYaw: Double?
            var wasLookingAway = false

            for frame in facedFrames {
                guard let face = frame.face else { continue }
                let yawDegrees = (face.yaw ?? 0).radiansToDegrees
                yawValues.append(abs(yawDegrees))

                if let previousYaw, abs(yawDegrees - previousYaw) >= configuration.headMovementDeltaThresholdDegrees {
                    movementEvents += 1
                }
                previousYaw = yawDegrees

                let isLookingAway = !isLookingAtCamera(face)
                if isLookingAway && !wasLookingAway {
                    lookingAwayEvents += 1
                }
                wasLookingAway = isLookingAway
            }
        }

        let averageYaw = yawValues.average
        let frequencyPerMinute = totalDuration > 0 ? Double(movementEvents) / (totalDuration / 60) : 0

        let bandExcess = max(0, frequencyPerMinute - configuration.headMovementNaturalBandPerMinute)
        let movementPenalty = bandExcess * 2.5
        let lookingAwayPenalty = Double(lookingAwayEvents) * 4
        let score = Int((100 - movementPenalty - lookingAwayPenalty).rounded().clamped(to: 0...100))

        return HeadMovementMetrics(
            averageAbsoluteYawDegrees: averageYaw,
            movementFrequencyPerMinute: frequencyPerMinute,
            lookingAwayEventCount: lookingAwayEvents,
            score: score
        )
    }
}

// MARK: - Hand movement

private extension VisualMetricsEngine {
    func calculateHandMovement(_ segments: [[FrameObservation]]) -> HandMovementMetrics {
        var amplitudes: [Double] = []
        var movementEvents = 0
        var stillPairs = 0
        var totalDuration: TimeInterval = 0

        for segment in segments {
            guard let first = segment.first, let last = segment.last, last.timestamp > first.timestamp else { continue }
            totalDuration += last.timestamp - first.timestamp

            for chirality in [HandChirality.left, .right] {
                let track: [(timestamp: TimeInterval, point: NormalizedPoint)] = segment.compactMap { frame in
                    guard let hand = frame.hands.first(where: { $0.chirality == chirality }),
                          let position = hand.wristPosition ?? hand.indexTipPosition else { return nil }
                    return (frame.timestamp, position)
                }
                guard track.count > 1 else { continue }

                for i in 1..<track.count {
                    let displacement = track[i].point.distance(to: track[i - 1].point)
                    if displacement >= configuration.handMovementDeltaThreshold {
                        movementEvents += 1
                        amplitudes.append(displacement)
                    } else {
                        stillPairs += 1
                    }
                }
            }
        }

        let totalPairs = movementEvents + stillPairs
        let inactivityRatio = totalPairs > 0 ? Double(stillPairs) / Double(totalPairs) : 0
        let frequencyPerMinute = totalDuration > 0 ? Double(movementEvents) / (totalDuration / 60) : 0

        // "Good" hand movement sits inside a natural band — too still can read as
        // disengaged, too much can read as fidgety. Score penalizes both directions.
        let band = configuration.handMovementNaturalBandPerMinute
        let belowBandPenalty = max(0, band.min - frequencyPerMinute) * 2
        let aboveBandPenalty = max(0, frequencyPerMinute - band.max) * 2
        let inactivityPenalty = inactivityRatio > configuration.handInactivityPenaltyThreshold
            ? (inactivityRatio - configuration.handInactivityPenaltyThreshold) * 200
            : 0
        let score = Int((100 - belowBandPenalty - aboveBandPenalty - inactivityPenalty).rounded().clamped(to: 0...100))

        return HandMovementMetrics(
            movementFrequencyPerMinute: frequencyPerMinute,
            averageAmplitude: amplitudes.average,
            inactivityRatio: inactivityRatio,
            score: score
        )
    }
}

// MARK: - Body movement

private extension VisualMetricsEngine {
    func calculateBodyMovement(_ segments: [[FrameObservation]]) -> BodyMovementMetrics {
        var displacements: [Double] = []
        var movementEvents = 0
        var excessiveEvents = 0
        var totalDuration: TimeInterval = 0

        for segment in segments {
            guard let first = segment.first, let last = segment.last, last.timestamp > first.timestamp else { continue }
            totalDuration += last.timestamp - first.timestamp

            let bodyFrames = segment.compactMap { frame -> (TimeInterval, BodyObservation)? in
                guard let body = frame.body else { return nil }
                return (frame.timestamp, body)
            }
            guard bodyFrames.count > 1 else { continue }

            for i in 1..<bodyFrames.count {
                let previousJoints = bodyFrames[i - 1].1.joints
                let currentJoints = bodyFrames[i].1.joints
                let sharedJoints = Set(previousJoints.keys).intersection(currentJoints.keys)
                guard !sharedJoints.isEmpty else { continue }

                let totalDisplacement = sharedJoints.reduce(0.0) { partial, joint in
                    partial + currentJoints[joint]!.distance(to: previousJoints[joint]!)
                }
                let averageDisplacement = totalDisplacement / Double(sharedJoints.count)
                displacements.append(averageDisplacement)

                if averageDisplacement >= configuration.bodyMovementDeltaThreshold {
                    movementEvents += 1
                }
                if averageDisplacement >= configuration.bodyExcessiveMovementThreshold {
                    excessiveEvents += 1
                }
            }
        }

        let frequencyPerMinute = totalDuration > 0 ? Double(movementEvents) / (totalDuration / 60) : 0
        let excessivePenalty = Double(excessiveEvents) * 6
        let score = Int((100 - excessivePenalty).rounded().clamped(to: 0...100))

        return BodyMovementMetrics(
            movementFrequencyPerMinute: frequencyPerMinute,
            averageJointDisplacement: displacements.average,
            excessiveMovementEventCount: excessiveEvents,
            score: score
        )
    }
}

// MARK: - Overall score

private extension VisualMetricsEngine {
    func weightedOverallScore(
        eyeContact: EyeContactMetrics,
        posture: PostureMetrics,
        headMovement: HeadMovementMetrics,
        handMovement: HandMovementMetrics,
        bodyMovement: BodyMovementMetrics
    ) -> Int {
        let weighted =
            Double(eyeContact.score) * configuration.eyeContactWeight
            + Double(posture.score) * configuration.postureWeight
            + Double(headMovement.score) * configuration.headMovementWeight
            + Double(handMovement.score) * configuration.handMovementWeight
            + Double(bodyMovement.score) * configuration.bodyMovementWeight
        return Int(weighted.rounded().clamped(to: 0...100))
    }
}

// MARK: - Small math helpers

private extension NormalizedPoint {
    func distance(to other: NormalizedPoint) -> Double {
        let dx = x - other.x
        let dy = y - other.y
        return (dx * dx + dy * dy).squareRoot()
    }
}

private extension Double {
    var radiansToDegrees: Double { self * 180 / .pi }

    func clamped(to range: ClosedRange<Double>) -> Double {
        min(max(self, range.lowerBound), range.upperBound)
    }
}

private extension Array where Element == Double {
    var average: Double {
        isEmpty ? 0 : reduce(0, +) / Double(count)
    }

    var variance: Double {
        guard count > 1 else { return 0 }
        let mean = average
        let squaredDiffs = map { ($0 - mean) * ($0 - mean) }
        return squaredDiffs.reduce(0, +) / Double(count)
    }
}
