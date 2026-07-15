//
//  ContentView.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 12/07/2026.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var phoneVM = PhoneFieldViewModel(selectedCountry: CountryCode.defaultList[0])
    
    var body: some View {
        PhoneTextField(viewModel: phoneVM)
                    .padding()
//        Text("Hello world..")
    }
}
