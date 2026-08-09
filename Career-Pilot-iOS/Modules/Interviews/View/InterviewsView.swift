//
//  InterviewsView.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 09/08/2026.
//

import SwiftUI

struct InterviewsView: View {
    @EnvironmentObject var coordinator: AppCoordinator<HomeRoute>
    @StateObject private var viewModel: InterviewsViewModel = InterviewsViewModel()

    var body: some View {
        List {
            headerSection

            ForEach(viewModel.filteredInterviews) { item in
                InterviewTrackCard(item: item) {
                    print("Tapped on \(item.id)")
                    coordinator.push(.interviewPrep(
                        trackName: item.trackInterview.track.title,
                        trackId: item.trackInterview.track.id,
                        interviewType: .classic,
                    ),
                    )
                }
                .listRowInsets(EdgeInsets(top: Spacing.s6, leading: 0, bottom: Spacing.s6, trailing: 0))
//                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
        }
        .navigationTitle("Interviews")
        .navigationBarTitleDisplayMode(.inline)
        .padding(.horizontal)
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color(.systemGroupedBackground))
        .scrollIndicators(.hidden)
        .toolbar(.hidden, for: .tabBar)
    }


    private var headerSection: some View {
        Section {
            VStack(alignment: .leading, spacing: Spacing.s4) {
                Text("Interviews")
                    .font(.size32Bold)

                Text("Personalized to your profile")
                    .font(.size16Regular)
                    .foregroundColor(AppColors.secondaryText)
            }
            .listRowInsets(EdgeInsets(top: Spacing.s16, leading: 0, bottom: Spacing.s8, trailing: 0))
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)

            CustomSearchTextField(text: $viewModel.searchText, placeholder: "Search interviews...")
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: Spacing.s8, trailing: 0))
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
        }
    }

}

#Preview {
    InterviewsView()
}
