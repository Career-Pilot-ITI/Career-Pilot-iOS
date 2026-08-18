//
//  AppStrings.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 15/07/2026.
//

import Foundation

enum AppStrings {

    // Generic helper so every string below stays one line.
    private static func t(_ key: String, _ comment: String = "") -> String {
        NSLocalizedString(key, comment: comment)
    }

    enum Common {
        static let cancel = t("common.cancel", "Cancel button")
        static let done = t("common.done", "Done button")
        static let ok = t("common.ok", "OK button")
    }

    enum PhoneField {
        static let placeholder = t("phone_field.placeholder", "Placeholder for phone input")
        static let errorInvalid  = t("phone_field.error_invalid", "Shown when phone number fails validation")
        static let helperDefault = t("phone_field.helper_default", "Default helper text under the field")
        static let selectCountry = t("phone_field.select_country", "Country picker title")
    }
}
