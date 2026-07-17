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
    case idel, loading, error(UploadCVErrors)
}

@MainActor
class OnBordingViewModel: ObservableObject {
    @Published var currentView: OnBordingViews = .ChooseTrackView
    @Published var screenState: OnBordingScreenStates = .idel
    @Published var navToHomeScreen: Bool = false
    
    //For ChooseTrack View
    @Published var selectedTrackInfo: SelectedTrackViewInfo = SelectedTrackViewInfo()
    
    //For UploadCV View
    @Published var cvViewInfo: CvViewInfo = CvViewInfo(isUploaded: false)
    
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
            
        case.ChooseTrackView:
            return selectedTrackInfo.selectedTrack != nil
        case .UploadCvView:
            return cvViewInfo.isUploaded
        }
    }
    
    //MARK: For Uploding CV
    func onCvResult(result: Result<URL,Error>){
        switch result{
        case.success(let cvURL):
            didSelectCV(cvURL: cvURL)
        case.failure(let error):
            screenState = .error(error as! UploadCVErrors)
        }
    }
    
    private func didSelectCV(cvURL: URL){
        //For UplodingCV View
        extractName_SizeOfTheCv(cvUrl: cvURL)
        cvViewInfo.isUploaded = true
        //UserData
        userData.cv = cvURL
    }
    
    private func extractName_SizeOfTheCv(cvUrl: URL){
        do{
            let values = try cvUrl.resourceValues(forKeys: [.nameKey, .fileSizeKey])
            
            cvViewInfo.cvTitle = values.name
            let fileSizeInBytes = Double(values.fileSize ?? 0)
            let fileSizeInMB = fileSizeInBytes / (1024 * 1024)
            cvViewInfo.cvSize = fileSizeInMB
        }catch{
            screenState = .error(error as! UploadCVErrors)
        }
    }
    
    //MARK: For ChoseTrack
    func filterTrackes(query: String){
        
        //With empty text filed case
        if query.isEmpty{
            selectedTrackInfo.filteredTracks = tracks
            return
        }
        
        selectedTrackInfo.filteredTracks = tracks.filter { track in
            track.title.localizedCaseInsensitiveContains(query)
        }
    }
    
    func selectThisTrack(track: Track){
        selectedTrackInfo.selectedTrack = track
        userData.selectedTrack = track
    }
    
    
    //MARK: For Navigation
    func navToNext(){
        switch currentView{
        case.ChooseTrackView:
            currentView = .UploadCvView
        case.UploadCvView:
            currentView = .ProfileView
        case.ProfileView:
            onNavToHomeScreen()
        }
    }
    
    private func onNavToHomeScreen(){
        navToHomeScreen = true
        print(userData)
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
    
    //MARK: For Marking the dots with the correct color
    func isScreenIncludedToDrawAColor(index: Int) -> Bool{
        return index <= currentView.rawValue
    }
}


extension OnBordingViewModel: Hashable {
    nonisolated static func == (lhs: OnBordingViewModel, rhs: OnBordingViewModel) -> Bool {
        lhs === rhs
    }
    
    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
