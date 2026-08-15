import SwiftUI

struct MainTabBarView: View {
    @StateObject private var homeCoordinator: AppCoordinator<HomeRoute> = AppCoordinator<HomeRoute>()
    @StateObject private var atsViewModel: ATSViewModel = DIContainer.shared.container.resolve(ATSViewModel.self)!
    @StateObject private var cvOptimizeViewModel: CvOptimizeViewModel = DIContainer.shared.container.resolve(CvOptimizeViewModel.self)!
    @State private var selectedTab = 0
    @State private var settingsDeepLink: SettingsRoute?
    var body: some View {
        TabView(selection: $selectedTab) {
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
                        case .atsJobMatch:
                            ATSJobMatchView()
                        case .atsjobDescription:
                            JobDescriptionView()
                        case .coverLetter:
                            CoverLetterView()
                        case .atsJobmatchScore:
                            JobMatchView(onBuyCoins: {
                                homeCoordinator.popToRoot()
                                settingsDeepLink = .coin
                                selectedTab = 2
                            })
                        case .cvOptimizeProgress:
                            CvOptimizeProgressView()
                        case .cvOptimizeResults:
                            CvOptimizeResultsView()
                        }
                    }
            }
            .tabItem {
                Label { Text("Home") } icon: { Image.AppIcon.home.renderingMode(.template) }
            }
            .tag(0)
            .environmentObject(homeCoordinator)
            .environmentObject(atsViewModel)
            .environmentObject(cvOptimizeViewModel)

            
            // Tab 2: Reports
            ReportsView()
            .tabItem {
                Label { Text("Reports") } icon: { Image.AppIcon.report.renderingMode(.template) }
            }
            .tag(1)
            
            // Tab 3: Settings
            SettingsTabView(deepLink: $settingsDeepLink)
                .tabItem {
                    Label { Text("Settings") } icon: { Image.AppIcon.settings.renderingMode(.template) }
                }
                .tag(2)
        }
        .tint(Color.primary)
    }
}

//#Preview {
//    MainTabBarView()
//}
