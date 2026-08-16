//
//  SubscriptionView.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 16/08/2026.
//

import SwiftUI

struct SubscriptionView: View {
    @StateObject var viewModel: SubscriptionViewModel
    @EnvironmentObject var coordinator: AppCoordinator<SettingsRoute>
    
    var body: some View {
        Group {
            switch viewModel.subscribationShown {
            case .idle, .loading:
                ProgressView()
                
            case .failure:
                RetryableErrorView(
                        title: "Couldn't load subscription details",
                        message: "Please check your connection and try again.",
                        onRetry: {
                            Task { await viewModel.loadMySubscription() }
                        }
                    )
            case .success(let info):
                if info.tier == .free {
                    ChoosePlanView(viewModel: viewModel)
                } else {
                    MySubscriptionView(viewModel: viewModel)
                }
            }
        }
        .task {
            await viewModel.loadMySubscription()
        
            
        }
    }
}
