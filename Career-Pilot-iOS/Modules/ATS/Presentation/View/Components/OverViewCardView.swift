//
//  OverViewCardView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 12/08/2026.
//

import SwiftUI

struct OverViewCardView: View {
    let job: JobDescriptionModel
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.s12) {
            Text("Job Overview")
                .font(Font.size15Bold)

            HStack(spacing: 12) {
                OverViewItem(icon: "briefcase.fill", label: "EMPLOYMENT TYPE", value: job.employmentType)
                OverViewItem(icon: "graduationcap.fill", label: "EXPERIENCE LEVEL", value: job.experienceLevel)
            }
            HStack() {
                OverViewItem(icon: "clock.fill", label: "POSTED", value: job.postedText)
                OverViewItem(icon: "person.fill", label: "APPLIED", value: job.appliedText)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
    OverViewCardView(job: JobDescriptionModel.mock)
}
