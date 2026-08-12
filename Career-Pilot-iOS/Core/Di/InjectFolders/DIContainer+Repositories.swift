//
//  DIContainer+Repositories.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 19/07/2026.
//

import Foundation


extension DIContainer{
    func registerRepositories(){
        
        //UserDataRepo
        container.register(UserDataRepo.self){r in
            UserDataRepoImp(
                    remoteDataSource: r.resolve(UserDataRemoteDataSource.self)!,
                    localDataSource:r.resolve(UserLocalDataSource.self)!
            )
        }
        
        // AuthRepo
        container.register(AuthRepositoryProtocol.self) { r in
            AuthRepositoryImpl(
                remoteDataSource: r.resolve(AuthRemoteDataSourceProtocol.self)!,
                tokenStore: r.resolve(AuthTokenStoring.self)!, 
                userLocalDataSource: r.resolve(UserLocalDataSource.self)!
            )
        }
        //OnBordingRepo
        container.register(OnBordingRepo.self) { r in
            OnBordingRepoImp(remote: r.resolve(OnBordingRemoteDataSource.self)!, userLocalDataSource: r.resolve(UserLocalDataSource.self)!)
        }
        
        // MARK: - PracticeSession
        container.register(InterviewRepository.self) { r in
            
            //            StubInterviewRepository()
            
            InterviewRepositoryImp(remoteDataSource: r.resolve(InterviewSessionRemoteDataSource.self)!)
        }
        
        container.register(ReportsRepositoryProtocol.self) { r in
           ReportsRepository(
               remote: r.resolve(ReportsRemoteDataSourceProtocol.self)!,
               local: r.resolve(ReportsLocalDataProtocol.self)!
           )
       }
        
        // MARK: - Settings Repository
        container.register(SettingsRepoImp.self) { r in
            SettingsRepoImp(
                remote: r.resolve(SettingsRemoteImp.self)!,
                local: r.resolve(SettingsLocalDataSourceImp.self)!,
                // We force cast to KeychainAuthTokenStore since your manual init required it,
                // but ideally, your repo should depend on the AuthTokenStoring protocol.
                authToken: r.resolve(AuthTokenStoring.self) as! KeychainAuthTokenStore
            )
        }

        // MARK: - Checkout Repository
        container.register(CheckoutRepoImplementation.self) { r in
            CheckoutRepoImplementation(
                remote: r.resolve(CheckoutRemoteDataSourceImp.self)!
            )
        }

    }
}
