//
//  DIContainer+UseCases.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 19/07/2026.
//

import Foundation

extension DIContainer{
    func registerUseCases(){
        
        //MARK: OnBording
        
        //1) UploadCvUseCase
        container.register(UploadCvUseCase.self){r in
            UploadCvUseCase(userDataRepo: r.resolve(UserDataRepo.self)!)
        }
        //2) GetAllTrackesUseCase
        container.register(GetAllTrackesUseCase.self) {r in
            GetAllTrackesUseCase(onBordingRepo: r.resolve(OnBordingRepo.self)!)
        }

    }
}
