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
                Text("Couldn't load plans")
                    .foregroundColor(.errorColour)
                
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
                    Task {
                        await viewModel.handlePrimaryAction { checkoutItem in
                            coordinator.push(.checkout(item: checkoutItem))
                        }
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
                        Capsule().fill(viewModel.isSelectedPlanCurrent ? Color.background : Color.primary)
                    )
                }
                .disabled(viewModel.isSelectedPlanCurrent || viewModel.isPerformingAction)
            }
        }
        .padding(20)
        .background(Color.background)
        .task {
            await viewModel.loadPlans()
        }
    }
    // MARK: - Shimmering Skeleton
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
            .background(
                RoundedRectangle(cornerRadius: Radius.r16)
                    .fill(Color(.secondarySystemBackground))
            )
            
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
