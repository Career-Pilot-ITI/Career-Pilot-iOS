//
//  DIContainer+UseCases.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 19/07/2026.
//

import Foundation

extension DIContainer{
    func registerUseCases(){
        
        //UploadCvUseCase
        container.register(UploadCvUseCase.self){r in
            UploadCvUseCase(userDataRepo: r.resolve(UserDataRepo.self)!)
        }

    }
}
