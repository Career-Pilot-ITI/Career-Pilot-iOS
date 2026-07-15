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
            
            //Top Part
            topView
            
            //OnBording Content
            switch vm.screenState{
            case.idel:
                OnBordingIdelState(vm: vm)
            case.loading:
                ProgressView()
            case.error:
                OnBordingErrorState()
            }
            
            Spacer()
            
            //Bottom Part
            CustomButton(buttonTitle: vm.buttonTitle){
                //VM . next
            }
        }
    }
    
    private var topView: some View{
        HStack(spacing: 8){
            VStack{
                BackButton()
                drawDotts
            }
            
            Spacer()
            
            Text("\(vm.currentView.rawValue + 1) of \(OnBordingViews.allCases.count)")
                .foregroundColor(.gray400)
        }
        .padding()
    }
    
    private var drawDotts: some View{
        HStack(spacing: 4){
            ForEach(0..<OnBordingViews.allCases.count, id: \.self){ index in
                RoundedRectangle(cornerRadius: 25)
                    .frame(width: vm.isScreenIncludedToDrawAColor(index: index) ? 25 : 10 ,
                           height: 10)
                    .foregroundColor(vm.isScreenIncludedToDrawAColor(index: index) ? .activeColour : .gray400.opacity(0.5))
                
            }
        }
    }
}

struct BackButton: View{
    var body: some View{
        HStack(spacing: 8){
            Image(systemName: "arrow.left")
            Text("Back")
        }
    }
}

//Idal state
struct OnBordingIdelState: View{
    @ObservedObject var vm: OnBordingViewModel
    
    var body: some View{
        ScrollView{
            switch vm.currentView{
            case.ChooseTrackView:
                Text("ChoseTreack")
            case.UploadCvView:
                Text("UploadCv")
            case.ProfileView:
                profile(userData: vm.userData)
            }
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
