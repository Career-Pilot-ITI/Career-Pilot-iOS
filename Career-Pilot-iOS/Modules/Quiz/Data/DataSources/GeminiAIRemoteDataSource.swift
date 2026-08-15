////
////  GeminiAIRemoteDataSource.swift
////  Career-Pilot-iOS
////
////  Created by Ahmed El-Sayyad Mohamed on 14/08/2026.

import Foundation
import FirebaseAI

enum GeminiAIConfiguration {

    static let modelName = "gemini-3.6-flash"
}

protocol AIRemoteDataSourceProtocol {
    func generateSubtopics(
        trackTitle: String
    ) async throws -> [SubtopicDTO]

    func generateQuestions(
        trackTitle: String,
        subtopicTitle: String
    ) async throws -> [QuizQuestionDTO]
}

final class GeminiAIRemoteDataSource: AIRemoteDataSourceProtocol {

    // MARK: - Properties

    private lazy var ai = FirebaseAI.firebaseAI(
        backend: .googleAI()
    )

    // MARK: - Initialization

    init() {
        print("🤖 [AIDataSource Init] GeminiAIRemoteDataSource initialized")
        print("🤖 [AIDataSource] Model: \(GeminiAIConfiguration.modelName)")
    }

    // MARK: - Generate Subtopics

    func generateSubtopics(
        trackTitle: String
    ) async throws -> [SubtopicDTO] {

        print("------------------------------------------")
        print("🤖 [AIDataSource] Generating subtopics")
        print("🎯 Track: \(trackTitle)")
        print("🤖 Model: \(GeminiAIConfiguration.modelName)")
        print("------------------------------------------")

        let schema = Schema.object(
            properties: [
                "subtopics": .array(
                    items: .object(
                        properties: [
                            "title": .string(),
                            "order": .integer()
                        ]
                    )
                )
            ]
        )

        let model = ai.generativeModel(
            modelName: GeminiAIConfiguration.modelName,
            generationConfig: GenerationConfig(
                responseMIMEType: "application/json",
                responseSchema: schema
            )
        )

        let prompt = """
        Generate a structured roadmap of 5-7 core subtopics
        for the following technology track:

        "\(trackTitle)"

        Requirements:
        - Generate between 5 and 7 subtopics.
        - Each subtopic must have a clear technical title.
        - Each subtopic must have an ascending order number.
        - Order must start at 1.
        - Return only the requested JSON structure.
        """

        do {

            let response = try await model.generateContent(prompt)

            guard
                let jsonText = response.text,
                let data = jsonText.data(using: .utf8)
            else {
                throw GeminiAIError.emptyResponse
            }

            print("📄 [AIDataSource] Subtopics JSON:")
            print(jsonText)

            // MARK: AI Response Models

            struct AISubtopic: Decodable {
                let title: String
                let order: Int
            }

            struct AISubtopicResponse: Decodable {
                let subtopics: [AISubtopic]
            }

            // MARK: Decode AI Response

            let aiResult = try JSONDecoder().decode(
                AISubtopicResponse.self,
                from: data
            )

            print(
                "✅ [AIDataSource] Decoded \(aiResult.subtopics.count) subtopics"
            )

            // MARK: Map AI Model -> App DTO

            let result = aiResult.subtopics.map { item in

                SubtopicDTO(
                    id: UUID().uuidString,
                    title: item.title,
                    order: item.order
                )
            }

            print(
                "✅ [AIDataSource] Generated \(result.count) subtopics successfully"
            )

            return result

        } catch let error as DecodingError {

            logDecodingError(error)

            throw error

        } catch {

            print(
                "❌ [AIDataSource] Subtopics generation failed:"
            )
            print("❌ \(error)")

            throw error
        }
    }

    // MARK: - Generate Questions

