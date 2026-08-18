//
//  VisionFrameAnalysisService.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 13/08/2026.
//
import Vision
import CoreGraphics

final class VisionFrameAnalysisService: VisionFrameAnalyzing {

    private let maximumHandCount: Int
    private let minimumJointConfidence: Float

    init(maximumHandCount: Int = 2, minimumJointConfidence: Float = 0.1) {
        self.maximumHandCount = maximumHandCount
        self.minimumJointConfidence = minimumJointConfidence
    }

    func analyze(frames: [CapturedFrame]) async -> VisualAnalysisBatchResult {
        let maximumHandCount = maximumHandCount
        let minimumJointConfidence = minimumJointConfidence

        return await Task.detached(priority: .userInitiated) {
            var observations: [FrameObservation] = []
            var skipped = 0

            for frame in frames {
                if let observation = Self.analyzeFrame(
                    frame,
                    maximumHandCount: maximumHandCount,
                    minimumJointConfidence: minimumJointConfidence
                ) {
                    observations.append(observation)
                } else {
                    skipped += 1
                }
            }

            return VisualAnalysisBatchResult(
                observations: observations,
                framesAnalyzed: observations.count,
                framesSkipped: skipped
            )
        }.value
    }

    // MARK: - Per-frame analysis

    /// Returns nil only when the frame itself couldn't be processed at all (corrupt image,
    /// handler failure). A frame with no face/body/hands detected still returns a valid
    /// (mostly-empty) FrameObservation — that's a normal outcome, not a skip.
    private static func analyzeFrame(
        _ frame: CapturedFrame,
        maximumHandCount: Int,
        minimumJointConfidence: Float
    ) -> FrameObservation? {
        let handler = VNImageRequestHandler(cgImage: frame.image, orientation: .up, options: [:])

        let faceRequest = VNDetectFaceLandmarksRequest()
        let bodyRequest = VNDetectHumanBodyPoseRequest()
        let handRequest = VNDetectHumanHandPoseRequest()
        handRequest.maximumHandCount = maximumHandCount

        do {
            try handler.perform([faceRequest, bodyRequest, handRequest])
        } catch {
            return nil
        }

        return FrameObservation(
            timestamp: frame.timestamp,
            face: mapFace(from: faceRequest.results),
            body: mapBody(from: bodyRequest.results, minimumConfidence: minimumJointConfidence),
            hands: mapHands(from: handRequest.results, minimumConfidence: minimumJointConfidence)
        )
    }

    // MARK: - Mapping: Face

    private static func mapFace(from results: [VNFaceObservation]?) -> FaceObservation? {
        guard let results, !results.isEmpty else { return nil }

        // Multiple faces in frame (doc's "multiple faces detected" case) — take the largest
        // as the interview candidate rather than failing the frame.
        guard let primary = results.max(by: { $0.boundingBox.width * $0.boundingBox.height < $1.boundingBox.width * $1.boundingBox.height }) else {
            return nil
        }

        let boundingBox = NormalizedRect(
            x: Double(primary.boundingBox.origin.x),
            y: Double(primary.boundingBox.origin.y),
            width: Double(primary.boundingBox.width),
            height: Double(primary.boundingBox.height)
        )

        func averagedImagePoint(of region: VNFaceLandmarkRegion2D?) -> NormalizedPoint? {
            guard let region, region.pointCount > 0 else { return nil }
            let sum = region.normalizedPoints.reduce(CGPoint.zero) { CGPoint(x: $0.x + $1.x, y: $0.y + $1.y) }
            let count = CGFloat(region.pointCount)
            // Landmark points are normalized *within the face bounding box* — project them
            // back into full-image normalized space.
            let localPoint = CGPoint(x: sum.x / count, y: sum.y / count)
            let imageX = primary.boundingBox.origin.x + localPoint.x * primary.boundingBox.width
            let imageY = primary.boundingBox.origin.y + localPoint.y * primary.boundingBox.height
            return NormalizedPoint(x: Double(imageX), y: Double(imageY), confidence: primary.confidence)
        }

        return FaceObservation(
            boundingBox: boundingBox,
            yaw: primary.yaw?.doubleValue,
            roll: primary.roll?.doubleValue,
            pitch: primary.pitch?.doubleValue,
            leftEyePosition: averagedImagePoint(of: primary.landmarks?.leftEye),
            rightEyePosition: averagedImagePoint(of: primary.landmarks?.rightEye),
            noseTipPosition: averagedImagePoint(of: primary.landmarks?.nose),
            confidence: primary.confidence
        )
    }

    // MARK: - Mapping: Body

    private static let bodyJointMap: [(BodyJoint, VNHumanBodyPoseObservation.JointName)] = [
        (.nose, .nose), (.neck, .neck),
        (.leftShoulder, .leftShoulder), (.rightShoulder, .rightShoulder),
        (.leftElbow, .leftElbow), (.rightElbow, .rightElbow),
        (.leftWrist, .leftWrist), (.rightWrist, .rightWrist),
        (.leftHip, .leftHip), (.rightHip, .rightHip)
    ]

    private static func mapBody(from results: [VNHumanBodyPoseObservation]?, minimumConfidence: Float) -> BodyObservation? {
        guard let observation = results?.first else { return nil }

        var joints: [BodyJoint: NormalizedPoint] = [:]
        for (domainJoint, visionJoint) in bodyJointMap {
            guard let point = try? observation.recognizedPoint(visionJoint),
                  point.confidence >= minimumConfidence else { continue }
            joints[domainJoint] = NormalizedPoint(x: Double(point.location.x), y: Double(point.location.y), confidence: point.confidence)
        }

        guard !joints.isEmpty else { return nil }
        return BodyObservation(joints: joints, confidence: observation.confidence)
    }

    // MARK: - Mapping: Hands

    private static func mapHands(from results: [VNHumanHandPoseObservation]?, minimumConfidence: Float) -> [HandObservation] {
        guard let results else { return [] }

        return results.compactMap { observation -> HandObservation? in
            let wrist = try? observation.recognizedPoint(.wrist)
            let indexTip = try? observation.recognizedPoint(.indexTip)

            let wristPoint = (wrist?.confidence ?? 0) >= minimumConfidence
                ? wrist.map { NormalizedPoint(x: Double($0.location.x), y: Double($0.location.y), confidence: $0.confidence) }
                : nil
            let indexTipPoint = (indexTip?.confidence ?? 0) >= minimumConfidence
                ? indexTip.map { NormalizedPoint(x: Double($0.location.x), y: Double($0.location.y), confidence: $0.confidence) }
                : nil

            guard wristPoint != nil || indexTipPoint != nil else { return nil }

            let chirality: HandChirality
            switch observation.chirality {
            case .left: chirality = .left
            case .right: chirality = .right
            @unknown default: chirality = .unknown
            }

            return HandObservation(
                chirality: chirality,
                wristPosition: wristPoint,
                indexTipPosition: indexTipPoint,
                confidence: observation.confidence
            )
        }
    }
}
