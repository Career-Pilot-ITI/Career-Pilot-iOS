//
//  UploadCvView.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 15/07/2026.
//

import SwiftUI
import UniformTypeIdentifiers

struct UploadCvView: View {
    @ObservedObject var vm: OnBordingViewModel
    @State var isImporterPresented: Bool = false
    
    //A custom type for .docx
    var docxType = UTType(filenameExtension: "docx")!
    
    var body: some View {
        VStack(spacing: 35){
            topView
            
            CvUploadingView(didUpload: vm.cvViewInfo.isSelected,
                            baseSentance: vm.cvViewInfo.isSelected ? "\(vm.cvViewInfo.cvTitle ?? "No Name For The Cv")" : "Tap to upload your CV",
                            subSentanceOne: vm.cvViewInfo.isSelected ? "Size: \(String(format: "%.2f MB",vm.cvViewInfo.cvSize ?? 0.0))" : "PDF or DOC · Max 10 MB")
            .onTapGesture {
                isImporterPresented = true
            }
            .padding(.bottom, 30)
            
            if !vm.cvViewInfo.isSelected{
                Text("Skip for now →")
                    .font(.size13Medium)
                    .foregroundColor(.gray400)
                    .onTapGesture {
                        vm.skipAll()  
                    }                
            }else{
                Text("Remove Selected CV")
                    .font(.size13Medium)
                    .foregroundColor(.gray400)
                    .onTapGesture {
                        vm.didRemoveSelectedCV()
                    }
            }
            
            Spacer()
        }
        .fileImporter(isPresented: $isImporterPresented, allowedContentTypes: [.pdf,docxType]){ result in
            vm.onCvResult(result: result)
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


