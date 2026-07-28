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
        VStack(alignment: .leading, spacing: 8) {
            Text("PHONE NUMBER")
                .font(.size12Bold)
                .foregroundColor(Color.gray400)
                .padding(.leading, 4)
            
            HStack(spacing: 8) {
                countrySelectionButton
                    .padding(.all , 16)
                
               
                Divider()
                    .frame(width:2,height: 59)
                    .background(Color.gray400)
               
                
                TextField(placeholder, text: Binding(
                    get: { viewModel.formatNumber() },
                    set: { viewModel.updatePhone($0) }
                ), prompt: Text(placeholder)
                    .foregroundColor(Color.gray400)
                    .font(.size16Regular)
                )
                .foregroundStyle(.white)
                .keyboardType(.numberPad)
                .focused($isFieldFocused)
                .disabled(isDisabled || isLoading)
                .padding(.all , 16)
                
                trailingIcon
            }
            .background(RoundedRectangle(cornerRadius: 16).fill(isDisabled ? AppColors.PhoneField.backgroundDisabled : AppColors.PhoneField.background))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(currentState.borderColor, lineWidth: currentState.borderWidth))
            
            if viewModel.hasBeenEdited {
                HStack(spacing: 4) {
                    if viewModel.validationState == .valid {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(viewModel.validationState.color)
                    } else if viewModel.validationState != .idle {
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundColor(viewModel.validationState.color)
                    }
                    Text(viewModel.validationState.message)
                        .foregroundColor(viewModel.validationState.color)
                        .font(.caption)
                }
                .animation(.easeInOut(duration: 0.2), value: viewModel.validationState)
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
            HStack(spacing: 8) {
                Text(viewModel.selectedCountry.flag)
                Text(viewModel.selectedCountry.dialCode)
                    .font(.size14Semibold)
                    .foregroundStyle(.white)
                Image(systemName: "chevron.down").font(.caption2)
                    .foregroundColor(Color.gray400)
            }
            .foregroundColor(isDisabled ? AppColors.secondaryText.opacity(0.5) : AppColors.primaryText)
        }
        .disabled(isDisabled || isLoading)
    }
}

//
//#Preview {
//    ZStack {
//        Color.darkBackGround.ignoresSafeArea()
//        
//        PhoneTextField(viewModel: PhoneFieldViewModel(selectedCountry: CountryCode.defaultList[0]))
//            .padding(.horizontal, 16)
//    }
//}
