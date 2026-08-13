//
//  VideoFrameCaptureServicing.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 13/08/2026.
//

import AVFoundation

protocol VideoFrameCaptureServiceDelegate: AnyObject {
    /// Non-fatal by design: a capture failure should never be allowed to fail the interview.
    /// Conformers should log/skip video for the affected question and keep the audio flow going.
    func videoFrameCaptureService(_ service: VideoFrameCaptureServicing, didFailWithError error: VideoCaptureError)
}

/// Owns the front-camera capture session and samples frames from it per the injected
/// `FrameSamplingStrategy`. No video file is ever written — frames are handed back in memory
/// and are the only artifact this service produces.
protocol VideoFrameCaptureServicing: AnyObject {
    var delegate: VideoFrameCaptureServiceDelegate? { get set }

    /// Exposed only for the SwiftUI camera preview (`AVCaptureVideoPreviewLayer` wrapper).
    /// The view model never touches this directly.
    var previewSession: AVCaptureSession { get }

    var isConfigured: Bool { get }

    /// Requests camera permission (if needed) and configures the capture session once.
    /// Safe to call multiple times — subsequent calls no-op once configured.
    func configureSessionIfNeeded() async throws

    /// Starts the session running and begins sampling frames. No-op if not configured.
    func startCapturing()

    /// Stops sampling and returns everything captured since the last `startCapturing()`.
    @discardableResult
    func stopCapturing() -> [CapturedFrame]

    /// Fully tears down the capture session (inputs/outputs removed). Call on cancel/deinit.
    func teardownSession()
}
