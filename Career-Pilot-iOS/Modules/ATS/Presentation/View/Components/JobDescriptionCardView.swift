//
//  JobDescriptionCardView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 12/08/2026.
//

import SwiftUI

struct JobDescriptionCardView: View {
    let job: JobDescriptionModel
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Description")
                .font(Font.size15Bold)
                .foregroundStyle(Color.textPrimary)
            Text(job.description)
                .font(Font.size14Regular)
                .foregroundStyle(Color.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.gray400.opacity(0.08))
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
    JobDescriptionCardView(job: JobDescriptionModel.mock)
}
