//
//  SubscribtionView.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 20/07/2026.
//

import SwiftUI
import Shimmer

struct ChoosePlanView: View {
    @StateObject var viewModel: SubscriptionViewModel
       @EnvironmentObject var coordinator: AppCoordinator<SettingsRoute>

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
                        .foregroundColor(.primaryNavy)
                    Text("Unlock your full interview potential.")
                        .font(.size14Medium)
                        .foregroundColor(.gray600)
                }
                
                HStack(spacing: 8) {
                    ForEach(plans) { plan in
                        Text(plan.label.replacingOccurrences(of: " Plan", with: ""))
                            .font(.size14Semibold)
                            .foregroundColor(viewModel.selectedPlan == plan.type ? .white : .gray400)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(
                                Capsule().fill(viewModel.selectedPlan == plan.type ? Color.primaryNavy : Color.white)
                            )
                            .overlay(
                                Capsule().stroke(Color.gray200, lineWidth: viewModel.selectedPlan == plan.type ? 0 : 1)
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
                        coordinator.push(.checkout(item: displayInfo))
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
        .background(Color.gray100)
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
            VStack(alignment: .leading, spacing: 6) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.gray200)
                    .frame(width: 180, height: 26)
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray200)
                    .frame(width: 220, height: 14)
            }
            
            // Tabs placeholder
            HStack(spacing: 8) {
                ForEach(0..<3, id: \.self) { _ in
                    Capsule()
                        .fill(Color.gray200)
                        .frame(maxWidth: .infinity)
                        .frame(height: 38)
                }
            }
            
            // Detail card placeholder
            VStack(alignment: .leading, spacing: 16) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.gray200)
                    .frame(width: 140, height: 32)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray200)
                    .frame(width: 100, height: 14)
                
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(0..<4, id: \.self) { _ in
                        HStack(spacing: 10) {
                            Circle().fill(Color.gray200).frame(width: 16, height: 16)
                            RoundedRectangle(cornerRadius: 4).fill(Color.gray200).frame(height: 14)
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
                .fill(Color.gray200)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
        }
        .redacted(reason: .placeholder)
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
