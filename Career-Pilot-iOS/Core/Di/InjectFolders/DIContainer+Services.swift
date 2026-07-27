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
        container.register(MicrophonePermissionManaging.self){ _ in
            MicrophonePermissionManager()
            
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
            KeychainAuthTokenStore(keychain: r.resolve(KeychainManaging.self)!)
        }.inObjectScope(.container)
        
        // Token Provider
        container.register(TokenProviding.self) { r in
            AuthTokenProvider(tokenStore: r.resolve(AuthTokenStoring.self)!)
        }.inObjectScope(.container)
        
        //NetworkService
        container.register(NetworkService.self, name: "base") { _ in
                 URLSessionNetworkService()
             }
        
        container.register(NetworkService.self, name: "authenticated") { r in
            AuthenticatedNetworkService(
                baseService: r.resolve(NetworkService.self, name: "base")!,
                tokenProvider: r.resolve(TokenProviding.self)!
            )
        }
        
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

    }
}
