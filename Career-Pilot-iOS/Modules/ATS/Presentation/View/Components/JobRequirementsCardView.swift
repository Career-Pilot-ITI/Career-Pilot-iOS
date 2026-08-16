//
//  RequirementsCardView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 12/08/2026.
//

import SwiftUI

struct JobRequirementsCardView: View {
    let job: JobDescriptionModel
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Requirements")
                .font(.subheadline.bold())

            skillSection(title: "SKILLS (\(job.skillsCount))", items: job.skills, color: .green)
            skillSection(title: "PREFERRED SKILLS (\(job.preferredSkillsCount))", items: job.preferredSkills, color: .orange)
            skillSection(title: "TECHNOLOGIES (\(job.technologiesCount))", items: job.technologies, color: .green)
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
    
    private func skillSection(title: String, items: [String], color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
            WrapChips(items: items, color: color)
        }
    }
}

//
//#Preview {
//    JobRequirementsCardView(job:JobDescriptionModel.mock)
//}
