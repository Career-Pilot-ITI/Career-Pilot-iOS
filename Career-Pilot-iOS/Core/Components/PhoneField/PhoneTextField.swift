//
//  PhoneTextField.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 15/07/2026.

import SwiftUI

struct PhoneTextField: View {
    @ObservedObject var viewModel: PhoneFieldViewModel
    @FocusState private var isFieldFocused: Bool
    
    var isDisabled: Bool = false
    var isLoading: Bool = false
    var placeholder: String = AppStrings.PhoneField.placeholder
    @State private var showCountryPicker: Bool = false

    private var currentState: PhoneFieldState {
        if isDisabled { return .disabled }
        if isLoading { return .loading }
        if isFieldFocused { return .focused }
        if !viewModel.hasBeenEdited { return .idle }
        return viewModel.isValid ? .valid : .invalid
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("PHONE NUMBER")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(AppColors.secondaryText)
                .padding(.leading, 4)
            
            HStack(spacing: 8) {
                countrySelectionButton
                Divider().frame(height: 20)
                
                TextField(placeholder, text: Binding(
                    get: { viewModel.formatNumber() },
                    set: { viewModel.updatePhone($0) }
                ))
                .keyboardType(.numberPad)
                .focused($isFieldFocused)
                .disabled(isDisabled || isLoading)
                
                trailingIcon
            }
            .padding(12)
            .background(RoundedRectangle(cornerRadius: 10).fill(isDisabled ? AppColors.PhoneField.backgroundDisabled : AppColors.PhoneField.background))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(currentState.borderColor, lineWidth: currentState.borderWidth))
            
            if currentState == .invalid && !isFieldFocused {
                Label(AppStrings.PhoneField.errorInvalid, systemImage: "exclamationmark.circle.fill")
                    .foregroundColor(AppColors.error)
                    .font(.caption)
            }
        }
        .sheet(isPresented: $showCountryPicker) {
            CountryPickerSheet(countries: CountryCode.defaultList, selected: $viewModel.selectedCountry, isPresented: $showCountryPicker)
        }
    }
    
    @ViewBuilder
    private var trailingIcon: some View {
        switch currentState {
        case .loading: ProgressView().scaleEffect(0.8)
        case .valid: Image(systemName: "checkmark.circle.fill").foregroundColor(AppColors.PhoneField.iconValid)
        case .invalid: Image(systemName: "xmark.circle.fill").foregroundColor(AppColors.PhoneField.iconInvalid)
        default: EmptyView()
        }
    }
    
    private var countrySelectionButton: some View {
        Button { showCountryPicker = true } label: {
            HStack(spacing: 4) {
                Text(viewModel.selectedCountry.flag)
                Text(viewModel.selectedCountry.dialCode)
                Image(systemName: "chevron.down").font(.caption2)
            }
            .foregroundColor(isDisabled ? AppColors.secondaryText.opacity(0.5) : AppColors.primaryText)
        }
        .disabled(isDisabled || isLoading)
    }
}
