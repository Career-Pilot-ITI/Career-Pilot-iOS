//
//  SubscriptionViewModel.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 22/07/2026.
//

import Foundation
import Combine

// SubscriptionViewModel.swift
@MainActor
final class SubscriptionViewModel: ObservableObject {
    @Published var plansState: LoadState<[SubscriptionPlan]> = .idle
    @Published var selectedPlan: PlanType? {
           didSet { updateButtonTitle() }
       }
       @Published var buttonTitle: String = ""
    private let getPlansUseCase: GetSubscribtionPlan
    private let getUserSubscribtion : GetUserSubscribtion
    private var fetchedUserPlan : PlanType?
    
    init(getPlansUseCase: GetSubscribtionPlan , getUserSubscribtion : GetUserSubscribtion) {
        self.getPlansUseCase = getPlansUseCase
        self.getUserSubscribtion = getUserSubscribtion
    }
    
    var currentPlan: SubscriptionPlan? {
        plansState.value?.first { $0.type == selectedPlan }
    }
    var isSelectedPlanCurrent: Bool {
            selectedPlan == fetchedUserPlan
        }
    func loadPlans() async {
        plansState = .loading
        do {
            
            let plans = try await getPlansUseCase.execute()
            let userPlan = try await getUserSubscribtion.execute()
                   selectedPlan = userPlan
            fetchedUserPlan = userPlan
            updateButtonTitle()
            plansState = .success(plans)
        } catch {
            plansState = .failure(error)
        }
    }
    private func updateButtonTitle() {
         guard let selectedPlan else {
             buttonTitle = ""
             return
         }
         
         if isSelectedPlanCurrent {
             buttonTitle = "Current Plan"
         } else if selectedPlan == .free {
             buttonTitle = "Go back to Free"
         } else {
             buttonTitle = "Upgrade to \(selectedPlan.rawValue)"
         }
     }
}
