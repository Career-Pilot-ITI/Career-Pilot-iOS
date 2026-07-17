//
//  PhoneFieldViewModel.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 15/07/2026.
//

import SwiftUI
import Combine

class PhoneFieldViewModel: ObservableObject {
    @Published var phoneNumber: String = ""
    @Published var selectedCountry: CountryCode
    @Published var hasBeenEdited: Bool = false
    
    init(selectedCountry: CountryCode) {
        self.selectedCountry = selectedCountry
    }
    
    var isValid: Bool {
        PhoneValidator.isValid(number: phoneNumber, for: selectedCountry)
    }
    
    var canProceed: Bool {
        !phoneNumber.isEmpty && isValid
    }
    
    func formatNumber() -> String {
        PhoneValidator.format(phoneNumber)
    }
    
    func updatePhone(_ newValue: String) {
        let digits = newValue.filter(\.isNumber)
        phoneNumber = String(digits.prefix(selectedCountry.maxLength))
        hasBeenEdited = true
    }
    
    func rawPhoneNumber() -> String {
        return selectedCountry.dialCode + phoneNumber
    }
    
    func markAsEditedIfNeeded() {
        if !hasBeenEdited {
            hasBeenEdited = true
        }
    }
}
