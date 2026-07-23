//
//  AccountSettingsViewMdoel.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 22/07/2026.
//

//import Foundation
//@MainActor
//final class SettingsViewModel: ObservableObject {
//    @Published var items: [AccountItem] = []
//    
//    private let userSession: UserSession
//    private var cancellables = Set<AnyCancellable>()
//    
//    init(userSession: UserSession) {
//        self.userSession = userSession
//        
//        // Recompute items any time UserSession's state changes
//        userSession.$state
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] _ in
//                self?.buildItems()
//            }
//            .store(in: &cancellables)
//    }
//    
//    var loadState: LoadState<[AccountItem]> {
//        switch userSession.state {
//        case .idle: return .idle
//        case .loading: return .loading
//        case .failure(let error): return .failure(error)
//        case .success: return .success(items)
//        }
//    }
//    
//    private func buildItems() {
//        guard let user = userSession.userData else { return }
//        items = [
//            AccountItem(icon: "Subscription", title: "Subscription", subtitle: user.subscriptionSummary, route: .subscriptionScreen),
//            AccountItem(icon: "Favourite", title: "Coin Balance", subtitle: "\(user.coinBalance) coins", route: .coinBalanceScreen),
//            AccountItem(icon: "notifiaction", title: "Notifications", subtitle: user.notificationsEnabled ? "Reminders on" : "Reminders off", route: .notificationsScreen)
//        ]
//    }
//    
//    func load() async {
//        await userSession.loadUserData()
//    }
//}
