//
//  SubscribtionView.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 20/07/2026.
//

import SwiftUI
import SwiftUI





struct ChoosePlanView: View {
    @StateObject var viewModel: SubscriptionViewModel = SubscriptionViewModel(getPlansUseCase: GetSubscribtionPlan(settingsRepo: SettingsRepoImp(remote: SettingsRemoteImp(apiService: URLSessionNetworkService()), local: SettingsLocalDataSourceImp(coreDataManager: CoreDataManager()), authToken: KeychainAuthTokenStore())))
    @EnvironmentObject var coordinator: AppCoordinator<SettingsRoute>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Choose your plan")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.primaryNavy)
                Text("Unlock your full interview potential.")
                    .font(.size14Medium)
                    .foregroundColor(.gray600)
            }
            
            switch viewModel.plansState {
            case .idle, .loading:
                ProgressView()
                    .frame(maxWidth: .infinity)
                
            case .failure:
                Text("Couldn't load plans")
                    .foregroundColor(.errorColour)
                
            case .success(let plans):
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
                    guard let currentPlan = viewModel.currentPlan else { return }
                    let item = CheckoutDisplayInfo.subscription(
                        
                        plan: currentPlan.label, monthlyPrice: currentPlan.price,
                        billingCycle: "Monthly",
                        total: currentPlan.price, checkoutItem: CheckoutItem.subscription(planType: currentPlan.type  )
                    )
                    coordinator.push(.checkout(item: item))
                }) {
                    HStack {
                        Text(viewModel.selectedPlan == .free ? "Current Plan" : "Upgrade to \(viewModel.selectedPlan.rawValue)")
                            .font(.size16Bold)
                        if viewModel.selectedPlan != .free {
                            Image(systemName: "arrow.right")
                        }
                    }
                    .foregroundColor(viewModel.selectedPlan == .free ? .gray400 : .white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        Capsule().fill(viewModel.selectedPlan == .free ? Color.gray100 : Color.orange)
                    )
                }
                .disabled(viewModel.selectedPlan == .free)
            }
        }
        .padding(20)
        .background(Color.gray100)
        .task {
            await viewModel.loadPlans()
        }
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
//struct ChoosePlanView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChoosePlanView()
//            .environmentObject(AppCoordinator())
//    }
//}

//struct SubscribtionView_Previews: PreviewProvider {
//    static var previews: some View {
//        SubscribtionView()
//    }
//}
