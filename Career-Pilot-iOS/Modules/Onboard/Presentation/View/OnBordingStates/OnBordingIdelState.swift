//
//  OnBordingIdelState.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 17/07/2026.
//

import SwiftUI


struct OnBordingIdelState: View{
    @ObservedObject var vm: OnBordingViewModel
    
    var body: some View{
        ScrollView{
            switch vm.currentView{
            case.ChooseTrackView:
                ChoseTrackView(vm: vm)
            case.UploadCvView:
                UploadCvView(vm: vm)
            case.ProfileView:
                profile(userData: $vm.userData)
            }
        }
        .padding(.bottom, 20)
    }
}

struct OnBordingIdelState_Previews: PreviewProvider {
    static var previews: some View {
        OnBordingIdelState(vm: OnBordingViewModel())
    }
}
