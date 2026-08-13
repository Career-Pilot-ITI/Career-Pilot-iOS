//
//  SupportAndLeagalSettingsView.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 15/07/2026.
//

import SwiftUI
struct SupportItem {
    let icon: String
    let title: String
    let subtitle: String
}
struct SupportAndLeagalSettingsView: View {
    let items: [SupportItem] = [
        SupportItem(icon: "Privacy", title: "Subscription", subtitle: ""),
        SupportItem(icon: "paper", title: "Terms of Service", subtitle: ""),
        SupportItem(icon: "HelpandSupport", title: "Help & Support", subtitle: "")
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
                        .fill(Color.gray400.opacity(0.08))
                )
              
    }
}

//struct SupportAndLeagalSettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SupportAndLeagalSettingsView()
//    }
//}
