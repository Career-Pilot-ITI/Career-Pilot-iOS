//
//  ChoseTrackView.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 16/07/2026.
//

import SwiftUI

struct ChooseTrackView: View {
    @ObservedObject var vm: OnBordingViewModel
    @State private var textFieldInput: String = ""
    
    
    var body: some View {
        VStack {
            Spacer()

            VStack(alignment: .leading, spacing: 12) {
                Text("Choose your Track")
                    .font(.system(size: 24, weight: .bold))

                Text("We'll tailor questions and feedback for your role.")
                    .font(.system(size: 14, weight: .regular))

                CustomSearchTextField(
                    text: $textFieldInput,
                    placeholder: "Search tracks…"
                )

                if vm.selectedTrackInfo.traks.isEmpty {
                    VStack(alignment: .center, spacing: 16) {
                        Text("No tracks available")
                            .font(.headline)

                        Text("We couldn't load any tracks right now.")
                            .font(.size13Medium)
                            .foregroundColor(.gray400)
                            .multilineTextAlignment(.center)

                        Button("Try Again") {
                            vm.getAllTracks()
                        }
                        .foregroundColor(.primary)


                        Button("Skip for now →") {
                            vm.navToNext()
                        }
                        .foregroundColor(.gray400)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                }

                FlowLayout {
                    ForEach(vm.selectedTrackInfo.filteredTracks) { track in
                        TrackChip(
                            title: track.title,
                            isSelected: vm.selectedTrackInfo.selectedTrack?.id == track.id
                        )
                        .onTapGesture {
                            vm.selectThisTrack(track: track)
                        }
                    }
                }
                .padding()
            }
            .padding(.horizontal, Spacing.s12)

            Spacer()
        }
        .onChange(of: textFieldInput) { query in
            vm.filterTrackes(query: query)
        }
    }
}

//struct ChoseTrackView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChoseTrackView(vm:OnBordingViewModel(uploadCvUseCase: UploadCvUseCase(userDataRepo: UserDataRepoImp(remoteDataSource: UserDataRemoteDataSourceImp(networkService: URLSessionNetworkService())))))
//    }
//}
