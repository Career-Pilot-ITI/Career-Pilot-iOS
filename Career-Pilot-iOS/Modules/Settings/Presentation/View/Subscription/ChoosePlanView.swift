//
//  SubscribtionView.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 20/07/2026.
//
//  NOTE: This view is reused from two different navigation stacks
//  (Settings tab, and the video-upsell path off Home). It must NOT
//  hardcode which coordinator/Route type presented it — the caller
//  decides what "go to checkout" means for its own stack.
//

import SwiftUI
import Shimmer

struct ChoosePlanView: View {
    @StateObject var viewModel: SubscriptionViewModel
//       @EnvironmentObject var coordinator: AppCoordinator<SettingsRoute>
    let onCheckout: (CheckoutDisplayInfo) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            switch viewModel.plansState {
            case .idle, .loading:
                planSkeleton
            case .failure:
                RetryableErrorView(
                    title: "Couldn't load plans",
                    message: "Please check your connection and try again.",
                    onRetry: {
                        Task { await viewModel.loadPlans() }
                    }
                )
                
            case .success(let plans):
                VStack(alignment: .leading, spacing: 4) {
                    Text("Choose your plan")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.primary)
                    Text("Unlock your full interview potential.")
                        .font(.size14Medium)
                        .foregroundColor(.gray600)
                }

                HStack(spacing: 8) {
                    ForEach(plans) { plan in
                        Text(plan.label.replacingOccurrences(of: " Plan", with: ""))
                            .font(.size14Semibold)
                            .foregroundColor(viewModel.selectedPlan == plan.type ? .white : .gray600)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(
                                Capsule().fill(viewModel.selectedPlan == plan.type ? Color.primary : Color.gray100)
                            )
                            .overlay(
                                Capsule().stroke(Color.gray400, lineWidth: viewModel.selectedPlan == plan.type ? 0 : 1)
                            )
                            .onTapGesture {
                                withAnimation(.easeOut(duration: 0.2)) {
                                    viewModel.selectedPlan = plan.type
                                }
                            }
                    }
                }

                if let currentPlan = viewModel.currentPlan {
                    planDetailCard(currentPlan)
                }

                Spacer()

                Button(action: {
                    switch viewModel.primaryAction {
                    case .currentPlan:
                        break
                        
                    case .downgradeToFree:
                        guard !viewModel.isCancelled else { return }   // already cancelled — nothing to do
                        viewModel.showCancelAlert = true                // ask for confirmation first
                        
                    case .checkout(let displayInfo):
                        onCheckout(displayInfo)
                    }
                }) {
                    HStack {
                        if viewModel.isPerformingAction {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text(viewModel.buttonTitle)
                                .font(.size16Bold)
                            if !viewModel.isSelectedPlanCurrent && viewModel.selectedPlan != .free {
                                Image(systemName: "arrow.right")
                            }
                        }
                    }
                    .foregroundColor(viewModel.isSelectedPlanCurrent ? .gray400 : .white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        Capsule().fill(viewModel.isSelectedPlanCurrent ? Color.gray100 : viewModel.selectedPlan == .free && viewModel.isCancelled == true ? Color.gray400 : Color.orange)
                    )
                }
                .disabled(
                    viewModel.isSelectedPlanCurrent ||
                    viewModel.isPerformingAction ||
                    viewModel.isDowngradeAlreadyCancelled
                )
            }
        }
        .padding(20)
        .background(Color.background)
        .task {
            await viewModel.loadPlans()
        }
        .alert("Cancel Subscription?", isPresented: $viewModel.showCancelAlert) {
            Button("Keep Subscription", role: .cancel) {}
            Button("Yes, Cancel", role: .destructive) {
                Task {
                    await viewModel.performCancelSubscription()
                }
            }
        } message: {
            Text("Are you sure you want to cancel your subscription? You will still retain all \(viewModel.activeUserPlan.rawValue.capitalized) Plan features until \(viewModel.formattedRenewalDate).")
        }
        
    }
    // MARK: - Shimmring skeleton, including the header
    private var planSkeleton: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            // Header placeholder
            VStack(alignment: .leading, spacing: 8) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(.systemGray4))
                    .frame(width: 180, height: 26)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(.systemGray5))
                    .frame(width: 220, height: 14)
            }

            // Tabs placeholder
            HStack(spacing: 8) {
                ForEach(0..<3, id: \.self) { _ in
                    Capsule()
                        .fill(Color(.systemGray5))
                        .frame(maxWidth: .infinity)
                        .frame(height: 38)
                }
            }

            // Detail card placeholder
            VStack(alignment: .leading, spacing: 16) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(.systemGray3))
                    .frame(width: 140, height: 32)

                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(.systemGray4))
                    .frame(width: 100, height: 14)

                VStack(alignment: .leading, spacing: 12) {
                    ForEach(0..<4, id: \.self) { index in
                        HStack(spacing: 10) {
                            Circle()
                                .fill(Color(.systemGray4))
                                .frame(width: 16, height: 16)
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color(.systemGray5))
                                .frame(width: index % 2 == 0 ? 180 : 130, height: 14)
                        }
                    }
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: Radius.r16).fill(Color.gray200))

            Spacer()

            // Button placeholder
            Capsule()
                .fill(Color(.systemGray4))
                .frame(maxWidth: .infinity)
                .frame(height: 52)
        }
        .shimmering()
    }

    @ViewBuilder
    private func planDetailCard(_ plan: SubscriptionPlan) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text("EGP").font(.size14Medium).foregroundColor(.gray400)
                Text(plan.price).font(.system(size: 32, weight: .bold)).foregroundColor(.white)
                Text("/mo").font(.size14Medium).foregroundColor(.gray400)
            }

            HStack(spacing: 6) {
                Circle().fill(plan.type.accentColor).frame(width: 6, height: 6)
                Text(plan.label).font(.size14Semibold).foregroundColor(plan.type.accentColor)
            }

            VStack(alignment: .leading, spacing: 12) {
                ForEach(plan.features, id: \.self) { feature in
                    HStack(spacing: 10) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.teal)
                            .font(.system(size: 14))
                        Text(feature)
                            .font(.size14Medium)
                            .foregroundColor(.white)
                    }
                    if feature != plan.features.last {
                        Divider().background(Color.white.opacity(0.15))
                    }
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: Radius.r16).fill(Color.primaryNavy))
    }
}
