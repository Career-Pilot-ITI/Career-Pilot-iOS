//
//  PathLearnView.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 14/08/2026.
//

import SwiftUI

struct PathLearnView: View {
    @EnvironmentObject private var coordinator: AppCoordinator<HomeRoute>
    @StateObject private var viewModel: PathLearnViewModel

    init(viewModel: PathLearnViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        contentView
            .navigationTitle(viewModel.trackTitle)
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.background.ignoresSafeArea())
            .task {
                await viewModel.fetchSubtopics()
            }
    }
}

// MARK: - Subviews & Layout Breakdown
private extension PathLearnView {

    @ViewBuilder
    var contentView: some View {
        switch (viewModel.isLoading, viewModel.errorMessage, viewModel.subtopics.isEmpty) {
        case (true, _, _):
            loadingView
        case (false, .some(let error), _):
            errorView(error)
        case (false, nil, true):
            emptyView
        default:
            subtopicsList
        }
    }

    // MARK: Progress header — the signature element: this is a path, show the walk so far

    var progressHeader: some View {
        let total = viewModel.subtopics.count
        let completed = viewModel.subtopics.filter(\.isCompleted).count
        let fraction = total == 0 ? 0 : Double(completed) / Double(total)

        return HStack(spacing: Spacing.s16) {
            ZStack {
                Circle()
                    .stroke(Color.gray200, lineWidth: 5)

                Circle()
                    .trim(from: 0, to: fraction)
                    .stroke(
                        AppColors.success,
                        style: StrokeStyle(lineWidth: 5, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeOut(duration: 0.6), value: fraction)

                Text("\(Int(fraction * 100))%")
                    .font(.size12Bold)
                    .foregroundColor(AppColors.primaryText)
            }
            .frame(width: 52, height: 52)

            VStack(alignment: .leading, spacing: Spacing.s4) {
                Text(viewModel.trackTitle)
                    .font(.size16Bold)
                    .foregroundColor(AppColors.primaryText)
                    .lineLimit(1)

                Text("\(completed) of \(total) topics completed")
                    .font(.size13Regular)
                    .foregroundColor(AppColors.secondaryText)
            }

            Spacer()
        }
        .padding(Spacing.s16)
        .background(
            RoundedRectangle(cornerRadius: Radius.r16, style: .continuous)
                .fill(Color.gray400.opacity(0.06))
        )
        .padding(.horizontal, Spacing.s16)
        .padding(.top, Spacing.s12)
    }

    // MARK: Loading — real skeleton shaped like the eventual content

    var loadingView: some View {
        VStack(spacing: Spacing.s12) {
            RoundedRectangle(cornerRadius: Radius.r16, style: .continuous)
                .fill(Color.gray400.opacity(0.06))
                .frame(height: 84)
                .padding(.horizontal, Spacing.s16)
                .padding(.top, Spacing.s12)

            ForEach(0..<5, id: \.self) { _ in
                subtopicSkeletonRow
            }
            Spacer()
        }
        .redacted(reason: .placeholder)
        .shimmering()
    }

    var subtopicSkeletonRow: some View {
        HStack(spacing: Spacing.s16) {
            Circle()
                .fill(Color.gray200)
                .frame(width: 22, height: 22)

            VStack(alignment: .leading, spacing: Spacing.s6) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray200)
                    .frame(width: 160, height: 14)
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray200)
                    .frame(width: 90, height: 10)
            }
            Spacer()
        }
        .padding(Spacing.s14)
        .background(
            RoundedRectangle(cornerRadius: Radius.r14, style: .continuous)
                .fill(Color.gray400.opacity(0.05))
        )
        .padding(.horizontal, Spacing.s16)
    }

    // MARK: Error

    func errorView(_ error: String) -> some View {
        VStack(spacing: Spacing.s16) {
            ZStack {
                Circle()
                    .fill(AppColors.error.opacity(0.12))
                    .frame(width: 64, height: 64)
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(AppColors.error)
            }

            VStack(spacing: Spacing.s4) {
                Text("Couldn't load this path")
                    .font(.size15Bold)
                    .foregroundColor(AppColors.primaryText)
                Text(error)
                    .font(.size13Regular)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }

            Button {
                Task { await viewModel.fetchSubtopics() }
            } label: {
                Text("Retry")
                    .font(.size14Bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, Spacing.s24)
                    .padding(.vertical, Spacing.s10)
                    .background(Capsule().fill(Color.primary))
            }
            .padding(.top, Spacing.s4)
        }
        .padding(Spacing.s24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: Empty

    var emptyView: some View {
        VStack(spacing: Spacing.s16) {
            ZStack {
                Circle()
                    .fill(Color.gray200)
                    .frame(width: 64, height: 64)
                Image(systemName: "signpost.right.and.left")
                    .font(.system(size: 24))
                    .foregroundColor(AppColors.secondaryText)
            }

            VStack(spacing: Spacing.s4) {
                Text("No topics yet")
                    .font(.size15Bold)
                    .foregroundColor(AppColors.primaryText)
                Text("This path doesn't have any quiz topics added yet. Check back soon.")
                    .font(.size13Regular)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.s24)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: Content list

    var rowEntranceTransition: AnyTransition {
        AnyTransition.opacity.combined(with: .move(edge: .top))
    }

    var subtopicsList: some View {
        ScrollView {
            LazyVStack(spacing: Spacing.s12) {
                progressHeader

                ForEach(Array(viewModel.subtopics.enumerated()), id: \.element.id) { index, subtopic in
                    let rowDelay = Double(index) * 0.04

                    subtopicRow(subtopic)
                        .transition(rowEntranceTransition)
                        .animation(
                            .easeOut(duration: 0.35).delay(rowDelay),
                            value: viewModel.subtopics.count
                        )
                }
            }
            .padding(.bottom, Spacing.s24)
        }
        .refreshable {
            await viewModel.fetchSubtopics()
        }
    }

    func subtopicRow(_ subtopic: SubtopicEntity) -> some View {
        Button {
            coordinator.push(
                .quiz(
                    trackId: viewModel.trackId,
                    trackTitle: viewModel.trackTitle,
                    subtopicId: String(subtopic.id),
                    subtopicTitle: subtopic.title
                )
            )
        } label: {
            HStack(spacing: Spacing.s14) {
                ZStack {
                    Circle()
                        .fill(subtopic.isCompleted ? AppColors.success.opacity(0.15) : Color.gray200)
                        .frame(width: 36, height: 36)

                    Image(systemName: subtopic.isCompleted ? "checkmark" : "circle")
                        .font(.system(size: subtopic.isCompleted ? 14 : 8, weight: .bold))
                        .foregroundColor(subtopic.isCompleted ? AppColors.success : AppColors.secondaryText)
                        .animation(.spring(response: 0.35, dampingFraction: 0.6), value: subtopic.isCompleted)
                }

                VStack(alignment: .leading, spacing: Spacing.s4) {
                    Text(subtopic.title)
                        .font(.size15Bold)
                        .lineLimit(1)

                    if subtopic.isCompleted, let score = subtopic.score, let total = subtopic.totalQuestions {
                        scorePill(score: score, total: total)
                    } else {
                        Text("Not started")
                            .font(.size12Regular)
                            .foregroundColor(AppColors.secondaryText)
                    }
                }

                Spacer(minLength: Spacing.s8)

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(Spacing.s14)
            .background(
                RoundedRectangle(cornerRadius: Radius.r14, style: .continuous)
                    .fill(subtopic.isCompleted ? AppColors.success.opacity(0.05) : Color.gray400.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: Radius.r14, style: .continuous)
                            .stroke(subtopic.isCompleted ? AppColors.success.opacity(0.25) : Color.clear, lineWidth: 1)
                    )
            )
            .padding(.horizontal, Spacing.s16)
        }
        .buttonStyle(.plain)
    }

    func scorePill(score: Int, total: Int) -> some View {
        Text("Score \(score)/\(total)")
            .font(.size11Bold)
            .foregroundColor(AppColors.success)
            .padding(.horizontal, Spacing.s8)
            .padding(.vertical, 2)
            .background(Capsule().fill(AppColors.success.opacity(0.15)))
    }
}

// MARK: - Shimmer effect for skeleton loading

private struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = -0.3

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geo in
                    LinearGradient(
                        colors: [.clear, Color.white.opacity(0.35), .clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geo.size.width * 0.6)
                    .offset(x: phase * geo.size.width)
                    .blendMode(.plusLighter)
                }
                .mask(content)
            )
            .onAppear {
                withAnimation(.linear(duration: 1.2).repeatForever(autoreverses: false)) {
                    phase = 1.3
                }
            }
    }
}

