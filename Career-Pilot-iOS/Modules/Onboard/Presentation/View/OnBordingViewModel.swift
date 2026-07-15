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
    @Published var currentView: OnBordingViews = .ChooseTrackView
    @Published var screenState: OnBordingScreenStates = .idel
    @Published var navToHomeScreen: Bool = false
    
    //For UploadCV View
    @Published var isUploaded: Bool = false
    @Published var cvTitle: String = "Cv Name"
    @Published var cvSize: Double = 0.0
    
    //For Profie View
    @Published var userData: UserData = UserData(email: "", title: "", experienceLevel: "", skills: ["C++"], firstName: "", lastName: "")
    
    //For Bottom Button
    var buttonTitle: String {
        switch currentView{
        case.ProfileView:
            return "Start Practising"
        default:
            return "Continue"
        }
    }
    var isButtonEnabeld: Bool {
        switch currentView {
        case .ProfileView:
            return !userData.fullName.trimmingCharacters(in: .whitespaces).isEmpty &&
                   !userData.email.trimmingCharacters(in: .whitespaces).isEmpty &&
                   !userData.title.trimmingCharacters(in: .whitespaces).isEmpty &&
                   !userData.experienceLevel.trimmingCharacters(in: .whitespaces).isEmpty

        case .UploadCvView, .ChooseTrackView:
            return true
        }
    }
    
    //MARK: For Uploding CV
    func uploadCV(){
        print("Uploading cv")
        screenState = .loading
        Task{
            try? await Task.sleep(for:.nanoseconds(2000000000))
            screenState = .idel
        }
    }
    

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