    func generateQuestions(
        trackTitle: String,
        subtopicTitle: String
    ) async throws -> [QuizQuestionDTO] {

        print("------------------------------------------")
        print("🤖 [AIDataSource] Generating questions")
        print("🎯 Track: \(trackTitle)")
        print("📚 Subtopic: \(subtopicTitle)")
        print("🤖 Model: \(GeminiAIConfiguration.modelName)")
        print("------------------------------------------")

        let schema = Schema.object(
            properties: [
                "questions": .array(
                    items: .object(
                        properties: [
                            "questionText": .string(),
                            "options": .array(
                                items: .string()
                            ),
                            "correctIndex": .integer()
                        ]
                    )
                )
            ]
        )

        let model = ai.generativeModel(
            modelName: GeminiAIConfiguration.modelName,
            generationConfig: GenerationConfig(
                responseMIMEType: "application/json",
                responseSchema: schema
            )
        )

        let prompt = """
        Generate exactly 5 multiple-choice technical interview questions.

        Track:
        "\(trackTitle)"

        Subtopic:
        "\(subtopicTitle)"

        Requirements:
        - Exactly 5 questions.
        - Each question must have exactly 4 options.
        - correctIndex must be between 0 and 3.
        - Questions must be technically accurate.
        - Questions should match the difficulty of the track.
        - Return only the requested JSON structure.
        """

        do {

            let response = try await model.generateContent(prompt)

            guard
                let jsonText = response.text,
                let data = jsonText.data(using: .utf8)
            else {
                throw GeminiAIError.emptyResponse
            }

            print("📄 [AIDataSource] Questions JSON:")
            print(jsonText)

            // MARK: AI Response Models

            struct AIQuestion: Decodable {
                let questionText: String
                let options: [String]
                let correctIndex: Int
            }

            struct AIQuestionResponse: Decodable {
                let questions: [AIQuestion]
            }

            // MARK: Decode AI Response

            let aiResult = try JSONDecoder().decode(
                AIQuestionResponse.self,
                from: data
            )

            print(
                "✅ [AIDataSource] Decoded \(aiResult.questions.count) questions"
            )

            // MARK: Validate AI Response

            for question in aiResult.questions {

                guard question.options.count == 4 else {
                    throw GeminiAIError.invalidQuestionOptionsCount
                }

                guard question.correctIndex >= 0,
                      question.correctIndex < question.options.count
                else {
                    throw GeminiAIError.invalidCorrectIndex
                }
            }

            // MARK: Map AI Model -> App DTO

            let result = aiResult.questions.map { question in

                QuizQuestionDTO(
                    questionText: question.questionText,
                    options: question.options,
                    correctIndex: question.correctIndex
                )
            }

            print(
                "✅ [AIDataSource] Generated \(result.count) questions successfully"
            )

            return result

        } catch let error as DecodingError {

            logDecodingError(error)

            throw error

        } catch {

            print(
                "❌ [AIDataSource] Questions generation failed:"
            )
            print("❌ \(error)")

            throw error
        }
    }
}

// MARK: - Errors

private enum GeminiAIError: LocalizedError {

    case emptyResponse
    case invalidQuestionOptionsCount
    case invalidCorrectIndex

    var errorDescription: String? {

        switch self {

        case .emptyResponse:
            return "Gemini returned an empty response."

        case .invalidQuestionOptionsCount:
            return "AI question must contain exactly 4 options."

        case .invalidCorrectIndex:
            return "AI returned an invalid correct answer index."
        }
    }
}

// MARK: - Decoding Error Logging

private func logDecodingError(
    _ error: DecodingError
) {

    print("❌ [AIDataSource] JSON decoding failed")

    switch error {

    case .keyNotFound(let key, let context):

        print("❌ Missing key: \(key.stringValue)")
        print("📍 \(context.debugDescription)")

    case .typeMismatch(let type, let context):

        print("❌ Type mismatch: \(type)")
        print("📍 \(context.debugDescription)")

    case .valueNotFound(let type, let context):

        print("❌ Missing value: \(type)")
        print("📍 \(context.debugDescription)")

    case .dataCorrupted(let context):

        print("❌ Data corrupted")
        print("📍 \(context.debugDescription)")

    @unknown default:

        print("❌ Unknown decoding error")
    }
}
