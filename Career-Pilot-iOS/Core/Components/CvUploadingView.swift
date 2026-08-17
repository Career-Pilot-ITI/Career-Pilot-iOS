//
//  CvUploadingView.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 15/07/2026.
//

import SwiftUI

struct CvUploadingView: View {
    //Properties
    var didUpload: Bool
    var baseSentance: String
    var subSentanceOne: String
    
    
    var body: some View {
        VStack(alignment: .center,spacing: 12){
            // Icon
            if didUpload{
                Image("done_icon")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .padding(.bottom, 10)
            }else{
                Image("download_icon")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .padding(.bottom, 20)
            }
            
            //BaseSentance
            Text(baseSentance)
                .font(.system(size: 16,weight: .bold))
            
            Text(subSentanceOne)
                .foregroundColor(.gray400)
                .font(.system(size: 13,weight: .medium))
        }
        .frame(width: 300, height: 200)
        .overlay{
            RoundedRectangle(cornerRadius: 25,style: .continuous)
                .stroke(
                    didUpload ? .activeColour : Color.gray400,
                    style: StrokeStyle(
                        lineWidth: 2,
                        lineCap: .butt,
                        dash: [2]
                    )
                )
        }
    }
}

struct CvUploadingView_Previews: PreviewProvider {
    static var previews: some View {
        CvUploadingView(didUpload: false, baseSentance: "Tap to upload your CV", subSentanceOne: "PDF or DOC · Max 10 MB")
    }
}
