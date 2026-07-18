//
//  Userdefaultsmanager.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 18/07/2026.
//

import Foundation

final class UserDefaultsManager {

    static let shared = UserDefaultsManager()

    private let defaults: UserDefaults
    private let namespace: String
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(suiteName: String? = nil, namespace: String = "com.app") {
        self.defaults = suiteName.flatMap { UserDefaults(suiteName: $0) } ?? .standard
        self.namespace = namespace
    }

    private func key(_ key: String) -> String {
        "\(namespace).\(key)"
    }

    
    func exists(_ key: String) -> Bool {
        defaults.object(forKey: self.key(key)) != nil
    }

    func remove(_ key: String) {
        defaults.removeObject(forKey: self.key(key))
    }

    func clearAll() {
        let keys = defaults.dictionaryRepresentation().keys
        keys.filter { $0.hasPrefix("\(namespace).") }
            .forEach { defaults.removeObject(forKey: $0) }
    }

    
    func set(_ value: Bool, forKey key: String) {
        defaults.set(value, forKey: self.key(key))
    }

    func bool(forKey key: String, default defaultValue: Bool = false) -> Bool {
        exists(key) ? defaults.bool(forKey: self.key(key)) : defaultValue
    }

    func set(_ value: Int, forKey key: String) {
        defaults.set(value, forKey: self.key(key))
    }

    func int(forKey key: String, default defaultValue: Int = 0) -> Int {
        exists(key) ? defaults.integer(forKey: self.key(key)) : defaultValue
    }

    func set(_ value: Double, forKey key: String) {
        defaults.set(value, forKey: self.key(key))
    }

    func double(forKey key: String, default defaultValue: Double = 0) -> Double {
        exists(key) ? defaults.double(forKey: self.key(key)) : defaultValue
    }

    func set(_ value: String, forKey key: String) {
        defaults.set(value, forKey: self.key(key))
    }

    func string(forKey key: String, default defaultValue: String = "") -> String {
        defaults.string(forKey: self.key(key)) ?? defaultValue
    }

    @discardableResult
    func set<T: Codable>(_ value: T, forKey key: String) -> Bool {
        guard let data = try? encoder.encode(value) else { return false }
        defaults.set(data, forKey: self.key(key))
        return true
    }

    func object<T: Codable>(forKey key: String, as type: T.Type, default defaultValue: T? = nil) -> T? {
        guard let data = defaults.data(forKey: self.key(key)),
              let decoded = try? decoder.decode(T.self, from: data) else {
            return defaultValue
        }
        return decoded
    }
}
/*
 USAGE EXAMPLES
 ==============
 
 // MARK: - 1. Simple flags & settings (primitives)

 let defaults = UserDefaultsManager.shared

 // Save
 defaults.set(true, forKey: "hasSeenOnboarding")
 defaults.set(3, forKey: "appLaunchCount")
 defaults.set("dark", forKey: "themeName")

 // Read (with a fallback if the key was never set)
 let hasSeenOnboarding = defaults.bool(forKey: "hasSeenOnboarding", default: false)
 let launchCount = defaults.int(forKey: "appLaunchCount", default: 0)
 let theme = defaults.string(forKey: "themeName", default: "light")

 // Increment and re-save
 defaults.set(launchCount + 1, forKey: "appLaunchCount")

 // Remove a single value
 defaults.remove("hasSeenOnboarding")

 // Check before reading
 if defaults.exists("themeName") {
     print("Theme is set")
 }

 // MARK: - 2. Saving a custom struct (Codable object)

 struct UserProfile: Codable {
     let id: String
     var name: String
     var age: Int
 }

 let profile = UserProfile(id: "u1", name: "Ahmed", age: 25)
 defaults.set(profile, forKey: "userProfile")

 if let saved = defaults.object(forKey: "userProfile", as: UserProfile.self) {
     print("Welcome back, \(saved.name)")
 }

 let profileOrDefault = defaults.object(
     forKey: "userProfile",
     as: UserProfile.self,
     default: UserProfile(id: "guest", name: "Guest", age: 0)
 )

 // MARK: - 3. Saving an array of Codable structs

 struct Task: Codable {
     let title: String
     var isDone: Bool
 }

 let tasks = [
     Task(title: "Buy milk", isDone: false),
     Task(title: "Walk dog", isDone: true)
 ]
 defaults.set(tasks, forKey: "taskList")

 let savedTasks = defaults.object(forKey: "taskList", as: [Task].self, default: [])

 // MARK: - 4. Saving a Codable enum

 enum AppTheme: String, Codable {
     case light, dark, system
 }

 defaults.set(AppTheme.dark, forKey: "appTheme")
 let currentTheme = defaults.object(forKey: "appTheme", as: AppTheme.self, default: .system)

 // MARK: - 5. Separate suite/namespace (e.g. widgets/App Groups)

 let widgetDefaults = UserDefaultsManager(
     suiteName: "group.com.yourcompany.yourapp",
     namespace: "widget"
 )
 widgetDefaults.set("Last synced 2 min ago", forKey: "widgetStatusText")
 let status = widgetDefaults.string(forKey: "widgetStatusText", default: "Not synced")

 // MARK: - 6. Clearing everything (e.g. on logout)

 defaults.clearAll() // wipes every key saved under this namespace
*/
