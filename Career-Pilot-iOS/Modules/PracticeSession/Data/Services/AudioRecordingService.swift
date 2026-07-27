import Foundation
import AVFoundation

enum AudioRecordingError: Error, LocalizedError {
    case permissionDenied
    case audioSessionConfigurationFailed(String)
    case recorderInitializationFailed(String)
    case alreadyRecording
    case notRecording
    case fileWriteFailed(String)

    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "Microphone access is required to record your answer."
        case .audioSessionConfigurationFailed(let reason):
            return "Couldn't configure the audio session: \(reason)"
        case .recorderInitializationFailed(let reason):
            return "Couldn't start the recorder: \(reason)"
        case .alreadyRecording:
            return "A recording is already in progress."
        case .notRecording:
            return "No recording is in progress."
        case .fileWriteFailed(let reason):
            return "Couldn't save the recording: \(reason)"
        }
    }
}

struct AudioRecordingResult {
    let fileURL: URL
    let duration: TimeInterval
}

protocol AudioRecordingServiceDelegate: AnyObject {
    /// Normalized 0...1 volume level, sampled every ~0.1s. Feed this straight into
    /// SilenceDetectionService.processLevel(_:) — that's the only reason it's exposed.
    func audioRecordingService(_ service: AudioRecordingService, didUpdateLevel level: Float)
    func audioRecordingService(_ service: AudioRecordingService, didFailWithError error: AudioRecordingError)
}

protocol AudioRecordingServicing: AnyObject {
    var delegate: AudioRecordingServiceDelegate? { get set }
    var isRecording: Bool { get }
    func requestPermission() async -> Bool
    func startRecording() throws
    func stopRecording() throws -> AudioRecordingResult
    func cancelRecording()
}

final class AudioRecordingService: NSObject, AudioRecordingServicing {

    weak var delegate: AudioRecordingServiceDelegate?

    private(set) var isRecording = false

    private var recorder: AVAudioRecorder?
    private var levelTimer: Timer?
    private var recordingStartTime: Date?

    private let levelPollInterval: TimeInterval = 0.1
    private let minDecibels: Float = -60

    func requestPermission() async -> Bool {
        await withCheckedContinuation { continuation in
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                continuation.resume(returning: granted)
            }
        }
    }

    func startRecording() throws {
        guard !isRecording else {
            throw AudioRecordingError.alreadyRecording
        }

        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .spokenAudio, options: [.defaultToSpeaker])
            try session.setActive(true)
        } catch {
            throw AudioRecordingError.audioSessionConfigurationFailed(error.localizedDescription)
        }

        let fileURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("m4a")

        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44_100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue
        ]

        do {
            let newRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            newRecorder.delegate = self
            newRecorder.isMeteringEnabled = true
            guard newRecorder.record() else {
                throw AudioRecordingError.recorderInitializationFailed("record() returned false")
            }
            recorder = newRecorder
        } catch let error as AudioRecordingError {
            throw error
        } catch {
            throw AudioRecordingError.recorderInitializationFailed(error.localizedDescription)
        }

        recordingStartTime = Date()
        isRecording = true
        startLevelPolling()
    }

    func stopRecording() throws -> AudioRecordingResult {
        guard isRecording, let recorder = recorder, let startTime = recordingStartTime else {
            throw AudioRecordingError.notRecording
        }

        stopLevelPolling()
        recorder.stop()
        isRecording = false

        let duration = Date().timeIntervalSince(startTime)
//        let url = URL(string: "file:///Users/mohamed/Library/Developer/CoreSimulator/Devices/CD29D4D6-B581-41CE-86CB-B816F1261257/data/Containers/Shared/AppGroup/626553A3-43FF-409F-BF4E-84101AE7D052/File%20Provider%20Storage/a%CC%82%C2%80%C2%8Ea%CC%82%C2%81%C2%A8%C3%98%C2%B4%C3%98%C2%A7%C3%98%C2%B1%C3%98%C2%B9%20%C3%98%C2%A7U%CC%80%C2%84U%CC%80%C2%81%C3%98%C2%B1U%CC%80%C2%8AU%CC%80%C2%82%20%C3%98%C2%B9%C3%98%C2%B2U%CC%80%C2%8A%C3%98%C2%B2%20%C3%98%C2%A7U%CC%80%C2%84U%CC%80%3F%C3%98%C2%B5%C3%98%C2%B1U%CC%80%C2%8A%2094a%CC%82%C2%81%C2%A9.m4a")!
        let url = recorder.url

        guard FileManager.default.fileExists(atPath: url.path) else {
            throw AudioRecordingError.fileWriteFailed("Recorded file was not found on disk.")
        }

        self.recorder = nil
        self.recordingStartTime = nil

        return AudioRecordingResult(fileURL: url, duration: duration)
    }

    func cancelRecording() {
        stopLevelPolling()
        recorder?.stop()
        recorder?.deleteRecording()
        recorder = nil
        recordingStartTime = nil
        isRecording = false
    }

    private func startLevelPolling() {
        levelTimer?.invalidate()
        levelTimer = Timer.scheduledTimer(withTimeInterval: levelPollInterval, repeats: true) { [weak self] _ in
            self?.pollLevel()
        }
    }

    private func stopLevelPolling() {
        levelTimer?.invalidate()
        levelTimer = nil
    }

    private func pollLevel() {
        guard let recorder = recorder else { return }
        recorder.updateMeters()
        // averagePower(forChannel:) is in decibels, roughly -60 (near-silence) to 0 (max).
        // Normalize to 0...1 so SilenceDetectionService doesn't need to know about dB.
        let decibels = recorder.averagePower(forChannel: 0)
        let normalized = normalizedLevel(fromDecibels: decibels)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.delegate?.audioRecordingService(self, didUpdateLevel: normalized)
        }
    }

    private func normalizedLevel(fromDecibels decibels: Float) -> Float {
        guard decibels.isFinite else { return 0 }
        if decibels < minDecibels { return 0 }
        if decibels >= 0 { return 1 }
        return (decibels - minDecibels) / (0 - minDecibels)
    }
}

extension AudioRecordingService: AVAudioRecorderDelegate {
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        stopLevelPolling()
        isRecording = false
        let recordingError = AudioRecordingError.fileWriteFailed(error?.localizedDescription ?? "Unknown encoding error")
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.delegate?.audioRecordingService(self, didFailWithError: recordingError)
        }
    }
}
