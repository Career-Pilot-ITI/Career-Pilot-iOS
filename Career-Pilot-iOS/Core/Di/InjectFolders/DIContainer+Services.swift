//
//  DIContainer+Services.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 19/07/2026.
//

import Foundation

extension DIContainer{
    func registerServices(){
        
        //MicrophonePermissionManaging
        container.register(PermissionManaging.self){ _ in
            PermissionManager()
            
        }.inObjectScope(.container)
        
        // CoreData
        container.register(CoreDataManager.self) { _ in
            CoreDataManager() 
        }.inObjectScope(.container)
        
        // keychainManager
        container.register(KeychainManaging.self) { _ in
            KeychainManager()
        }.inObjectScope(.container)
        
        container.register(CoreDataManaging.self) { _ in
            CoreDataManager()
        }.inObjectScope(.container)
        
        container.register(CurrentUserProviding.self) { _ in
            CurrentUserProvider()
        }.inObjectScope(.container)
        
        // KeychainAuthTokenStore
        container.register(AuthTokenStoring.self) { r in
            KeychainAuthTokenStore(
                keychain: r.resolve(KeychainManaging.self)!,
                refreshService: r.resolve(NetworkService.self, name: "base"),
                refreshActor: r.resolve(TokenRefreshActor.self)
            )
        }.inObjectScope(.container)
        
        // Token Provider
        container.register(TokenProviding.self) { r in
            AuthTokenProvider(tokenStore: r.resolve(AuthTokenStoring.self)!)
        }.inObjectScope(.container)

        // Token Refresh Actor — must be a singleton so all services share
        // the same deduplication state.
        container.register(TokenRefreshActor.self) { _ in
            TokenRefreshActor()
        }.inObjectScope(.container)

        // NetworkService
        container.register(NetworkService.self, name: "base") { _ in
            URLSessionNetworkService()
        }.inObjectScope(.container)

        container.register(NetworkService.self, name: "authenticated") { r in
            let appState = r.resolve(AppState.self)!
            let container = r
            return AuthenticatedNetworkService(
                baseService:    r.resolve(NetworkService.self, name: "base")!,
                tokenProvider:  r.resolve(TokenProviding.self)!,
                tokenStore:     r.resolve(AuthTokenStoring.self)!,
                refreshService: r.resolve(NetworkService.self, name: "base")!,
                refreshActor:   r.resolve(TokenRefreshActor.self)!,
                onForceLogout: {
                    await MainActor.run { appState.logout() }
                    try? await container.resolve(AuthRepositoryProtocol.self)?.clearSession()
                }
            )
        }.inObjectScope(.container)
        
        container.register(AppState.self) { _ in
            AppState()	
        }
        
        //MARK: PracticeSession
        container.register(InterviewValidationServicing.self) { _ in
            InterviewValidationService()
        }

        container.register(InterviewProgressServicing.self) { _ in
            InterviewProgressService()
        }

        container.register(AudioRecordingServicing.self) { _ in
            AudioRecordingService()
        }

        container.register(SilenceDetectionServicing.self) { _ in
            SilenceDetectionService()
        }

        container.register(SpeechPlaybackServicing.self) { _ in
            SpeechPlaybackService()
        }

        container.register(SpeechRecognitionServicing.self) { _ in
            SpeechRecognitionService()
        }
        
        //SubscriptionAccessManaging
        container.register((any SubscriptionAccessManaging).self) { r in
            SubscriptionAccessManager(userSession: r.resolve(UserSession.self)!)
        }

        container.register(UserSession.self) { r in
            UserSession(getUserDataUseCase: r.resolve(GetUserDataUseCase.self)!, refreshUseCase: r.resolve(RefreshUserDataUseCase.self)!)
        }
    }
}
