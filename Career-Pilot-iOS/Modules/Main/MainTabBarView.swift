import SwiftUI

struct MainTabBarView: View {
    @StateObject private var homeCoordinator = AppCoordinator<HomeRoute>()
    var body: some View {
        TabView {
            // Tab 1: Home
            NavigationStack(path: $homeCoordinator.path) {
                HomeView()
                    .navigationDestination(for: HomeRoute.self) { route in
                        switch route {
                        case .sessionDetail(let metrics, let suggestions):
                            Text("Session Detail View")
                            
                        case .interviewPrep(let trackName, let interviewTime, let questionsCount):
                            InterviewPrepContainerView(
                                trackName: trackName,
                                interviewTime: interviewTime,
                                quetionsCount: questionsCount
                            ).toolbar(.hidden, for: .tabBar)
                        }
                      }
                    }
                    .tabItem {
                        Label { Text("Home") } icon: { Image.AppIcon.home.renderingMode(.template) }
                    }
                    .environmentObject(homeCoordinator)

            // Tab 2: Practice
            PracticeSessionView(vm: DIContainer.shared.container.resolve(PracticeSessionViewModel.self)!)
                .tabItem {
                    Label { Text("Practice") } icon: { Image.AppIcon.mic.renderingMode(.template) }
                }
            
            // Tab 3: Reports
            ReportsView()
                .tabItem {
                    Label { Text("Reports") } icon: { Image.AppIcon.report.renderingMode(.template) }
                }
            
            // Tab 4: Settings
            SettingsView()
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
