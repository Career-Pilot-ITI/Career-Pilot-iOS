//
//  DIContainer+DataSources.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 19/07/2026.
//

import Foundation

extension DIContainer{
    
    func registerDataSources(){
        
        //AuthRemoteDataSource
        container.register(AuthRemoteDataSourceProtocol.self) { r in
            AuthRemoteDataSource()
        }
        // Local Data Source — uses shared CoreDataManager
        container.register(UserLocalDataSource.self) { r in
            UserLocalDataSourceImpl(
                coreData: r.resolve(CoreDataManager.self)!
            )
        }.inObjectScope(.container)
        
        container.register(UserLocalDataSource.self) { r in
            UserLocalDataSourceImpl(
                coreData: r.resolve(CoreDataManager.self)!
            )
        }
        
        //UserData
        container.register(UserDataRemoteDataSource.self) { r in
            UserDataRemoteDataSourceImp(networkService: r.resolve(NetworkService.self, name: "authenticated")!)
        }
        
        //OnBording
        container.register(OnBordingRemoteDataSource.self) { r in
            OnBordingRemoteDataSourceImp(
                apiService: r.resolve(NetworkService.self, name: "authenticated")!
            )
        }
        
        //MARK: PracticSession
        container.register(InterviewSessionRemoteDataSource.self) { r in
            InterviewSessionRemoteDataSourceImp(apiService: r.resolve(NetworkService.self, name: "authenticated")!)
        }
        
        container.register(ReportsRemoteDataSourceProtocol.self) { r in
            ReportsRemoteDataSource(network: r.resolve(NetworkService.self, name: "authenticated")!)
        }
        container.register(ReportsLocalDataProtocol.self) { r in
            ReportsLocalDataSource(coreDataManager: r.resolve(CoreDataManaging.self)!)
        }
    }
}
