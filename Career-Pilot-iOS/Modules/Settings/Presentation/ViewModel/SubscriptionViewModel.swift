//
//  SubscriptionViewModel.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 22/07/2026.
//

import Foundation
import Combine

@MainActor
final class SubscriptionViewModel: ObservableObject  {
    
    // MARK: - Published Properties (Plans & Selection)
    @Published var plansState: LoadState<[SubscriptionPlan]> = .idle
    @Published var subscribationShown : LoadState<UserSubscribtionDomain> = .idle
    @Published var isPerformingAction: Bool = false
    @Published var actionError: Error?
    @Published var selectedPlan: PlanType? {
        didSet { updateButtonTitle() }
    }
    @Published var buttonTitle: String = ""
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Published Properties (My Subscription Status & Actions)
    @Published var currentSubscriptionInfo: UserSubscribtionDomain?
    @Published var isCancelled: Bool = false
    @Published var showCancelAlert: Bool = false
    @Published var isCancelling: Bool = false
    
    // MARK: - Dependencies
    private let getPlansUseCase: GetSubscribtionPlan
    private let getUserSubscribtion: GetUserSubscribtion
    private let cancelUserSubscribtion: CancelSubscription
    private let userSession: UserSession
    
    // MARK: - Private State
    private var fetchedUserPlan: PlanType?
    
    // MARK: - Init
    init(
        getPlansUseCase: GetSubscribtionPlan,
        getUserSubscribtion: GetUserSubscribtion,
        cancelUserSubscribtion: CancelSubscription,
        userSession: UserSession
    ) {
        self.getPlansUseCase = getPlansUseCase
        self.getUserSubscribtion = getUserSubscribtion
        self.cancelUserSubscribtion = cancelUserSubscribtion
        self.userSession = userSession
        userSession.$userData
            .dropFirst()
            .compactMap { $0 }
            .sink { [weak self] _ in
                Task { await self?.loadPlans() }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Computed Properties (Choose Plan Screen)
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
    
    // MARK: - Computed Properties (My Subscription Screen)
    var activeUserPlan: PlanType {
        fetchedUserPlan ?? .free
    }
    
    var formattedStartDate: String {
        guard let dateString = currentSubscriptionInfo?.startedAt else { return "N/A" }
        return formatServerDate(dateString)
    }
    
    var formattedRenewalDate: String {
        guard let dateString = currentSubscriptionInfo?.renewalDate else { return "N/A" }
        return formatServerDate(dateString)
    }
    
    var planFeatures: [String] {
        activeUserPlan.includedFeatures
    }
    
    // MARK: - Public Methods
    func loadPlans() async {
        plansState = .loading
        do {
            async let plansTask = getPlansUseCase.execute()
            async let userPlanTask = getUserSubscribtion.execute()
            
            let (plans, userPlan) = try await (plansTask, userPlanTask)
            applyUserPlan(userPlan)
            plansState = .success(plans)
        } catch {
            plansState = .failure(error)
        }
    }

    // New — dedicated to MySubscriptionView
    func loadMySubscription() async {
        subscribationShown = .loading
        do {
            print("I've entered here ")
            let userPlan = try await getUserSubscribtion.execute()
            print("The user plan is \(userPlan.tier)")

            applyUserPlan(userPlan)
            print("The user plan is \(userPlan.tier)")
            subscribationShown = .success(userPlan)
        } catch {
            subscribationShown = .failure(error)
        }
    }

    private func applyUserPlan(_ userPlan: UserSubscribtionDomain) {
        currentSubscriptionInfo = userPlan
        selectedPlan = userPlan.tier
        fetchedUserPlan = userPlan.tier
        isCancelled = !(userPlan.cancelledAt?.isEmpty ?? true)
        updateButtonTitle()
    }
    func handlePrimaryAction(onNavigateToCheckout: (CheckoutDisplayInfo) -> Void) async {
        switch primaryAction {
        case .currentPlan:
            break
            
        case .downgradeToFree:
            await performCancelSubscription()
            
        case .checkout(let displayInfo):
            onNavigateToCheckout(displayInfo)
        }
    }
    var isDowngradeAlreadyCancelled: Bool {
        if case .downgradeToFree = primaryAction {
            return isCancelled
        }
        return false
    }
    
    func performCancelSubscription() async {
        guard !isCancelled else { return }   // don't cancel an already-cancelled subscription
        
        isCancelling = true
        defer { isCancelling = false }
        
        do {
            _ = try await cancelUserSubscribtion.execute()
            isCancelled = true
            
            if var current = currentSubscriptionInfo {
                current.cancelledAt = current.renewalDate
                currentSubscriptionInfo = current
            }
            
            ToastManager.shared.show("Subscription cancelled. Access remains active until \(formattedRenewalDate).")
        } catch {
            actionError = error
            ToastManager.shared.show("Failed to cancel subscription: \(error.localizedDescription)")
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
            if self.isCancelled == true
            {
                buttonTitle = "You already will be on free"
            }
            else {
                buttonTitle = "Go back to Free"
            }
        } else {
            buttonTitle = "Upgrade to \(selectedPlan.rawValue.capitalized)"
        }
    }
    
    private func formatServerDate(_ rawDate: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        var parsedDate = isoFormatter.date(from: rawDate)
        if parsedDate == nil {
            let standardISO = ISO8601DateFormatter()
            parsedDate = standardISO.date(from: rawDate)
        }
        
        guard let date = parsedDate else { return rawDate }
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .medium
        displayFormatter.timeStyle = .none
        return displayFormatter.string(from: date)
    }
}


extension SubscriptionViewModel: Hashable {
    nonisolated static func == (lhs: SubscriptionViewModel, rhs: SubscriptionViewModel) -> Bool {
        lhs === rhs
    }
    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}



