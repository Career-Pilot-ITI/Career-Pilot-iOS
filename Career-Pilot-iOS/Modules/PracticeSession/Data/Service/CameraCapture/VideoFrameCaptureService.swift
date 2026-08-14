//
//  VideoFrameCaptureService.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 13/08/2026.
//

import AVFoundation
import CoreImage

/// Data-layer implementation of `VideoFrameCaptureServicing`.
///
/// This is the only file in the video-capture module that imports AVFoundation/CoreMedia.
/// Everything it hands back upward (`CapturedFrame`) is framework-light (`CGImage` + `TimeInterval`),
/// so the view model and any future Domain/Vision layer never need to import AVFoundation.
final class VideoFrameCaptureService: NSObject, VideoFrameCaptureServicing {

    weak var delegate: VideoFrameCaptureServiceDelegate?

    let previewSession = AVCaptureSession()

    private(set) var isConfigured = false

    private let samplingStrategy: FrameSamplingStrategy
    private let sessionQueue = DispatchQueue(label: "com.careerpilot.videoFrameCapture.session")
    private let videoOutput = AVCaptureVideoDataOutput()
    private let ciContext = CIContext()

    private let sessionStartDate = Date()
    private var isCapturing = false
    private var lastKeptTimestamp: TimeInterval = 0

    private let bufferLock = NSLock()
    private var buffer: [CapturedFrame] = []

    init(samplingStrategy: FrameSamplingStrategy = .default) {
        self.samplingStrategy = samplingStrategy
        super.init()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleSessionRuntimeError(_:)),
            name: .AVCaptureSessionRuntimeError,
            object: previewSession
        )
    }

    // MARK: - VideoFrameCaptureServicing

    func configureSessionIfNeeded() async throws {
        guard !isConfigured else { return }

        guard await requestCameraAccess() else {
            throw VideoCaptureError.permissionDenied
        }

        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            sessionQueue.async { [weak self] in
                guard let self else { return }
                do {
                    try self.configureSessionOnQueue()
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
        isConfigured = true
    }

    func startCapturing() {
        guard isConfigured else { return }

        bufferLock.lock()
        buffer.removeAll()
        bufferLock.unlock()
        lastKeptTimestamp = 0
        isCapturing = true

        sessionQueue.async { [weak self] in
            guard let self, !self.previewSession.isRunning else { return }
            self.previewSession.startRunning()
        }
    }

    @discardableResult
    func stopCapturing() -> [CapturedFrame] {
        isCapturing = false

        sessionQueue.async { [weak self] in
            guard let self, self.previewSession.isRunning else { return }
            self.previewSession.stopRunning()
        }

        bufferLock.lock()
        let frames = buffer
        buffer.removeAll()
        bufferLock.unlock()
        return frames
    }

    func teardownSession() {
        isCapturing = false
        sessionQueue.async { [weak self] in
            guard let self else { return }
            if self.previewSession.isRunning {
                self.previewSession.stopRunning()
            }
            self.previewSession.inputs.forEach { self.previewSession.removeInput($0) }
            self.previewSession.outputs.forEach { self.previewSession.removeOutput($0) }
        }
        isConfigured = false
    }

    // MARK: - Setup

    private func requestCameraAccess() async -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            return true
        case .notDetermined:
            return await AVCaptureDevice.requestAccess(for: .video)
        case .denied, .restricted:
            return false
        @unknown default:
            return false
        }
    }

    /// Must run on `sessionQueue`.
    private func configureSessionOnQueue() throws {
        previewSession.beginConfiguration()
        defer { previewSession.commitConfiguration() }

        previewSession.sessionPreset = .medium

        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            throw VideoCaptureError.cameraUnavailable
        }

        let input: AVCaptureDeviceInput
        do {
            input = try AVCaptureDeviceInput(device: device)
        } catch {
            throw VideoCaptureError.sessionConfigurationFailed(error.localizedDescription)
        }
        guard previewSession.canAddInput(input) else {
            throw VideoCaptureError.sessionConfigurationFailed("Cannot add front camera input.")
        }
        previewSession.addInput(input)

        videoOutput.setSampleBufferDelegate(self, queue: sessionQueue)
        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        videoOutput.alwaysDiscardsLateVideoFrames = true

        guard previewSession.canAddOutput(videoOutput) else {
            throw VideoCaptureError.sessionConfigurationFailed("Cannot add video data output.")
        }
        previewSession.addOutput(videoOutput)

        if let connection = videoOutput.connection(with: .video), connection.isVideoOrientationSupported {
            connection.videoOrientation = .portrait
        }
    }

    // MARK: - Frame handling

    private func handle(_ sampleBuffer: CMSampleBuffer) {
        guard isCapturing, let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        let presentationTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
        let timestamp = presentationTime.isValid
            ? presentationTime.seconds
            : Date().timeIntervalSince(sessionStartDate)

        guard timestamp - lastKeptTimestamp >= samplingStrategy.minimumInterval else { return }
        lastKeptTimestamp = timestamp

        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        guard let cgImage = ciContext.createCGImage(ciImage, from: ciImage.extent) else { return }

        let frame = CapturedFrame(image: cgImage, timestamp: timestamp)
        bufferLock.lock()
        buffer.append(frame)
        bufferLock.unlock()
    }

    @objc private func handleSessionRuntimeError(_ notification: Notification) {
        let reason = (notification.userInfo?[AVCaptureSessionErrorKey] as? Error)?.localizedDescription ?? "unknown"
        Task { @MainActor [weak self] in
            guard let self else { return }
            self.delegate?.videoFrameCaptureService(self, didFailWithError: .sessionInterrupted(reason))
        }
    }
}

extension VideoFrameCaptureService: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        handle(sampleBuffer)
    }
}
