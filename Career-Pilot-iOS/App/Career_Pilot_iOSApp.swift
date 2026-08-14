//
//  Career_Pilot_iOSApp.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 12/07/2026.
//
import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}




@main
struct Career_Pilot_iOSApp: App {
    
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    let persistenceController = PersistenceController.shared
    @StateObject private var appState = AppState()
    
    init() {
            let state = AppState()
            _appState = StateObject(wrappedValue: state)

            DIContainer.shared.container.register(AppState.self) { _ in state }
                .inObjectScope(.container)
        }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(appState)
        }
    }
}
