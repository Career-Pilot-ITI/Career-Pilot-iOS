//
//  OnBordingView.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 15/07/2026.
//

import SwiftUI

struct OnBordingView: View {
    @EnvironmentObject var appState: AppState
    @StateObject var vm: OnBordingViewModel = DIContainer.shared.container.resolve(OnBordingViewModel.self)!

    var body: some View {
         ZStack {
            Color.gray100
                    .ignoresSafeArea()
            VStack(alignment: .center, spacing: 14) {
                
                if vm.currentView != .ProfileView {
                    OnBordingTopPart(vm: vm)
                }
                
                Spacer()
                // Onboarding Content
                switch vm.screenState {
                case .idel:
                    OnBordingIdelState(vm: vm)
                    
                case .loading:
                    ProgressView()
                    
                case .error(let error):
                    OnBoardingErrorState(vm: vm, errorMessage: error.description)
                }
                
                Spacer()
                
                // Bottom Part
                CustomButton(
                    isButtonEnabeld: vm.isButtonEnabeld,
                    buttonTitle: vm.buttonTitle
                ) {
                    vm.navToNext()
                }
            }
            .ignoresSafeArea(.keyboard)
            .toolbar(.hidden, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $vm.navToHomeScreen) {
                MainTabBarView()
            }
            .task {
                vm.onApper()
            }
        }
    }
}

private struct OnBordingTopPart: View {
    @ObservedObject var vm: OnBordingViewModel

    var body: some View {
        HStack(spacing: 8) {

            VStack {
                if vm.currentView.rawValue != 0 {
                    BackButton(text: "Back")
                        .onTapGesture {
                            vm.backByStep()
                        }
                }

                drawDotts
            }

            Spacer()

            Text("\(vm.currentView.rawValue + 1) of \(OnBordingViews.allCases.count)")
                .foregroundColor(.gray400)
        }
        .padding()
    }

    private var drawDotts: some View {
        HStack(spacing: 4) {
            ForEach(0..<OnBordingViews.allCases.count, id: \.self) { index in
                RoundedRectangle(cornerRadius: 25)
                    .frame(
                        width: vm.isScreenIncludedToDrawAColor(index: index) ? 25 : 10,
                        height: 10
                    )
                    .foregroundColor(
                        vm.isScreenIncludedToDrawAColor(index: index)
                        ? .activeColour
                        : .gray400.opacity(0.5)
                    )
            }
        }
    }
}

struct BackButton: View {
    let text: String
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "arrow.left")
            Text(text)
        }
    }
}

struct OnBordingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBordingView()
    }
}
