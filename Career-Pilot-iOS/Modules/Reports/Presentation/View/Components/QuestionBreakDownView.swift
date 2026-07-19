//
//  QuestionBreakDownView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 19/07/2026.
//

import SwiftUI

struct QuestionBreakDownView: View {
    var body: some View {
        HStack() {
            Image(systemName: "doc.text")
                .font(.system(size: 18))
                .foregroundStyle(Color.activeColour)
                .padding(.trailing,12)
                
            Text("View per-question breakdown")
                .font(Font.size16SemiBold)
                .foregroundStyle(Color.primaryNavy)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 18))
                .foregroundStyle(Color.gray400)
            
        }
        .padding(.all,16)
        .background {
            RoundedRectangle(cornerRadius: Radius.r16)
                .fill(.white)
        }
    }
}

#Preview {
    ZStack() {
        Color.lightBackGround
        VStack {
            Spacer()
            QuestionBreakDownView()
            Spacer()
        }
        .padding(.horizontal, 24)
    }
}
