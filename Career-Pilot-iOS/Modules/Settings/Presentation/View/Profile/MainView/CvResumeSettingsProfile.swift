//
//  CvResumeSettingsProfile.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 17/07/2026.
//

import SwiftUI

struct CvResumeSettingsProfile: View {
    var cv: String
    let onCVPicked: (URL) -> Void
    
    @State private var showUploadSheet = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            if cv.isEmpty {
                Button(action: { showUploadSheet = true }) {
                    HStack {
                        Image("download_icon")
                        Text("\(cv)")
                            .font(.size12Bold)
                    }
                    .padding(.horizontal, Spacing.s16)
                    .padding(.vertical, Spacing.s16)
                    .foregroundStyle(Color.primaryNavy)
                }
                .frame(maxWidth: .infinity)
                .background(
                    Color.primaryNavy.opacity(0.06),
                    in: RoundedRectangle(cornerRadius: Radius.r16)
                )
                
            } else {
                HStack {
                    customIcon(icon: "paper", color: nil)
                    VStack(alignment: .leading) {
                        Text("resume file name").font(.size12Bold).foregroundColor(.primaryNavy)
                        Text("Uploaded data & time & size").font(.size14Regular).foregroundColor(.gray400)
                    }
                    Spacer()
                    customIcon(icon: "done_icon", color: .successColour)
                }
                
                Button(action: { showUploadSheet = true }) {
                    HStack {
                        Image("download_icon")
                        Text("Re-uploadCV")
                            .font(.size12Bold)
                    }
                    .padding(.horizontal, Spacing.s16)
                    .padding(.vertical, Spacing.s16)
                    .foregroundStyle(Color.primaryNavy)
                }
                .frame(maxWidth: .infinity)
                .background(
                    Color.primaryNavy.opacity(0.06),
                    in: RoundedRectangle(cornerRadius: Radius.r16)
                )
                
                Text("Re-uploading your CV will refresh your detected skills and recommended track")
                    .font(.size12Medium)
                    .foregroundColor(.gray400)
            }
        }
        .padding(.vertical, Spacing.s20)
        .padding(.horizontal, Spacing.s20)
        .background(Color.white, in: RoundedRectangle(cornerRadius: Radius.r16))
        .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
        .sheet(isPresented: $showUploadSheet) {
            CvUploadSheet(onCVPicked: { url in
                onCVPicked(url)
                showUploadSheet = false
            })
        }
    }
    
    @ViewBuilder
    private func customIcon(icon: String, color: Color?) -> some View {
        let resolvedColor = color ?? .activeColour
        
        Image(icon)
            .resizable()
            .renderingMode(.template)
            .padding([.vertical, .horizontal], 11)
            .frame(width: 40, height: 40)
            .foregroundColor(resolvedColor)
            .background(
                RoundedRectangle(cornerRadius: Radius.r16)
                    .fill(resolvedColor.opacity(0.1))
            )
    }
}
