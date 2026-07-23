import Foundation

enum SilenceDetectionError: Error, LocalizedError {
    case alreadyMonitoring
    case notMonitoring

    var errorDescription: String? {
        switch self {
        case .alreadyMonitoring: return "Silence detection is already running."
        case .notMonitoring: return "Silence detection isn't running."
        }
    }
}

protocol SilenceDetectionServiceDelegate: AnyObject {

    func silenceDetectionServiceDidDetectSilenceStart(_ service: SilenceDetectionService)
    func silenceDetectionServiceDidResumeSpeech(_ service: SilenceDetectionService)
    func silenceDetectionServiceDidTimeout(_ service: SilenceDetectionService)
    func silenceDetectionService(_ service: SilenceDetectionService, didUpdateCountdown remaining: TimeInterval)
}

protocol SilenceDetectionServicing: AnyObject {
    var delegate: SilenceDetectionServiceDelegate? { get set }
    var isMonitoring: Bool { get }
    func startMonitoring(silenceTimeout: TimeInterval, silenceThreshold: Float) throws
    func stopMonitoring()
    /// Feed this from AudioRecordingServiceDelegate.didUpdateLevel. This service has no
    /// idea AVFoundation exists — it just reacts to numbers, which makes it trivial to
    /// unit test without a microphone.
    func processLevel(_ level: Float)
}

final class SilenceDetectionService: SilenceDetectionServicing {

    weak var delegate: SilenceDetectionServiceDelegate?

    private(set) var isMonitoring = false

    private var silenceTimeout: TimeInterval = 0
    private var silenceThreshold: Float = 0
    private var countdownTimer: Timer?
    private var remainingTime: TimeInterval = 0
    private var isCurrentlySilent = false

    private let tickInterval: TimeInterval = 0.2

    func startMonitoring(silenceTimeout: TimeInterval, silenceThreshold: Float) throws {
        guard !isMonitoring else {
            throw SilenceDetectionError.alreadyMonitoring
        }
        self.silenceTimeout = silenceTimeout
        self.silenceThreshold = silenceThreshold // That the level that act as a mesurement
        self.isMonitoring = true
        self.isCurrentlySilent = false
        self.remainingTime = silenceTimeout
    }

    func stopMonitoring() {
        countdownTimer?.invalidate()
        countdownTimer = nil
        isMonitoring = false
        isCurrentlySilent = false
    }

    func processLevel(_ level: Float) {
        guard isMonitoring else { return }

        let isSilentNow = level < silenceThreshold

        if isSilentNow && !isCurrentlySilent {
            // Went silent — start the countdown.
            isCurrentlySilent = true
            remainingTime = silenceTimeout
            delegate?.silenceDetectionServiceDidDetectSilenceStart(self)
            startCountdown()
        } else if !isSilentNow && isCurrentlySilent {
            // Speech resumed before the timer ran out — cancel.
            isCurrentlySilent = false
            countdownTimer?.invalidate()
            countdownTimer = nil
            delegate?.silenceDetectionServiceDidResumeSpeech(self)
        }
    }

    private func startCountdown() {
        countdownTimer?.invalidate()
        countdownTimer = Timer.scheduledTimer(withTimeInterval: tickInterval, repeats: true) { [weak self] timer in
            guard let self = self else { timer.invalidate(); return }
            self.remainingTime -= self.tickInterval
            if self.remainingTime <= 0 {
                timer.invalidate()
                self.countdownTimer = nil
                self.isMonitoring = false
                self.delegate?.silenceDetectionServiceDidTimeout(self)
            } else {
                self.delegate?.silenceDetectionService(self, didUpdateCountdown: self.remainingTime)
            }
        }
    }
}
