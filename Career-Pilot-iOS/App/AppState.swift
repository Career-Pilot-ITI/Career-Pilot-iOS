//
//  AppState.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 19/07/2026.
//

import SwiftUI

final class AppState: ObservableObject {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false {
        willSet {
            objectWillChange.send()
        }
    }
    
    @AppStorage("isOnboadingSeen") var isOnboadingSeen: Bool = false {
        willSet {
            objectWillChange.send()
        }
    }
    
    func markLoggedIn() {
        isLoggedIn = true
    }
    
    func markOnboardingSeen() {
        isOnboadingSeen = true
    }
    
    func logout() {
        isLoggedIn = false
    }
}
