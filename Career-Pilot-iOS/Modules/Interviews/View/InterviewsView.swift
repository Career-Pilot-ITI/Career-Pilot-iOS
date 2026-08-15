//
//  InterviewsView.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 09/08/2026.
//
import SwiftUI

struct InterviewsView: View {
    @EnvironmentObject var coordinator: AppCoordinator<HomeRoute>
    @StateObject private var viewModel: InterviewsViewModel =
        DIContainer.shared.container.resolve(InterviewsViewModel.self)!

    var body: some View {
        List {
            headerSection

            switch viewModel.tracksState {
            case .loading:
                skeletonLoadingSection

            case .error(let message):
                errorSection(message: message)

            case .success, .idle:
                if viewModel.filteredInterviews.isEmpty {
                    emptyStateSection
                } else {
                    contentSection
                }
            }
        }
        .navigationTitle("Interviews")
        .navigationBarTitleDisplayMode(.inline)
        .padding(.horizontal)
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color(.background))
        .scrollIndicators(.hidden)
        .toolbar(.hidden, for: .tabBar)
        .task {
            await viewModel.loadRecommendedInterviews()
        }
        .refreshable {
            await viewModel.loadRecommendedInterviews()
        }
    }

    // MARK: - Header
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

    // MARK: - Content Section (Success State)
    private var contentSection: some View {
        ForEach(viewModel.filteredInterviews) { item in
            InterviewTrackCard(item: item){
                print("Tapped on \(item.id)")
                coordinator.push(
                    .interviewPrep(
                        trackName: item.trackInterview.track.title,
                        trackId: item.trackInterview.track.id,
                        interviewType: .classic
                    )
                )
            }
            onStartQuiz:{
                coordinator.push(
                        .pathLearn(
                            trackId: String(item.trackInterview.track.id),
                            trackName: item.trackInterview.track.title
                        )
                )
            }
            .listRowInsets(EdgeInsets(top: Spacing.s6, leading: 0, bottom: Spacing.s6, trailing: 0))
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
        }
    }

    // MARK: - Skeleton Loading Section
    private var skeletonLoadingSection: some View {
        ForEach(0..<6, id: \.self) { _ in
            SessionRowSkeleton()
                .listRowInsets(EdgeInsets(top: Spacing.s6, leading: 0, bottom: Spacing.s6, trailing: 0))
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
        }
    }

    // MARK: - Error Section
    private func errorSection(message: String) -> some View {
        VStack(spacing: Spacing.s16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(.red)

            Text("Failed to Load Interviews")
                .font(.size18Bold)

            Text(message)
                .font(.size14Regular)
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)

            Button(action: {
                Task {
                    await viewModel.loadRecommendedInterviews()
                }
            }) {
                Text("Retry")
                    .font(.size14Semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, Spacing.s24)
                    .padding(.vertical, Spacing.s12)
                    .background(Color.accentColor)
                    .cornerRadius(Radius.r12)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.s32)
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
    }

    // MARK: - Empty State Section
    private var emptyStateSection: some View {
        VStack(spacing: Spacing.s12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 36))
                .foregroundColor(.secondary)

            Text("No Interviews Found")
                .font(.size18Bold)

            Text("Try searching for another track or technology.")
                .font(.size14Regular)
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.s32)
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
    }
}
