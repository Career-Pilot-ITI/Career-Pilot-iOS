import Foundation
import AVFoundation

enum SpeechPlaybackError: Error, LocalizedError {
    case audioSessionConfigurationFailed(String)
    case alreadyPlaying
    case voiceUnavailable

    var errorDescription: String? {
        switch self {
        case .audioSessionConfigurationFailed(let reason):
            return "Couldn't configure audio playback: \(reason)"
        case .alreadyPlaying:
            return "AI is already speaking."
        case .voiceUnavailable:
            return "No voice is available for this language."
        }
    }
}

protocol SpeechPlaybackServiceDelegate: AnyObject {
    func speechPlaybackServiceDidStart(_ service: SpeechPlaybackService)
    func speechPlaybackServiceDidFinish(_ service: SpeechPlaybackService)
    func speechPlaybackService(_ service: SpeechPlaybackService, didFailWithError error: SpeechPlaybackError)
}

protocol SpeechPlaybackServicing: AnyObject {
    var delegate: SpeechPlaybackServiceDelegate? { get set }
    var isPlaying: Bool { get }
    func speak(text: String) async throws
    func stop()
}

final class SpeechPlaybackService: NSObject, SpeechPlaybackServicing {

    weak var delegate: SpeechPlaybackServiceDelegate?

    private(set) var isPlaying = false

    private let synthesizer = AVSpeechSynthesizer()
    private var continuation: CheckedContinuation<Void, Error>?

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    func speak(text: String) async throws {

        guard !isPlaying else {
            throw SpeechPlaybackError.alreadyPlaying
        }

        let session = AVAudioSession.sharedInstance()

        do {
            try session.setCategory(.playback,
                                    mode: .spokenAudio,
                                    options: [.duckOthers])

            try session.setActive(true)

        } catch {
            throw SpeechPlaybackError.audioSessionConfigurationFailed(
                error.localizedDescription
            )
        }

        let utterance = AVSpeechUtterance(string: text)

        guard let voice = AVSpeechSynthesisVoice(language: "en-US") else {
            throw SpeechPlaybackError.voiceUnavailable
        }

        utterance.voice = voice

        isPlaying = true

        try await withCheckedThrowingContinuation { continuation in

            self.continuation = continuation

            synthesizer.speak(utterance)
        }
    }

    func stop() {

        guard isPlaying else { return }

        synthesizer.stopSpeaking(at: .immediate)
    }
}

extension SpeechPlaybackService: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.delegate?.speechPlaybackServiceDidStart(self)
        }
    }

    func speechSynthesizer(
        _ synthesizer: AVSpeechSynthesizer,
        didFinish utterance: AVSpeechUtterance
    ) {

        isPlaying = false

        continuation?.resume()

        continuation = nil
    }

    func speechSynthesizer(
        _ synthesizer: AVSpeechSynthesizer,
        didCancel utterance: AVSpeechUtterance
    ) {

        isPlaying = false

        continuation?.resume(
            throwing: CancellationError()
        )

        continuation = nil
    }
}

