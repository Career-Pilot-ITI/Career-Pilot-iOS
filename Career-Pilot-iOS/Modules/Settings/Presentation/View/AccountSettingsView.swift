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
}
struct AccountSettingsView: View {
    let items: [AccountItem] = [
           AccountItem(icon: "Subscription", title: "Subscription", subtitle: "Free · 3 sessions/mo"),
           AccountItem(icon: "Favourite", title: "Coin Balance", subtitle: "247 coins"),
           AccountItem(icon: "notifiaction", title: "Notifications", subtitle: "Reminders on")
       ]
       
       var body: some View {
           VStack(spacing: 0) {
               ForEach(items.indices, id: \.self) { index in
                   SettingsCard(leadingIcon: items[index].icon, title: items[index].title, subtitle: items[index].subtitle)
                   
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

