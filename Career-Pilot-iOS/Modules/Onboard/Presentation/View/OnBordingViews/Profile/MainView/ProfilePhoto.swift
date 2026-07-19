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
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            
            Button(action: {
                showSouceDialog = true
            }) {
                if(image == nil){
                    Text("SC")
                        .font(.size26Semibold)
                        .foregroundColor(.gray600)
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
            .shadow(color: Color.primaryNavy.opacity(0.12), radius: 16, x: 0, y: 4)

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
                        .fill(Color.activeColour)
                        .overlay(
                            RoundedRectangle(cornerRadius: Radius.pill)
                                .stroke(Color.white, lineWidth: 2.4)
                        )
                )
                .shadow(color: Color.activeColour.opacity(0.40), radius: 8, x: 0, y: 2)
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
        }    }
}

struct ProfilePhoto_Previews: PreviewProvider {
    static var previews: some View {
        PreviewContainer()
    }

    struct PreviewContainer: View {

        @State private var image: UIImage? = nil
        
        var body: some View {
            ProfilePhoto(image: $image)
        }
    }
}
