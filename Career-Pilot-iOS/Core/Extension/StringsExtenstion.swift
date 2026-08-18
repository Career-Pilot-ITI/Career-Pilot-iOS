//
//  StringsExtenstion.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 21/07/2026.
//

import Foundation
extension String {
    func removingLeadingPlus() -> String {
        if self.hasPrefix("+") {
            return String(self.dropFirst())
        }
        return self
    }
}
