//
//  DIContainer+DataSources.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 19/07/2026.
//

import Foundation

extension DIContainer{
    
    func registerDataSources(){
        
        //UserDataRemoteDataSource
        container.register(UserDataRemoteDataSource.self){r in
            UserDataRemoteDataSourceImp(networkService: r.resolve(NetworkService.self)!)
        }
    }
}
