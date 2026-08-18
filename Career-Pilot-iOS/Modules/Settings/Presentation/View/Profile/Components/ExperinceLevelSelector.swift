import SwiftUI

struct ExperienceLevelSelector: View {
    let options = ["Junior", "Mid-Level", "Senior"]
    @Binding var selected: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image("experienceLevel")
                .frame(width: 44, height: 44)
                .background(
                    RoundedRectangle(cornerRadius: Radius.r12)
                        .fill(Color.primary.opacity(0.6))
                )
            
            VStack(alignment: .leading, spacing: 8) {
                Text("EXPERIENCE LEVEL")
                    .font(.caption.bold())
                    .foregroundColor(.gray400)
                
                HStack(spacing: 6) {
                    ForEach(options, id: \.self) { option in
                        Text(option)
                            .font(.size13Medium.bold())
                            .lineLimit(1)
                            .minimumScaleFactor(0.8) // Shrinks slightly if screen is very narrow
                            .foregroundColor(selected == option ? .white : .gray400)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity) // Makes all 3 pills equal width & fill space
                            .background(
                                Capsule()
                                    .fill(selected == option ? Color.primary : Color.gray100)
                            )
                            .onTapGesture {
                                selected = option
                            }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
