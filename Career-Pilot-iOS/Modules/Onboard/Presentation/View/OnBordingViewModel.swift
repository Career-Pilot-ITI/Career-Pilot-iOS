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

enum OnBordingScreenStates : Equatable{
    case idel, loading, error(String)
    
    var isError: Bool{
        switch self{
        case.error(_):
            return true
        default:
            return false
        }
    }
}

@MainActor
class OnBordingViewModel: ObservableObject {
    private var appState: AppState
    @Published var currentView: OnBordingViews = .ChooseTrackView
    @Published var screenState: OnBordingScreenStates = .loading
    @Published var navToHomeScreen: Bool = false
    @Published var emailErrorMessage: String? = nil
    
    //For ChooseTrack View
    @Published var selectedTrackInfo: SelectedTrackViewInfo = SelectedTrackViewInfo()
    
    //For UploadCV View
    @Published var cvViewInfo: CvViewInfo = CvViewInfo(isSelected: false)
    
    //For Profie View
    @Published var userData: OnBoardingUser = OnBoardingUser(email: "", title: "", experienceLevel: "", skills:[], firstName: "", lastName: "")
    
    //UseCases
    var uploadCvUseCase: UploadCvUseCase
    var getAllTracksUseCase: GetAllTrackesUseCase
    private let updateProfileUseCase: UpdateProfileUseCase

    private let saveUserUseCase: SaveUserUseCase

    init(appState: AppState, 
         uploadCvUseCase: UploadCvUseCase, 
         getAllTracksUseCase: GetAllTrackesUseCase,
         updateProfileUseCase: UpdateProfileUseCase,
         saveUserUseCase: SaveUserUseCase
         ) {
        self.appState = appState
        self.uploadCvUseCase = uploadCvUseCase
        self.getAllTracksUseCase = getAllTracksUseCase
        self.updateProfileUseCase = updateProfileUseCase
        self.saveUserUseCase = saveUserUseCase
    }
    
    //MARK: OnAppers
    func onApper(){
        getAllTracks()
    }
    
    func onTryAgin(){
        switch currentView {
        case .ChooseTrackView:
            getAllTracks()
        case .UploadCvView:
            screenState = .idel
        case .ProfileView:
            screenState = .idel
        }
    }
    
    //MARK: For Uploding CV
    func onCvResult(result: Result<URL,Error>){
        switch result{
        case.success(let cvURL):
            didSelectCV(cvURL: cvURL)
        case.failure(_):
            screenState = .error(UploadCVErrors.CanNotUploadCv.description)
        }
    }
    
    
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
        if screenState.isError{
            return false
        }
        switch currentView {
        case .ProfileView:
            return !userData.fullName.trimmingCharacters(in: .whitespaces).isEmpty &&
            !userData.email.trimmingCharacters(in: .whitespaces).isEmpty &&
            !userData.title.trimmingCharacters(in: .whitespaces).isEmpty &&
            !userData.experienceLevel.trimmingCharacters(in: .whitespaces).isEmpty
            
        case.ChooseTrackView:
            return selectedTrackInfo.selectedTrack != nil
        case .UploadCvView:
            return cvViewInfo.isSelected
        }
    }
    
    
    
    private func didSelectCV(cvURL: URL){
        //For UplodingCV View
        extractName_SizeOfTheCv(cvUrl: cvURL)
        cvViewInfo.isSelected = true
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
            onCatchError(error: error)
        }
    }
    
    private func onCatchError(error: Error){
        if let networkError = error as? NetworkError{
            screenState = .error(networkError.userMessage)
        }else if let cvError = error as? UploadCVErrors{
            screenState = .error(cvError.description)
        } else if let validationError = error as? ProfileValidationError {
            
            screenState = .error(validationError.errorDescription ?? "Please check your details")
        }
        else {
            screenState = .error(error.localizedDescription)
        }
    }
    
    func didRemoveSelectedCV(){
        userData.cv = nil
        cvViewInfo.isSelected = false
    }
    
    //MARK: For ChoseTrack
    func getAllTracks() {
        
        Task{
            do{
                screenState = .loading
                selectedTrackInfo.traks = try await getAllTracksUseCase.execute(())
                selectedTrackInfo.filteredTracks = selectedTrackInfo.traks
                screenState = .idel
            }catch{
                onCatchError(error: error)
            }
        }
    }
    
    func filterTrackes(query: String){
        
        //With empty text filed case
        if query.isEmpty{
            selectedTrackInfo.filteredTracks = selectedTrackInfo.traks
            return
        }
        
        selectedTrackInfo.filteredTracks = selectedTrackInfo.traks.filter { track in
            track.title.localizedCaseInsensitiveContains(query)
        }
    }
    
    func selectThisTrack(track: Track){
        selectedTrackInfo.selectedTrack = track
        userData.selectedTrack = track
    }
    
    
    //MARK: For Navigation
    func navToNext(){
        screenState = .idel
        switch currentView{
        case.ChooseTrackView:
            onNavToUploadCV()
        case.UploadCvView:
            onNavToProvileView()
        case.ProfileView:
            onNavToHomeScreen()
        }
    }
    
    private func onNavToUploadCV(){
        if userData.selectedTrack != nil{
            currentView = .UploadCvView
        }
    }
    
    private func onNavToProvileView(){
        guard let userCV = userData.cv else{
            //If the user skip uploading the cv
            currentView = .ProfileView
            return
        }
        
        Task{
            do{
                screenState = .loading
                try await uploadUserCv(userCV: userCV)
                currentView = .ProfileView
                screenState = .idel
                print("Now on ProfileView")
            }catch{
                onCatchError(error: error)
            }
        }
    }
    
    private func uploadUserCv(userCV: URL) async throws {
        let cvResponse = try await self.uploadCvUseCase.execute(UploadCvRequest(cv: userCV))
        let oldUserData = userData
        
        userData = cvResponse.userData
        userData.selectedTrack = oldUserData.selectedTrack
    }

    private func onNavToHomeScreen() {
        Task {
            await updateAndPersistUser()
        }
    }

    @MainActor
    private func updateAndPersistUser() async {
        screenState = .loading
        
        do {
            let user = userData.toUser()
            let updatedUser = try await updateUser(user)
            try await persistUser(updatedUser)
            
            completeOnboarding()
        } catch{
            onCatchError(error: error)
        }
    }

    private func updateUser(_ user: User) async throws -> User {
        let updatedUser = try await updateProfileUseCase.execute(user)
        print("✅ Profile updated successfully for user ID: \(updatedUser.id)")
        return updatedUser
    }

    private func persistUser(_ user: User) async throws {
        let isSaved = try await saveUserUseCase.save(user)

        if isSaved {
            print("✅ User saved to CoreData")
        }
    }

    @MainActor
    private func completeOnboarding() {
        screenState = .idel
        navToHomeScreen = true
        appState.markOnboardingSeen()
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
        onNavToProvileView()
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
