//
//  QuizView.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 14/08/2026.
//

import SwiftUI

struct QuizView: View {
    @EnvironmentObject private var coordinator: AppCoordinator<HomeRoute>
    @StateObject private var viewModel: QuizViewModel

    init(viewModel: QuizViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            if !viewModel.isLoading, !viewModel.isCompleted, !viewModel.questions.isEmpty {
                progressBar
            }

            content
        }
        .padding(.horizontal, Spacing.s16)
        .background(Color.background.ignoresSafeArea())
        .navigationTitle(viewModel.subtopicTitle)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadQuestions()
        }
    }
}

// MARK: - Subviews
private extension QuizView {

    @ViewBuilder
    var content: some View {
        if viewModel.isLoading {
            loadingView
        } else if viewModel.isCompleted {
            completedView
        } else if !viewModel.questions.isEmpty {
            questionContentView
        } else if let error = viewModel.errorMessage {
            errorView(error)
        }
    }


    var progressBar: some View {
        let fraction = viewModel.questions.isEmpty
            ? 0
            : Double(viewModel.currentIndex + 1) / Double(viewModel.questions.count)

        return GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.gray200)

                Capsule()
                    .fill(Color.primary)
                    .frame(width: geo.size.width * fraction)
                    .animation(.easeOut(duration: 0.3), value: fraction)
            }
        }
        .frame(height: 6)
        .padding(.top, Spacing.s12)
        .padding(.bottom, Spacing.s16)
    }

    // MARK: Loading State

    var loadingView: some View {
        VStack(alignment: .leading, spacing: Spacing.s20) {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.gray200)
                .frame(width: 140, height: 12)

            RoundedRectangle(cornerRadius: 6)
                .fill(Color.gray200)
                .frame(height: 46)

            VStack(spacing: Spacing.s12) {
                ForEach(0..<4, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: Spacing.s8)
                        .fill(Color.gray200)
                        .frame(height: 52)
                }
            }

            Spacer()
        }
        .redacted(reason: .placeholder)
        .overlay(alignment: .bottom) {
            VStack(spacing: Spacing.s10) {
                ProgressView()
                    .tint(Color.primary)
                Text("Generating questions with AI…")
                    .font(.size14Medium)
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(.bottom, Spacing.s40)
        }
    }


    var completedView: some View {
        let total = viewModel.questions.count
        let score = viewModel.finalScore
        let fraction = total == 0 ? 0 : Double(score) / Double(total)
        let isStrong = fraction >= 0.7

        return VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: Spacing.s24) {
                    ZStack {
                        Circle()
                            .stroke(Color.gray400, lineWidth: 8)
                            .frame(width: 120, height: 120)

                        Circle()
                            .trim(from: 0, to: fraction)
                            .stroke(
                                isStrong ? AppColors.success : AppColors.error,
                                style: StrokeStyle(lineWidth: 8, lineCap: .round)
                            )
                            .frame(width: 120, height: 120)
                            .rotationEffect(.degrees(-90))
                            .animation(.easeOut(duration: 0.7), value: fraction)

                        VStack(spacing: 2) {
                            Text("\(score)/\(total)")
                                .font(.size20Semibold)
                                .foregroundColor(AppColors.primaryText)
                            Text("\(Int(fraction * 100))%")
                                .font(.size12Regular)
                                .foregroundColor(AppColors.secondaryText)
                        }
                    }
                    .padding(.top, Spacing.s24)

                    VStack(spacing: Spacing.s6) {
                        Text(isStrong ? "Nice work!" : "Quiz Completed")
                            .font(.size24Semibold)
                            .foregroundColor(AppColors.primaryText)

                        Text(isStrong
                             ? "You've got a solid grasp of \(viewModel.subtopicTitle)."
                             : "Review \(viewModel.subtopicTitle) and give it another shot.")
                            .font(.size14Regular)
                            .foregroundColor(AppColors.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, Spacing.s24)
                    }

                    reviewList
                }
                .padding(.bottom, Spacing.s16)
            }

            Button {
                coordinator.pop()
            } label: {
                Text("Done")
                    .font(.size16Bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.s12)
                    .background(Color.primary)
                    .cornerRadius(Spacing.s8)
            }
            .padding(.top, Spacing.s12)
            .padding(.bottom, Spacing.s12)
        }
    }

    // MARK: Review list — per-question breakdown, correct vs picked answer

    var reviewList: some View {
        VStack(alignment: .leading, spacing: Spacing.s12) {
            Text("Review Answers")
                .font(.size15Bold)
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, Spacing.s4)

            ForEach(Array(viewModel.questions.enumerated()), id: \.offset) { index, question in
                reviewRow(question: question, index: index)
            }
        }
        .padding(.horizontal, Spacing.s4)
    }

    func reviewRow(question: QuestionEntity, index: Int) -> some View {
        let picked: Int? = viewModel.selectedAnswers[index]
        let correctIdx: Int = question.correctIndex
        let isCorrect: Bool = picked == correctIdx

        let fillColor: Color = isCorrect
            ? AppColors.success.opacity(0.08)
            : AppColors.error.opacity(0.08)

        let strokeColor: Color = isCorrect
            ? AppColors.success.opacity(0.4)
            : AppColors.error.opacity(0.4)

        return VStack(alignment: .leading, spacing: Spacing.s8) {
            Text("\(index + 1). \(question.questionText)")
                .font(.size14Bold)
                .foregroundColor(AppColors.primaryText)
                .fixedSize(horizontal: false, vertical: true)

            ForEach(0..<question.options.count, id: \.self) { optIdx -> AnyView in
                AnyView(
                    reviewOptionRow(
                        text: question.options[optIdx],
                        optIdx: optIdx,
                        picked: picked,
                        correctIdx: correctIdx
                    )
                )
            }
        }
        .padding(Spacing.s16)
        .background(
            RoundedRectangle(cornerRadius: Spacing.s12, style: .continuous)
                .fill(fillColor)
        )
        .overlay(
            RoundedRectangle(cornerRadius: Spacing.s12, style: .continuous)
                .stroke(strokeColor, lineWidth: 1)
        )
    }

    @ViewBuilder
    func reviewOptionRow(text: String, optIdx: Int, picked: Int?, correctIdx: Int) -> some View {
        let isCorrectOption = optIdx == correctIdx
        let isPickedWrong = optIdx == picked && picked != correctIdx

        HStack(spacing: Spacing.s8) {
            Image(systemName: isCorrectOption ? "checkmark.circle.fill" : (isPickedWrong ? "xmark.circle.fill" : "circle"))
                .foregroundColor(
                    isCorrectOption ? AppColors.success : (isPickedWrong ? AppColors.error : AppColors.secondaryText)
                )

            Text(text)
                .font(.size13Regular)
                .foregroundColor(
                    isCorrectOption ? AppColors.success : (isPickedWrong ? AppColors.error : AppColors.secondaryText)
                )
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 0)
        }
    }

    // MARK: Question Content

    var questionContentView: some View {
        let currentQ = viewModel.questions[viewModel.currentIndex]
        let selected = viewModel.selectedAnswers[viewModel.currentIndex]

        return VStack(alignment: .leading, spacing: Spacing.s16) {
            Text("Question \(viewModel.currentIndex + 1) of \(viewModel.questions.count)")
                .font(.size13Semibold)
                .foregroundColor(AppColors.secondaryText)

            Text(currentQ.questionText)
                .font(.size18Bold)
                .foregroundColor(Color.gray600)
                .fixedSize(horizontal: false, vertical: true)

            optionsList(currentQ: currentQ, selected: selected)

            Spacer()

            actionButton(selected: selected)
        }
        .id(viewModel.currentIndex)
        .transition(questionTransition)
        .animation(.easeInOut(duration: 0.25), value: viewModel.currentIndex)
    }

    var questionTransition: AnyTransition {
        AnyTransition.opacity.combined(with: .move(edge: .trailing))
    }

    func optionsList(currentQ: QuestionEntity, selected: Int?) -> some View {
        ScrollView {
            VStack(spacing: Spacing.s12) {
                ForEach(0..<currentQ.options.count, id: \.self) { idx in
                    optionRow(text: currentQ.options[idx], index: idx, isSelected: selected == idx)
                }
            }
        }
    }

    func optionRow(text: String, index: Int, isSelected: Bool) -> some View {
        Button {
            viewModel.selectAnswer(index: index)
        } label: {
            HStack(spacing: Spacing.s12) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.white.opacity(0.2) : Color.gray200)
                        .frame(width: 28, height: 28)

                    Text(optionLabel(for: index))
                        .font(.size14Bold)
                        .foregroundColor(isSelected ? .white : .gray)
                }

                Text(text)
                    .font(.size15Medium)
                    .foregroundColor(isSelected ? .white : .gray600)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer(minLength: 0)

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                }
            }
            .padding(Spacing.s16)
            .background(
                RoundedRectangle(cornerRadius: Spacing.s12, style: .continuous)
                    .fill(isSelected ? Color.primary : Color.gray100)
            )
            .overlay(
                RoundedRectangle(cornerRadius: Spacing.s12, style: .continuous)
                    .stroke(isSelected ? Color.clear : Color.gray600, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .animation(.easeOut(duration: 0.15), value: isSelected)
    }

    func optionLabel(for index: Int) -> String {
        guard let scalar = UnicodeScalar(65 + index) else { return "\(index + 1)" }
        return String(Character(scalar))
    }

    // MARK: Action Button

    @ViewBuilder
    func actionButton(selected: Int?) -> some View {
        let isDisabled = selected == nil || viewModel.isSubmitting

        if viewModel.currentIndex < viewModel.questions.count - 1 {
            Button {
                withAnimation {
                    viewModel.currentIndex += 1
                }
            } label: {
                Text("Next Question")
                    .font(.size16Bold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.s12)
                    .background(isDisabled ? Color.gray200 : Color.primary)
                    .foregroundColor(isDisabled ? .gray : .white)
                    .cornerRadius(Spacing.s8)
            }
            .disabled(isDisabled)
        } else {
            Button {
                Task {
                    await viewModel.submit()
                }
            } label: {
                HStack {
                    if viewModel.isSubmitting {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Submit Quiz")
                            .font(.size16Bold)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.s12)
                .background(isDisabled ? Color.gray200 : Color.primary)
                .foregroundColor(isDisabled ? AppColors.secondaryText : .white)
                .cornerRadius(Spacing.s8)
            }
            .disabled(isDisabled)
        }
    }

    // MARK: Error State

    func errorView(_ error: String) -> some View {
        VStack(spacing: Spacing.s16) {
            Spacer()

            ZStack {
                Circle()
                    .fill(AppColors.error.opacity(0.12))
                    .frame(width: 64, height: 64)
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(AppColors.error)
            }

            VStack(spacing: Spacing.s4) {
                Text("Couldn't load this quiz")
                    .font(.size15Bold)
                    .foregroundColor(AppColors.primaryText)

                Text(error)
                    .font(.size13Regular)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }

            Button {
                Task { await viewModel.loadQuestions() }
            } label: {
                Text("Retry")
                    .font(.size14Bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, Spacing.s24)
                    .padding(.vertical, Spacing.s10)
                    .background(Capsule().fill(Color.primary))
            }
            .padding(.top, Spacing.s4)

            Spacer()
        }
        .padding(Spacing.s24)
    }
}
