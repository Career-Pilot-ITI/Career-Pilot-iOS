//
//  UploadCvView.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 15/07/2026.
//

import SwiftUI

struct UploadCvView: View {
    @StateObject var vm: OnBordingViewModel
    
    var body: some View {
        VStack(spacing: 35){
            topView
            
            CvUploadingView(didUpload: vm.cvViewInfo.isUploaded,
                            baseSentance: vm.cvViewInfo.isUploaded ? "\(vm.cvViewInfo.cvTitle)" : "Tap to upload your CV",
                            subSentanceOne: vm.cvViewInfo.isUploaded ? "Size: \(vm.cvViewInfo.cvSize)" : "PDF or DOC · Max 10 MB")
            .onTapGesture {
                vm.uploadCV()
            }
            .padding(.bottom, 30)
            
            if !vm.cvViewInfo.isUploaded{
                Text("Skip for now →")
                    .font(.bodySmall)
                    .foregroundColor(.gray400)
                    .onTapGesture {
                        vm.skipAll()
                    }                
            }
            
            Spacer()
        }
    }
    
    private var topView: some View{
        VStack(alignment: .leading,spacing: 4){
            Text("Upload your CV")
                .font(.system(size: 24,weight: .bold))
            Text("We'll extract your experience so questions feel personal.")
                .foregroundColor(.gray600)
        }
    }
}

struct UploadCvView_Previews: PreviewProvider {
    static var previews: some View {
        UploadCvView(vm: OnBordingViewModel())
    }
}
