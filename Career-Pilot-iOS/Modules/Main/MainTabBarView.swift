import SwiftUI

enum Tab: Int, Hashable {
    case home
    case reports
    case settings
}

@MainActor
struct MainTabBarView: View {
    @StateObject private var homeCoordinator: AppCoordinator<HomeRoute> = AppCoordinator<HomeRoute>()
    @State private var selectedTab: Tab = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            // Tab 1: Home
            NavigationStack(path: $homeCoordinator.path) {

                HomeView(onSeeAllSessionsTapped: {
                    selectedTab = .reports
                })
                .navigationDestination(for: HomeRoute.self) { route in
                    switch route {
                    case .sessionDetail(let sessionId):
                        SessionView(
                            sessionId: sessionId,
                            viewModel: DIContainer.shared.container.resolve(SessionDetailViewModel.self, argument: sessionId)!
                        )
                        
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
                        SessionFeedBackView(feedback: feedBack, sessionId: sessionId) {
                            homeCoordinator.popToRoot()
                        }
                        .navigationBarBackButtonHidden()
                    case .subscribtion:
                        ChoosePlanView(viewModel: DIContainer.shared.container.resolve(SubscriptionViewModel.self)!)
                    }
                }
            }
            .tabItem {
                Label { Text("Home") } icon: { Image.AppIcon.home.renderingMode(.template) }
            }
            .tag(Tab.home)
            .environmentObject(homeCoordinator)

            // Tab 2: Reports
            ReportsView()
                .tabItem {
                    Label { Text("Reports") } icon: { Image.AppIcon.report.renderingMode(.template) }
                }
                .tag(Tab.reports)
            
            // Tab 3: Settings
            SettingsTabView()
                .tabItem {
                    Label { Text("Settings") } icon: { Image.AppIcon.settings.renderingMode(.template) }
                }
                .tag(Tab.settings)
        }
        .tint(Color.primary)
    }
}
