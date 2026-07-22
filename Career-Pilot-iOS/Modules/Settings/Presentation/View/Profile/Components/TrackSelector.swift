//
//  TrackSelector.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 17/07/2026.
//

import SwiftUI

struct TrackSelector: View {
    let options = [ "Software Engineering", "Product Management", "Data Science" ]
    @Binding var selected: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "brain.head.profile")
                .foregroundColor(.primaryNavy)
                .frame(width: 44, height: 44)
                .background(
                    RoundedRectangle(cornerRadius: Radius.lg)
                        .fill(Color.primaryNavy.opacity(0.06))
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text("TRACK")
                    .font(.caption.bold())
                    .foregroundColor(.gray400)
                
                Menu {
                    ForEach(options, id: \.self) { option in
                        Button(option) {
                            selected = option
                        }
                    }
                } label: {
                    HStack {
                        Text(selected)
                            .font(.bodyApp.bold())
                            .foregroundColor(.primaryNavy)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.gray400)
                            .font(.caption.bold())
                    }
                }
            }
        }
    }
}


