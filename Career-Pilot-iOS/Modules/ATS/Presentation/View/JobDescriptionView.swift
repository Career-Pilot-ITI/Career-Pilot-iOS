import SwiftUI

struct JobDescriptionView: View {
    @EnvironmentObject var coordinator: AppCoordinator<HomeRoute>
    let job: JobDescriptionModel

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.lightBackGround.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 16) {
                    JobHeaderCard(job: job) {
                        // open link
                    }
                    OverViewCardView(job: job)
                    JobDescriptionCardView(job:job)
                    JobRequirementsCardView(job: job)
                    
                }
                .padding(16)
                .padding(.bottom, 90) // room for the sticky button
            }
            .scrollIndicators(.hidden)
            
            startScoringButton
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Text("Job Description"))
    }

    // MARK: Sticky button

    private var startScoringButton: some View {
        Button(action:  {
            coordinator.push(.atsJobmatchScore)
        }) {
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
}

// MARK: - Preview

#Preview {
    NavigationStack {
        JobDescriptionView(job: .mock)
    }
}
