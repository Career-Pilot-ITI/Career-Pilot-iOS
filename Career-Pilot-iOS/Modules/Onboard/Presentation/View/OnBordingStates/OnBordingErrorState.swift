//
//  OnBordingErrorState.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 16/07/2026.
//

import SwiftUI

struct OnBoardingErrorState: View {

    @ObservedObject var vm: OnBordingViewModel
    let errorMessage: String

    var body: some View {
        VStack(spacing: 24) {

            Spacer()

            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 60))
                .foregroundStyle(.red)

            VStack(spacing: 8) {
                Text("Something went wrong")
                    .font(.title2)
                    .fontWeight(.bold)

                Text(errorMessage)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            CustomButton(isButtonEnabeld: true,buttonTitle: "Try Again"){
                vm.screenState = .idel
            }

            Spacer()
        }
        .padding()
    }
}

struct OnBordingErrorState_Previews: PreviewProvider {
    static var previews: some View {
        
        OnBoardingErrorState(vm: OnBordingViewModel(uploadCvUseCase: UploadCvUseCase(userDataRepo: UserDataRepoImp(remoteDataSource: UserDataRemoteDataSourceImp(networkService: URLSessionNetworkService())))), errorMessage: "It is an error")
    }
}
