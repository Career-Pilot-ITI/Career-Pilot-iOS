//
//  Date+Formatting.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 26/07/2026.
//

import Foundation

extension Date {
    /// Returns "Today", "Yesterday", or a formatted date like "Mon 8 Jul"
    func formattedRelative(calendar: Calendar = .current) -> String {
        if calendar.isDateInToday(self) {
            return "Today"
        }
        if calendar.isDateInYesterday(self) {
            return "Yesterday"
        }
        return Self.relativeFormatter.string(from: self)
    }

    private static let relativeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE d MMM" 
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
