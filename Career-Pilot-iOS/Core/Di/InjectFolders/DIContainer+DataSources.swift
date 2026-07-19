//
//  DIContainer+DataSources.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 19/07/2026.
//

import Foundation

extension DIContainer{
    
    func registerDataSources(){
        
        //UserData
        container.register(UserDataRemoteDataSource.self){r in
            UserDataRemoteDataSourceImp(networkService: r.resolve(NetworkService.self)!)
        }
        
        //OnBording
        container.register(OnBordingRemoteDataSource.self) { r in
            OnBordingRemoteDataSourceImp(apiService: r.resolve(NetworkService.self)!)
        }
    }
}
