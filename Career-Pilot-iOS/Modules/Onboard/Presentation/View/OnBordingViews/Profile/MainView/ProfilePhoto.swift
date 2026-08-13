//
//  ProfilePhoto.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 19/07/2026.
//

import SwiftUI

struct ProfilePhoto: View {
    @State private  var showSouceDialog : Bool = false
    @State private  var showCamerDialog : Bool = false
    @State private  var showImagePickerDialog : Bool = false
    @Binding  var image : UIImage?
    let onImagePicked: (Data) -> Void
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            
            Button(action: {
                showSouceDialog = true
            }) {
                if(image == nil){
                    Text("SC")
                        .font(.size26Semibold)
                        .foregroundColor(.primary)
                }
                else{
                    Image(uiImage: image!).resizable().scaledToFill().frame(width: 80, height: 80).clipShape(Circle())
                }
         
            }
            .frame(width: 80, height: 80)
            .background(
                RoundedRectangle(cornerRadius: Radius.pill)
                    .fill(Color.gray200)
                    .overlay(
                        RoundedRectangle(cornerRadius: Radius.pill)
                            .stroke(Color.white, lineWidth: 2.4)
                    )
            )
            .shadow(color: Color.primary.opacity(0.12), radius: 16, x: 0, y: 4)

            if( image == nil){
                Button(action: {
                    showSouceDialog = true
                }) {
                    Image(systemName: "camera")
                        .resizable()
                        .frame(width: 12, height: 12)
                        .foregroundColor(Color.white)
                }
                .frame(width: 26, height: 26)
                .background(
                    RoundedRectangle(cornerRadius: Radius.pill)
                        .fill(Color.primary)
                        .overlay(
                            RoundedRectangle(cornerRadius: Radius.pill)
                                .stroke(Color.white, lineWidth: 2.4)
                        )
                )
                .shadow(color: Color.primary.opacity(0.40), radius: 8, x: 0, y: 2)
                .offset(x: 2, y: 2)
            }
        
        }.confirmationDialog("Profile photo", isPresented: $showSouceDialog, actions: {
            Button("Take Photo") { showCamerDialog = true }
                Button("Choose from Library") { showImagePickerDialog = true }
                Button("Cancel", role: .cancel) { }
        })  .fullScreenCover(isPresented: $showCamerDialog) {
            ImagePicker(sourceType: .camera, selectedImage:  $image)
        }
        .sheet(isPresented: $showImagePickerDialog) {
            PhotoPicker(selectedImage: $image)
        }   .onChange(of: image) { newImage in
            guard let newImage, let data = newImage.jpegData(compressionQuality: 0.8) else { return }
            onImagePicked(data)
        }
        
    }
}


