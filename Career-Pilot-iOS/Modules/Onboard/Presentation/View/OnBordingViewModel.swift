//
//  OnBordingViewModel.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 15/07/2026.
//

import Foundation

enum OnBordingViews: Int, Hashable, CaseIterable{
    case ChooseTrackView = 0, UploadCvView = 1, ProfileView = 2
}

enum OnBordingScreenStates{
    case idel, loading, error
}

@MainActor
class OnBordingViewModel: ObservableObject{
    @Published var currentView: OnBordingViews = .ProfileView
    @Published var screenState: OnBordingScreenStates = .idel
    @Published var buttonTitle: String = "Continue"
    @Published var navToHomeScreen: Bool = false
    @Published var userData: UserData = UserData(email: "", title: "", experienceLevel: "", skills: [], firstName: "", lastName: "")
    
    
    func navToNext(){
        switch currentView{
        case.ChooseTrackView:
            currentView = .UploadCvView
        case.UploadCvView:
            currentView = .ProfileView
        case.ProfileView:
            navToHomeScreen = true
        }
    }
    
    func backByStep(){
        switch currentView{
        case.ChooseTrackView:
            currentView = .ChooseTrackView
        case.UploadCvView:
            currentView = .ChooseTrackView
        case.ProfileView:
            currentView = .UploadCvView
        }
    }
    
    func skipAll(){
        currentView = .ProfileView
    }
    
    func isScreenIncludedToDrawAColor(index: Int) -> Bool{
        return index <= currentView.rawValue
    }
    
}
