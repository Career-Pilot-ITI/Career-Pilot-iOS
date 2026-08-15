//
//  MainTabBarView.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 14/08/2026.
//

import SwiftUI

enum Tab: Int, Hashable {
    case home
    case reports
    case settings
}

@MainActor
struct MainTabBarView: View {
    @StateObject private var homeCoordinator = AppCoordinator<HomeRoute>()
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // MARK: - Tab 1: Home
            NavigationStack(path: $homeCoordinator.path) {
                HomeView(onSeeAllSessionsTapped: {
                    selectedTab = .reports
                })
                .navigationDestination(for: HomeRoute.self) { route in
                    destinationView(for: route)
                }
            }
            .environmentObject(homeCoordinator)
            .tabItem {
                Label {
                    Text("Home")
                } icon: {
                    Image.AppIcon.home.renderingMode(.template)
                }
            }
            .tag(Tab.home)
            
            // MARK: - Tab 2: Reports
            NavigationStack {
                ReportsView()
            }
            .tabItem {
                Label {
                    Text("Reports")
                } icon: {
                    Image.AppIcon.report.renderingMode(.template)
                }
            }
            .tag(Tab.reports)
            
            // MARK: - Tab 3: Settings
            NavigationStack {
                SettingsTabView()
            }
            .tabItem {
                Label {
                    Text("Settings")
                } icon: {
                    Image.AppIcon.settings.renderingMode(.template)
                }
            }
            .tag(Tab.settings)
        }
        .tint(Color.primary)
    }
}

// MARK: - Route Destination Builder
private extension MainTabBarView {
    @ViewBuilder
    func destinationView(for route: HomeRoute) -> some View {
        switch route {
        case .sessionDetail(let metrics, let suggestions):
            Text("Session Detail View")
                
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
            
        case .sessionFeedback(let feedback, let sessionId):
            SessionFeedBackView(feedback: feedback, sessionId: sessionId) {
                homeCoordinator.popToRoot()
            }
            .navigationBarBackButtonHidden()
            
        case let .pathLearn(trackId, trackName):
            PathLearnView(
                viewModel: DIContainer.shared.container.resolve(
                    PathLearnViewModel.self,
                    arguments: String(trackId), trackName
                )!
            )
            
        case let .quiz(trackId, trackTitle, subtopicId, subtopicTitle):
            QuizView(
                viewModel: DIContainer.shared.container.resolve(
                    QuizViewModel.self,
                    arguments: trackId, trackTitle, subtopicId, subtopicTitle
                )!
            )
        }
    }
}
