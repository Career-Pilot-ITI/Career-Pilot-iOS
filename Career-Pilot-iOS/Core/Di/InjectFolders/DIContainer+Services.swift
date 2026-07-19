//
//  DIContainer+Services.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 19/07/2026.
//

import Foundation

extension DIContainer{
    func registerServices(){
        
        //NetworkService
        container.register(NetworkService.self){ _ in
            URLSessionNetworkService()
        }

    }
}
