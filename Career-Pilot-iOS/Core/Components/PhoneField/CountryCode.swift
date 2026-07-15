//
//  CountryCode.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 15/07/2026.
//

import Foundation

struct CountryCode: Identifiable, Equatable {
    let id = UUID()
    let flag: String
    let dialCode: String
    let name: String
    let minLength: Int
    let maxLength: Int

    static let defaultList: [CountryCode] = [
        CountryCode(flag: "🇪🇬", dialCode: "+20", name: "Egypt", minLength: 7, maxLength: 10),
        CountryCode(flag: "🇺🇸", dialCode: "+1", name: "United States", minLength: 10, maxLength: 10)
    ]
}
//struct CountryCode: Identifiable, Equatable {
//    let id = UUID()
//    let flag: String
//    let dialCode: String
//    let name: String
//
//    
//    static let defaultList: [CountryCode] = [
//        CountryCode(flag: "🇪🇬", dialCode: "+20", name: "Egypt"),
//        CountryCode(flag: "🇺🇸", dialCode: "+1",  name: "United States"),
//        CountryCode(flag: "🇬🇧", dialCode: "+44", name: "United Kingdom"),
//        CountryCode(flag: "🇸🇦", dialCode: "+966", name: "Saudi Arabia"),
//        CountryCode(flag: "🇦🇪", dialCode: "+971", name: "UAE"),
//    ]
//}

