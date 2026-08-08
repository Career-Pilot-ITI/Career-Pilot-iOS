import SwiftUI

struct SessionHistory: View {
    let sessionCount: Int
    let sessionAvgScore: Double
    let sessions: [Session]
    let hasMore: Bool
    let onLoadMore: () -> Void

    var body: some View {
        ZStack {
            Color.lightBackGround.ignoresSafeArea()

            VStack(alignment: .leading) {
                Text("Session History")
                    .font(Font.size22Bold)
                    .foregroundStyle(Color.primaryNavy)

                Text("\(sessionCount) sessions · Avg score \(Int(sessionAvgScore))")
                    .font(Font.size14Regular)
                    .foregroundStyle(Color.gray600)
                    .padding(.bottom, 16)

                ScrollView {
                   VStack(alignment: .leading, spacing: Spacing.s20) {
                       SessionHistoryListView(sessions: sessions)

                       if hasMore {
                           Button(action: onLoadMore) {
                               Text("Load More")
                                   .font(Font.size14Regular)
                                   .frame(maxWidth: .infinity)
                                   .padding(.vertical, 12)
                           }
                           .buttonStyle(.bordered)
                           .padding(.top, 8)
                       } else if !sessions.isEmpty {
                           Text("You've seen all sessions")
                               .font(Font.size14Regular)
                               .foregroundStyle(Color.gray600)
                               .frame(maxWidth: .infinity)
                               .padding(.vertical, 12)
                       }
                   }
               }
            }
            .padding(.top, 16)
            .padding(.horizontal, 24)
        }
    }
}
