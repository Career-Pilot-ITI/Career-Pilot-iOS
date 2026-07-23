import SwiftUI

struct MainTabBarView: View {
    var body: some View {
        TabView {
            // Tab 1: Home
            HomeView()
                .tabItem {
                    Label { Text("Home") } icon: { Image.AppIcon.home.renderingMode(.template) }
                }
            
            // Tab 2: Practice
            PracticeSessionView()
                .tabItem {
                    Label { Text("Practice") } icon: { Image.AppIcon.mic.renderingMode(.template) }
                }
            
            // Tab 3: Reports
            ReportsView()
                .tabItem {
                    Label { Text("Reports") } icon: { Image.AppIcon.report.renderingMode(.template) }
                }
            
            // Tab 4: Settings
            SettingsVIew()
                .tabItem {
                    Label { Text("Settings") } icon: { Image.AppIcon.settings.renderingMode(.template) }
                }
        }
        .tint(Color.primary)
    }
}

//#Preview {
//    MainTabBarView()
//}
