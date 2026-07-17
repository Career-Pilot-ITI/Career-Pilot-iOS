//
//  SuccessOTPCodeView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 15/07/2026.
//

import SwiftUI

struct SuccessOTPCodeView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    
    @State private var navigationTask: Task<Void, Never>?
    
    var body: some View {
        ZStack {
            Color.darkBackGround.ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()
                SuccessOTPScreen()
                SoundWaveView()
                Spacer()
            }
            .padding(.bottom, 40)
        }
        .onAppear {
            navigationTask = Task  {
                try? await Task.sleep(for: .seconds(5))
                guard !Task.isCancelled else { return }
                coordinator.push(.onboardingScreen(vm: OnBordingViewModel(uploadCvUseCase: UploadCvUseCase(userDataRepo: UserDataRepoImp(remoteDataSource: UserDataRemoteDataSourceImp(networkService: URLSessionNetworkService()))))))
            }
        }
        .onDisappear {
                    navigationTask?.cancel()
        }
    }
}
//
//#Preview {
//    SuccessOTPCodeView()
//}
