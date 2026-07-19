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
            UserDataRepoImp(remoteDataSource: r.resolve(UserDataRemoteDataSource.self)!)
        }
        
        //OnBordingRepo
        container.register(OnBordingRepo.self) { r in
            OnBordingRepoImp(remote: r.resolve(OnBordingRemoteDataSource.self)!)
        }

    }
}
