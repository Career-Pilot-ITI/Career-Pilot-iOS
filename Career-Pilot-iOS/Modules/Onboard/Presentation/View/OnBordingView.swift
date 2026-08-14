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
            Color.background
                    .ignoresSafeArea()
            VStack(alignment: .center, spacing: 14) {
                
                
                OnBordingTopPart(vm: vm)
                
                Spacer()
                // Onboarding Content
                switch vm.screenState {
                case .idel:
                    OnBordingIdelState(vm: vm)
                    
                case .loading:
                    OnboardingLoadingView(vm: vm)
                    
                case .error(let errorMessage) :
                    OnBoardingErrorState(vm: vm, errorMessage: errorMessage)
            
                }
           
                
                Spacer()
                
                // Bottom Part
                if vm.screenState == .idel{
                    CustomButton(
                        isButtonEnabeld: vm.isButtonEnabeld,
                        buttonTitle: vm.buttonTitle
                    ) {
                        
                        vm.navToNext()
                    }
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
private struct OnboardingLoadingView: View {
    @ObservedObject var vm: OnBordingViewModel

    var body: some View {
        VStack(spacing: 24) {
            ProgressView()
                .controlSize(.large)
                .tint(.accentColor)

            VStack(spacing: 8) {
                Text("Setting Things Up")
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(vm.currentView.screenDescription)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(32)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
        )
        .padding(.horizontal, 24)
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
                        ? .primary
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

#Preview {
    OnBordingView()
        .environmentObject(AppState())
}
