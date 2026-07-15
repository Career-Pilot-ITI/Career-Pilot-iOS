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

    
    @State var flag: Bool = true
    
    var body: some View {
//        Text("Hello world..")
        CvUploadingView(didUpload: flag, baseSentance: "Tap to upload your CV", subSentanceOne: "PDF or DOC · Max 10 MB")
            .padding(.bottom, 25)
        CustomButton(buttonTitle:"Change State"){
            flag.toggle()
        }
    }
}

