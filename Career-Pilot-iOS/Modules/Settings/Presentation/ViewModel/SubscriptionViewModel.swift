//
//  SubscriptionViewModel.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 22/07/2026.
//

import Foundation
import Combine

@MainActor
final class SubscriptionViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var plansState: LoadState<[SubscriptionPlan]> = .idle
    @Published var isPerformingAction: Bool = false
    @Published var actionError: Error?
    @Published var selectedPlan: PlanType? {
        didSet { updateButtonTitle() }
    }
    @Published var buttonTitle: String = ""
    
    // MARK: - Private Properties
    private let getPlansUseCase: GetSubscribtionPlan
    private let getUserSubscribtion: GetUserSubscribtion
    private let downgrade: DowngradeUserSubscription
    private let userSession: UserSession
    private var fetchedUserPlan: PlanType?
    
    // MARK: - Init
    init(
        getPlansUseCase: GetSubscribtionPlan,
        getUserSubscribtion: GetUserSubscribtion,
        downgrade: DowngradeUserSubscription,
        userSession: UserSession
    ) {
        self.getPlansUseCase = getPlansUseCase
        self.getUserSubscribtion = getUserSubscribtion
        self.downgrade = downgrade
        self.userSession = userSession
    }
    
    // MARK: - Computed Properties
    var currentPlan: SubscriptionPlan? {
        plansState.value?.first { $0.type == selectedPlan }
    }
    
    var isSelectedPlanCurrent: Bool {
        selectedPlan == fetchedUserPlan
    }
    
    enum PrimaryAction {
        case currentPlan
        case downgradeToFree
        case checkout(CheckoutDisplayInfo)
    }
    
    var primaryAction: PrimaryAction {
        guard let selectedPlan = selectedPlan else { return .currentPlan }
        
        if isSelectedPlanCurrent {
            return .currentPlan
        }
        
        if selectedPlan == .free {
            return .downgradeToFree
        }
        
        if let currentPlan = currentPlan {
            let item = CheckoutDisplayInfo.subscription(
                plan: currentPlan.label,
                monthlyPrice: currentPlan.price,
                billingCycle: "Monthly",
                total: currentPlan.price,
                checkoutItem: CheckoutItem.subscription(planType: currentPlan.type)
            )
            return .checkout(item)
        }
        
        return .currentPlan
    }
    
    // MARK: - Public Methods
    func loadPlans() async {
        plansState = .loading
        do {
            let plans = try await getPlansUseCase.execute()
            let userPlan = try await getUserSubscribtion.execute()
            selectedPlan = userPlan.tier
            fetchedUserPlan = userPlan.tier
            updateButtonTitle()
            plansState = .success(plans)
        } catch {
            plansState = .failure(error)
        }
    }
    
    /// Main entry point for the primary CTA button in the View
    func handlePrimaryAction(onNavigateToCheckout: (CheckoutDisplayInfo) -> Void) async {
        switch primaryAction {
        case .currentPlan:
            break
            
        case .downgradeToFree:
            await performDowngradeToFree()
            
        case .checkout(let displayInfo):
            onNavigateToCheckout(displayInfo)
        }
    }
    
    private func performDowngradeToFree() async {
        isPerformingAction = true
        actionError = nil
        
        do {
            _ = try await downgrade.execute()
            
            fetchedUserPlan = .free
            selectedPlan = .free
            
            if var updatedUserData = userSession.userData {
                updatedUserData.subscriptionPlan = PlanType.free.rawValue
                userSession.userData = updatedUserData
            }
            
            updateButtonTitle()
        } catch {
            actionError = error
        }
        
        isPerformingAction = false
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
            buttonTitle = "Upgrade to \(selectedPlan.rawValue.capitalized)"
        }
    }
}
