//
//  AppRoute.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 15/07/2026.
//

import Foundation
import SwiftUI

enum AppRoute : Hashable {
    // MARK : Auth
    case phoneEntryScreen
    case sendingOTPScreen(phoneNumber: String)
    case otpScreen(phoneNumber: String)
    case successOTPScreen
    
    // MARK : Onboarding
    case onboardingScreen(vm : OnBordingViewModel)
}


final class AppCoordinator : ObservableObject {
    @Published var path = NavigationPath()
        
    func push(_ route : AppRoute) {
        path.append(route)
    }
    
    func pop() {
        guard !path.isEmpty else {return}
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
        
    }
}
