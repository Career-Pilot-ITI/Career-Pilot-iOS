import SwiftUI

struct MainTabBarView: View {
    @StateObject private var homeCoordinator: AppCoordinator<HomeRoute> = AppCoordinator<HomeRoute>()
    var body: some View {
        TabView {
            // Tab 1: Home
            NavigationStack(path: $homeCoordinator.path) {
                HomeView()
                    .navigationDestination(for: HomeRoute.self) { route in
                        switch route {
                        case .sessionDetail(let metrics, let suggestions):
                            Text("Session Detail View")
                            
                        case let .interviewPrep(trackName, trackId, interviewType):
                            InterviewPrepContainerView(trackName: trackName, trackId: trackId, interviewType: interviewType)
                        case let .practiceInterview(_, trackId, interviewType):
                            PracticeSessionView(
                                vm: DIContainer.shared.container.resolve(PracticeSessionViewModel.self)!,
                                trackId: trackId,
                                interviewType: interviewType
                            )
                        case .InterviewsView:
                            InterviewsView()
                        case .sessionFeedback(let feedBack, let sessionId):
                            SessionFeedBackView(feedback: feedBack,sessionId: sessionId)
                        }
                    }
            }
            .tabItem {
                Label { Text("Home") } icon: { Image.AppIcon.home.renderingMode(.template) }
            }
            .environmentObject(homeCoordinator) 

            
            // Tab 2: Reports
            ReportsView()
                .tabItem {
                    Label { Text("Reports") } icon: { Image.AppIcon.report.renderingMode(.template) }
                }
            
            // Tab 3: Settings
            SettingsTabView()
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
