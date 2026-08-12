//
//  JobHeaderCard.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 09/08/2026.

import SwiftUI

struct JobHeaderCard: View {
    let job: JobDescriptionModel
    var onOpenLink: (() -> Void)? = nil

    
    var body: some View {
        HStack(alignment: .center, spacing: Spacing.s12) {
            ZStack {
                RoundedRectangle(cornerRadius: Radius.r12)
                    .fill(Color.red)
                    .frame(width: 48, height: 48)
                Text(job.companyInitial)
                    .font(Font.size20Bold)
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: Spacing.s4) {
                Text(job.title)
                    .font(Font.size16Bold)
                Text("\(job.company) · \(job.location) · \(job.workMode)")
                    .font(Font.size14Regular)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "arrow.up.forward.square")
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: Radius.r16))
        .overlay {
            RoundedRectangle(cornerRadius: Radius.r16, style: .continuous)
                .stroke(Color.black.opacity(0.06), lineWidth: 1)
        }
        .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 4)
        .shadow(color: Color.black.opacity(0.03), radius: 2, x: 0, y: 1)
        
    }
}

#Preview {
    JobHeaderCard(job: JobDescriptionModel.mock, onOpenLink: {
        //
    })
        .padding()
}
