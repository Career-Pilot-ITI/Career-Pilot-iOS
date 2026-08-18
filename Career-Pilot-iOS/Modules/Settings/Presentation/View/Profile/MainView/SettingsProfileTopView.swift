//
//  SettingsProfileTopView.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 16/07/2026.
//

import SwiftUI

struct SettingsProfileTopView: View {
    var title: String = "Profile Settings"
    var isSaveEnabled: Bool
    var onBack: (() -> Void)? = nil
    var onSave: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            if let onBack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                        .frame(width: 36, height: 36)
                        .background(
                            Circle()
                                .fill(Color(.secondarySystemBackground))
                        )
                }
            }

            Text(title)
                .font(.title3.bold())

            Spacer()

            Button(action: onSave) {
                Text("Save")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(isSaveEnabled ? .white : .secondary)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(isSaveEnabled ? Color.accentColor : Color(.systemGray5))
                    )
            }
            .disabled(!isSaveEnabled)
            .animation(.easeInOut(duration: 0.2), value: isSaveEnabled)
        }
        .padding(.vertical, 12)
    }
}

//struct SettingsProfileTopView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsProfileTopView()
//    }
//}
