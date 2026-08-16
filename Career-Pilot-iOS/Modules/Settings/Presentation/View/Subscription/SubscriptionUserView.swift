//
//  MySubscriptionView.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 20/07/2026.
//

import SwiftUI

struct MySubscriptionView: View {
    @StateObject var viewModel: SubscriptionViewModel
    @EnvironmentObject var coordinator: AppCoordinator<SettingsRoute>
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: - Dynamic Palette
    private var screenBackground: Color {
        colorScheme == .dark ? Color.primaryNavy : Color.gray100
    }
    
    private var cardBackground: Color {
        colorScheme == .dark ? Color.primaryNavy : Color.white
    }
    
    private var primaryTextColor: Color {
        colorScheme == .dark ? Color.white : Color.primaryNavy
    }
    
    private var secondaryTextColor: Color {
        colorScheme == .dark ? Color.gray400 : Color.gray600
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                switch viewModel.subscribationShown {
                case .idle, .loading:
                    subscriptionSkeletonView
                    
                case .failure:
                    VStack(alignment: .center, spacing: 12) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 36))
                            .foregroundColor(Color.errorColour)
                        
                        Text("Couldn't load subscription details")
                            .font(.size16Bold)
                            .foregroundColor(Color.errorColour)
                        
                        Button("Retry") {
                            Task {
                                await viewModel.loadMySubscription()
                            }
                        }
                        .font(.size14Medium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 10)
                        .background(Capsule().fill(Color.matchAmber))
                    }
                    .frame(maxWidth: .infinity, minHeight: 250)
                    .padding(.top, 40)
                    
                case .success:
                    subscriptionContentView
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
        }
        .background(screenBackground.ignoresSafeArea())
        .navigationTitle("My Subscription")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Cancel Subscription?", isPresented: $viewModel.showCancelAlert) {
            Button("Keep Subscription", role: .cancel) {
            }
            Button("Yes, Cancel", role: .destructive) {
               
                Task {
                    await viewModel.performCancelSubscription()
                }
            }
        } message: {
            Text("Are you sure you want to cancel your subscription? You will still retain all \(viewModel.activeUserPlan.rawValue.capitalized) Plan features until \(viewModel.formattedRenewalDate).")
        }
    }
    
    // MARK: - Subscription Content View
    @ViewBuilder
    private var subscriptionContentView: some View {
        VStack(spacing: 20) {
            // Header Info Card
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .center, spacing: 14) {
                    ZStack {
                        RoundedRectangle(cornerRadius: Radius.r16)
                            .fill(
                                LinearGradient(
                                    colors: [Color.amberChipBg, Color.teal],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 54, height: 54)
                        
                        Image(systemName: "star.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text("\(viewModel.activeUserPlan.rawValue.capitalized) Plan")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(primaryTextColor)
                        
                        Text("Current Plan")
                            .font(.size13Medium)
                            .foregroundColor(secondaryTextColor)
                    }
                    
                    Spacer()
                    
                    // Status Badge (Red if Cancelled, Teal if Active)
                    HStack(spacing: 6) {
                        Circle()
                            .fill(viewModel.isCancelled ? Color.errorColour : Color.teal)
                            .frame(width: 7, height: 7)
                        
                        Text(viewModel.isCancelled ? "Cancelled" : "Active")
                            .font(.size12Bold)
                            .foregroundColor(viewModel.isCancelled ? Color.errorColour : Color.teal)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        Capsule().fill(
                            (viewModel.isCancelled ? Color.errorColour : Color.teal).opacity(0.15)
                        )
                    )
                }
                
                Divider()
                    .background(colorScheme == .dark ? Color.gray600.opacity(0.4) : Color.gray200)
                
                // Dynamic Dates
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 12) {
                        Image(systemName: "calendar")
                            .font(.system(size: 16))
                            .foregroundColor(secondaryTextColor)
                        
                        Text("Started on \(viewModel.formattedStartDate)")
                            .font(.size13Medium)
                            .foregroundColor(secondaryTextColor)
                    }
                    
                    HStack(spacing: 12) {
                        Image(systemName: "clock")
                            .font(.system(size: 16))
                            .foregroundColor(secondaryTextColor)
                        
                        Text(viewModel.isCancelled
                             ? "Access ends on \(viewModel.formattedRenewalDate)"
                             : "Renews on \(viewModel.formattedRenewalDate)")
                            .font(.size13Medium)
                            .foregroundColor(secondaryTextColor)
                    }
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: Radius.r20)
                    .fill(cardBackground)
                    .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.04), radius: 8, x: 0, y: 4)
            )
            
            // Features Included Card
            VStack(alignment: .leading, spacing: 18) {
                Text("Included in your plan")
                    .font(.size16Bold)
                    .foregroundColor(primaryTextColor)
                
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(viewModel.planFeatures, id: \.self) { feature in
                        HStack(spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 20))
                                .foregroundColor(Color.teal)
                            
                            Text(feature)
                                .font(.size14Medium)
                                .foregroundColor(primaryTextColor)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: Radius.r20)
                    .fill(cardBackground)
                    .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.04), radius: 8, x: 0, y: 4)
            )
            
            Spacer(minLength: 16)
            
            // Action Buttons
            VStack(spacing: 14) {
                // Change Plan Button
                Button(action: {
                    coordinator.push(.subscriptionPlans(vm: viewModel))
                }) {
                    Text("Change Plan")
                        .font(.size16Bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            Capsule().fill(Color.matchAmber)
                        )
                }
                
                // Top up Coins Button
                Button(action: {
                    coordinator.push(.coin)
                }) {
                    Text("Top up Coins")
                        .font(.size16Bold)
                        .foregroundColor(Color.teal)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            Capsule().fill(colorScheme == .dark ? Color.primaryTealLight.opacity(0.15) : Color.primaryTealLight)
                        )
                }
                
                // Cancel Subscription Button (Hidden once cancelled or if free)
                if !viewModel.isCancelled && viewModel.activeUserPlan != .free {
                    Button(action: {
                        // Triggers the alert dialog without running cancellation logic yet
                        viewModel.showCancelAlert = true
                    }) {
                        if viewModel.isCancelling {
                            ProgressView()
                                .tint(Color.errorColour)
                        } else {
                            Text("Cancel Subscription")
                                .font(.size14Bold)
                                .foregroundColor(Color.errorColour)
                                .padding(.top, 4)
                        }
                    }
                    .disabled(viewModel.isCancelling)
                }
            }
            .padding(.bottom, 20)
        }
    }
    
    // MARK: - Skeleton View
    private var subscriptionSkeletonView: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 14) {
                    RoundedRectangle(cornerRadius: Radius.r16)
                        .fill(Color.gray200)
                        .frame(width: 54, height: 54)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray200)
                            .frame(width: 120, height: 20)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray200)
                            .frame(width: 80, height: 14)
                    }
                    
                    Spacer()
                    
                    Capsule()
                        .fill(Color.gray200)
                        .frame(width: 70, height: 26)
                }
                
                Divider()
                    .background(Color.gray200)
                
                VStack(alignment: .leading, spacing: 10) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray200)
                        .frame(width: 200, height: 14)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray200)
                        .frame(width: 230, height: 14)
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: Radius.r20)
                    .fill(cardBackground)
            )
            
            VStack(alignment: .leading, spacing: 18) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray200)
                    .frame(width: 150, height: 16)
                
                VStack(alignment: .leading, spacing: 14) {
                    ForEach(0..<5, id: \.self) { _ in
                        HStack(spacing: 12) {
                            Circle()
                                .fill(Color.gray200)
                                .frame(width: 20, height: 20)
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.gray200)
                                .frame(height: 14)
                        }
                    }
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: Radius.r20)
                    .fill(cardBackground)
            )
            
            Spacer(minLength: 16)
            
            VStack(spacing: 14) {
                Capsule()
                    .fill(Color.gray200)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                
                Capsule()
                    .fill(Color.gray200)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
            }
            .padding(.bottom, 20)
        }
        .redacted(reason: .placeholder)
        .shimmering()
    }
}


