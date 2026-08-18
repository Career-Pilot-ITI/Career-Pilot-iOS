//
//  Career_Pilot_iOSApp.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 12/07/2026.
//

import SwiftUI
import FirebaseCore
import FirebaseAppCheck
import FirebaseAI

// MARK: - Firebase App Delegate

final class AppDelegate: NSObject, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {

        #if DEBUG
        print("🔥 DEBUG BUILD")

        let providerFactory = AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)

        print("🔥 App Check Debug Provider configured")
        #endif

        print("🔥 Configuring Firebase...")

        FirebaseApp.configure()

        print("🔥 Firebase configured")

        return true
    }
}

// MARK: - Main App Entry Point

@main
struct Career_Pilot_iOSApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    let persistenceController = PersistenceController.shared

    @StateObject private var appState: AppState
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
                .environment(
                    \.managedObjectContext,
                    persistenceController.container.viewContext
                )
                .environmentObject(appState)
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .task {
                    await testFirebaseAI()
                }
        }
    }

    // MARK: - Firebase AI Test Routine

    private func testFirebaseAI() async {
        print("------------------------------------------")
        print("🤖 [FIREBASE AI] Starting test...")
        print("------------------------------------------")

        let ai = FirebaseAI.firebaseAI(
            backend: .googleAI()
        )

        let model = ai.generativeModel(
            modelName: "gemini-2.5-flash"
        )

        do {
            print("🤖 [FIREBASE AI] Sending request...")

            let response = try await model.generateContent(
                "Reply with exactly: Firebase AI Logic is working."
            )

            print("------------------------------------------")
            print("✅ [FIREBASE AI] SUCCESS")
            print("🤖 Response:")
            print(response.text ?? "No response text")
            print("------------------------------------------")

        } catch {
            print("------------------------------------------")
            print("❌ [FIREBASE AI] ERROR")
            print("❌ \(error)")
            print("------------------------------------------")
        }
    }
}
