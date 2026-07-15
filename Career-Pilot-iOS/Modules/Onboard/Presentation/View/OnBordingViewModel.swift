//
//  OnBordingViewModel.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 15/07/2026.
//

import Foundation

enum OnBordingViews: Hashable{
    case ChooseTrackView, UploadCvView, ProfileView
}

enum OnBordingScreenStates{
    case idel, loading, error
}

@MainActor
class OnBordingViewModel: ObservableObject{
    @Published var currentView: OnBordingViews = .ChooseTrackView
    @Published var screenState: OnBordingScreenStates = .idel
    
    
    
}
