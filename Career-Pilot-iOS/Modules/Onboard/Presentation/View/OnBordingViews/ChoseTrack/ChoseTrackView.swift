//
//  ChoseTrackView.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 16/07/2026.
//

import SwiftUI

struct ChoseTrackView: View {
    @StateObject var vm: OnBordingViewModel
    @State private var textFieldInput: String = ""
    
    
    var body: some View {
        VStack(spacing: 12){
            Text("Choose your Track")
                .font(.system(size: 24, weight: .bold))
            Text("We'll tailor questions and feedback for your role.")
                .font(.system(size: 14, weight: .regular))
            
            CustomSearchTextField(text: $textFieldInput,placeholder: "Search tracks…")
            
            FlowLayout {
                ForEach(vm.selectedTrackInfo.filteredTracks) { track in
                    TrackChip(
                        title: track.title,
                        isSelected: vm.selectedTrackInfo.selectedTrack?.id  == track.id
                    )
                    .onTapGesture {
                        vm.selectThisTrack(track: track)
                    }
                }
            }
            .padding()
        }
        .onChange(of: textFieldInput){ query in
            vm.filterTrackes(query: query)
        }
    }
}

struct ChoseTrackView_Previews: PreviewProvider {
    static var previews: some View {
        ChoseTrackView(vm:OnBordingViewModel(uploadCvUseCase: UploadCvUseCase(userDataRepo: UserDataRepoImp(remoteDataSource: UserDataRemoteDataSourceImp(networkService: URLSessionNetworkService())))))
    }
}
