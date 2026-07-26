//
//  SessionHistroyItem.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 19/07/2026.
//

import SwiftUI

struct Session: Identifiable , Hashable {
    let id: Int
    let title: String
    let score: Double
    let noOfQuestions: Int
    let perioudTime: String
    let date: String
}

struct SessionHistroyItem: View {
    let session : Session
    var color : Color {
        switch session.score {
        case 0..<50:
            return Color.red
        case 50..<80:
            return Color.primaryYellow
        case 80...100:
            return Color.successColour
        default :
            return Color.gray
        }
    }
    var body: some View {
        HStack() {
            Text("\(Int(session.score))")
                .foregroundStyle(color)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background {
                    RoundedRectangle(cornerRadius: 	Radius.r13)
                        .fill(color)
                        .opacity(0.08)
                }
                .padding(.trailing, 12)
            
            VStack(alignment: .leading,spacing: Spacing.s4) {
                Text(session.title)
                    .font(Font.size14Bold)
                    .foregroundStyle(Color.primaryNavy)
                
                Text("\(session.date) · \(session.perioudTime) · \(session.noOfQuestions) questions")
                    .font(Font.size12Medium)
                    .foregroundStyle(Color.gray400)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 18))
                .foregroundStyle(Color.gray400)
        }
        .padding(.all, 16)
        .background {
            RoundedRectangle(cornerRadius: Radius.r16)
                .fill(.white)
        }
    }
}
//
//#Preview {
//    ZStack() {
//        Color.lightBackGround
//        VStack {
//            Spacer()
//            SessionHistroyItem(
//                session: Session(
//                    title: "Behavioral Interview",
//                    score: 82,
//                    noOfQuestions: 5,
//                    perioudTime: "12 min",
//                    date: "Today, 2:14 PM"
//                )
//            )
//            Spacer()
//        }
//        .padding(.horizontal, 24)
//    }
//
//}
