import SwiftUI

// MARK: - Root View

struct JobDescriptionView: View {
    let job: JobDescriptionModel
    var onBack: () -> Void = {}
    var onStartScoring: () -> Void = {}

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {
                    headerCard
                    overviewCard
                    descriptionCard
                    requirementsCard
                    
                }
                .padding(16)
                .padding(.bottom, 90) // room for the sticky button
            }
            .scrollIndicators(.hidden)

            startScoringButton
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            navBar
        }
        .navigationBarHidden(true)
    }

    // MARK: Nav bar

    private var navBar: some View {
        HStack {
            Button(action: onBack) {
                HStack(spacing: 6) {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
                .foregroundStyle(.primary)
            }
            Spacer()
            Text("Job Description")
                .font(.headline)
            Spacer()
            // symmetry spacer to keep title centered
            HStack(spacing: 6) {
                Image(systemName: "chevron.left").opacity(0)
                Text("Back").opacity(0)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemGroupedBackground))
    }

    // MARK: Header card

    private var headerCard: some View {
        HStack(alignment: .center, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.red)
                    .frame(width: 48, height: 48)
                Text(job.companyInitial)
                    .font(.title2.bold())
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(job.title)
                    .font(.headline)
                Text("\(job.company) · \(job.location) · \(job.workMode)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "arrow.up.forward.square")
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .background(cardBackground)
    }

    // MARK: Overview card

    private var overviewCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Job Overview")
                .font(.subheadline.bold())

            HStack(alignment: .top, spacing: 12) {
                overviewItem(icon: "briefcase.fill", label: "EMPLOYMENT TYPE", value: job.employmentType)
                overviewItem(icon: "graduationcap.fill", label: "EXPERIENCE LEVEL", value: job.experienceLevel)
            }
            HStack(alignment: .top, spacing: 12) {
                overviewItem(icon: "clock.fill", label: "POSTED", value: job.postedText)
                overviewItem(icon: "person.fill", label: "APPLIED", value: job.appliedText)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(cardBackground)
    }

    private func overviewItem(icon: String, label: String, value: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(.secondary)
                .frame(width: 18)

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.subheadline.weight(.semibold))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: Description card

    private var descriptionCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Description")
                .font(.subheadline.bold())
            Text(job.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(cardBackground)
    }

    // MARK: Requirements card

    private var requirementsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Requirements")
                .font(.subheadline.bold())

            skillSection(title: "SKILLS (\(job.skillsCount))", items: job.skills, color: .green)
            skillSection(title: "PREFERRED SKILLS (\(job.preferredSkillsCount))", items: job.preferredSkills, color: .orange)
            skillSection(title: "TECHNOLOGIES (\(job.technologiesCount))", items: job.technologies, color: .green)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(cardBackground)
    }

    private func skillSection(title: String, items: [String], color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
            WrapChips(items: items, color: color)
        }
    }

    // MARK: Sticky button

    private var startScoringButton: some View {
        Button(action: onStartScoring) {
            Text("Start Scoring")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.orange)
                )
        }
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color(.secondarySystemGroupedBackground))
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        JobDescriptionView(job: .mock)
    }
}
