//
//  OnBordingView.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 15/07/2026.
//

import SwiftUI

struct OnBordingView: View {
    @StateObject var vm: OnBordingViewModel = OnBordingViewModel()
    
    var body: some View {
        VStack(alignment: .center, spacing: 14){
            Text("Header")
            
            switch vm.screenState{
            case.idel:
                OnBordingIdelState(vm: vm)
            case.loading:
                ProgressView()
            case.error:
                OnBordingErrorState()
            }
            
            
            Text("Footer")
        }
    }
}

//Idal state
struct OnBordingIdelState: View{
    @ObservedObject var vm: OnBordingViewModel
    
    var body: some View{
        switch vm.currentView{
        case.ChooseTrackView:
            Text("ChoseTreack")
        case.UploadCvView:
            Text("UploadCv")
        case.ProfileView:
            Text("ProfileView")
        }
    }
}

//Error state
struct OnBordingErrorState: View{
    var body: some View{
        Text("Error state")
    }
}

//Preview
struct OnBordingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBordingView()
    }
}
