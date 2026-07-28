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
    @Published private(set) var validationState: PhoneValidationState = .idle
    
    private var cancellables = Set<AnyCancellable>()
    
    init(selectedCountry: CountryCode = CountryCode.defaultList[0]) {
        self.selectedCountry = selectedCountry
        setupValidationPipeline()
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
    
    // MARK: - Reactive Validation
    
    private func setupValidationPipeline() {
        // Combine phoneNumber and selectedCountry into a single stream,
        // debounce to avoid validating on every keystroke.
        Publishers.CombineLatest($phoneNumber, $selectedCountry)
            .debounce(for: .milliseconds(400), scheduler: RunLoop.main)
            .map { number, country in
                guard !number.isEmpty else {
                    return .idle
                }
                return PhoneValidator.validate(number: number, for: country)
            }
            .assign(to: &$validationState)
    }
}

