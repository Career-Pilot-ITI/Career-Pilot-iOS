//
//  SubscribtionView.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 20/07/2026.
//

import SwiftUI
import SwiftUI

enum PlanType: String, CaseIterable {
    case free = "Free"
    case plus = "Plus"
    case pro = "Pro"
}

struct Plan {
    let type: PlanType
    let price: String
    let label: String
    let accentColor: Color
    let features: [String]
}

struct ChoosePlanView: View {
    @State private var selectedPlan: PlanType = .plus
    @EnvironmentObject var coordinator: AppCoordinator

    let plans: [PlanType: Plan] = [
        .free: Plan(
            type: .free,
            price: "0",
            label: "Free Plan",
            accentColor: .gray400,
            features: ["3 sessions / month", "Basic score report", "Standard feedback"]
        ),
        .plus: Plan(
            type: .plus,
            price: "199",
            label: "Plus Plan",
            accentColor: .orange,
            features: ["12 sessions / month", "Detailed radar chart", "Priority AI feedback", "Coaching tips library"]
        ),
        .pro: Plan(
            type: .pro,
            price: "349",
            label: "Pro Plan",
            accentColor: .teal,
            features: ["Unlimited sessions", "Instant feedback", "All tracks unlocked", "1:1 coaching session"]
        )
    ]
    
    private var currentPlan: Plan {
        plans[selectedPlan]!
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Button(action: { /* close action */ }) {
                HStack(spacing: 4) {
                    Image(systemName: "xmark")
                    Text("Close")
                }
                .foregroundColor(.gray600)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Choose your plan")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.primaryNavy)
                Text("Unlock your full interview potential.")
                    .font(.size14Medium)
                    .foregroundColor(.gray600)
            }
            
            // Segmented tabs
            HStack(spacing: 8) {
                ForEach(PlanType.allCases, id: \.self) { plan in
                    Text(plan.rawValue)
                        .font(.size14Semibold)
                        .foregroundColor(selectedPlan == plan ? .white : .gray400)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            Capsule().fill(selectedPlan == plan ? Color.primaryNavy : Color.white)
                        )
                        .overlay(
                            Capsule().stroke(Color.gray200, lineWidth: selectedPlan == plan ? 0 : 1)
                        )
                        .onTapGesture {
                            withAnimation(.easeOut(duration: 0.2)) {
                                selectedPlan = plan
                            }
                        }
                }
            }
            
            // Plan detail card
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("EGP")
                        .font(.size14Medium)
                        .foregroundColor(.gray400)
                    Text(currentPlan.price)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    Text("/mo")
                        .font(.size14Medium)
                        .foregroundColor(.gray400)
                }
                
                HStack(spacing: 6) {
                    Circle()
                        .fill(currentPlan.accentColor)
                        .frame(width: 6, height: 6)
                    Text(currentPlan.label)
                        .font(.size14Semibold)
                        .foregroundColor(currentPlan.accentColor)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(currentPlan.features, id: \.self) { feature in
                        HStack(spacing: 10) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.teal)
                                .font(.system(size: 14))
                            Text(feature)
                                .font(.size14Medium)
                                .foregroundColor(.white)
                        }
                        if feature != currentPlan.features.last {
                            Divider().background(Color.white.opacity(0.15))
                        }
                    }
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: Radius.r16)
                    .fill(Color.primaryNavy)
            )
            
            Spacer()
            
            Button(action: {
                let item = CheckoutItem.subscription(
                                   plan: currentPlan.label,
                                   monthlyPrice: currentPlan.price,
                                   billingCycle: "Monthly",
                                   total: currentPlan.price
                               )
                               coordinator.push(.checkout(item: item))
            }) {
                HStack {
                    Text(selectedPlan == .free ? "Current Plan" : "Upgrade to \(selectedPlan.rawValue)")
                        .font(.size16Bold)
                    if selectedPlan != .free {
                        Image(systemName: "arrow.right")
                    }
                }
                .foregroundColor(selectedPlan == .free ? .gray400 : .white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    Capsule().fill(selectedPlan == .free ? Color.gray100 : Color.orange)
                )
            }
            .disabled(selectedPlan == .free)
        }
        .padding(20)
        .background(Color.gray100)
    }
}

struct ChoosePlanView_Previews: PreviewProvider {
    static var previews: some View {
        ChoosePlanView()
            .environmentObject(AppCoordinator())
    }
}

//struct SubscribtionView_Previews: PreviewProvider {
//    static var previews: some View {
//        SubscribtionView()
//    }
//}
