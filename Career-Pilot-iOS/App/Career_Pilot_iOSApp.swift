//
//  Career_Pilot_iOSApp.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 12/07/2026.
//

import SwiftUI

@main
struct Career_Pilot_iOSApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var appState = AppState()
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false

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
                .preferredColorScheme(isDarkMode ? .dark : .light)

        }
    }
}
