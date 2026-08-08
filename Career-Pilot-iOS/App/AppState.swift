//
//  AppState.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 19/07/2026.
// test 

import SwiftUI
final class AppState: ObservableObject {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false {
        willSet {
            print("🔄 isLoggedIn will change to: \(newValue)")
            objectWillChange.send()
        }
    }
    
    @AppStorage("isOnboadingSeen") var isOnboadingSeen: Bool = false {
        willSet {
            print("🔄 isOnboadingSeen will change to: \(newValue)")
            objectWillChange.send()
        }
    }
    
    func markLoggedIn() {
        print("👉 markLoggedIn() called")
        isLoggedIn = true
    }
    
    func markOnboardingSeen() {
        print("👉 markOnboardingSeen() called")
        isOnboadingSeen = true
    }
    
    func logout() {
        print("👉 logout() called")
        isLoggedIn = false
    }
}
