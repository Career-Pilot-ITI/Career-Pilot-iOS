import SwiftUI

enum Tab: Int, Hashable {
    case home
    case reports
    case settings
}

@MainActor
struct MainTabBarView: View {
    @StateObject private var homeCoordinator: AppCoordinator<HomeRoute> = AppCoordinator<HomeRoute>()
    @StateObject private var settingsCoordinator: AppCoordinator<SettingsRoute> = AppCoordinator<SettingsRoute>()

    @StateObject private var atsViewModel: ATSViewModel = DIContainer.shared.container.resolve(ATSViewModel.self)!
    @StateObject private var cvOptimizeViewModel: CvOptimizeViewModel = DIContainer.shared.container.resolve(CvOptimizeViewModel.self)!
    @State private var settingsDeepLink: SettingsRoute?
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
                        InterviewPrepContainerView(
                            trackName: trackName,
                            trackId: trackId,
                            interviewType: interviewType
                        )
                        
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
                            selectedTab = .settings
                        })
                        
                    case .cvOptimizeProgress:
                        CvOptimizeProgressView()
                        
                    case .cvOptimizeResults:
                        CvOptimizeResultsView()
                        
                    case .subscribtion, .subscriptionView:
                        ChoosePlanView(
                            viewModel: DIContainer.shared.container.resolve(SubscriptionViewModel.self)!
                        )
                        
                    case .checkout(let item):
                        CheckOutView(
                            checkoutDisplayInfo: item,
                            paymentVM: DIContainer.shared.container.resolve(PaymentViewModel.self)!
                        ) {
                            homeCoordinator.popToRoot()
                        }
                    }
                }
            }
            .tabItem {
                Label { Text("Home") } icon: { Image.AppIcon.home.renderingMode(.template) }
            }
            .tag(Tab.home)
            .environmentObject(homeCoordinator)
            .environmentObject(settingsCoordinator)
            .environmentObject(atsViewModel)
            .environmentObject(cvOptimizeViewModel)

            // Tab 2: Reports
            ReportsView()
                .tabItem {
                    Label { Text("Reports") } icon: { Image.AppIcon.report.renderingMode(.template) }
                }
                .tag(Tab.reports)

            // Tab 3: Settings
            SettingsTabView(deepLink: $settingsDeepLink)
                .tabItem {
                    Label { Text("Settings") } icon: { Image.AppIcon.settings.renderingMode(.template) }
                }
                .tag(Tab.settings)
        }
        .tint(Color.primary)
    }
}