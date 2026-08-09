//
//  CustomNavigationBar.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 16/07/2026.
//

import SwiftUI

struct CustomNavigationBar: View {
    let userName: String
    let userScore: Int
    
    var body: some View {
        HStack {
            VStack(alignment:.leading,spacing: 4) {
                Text("Good morning 👋")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text(userName)
                    .font(.title3)
                    .lineLimit(1)
                    .fontWeight(.bold)
            }
            
            Spacer()
            
            HStack(alignment: .bottom,spacing:12){
                
                HStack(spacing: 4) {
                    Image.AppIcon.star
                        .foregroundColor(.primary)
                    
                    Text("\(userScore)")
                        .fontWeight(.semibold)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(.primary.opacity(0.1))
                .cornerRadius(20)
                
                // Notification Button
//                Button(action: {
//                    print("Notifications tapped")
//                }) {
//                    Image.AppIcon.bell
//                    .font(.title3)
//                        .foregroundColor(.gray)
//                        .padding(8)
//                        .background(Color.gray.opacity(0.1))
//                        .clipShape(Circle())
//                }
            }.padding(.horizontal)
        }
    }
}

//#Preview {
//    CustomNavigationBar(userName: "Ahmed El-Sayyad Mohamed", userScore: 247)
//}
