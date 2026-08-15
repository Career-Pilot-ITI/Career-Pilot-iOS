//
//  Career_Pilot_iOSTests.swift
//  Career-Pilot-iOSTests
//
//  Created by Mohamed Magdy on 12/07/2026.
//

import XCTest
@testable import Career_Pilot_iOS

final class Career_Pilot_iOSTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
    }

    @MainActor
    func testOptimizePollingUpdatesProgressBeforeTimeout() async {
        let repository = OptimizeRepositoryStub(responses: [
            .success(makeResponse(progress: 10)),
            .success(makeResponse(progress: 45))
        ])
        let viewModel = makeViewModel(repository: repository, maxPollCount: 1)

        await viewModel.startOptimize(workspaceId: 19)
        await waitUntil { viewModel.state == .timeout }

        XCTAssertEqual(viewModel.displayedProgress, 45)
        XCTAssertEqual(repository.optimizeCallCount, 2)
    }

    @MainActor
    func testOptimizePollingCompletesWhenProgressReaches100() async {
        let result = CvOptimizationResult(sections: [], recommendedTracks: [], coinCost: 0)
        let repository = OptimizeRepositoryStub(responses: [
            .success(makeResponse(progress: 10)),
            .success(makeResponse(progress: 100, result: result))
        ])
        let viewModel = makeViewModel(repository: repository)

        await viewModel.startOptimize(workspaceId: 19)
        await waitUntil {
            if case .completed = viewModel.state { return true }
            return false
        }

        XCTAssertEqual(viewModel.displayedProgress, 100)
        XCTAssertEqual(repository.optimizeCallCount, 2)
    }

    @MainActor
    func testOptimizePollingStopsOnNonRetryableServerError() async {
        let repository = OptimizeRepositoryStub(responses: [
            .success(makeResponse(progress: 10)),
            .failure(NetworkError.serverError(statusCode: 400, data: nil, message: "Invalid resource path"))
        ])
        let viewModel = makeViewModel(repository: repository)

        await viewModel.startOptimize(workspaceId: 19)
        await waitUntil {
            if case .failed = viewModel.state { return true }
            return false
        }

        XCTAssertEqual(repository.optimizeCallCount, 2)
        XCTAssertEqual(viewModel.state, .failed(message: "Invalid resource path"))
    }

    @MainActor
    func testOptimizePollingTimesOutAfterMaxAttempts() async {
        let repository = OptimizeRepositoryStub(responses: [
            .success(makeResponse(progress: 10)),
            .success(makeResponse(progress: 20)),
            .success(makeResponse(progress: 30))
        ])
        let viewModel = makeViewModel(repository: repository, maxPollCount: 2)

        await viewModel.startOptimize(workspaceId: 19)
        await waitUntil { viewModel.state == .timeout }

        XCTAssertEqual(repository.optimizeCallCount, 3)
    }

    @MainActor
    private func makeViewModel(
        repository: OptimizeRepositoryStub,
        maxPollCount: Int = 5
    ) -> CvOptimizeViewModel {
        CvOptimizeViewModel(
            triggerUseCase: TriggerCvOptimizeUseCase(repository: repository),
            pollUseCase: PollCvOptimizeUseCase(repository: repository),
            pollInterval: 0,
            maxPollCount: maxPollCount,
            completionDelay: 0
        )
    }

    @MainActor
    private func waitUntil(
        _ condition: @escaping () -> Bool,
        attempts: Int = 100
    ) async {
        for _ in 0..<attempts where !condition() {
            await Task.yield()
        }
        XCTAssertTrue(condition())
    }

    private func makeResponse(
        progress: Int,
        result: CvOptimizationResult? = nil
    ) -> CvOptimizeResponse {
        CvOptimizeResponse(
            status: progress >= 100 ? .completed : .processing,
            progressPercentage: progress,
            currentStep: "Optimizing CV",
            errorMessage: nil,
            createdAt: "",
            startedAt: nil,
            completedAt: nil,
            result: result
        )
    }
}

private final class OptimizeRepositoryStub: ATSRepositoryProtocol {
    private var responses: [Result<CvOptimizeResponse, Error>]
    private(set) var optimizeCallCount = 0

    init(responses: [Result<CvOptimizeResponse, Error>]) {
        self.responses = responses
    }

    func optimizeCV(workspaceId: Int) async throws -> CvOptimizeResponse {
        optimizeCallCount += 1
        return try responses.removeFirst().get()
    }

    func getJobByURL(from url: String) async throws -> JobEntity { throw StubError.unused }
    func scoreCvAgainstJob(for id: Int) async throws -> JobMatchEntity { throw StubError.unused }
    func generateCoverLetter(for id: Int) async throws -> CoverLetterEntity { throw StubError.unused }

    private enum StubError: Error { case unused }
}

}
