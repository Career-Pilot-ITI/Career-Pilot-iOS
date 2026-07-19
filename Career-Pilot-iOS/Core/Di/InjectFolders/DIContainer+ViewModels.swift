//
//  DIContainer+ViewModels.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 19/07/2026.
//

import Foundation

@MainActor
extension DIContainer{
    func registerViewModels(){
        
        //OnBordingViewModel
        container.register(OnBordingViewModel.self){r in
            OnBordingViewModel(uploadCvUseCase: r.resolve(UploadCvUseCase.self)!)
        }
        
    }
}
