//
//  AcoountSettingsView.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 15/07/2026.
//

import SwiftUI

struct AccountItem {
    let icon: String
    let title: String
    let subtitle: String
    let route : AppRoute
}
struct AccountSettingsView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    let items: [AccountItem] = [
        AccountItem(icon: "Subscription", title: "Subscription", subtitle: "Free · 3 sessions/mo",route: .subscribtion ),
        AccountItem(icon: "Favourite", title: "Coin Balance", subtitle: "247 coins" , route: .coin),
        AccountItem(icon: "notifiaction", title: "Notifications", subtitle: "Reminders on" , route: .coin)
       ]
       
       var body: some View {
           VStack(spacing: 0) {
               ForEach(items.indices, id: \.self) { index in
                   SettingsCard(leadingIcon: items[index].icon, title: items[index].title, subtitle: items[index].subtitle).onTapGesture(perform: {
                       coordinator.push(items[index].route)
                   })
                   
                   if index != items.count - 1 {
                       Rectangle().fill(Color.gray100).frame(height: 1)
                   }
               }
           }
           .padding(.horizontal, Spacing.s32)
                   .padding(.vertical, Spacing.s8)
                   .background(
                       RoundedRectangle(cornerRadius: Radius.r24)
                           .fill(Color.white)
                   )
       }
}

