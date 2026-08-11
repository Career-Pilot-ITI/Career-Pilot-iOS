//
//  AcoountSettingsView.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 15/07/2026.
//

import SwiftUI
import Combine
struct AccountItem {
    let icon: String
    let title: String
    let subtitle: String
    let route : SettingsRoute
}
struct AccountSettingsView: View {
    var user: UserModelSettingsView
        
        @EnvironmentObject var coordinator: AppCoordinator<SettingsRoute>
        
        init(user: UserModelSettingsView) {
            self.user = user
        }
        
        var items: [AccountItem] {
            [
                AccountItem(icon: "Subscription", title: "Subscription", subtitle: "\(user.subscriptionPlan)", route: .subscribtion),
                AccountItem(icon: "Favourite", title: "Coin Balance", subtitle: "\(user.coinBalance)", route: .coin)
            ]
        }

       
       var body: some View {
           VStack(spacing: 0) {
               ForEach(items.indices, id: \.self) { index in
                   SettingsCard(leadingIcon: items[index].icon, title: items[index].title, subtitle: items[index].subtitle).contentShape(Rectangle()).onTapGesture(perform: {
                       coordinator.push(items[index].route)
                   })
                   
                   if index != items.count - 1 {
                       Rectangle().fill(Color.gray100).frame(height: 1)
                   }
               }
           }
           .padding(.horizontal, Spacing.s16)
                   .padding(.vertical, Spacing.s8)
                   .background(
                       RoundedRectangle(cornerRadius: Radius.r24)
                           .fill(Color.white)
                   )
       }
}

