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
                userLocalDataSource: r.resolve(UserLocalDataSourceProtocol.self)!
            )
        }
        //OnBordingRepo
        container.register(OnBordingRepo.self) { r in
            OnBordingRepoImp(remote: r.resolve(OnBordingRemoteDataSource.self)!)
        }

        // MARK: - PracticeSession
        container.register(InterviewRepository.self) { _ in
            InterviewRepositoryImp()
        }
    }
}
