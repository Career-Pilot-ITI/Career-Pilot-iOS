//
//  CountryPickerSheet.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 15/07/2026.
//

import SwiftUI

struct CountryPickerSheet: View {
    let countries: [CountryCode]
    @Binding var selected: CountryCode
    @Binding var isPresented: Bool

    var body: some View {
        NavigationView {
            List(countries) { country in
                Button {
                    selected = country
                    isPresented = false
                } label: {
                    HStack {
                        Text(country.flag)
                        Text(country.name)
                        Spacer()
                        Text(country.dialCode)
                            .foregroundColor(country == selected ? Color.primary :AppColors.secondaryText)
                        if country == selected {
                            Image(systemName: "checkmark")
                                .foregroundColor(Color.primary)
                        }
                    }
                }
                .foregroundColor(country == selected ? Color.primary :AppColors.secondaryText)
            }
            .navigationTitle(AppStrings.PhoneField.selectCountry)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(AppStrings.Common.cancel) { isPresented = false }
                }
            }
        }
    }
}
