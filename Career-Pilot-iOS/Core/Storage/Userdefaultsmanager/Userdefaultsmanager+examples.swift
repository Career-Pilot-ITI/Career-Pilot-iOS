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
