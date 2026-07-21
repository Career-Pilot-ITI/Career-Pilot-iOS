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
    @Published var currentView: OnBordingViews = .ChooseTrackView
    @Published var screenState: OnBordingScreenStates = .idel
    @Published var navToHomeScreen: Bool = false
    
    //For ChooseTrack View
    @Published var selectedTrackInfo: SelectedTrackViewInfo = SelectedTrackViewInfo()
    
    //For UploadCV View
    @Published var cvViewInfo: CvViewInfo = CvViewInfo(isSelected: false)
    
    //For Profie View
    @Published var userData: UserData = UserData(email: "", title: "", experienceLevel: "", skills: ["C++"], firstName: "", lastName: "")
    
    //UseCases
    var uploadCvUseCase: UploadCvUseCase
    var getAllTracksUseCase: GetAllTrackesUseCase
    private let updateProfileUseCase: UpdateProfileUseCase
    
    init(uploadCvUseCase: UploadCvUseCase,
         getAllTracksUseCase: GetAllTrackesUseCase,
         updateProfileUseCase: UpdateProfileUseCase) {
        
        self.uploadCvUseCase = uploadCvUseCase
        self.getAllTracksUseCase = getAllTracksUseCase
        self.updateProfileUseCase = updateProfileUseCase
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
        }catch let cvError as UploadCVErrors{
            screenState = .error(cvError.description)
        }catch{
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
                screenState = .idel
            }catch{
                screenState = .idel
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
            currentView = .UploadCvView
        case.UploadCvView:
            onNavToProvileView()
        case.ProfileView:
            onNavToHomeScreen()
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
                try await uploadUserCv(userCV: userCV)
                currentView = .ProfileView
                
            }catch let cvError as UploadCVErrors{
                screenState = .error(cvError.description)
            }catch{
                print(error.localizedDescription)
                screenState = .error(error.localizedDescription)
            }
        }
    }
    
    private func uploadUserCv(userCV: URL) async throws {
        let cvResponse = try await self.uploadCvUseCase.execute(UploadCvRequest(cv: userCV))
        userData = cvResponse.userData
        print(cvResponse.userData)
    }
    
//    private func onNavToHomeScreen() {
//        print("start update")
//        Task {
//            do {
//                screenState = .loading
//                
//                let currentUser = User(
//                    id: 0,
//                    phoneNumber: "",
//                    profile: userData.toUserProfile(),
//                    isNewUser: false
//                )
//                
//                let updatedUser = try await updateProfileUseCase.execute(currentUser)
//                
//                print("✅ Profile updated successfully for user ID: \(updatedUser.id)")
//                
//                screenState = .idel
//                navToHomeScreen = true
//                
//            } catch let error as NetworkError {
//                screenState = .error(error.errorDescription ?? error.localizedDescription)
//            } catch {
//                screenState = .error(error.localizedDescription)
//            }
//        }
//    }
  
    private func onNavToHomeScreen() {
        print("🚀 === START UPDATE PROFILE DEBUG ===")
        
        Task {
            do {
                screenState = .loading
                
                let currentUser = User(
                    id: 0,
                    phoneNumber: "",
                    profile: userData.toUserProfile(),
                    isNewUser: false
                )
                
                // 1. فحص الـ DTO والـ JSON المرسل
                let userDTO = currentUser.toDTO()
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                let jsonData = try encoder.encode(userDTO)
                
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print("🟢 1. Outgoing JSON Body:\n\(jsonString)")
                }
                
                // 2. تنفيذ الطلب
                print("🟡 2. Sending PATCH request to server...")
                let updatedUser = try await updateProfileUseCase.execute(currentUser)
                
                print("✅ 3. Success! Updated user ID: \(updatedUser.id)")
                screenState = .idel
                navToHomeScreen = true
                
            } catch let networkError as NetworkError {
                print("🔴 NETWORK ERROR: \(networkError)")
                print("🔴 Description: \(networkError.errorDescription ?? "No description")")
                screenState = .error(networkError.errorDescription ?? "Network Error")
                
            } catch let decodingError as DecodingError {
                print("🔴 DECODING ERROR (مشكلة في مطابقة الـ JSON القادم مع الـ Models): \(decodingError)")
                switch decodingError {
                case .typeMismatch(let type, let context):
                    print("Type '\(type)' mismatch: \(context.debugDescription), codingPath: \(context.codingPath)")
                case .valueNotFound(let type, let context):
                    print("Value '\(type)' not found: \(context.debugDescription), codingPath: \(context.codingPath)")
                case .keyNotFound(let key, let context):
                    print("Key '\(key)' not found: \(context.debugDescription), codingPath: \(context.codingPath)")
                case .dataCorrupted(let context):
                    print("Data corrupted: \(context.debugDescription), codingPath: \(context.codingPath)")
                @unknown default:
                    print("Unknown decoding error")
                }
                screenState = .error("Data format error")
                
            } catch {
                print("🔴 UNKNOWN ERROR: \(error)")
                print("🔴 Localized Description: \(error.localizedDescription)")
                screenState = .error(error.localizedDescription)
            }
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
