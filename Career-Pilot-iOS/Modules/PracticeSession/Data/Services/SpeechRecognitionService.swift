//
//  SpeechRecognitionService.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 21/07/2026.
//

import Foundation
import Speech
import AVFoundation

enum SpeechRecognitionError: Error, LocalizedError {
    case recognizerUnavailable
    case authorizationDenied
    case noSpeechDetected
    case transcriptionFailed(String)

    var errorDescription: String? {
        switch self {
        case .recognizerUnavailable:
            return "Speech recognizer is unavailable."
        case .authorizationDenied:
            return "Speech recognition permission was denied."
        case .noSpeechDetected:
            return "No speech could be recognized."
        case .transcriptionFailed(let reason):
            return "Transcription failed: \(reason)"
        }
    }
}

protocol SpeechRecognitionServicing {
    func transcribe(audioAt url: URL) async throws -> String
}

final class SpeechRecognitionService: SpeechRecognitionServicing {

    func requestPermission() async throws {
        let status = await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                continuation.resume(returning: status)
            }
        }
        guard status == .authorized else {
            throw SpeechRecognitionError.authorizationDenied
        }
    }

    func transcribe(audioAt url: URL) async throws -> String {
        try await requestPermission()

        guard let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US")) else {
            throw SpeechRecognitionError.recognizerUnavailable
        }
        guard recognizer.isAvailable else {
            throw SpeechRecognitionError.recognizerUnavailable
        }

        let request = SFSpeechURLRecognitionRequest(url: url)
        request.shouldReportPartialResults = false // fewer callback firings to guard against

        return try await withCheckedThrowingContinuation { continuation in
            // The completion handler can fire more than once even with partials off —
            // a continuation may only ever be resumed once or it's a hard crash, so
            // this flag makes every path after the first one a no-op.
            var didResume = false
            let resumeOnce: (Result<String, Error>) -> Void = { outcome in
                guard !didResume else { return }
                didResume = true
                switch outcome {
                case .success(let transcript): continuation.resume(returning: transcript)
                case .failure(let error): continuation.resume(throwing: error)
                }
            }

            recognizer.recognitionTask(with: request) { result, error in
                if let error {
                    print("Can't transcribe due: \(error.localizedDescription)")
                    print("Recognizer isAvailable:", recognizer.isAvailable)
                    print("Speech auth status:", SFSpeechRecognizer.authorizationStatus())
                    print("File exists:", FileManager.default.fileExists(atPath: url.path))
                    resumeOnce(.failure(SpeechRecognitionError.noSpeechDetected))
                    return
                }
                guard let result else { return }
                if result.isFinal {
                    resumeOnce(.success(result.bestTranscription.formattedString))
                }
            }
        }
    }
}
