//
//  PracticeCard.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 16/07/2026.
//
import SwiftUI

struct PracticeCard: View {
    let category: String
    let onStartInterview: () -> Void
    let onStartQuiz: () -> Void
    
    @State private var showEntryOptions = false

    var body: some View {
        Button(action: { showEntryOptions = true }) {
            HStack {
                Image(systemName: "mic.fill")
                    .foregroundColor(Color.primary)
                    .padding()
                    .background(Color.primary.opacity(0.2))
                    .cornerRadius(12)
                
                VStack(alignment: .leading) {
                    Text(category)
                        .font(.caption2)
                        .opacity(0.8)
                    Text("Practice Interview")
                        .font(.headline)
                }
                
                Spacer()
                
                Image(systemName: "arrow.right")
                    .padding(10)
                    .background(Color.primary)
                    .cornerRadius(8)
            }
            .padding()
            .background(Color(red: 0.1, green: 0.15, blue: 0.3))
            .foregroundColor(.white)
            .cornerRadius(16)
        }
        .confirmationDialog(
            "Start \(category)",
            isPresented: $showEntryOptions,
            titleVisibility: .visible
        ) {
            Button("Interview") { onStartInterview() }
            Button("Quiz Path") { onStartQuiz() }
            Button("Cancel", role: .cancel) {}
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        PracticeCard(
            category: "SOFTWARE ENGINEERING",
            onStartInterview: { print("Start Interview") },
            onStartQuiz: { print("Start Quiz") }
        )
        .padding()
    }
}
//#Preview {
//    PracticeCard(category: "SOFTWARE ENGINEERING")
//}
