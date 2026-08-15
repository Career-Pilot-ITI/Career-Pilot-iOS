//  HomeViewModel.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 16/07/2026.
//

import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    enum HomeState {
        case idle
        case loading
        case success
        case error(String)
    }
    
    // MARK: - Published Properties
    @Published var usedSessions: Double = 1.0
    @Published var totalSessions: Double = 3.0
    @Published private(set) var progressInfo: OverallProgressInfo?
    @Published private(set) var recommendedInterviews: [InterviewItem] = []
    @Published private(set) var recentSessions: [HomeSessionInfo] = []
    @Published private(set) var user: User = .guest
    
    // MARK: - States
    private var hasLoadedHome = false
    @Published private(set) var userState: HomeState = .idle
    @Published private(set) var tracksState: HomeState = .idle
    @Published private(set) var sessionsState: HomeState = .idle
    
    // MARK: - Dependencies & Cancellables
    private let userSession: UserSession
    private let getAllTracksUseCase: GetAllTrackesUseCase
    private let getAllSessionUseCase: LoadSessionsUseCase
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(
        userSession: UserSession,
        getAllTracksUseCase: GetAllTrackesUseCase,
        getAllSessionUseCase: LoadSessionsUseCase
    ) {
        self.userSession = userSession
        self.getAllTracksUseCase = getAllTracksUseCase
        self.getAllSessionUseCase = getAllSessionUseCase
        
        // 🔄 Automatically listen for any changes to the user session
        bindUserSession()
    }
    
    // MARK: - Bindings
    private func bindUserSession() {
        userSession.$userData
            .receive(on: RunLoop.main)
            .sink { [weak self] updatedUser in
                guard let self = self else { return }
                
                if let updatedUser = updatedUser {
                    // Update user (map to domain User if needed)
                    self.user = updatedUser.toUserSettingsDomain().toUser()
                    self.userState = .success
                } else {
                    self.user = .guest
                    self.userState = .idle
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Home
    func loadHome() async {
        guard !hasLoadedHome else { return }
        hasLoadedHome = true
        
        async let userTask: Void = loadUser()
        async let sessionsTask: Void = loadRecentSessions()
        async let interviewsTask: Void = loadRecommendedInterviews()
        
        _ = await (userTask, sessionsTask, interviewsTask)
    }
    
    // MARK: - User
    func loadUser() async {
        // If user is already available in UserSession, we don't need to show loading
        if userSession.userData != nil {
            userState = .success
            return
        }
        
        userState = .loading
        do {
            // Trigger refresh via userSession if not loaded yet
            try await userSession.reload()
            userState = .success
        } catch is CancellationError {
            return
        } catch {
            userState = .error(error.localizedDescription)
        }
    }
    
    // MARK: - Recent Sessions
    func loadRecentSessions(forceRefresh: Bool = false) async {
        sessionsState = .loading
        do {
            let result = try await getAllSessionUseCase.execute(LoadSessionsInput(page: 0, forceRefresh: forceRefresh))
            let rawSessions = result.items
            
            let mappedRawSessions = rawSessions
                .map { ReportsInterviewSession.toHomeSessionInfo(from: $0) }
            self.recentSessions = Array(mappedRawSessions.prefix(5))
            
            self.progressInfo = rawSessions.calculateOverallProgress()
            
            sessionsState = .success
        } catch is CancellationError {
            return
        } catch {
            sessionsState = .error(error.localizedDescription)
        }
    }
    
    // MARK: - Recommended Interviews
    func loadRecommendedInterviews() async {
        tracksState = .loading
        do {
            let tracks = try await getAllTracksUseCase.execute(())
            let mappedItems = tracks.map { $0.toInterviewItem() }
            
            self.recommendedInterviews = Array(mappedItems.prefix(5))
            tracksState = .success
        } catch is CancellationError {
            return
        } catch {
            tracksState = .error(error.localizedDescription)
        }
    }
}


