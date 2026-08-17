//
//  ProfilePhoto.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 19/07/2026.
//
import SwiftUI

struct ProfilePhoto: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var showSourceDialog: Bool = false
    @State private var showCameraDialog: Bool = false
    @State private var showImagePickerDialog: Bool = false
    
    @Binding var image: UIImage?
    var initials: String = ""
    let onImagePicked: (Data) -> Void
    var onImageRemoved: (() -> Void)? = nil
    
    var body: some View {
        if #available(iOS 17.0, *) {
            Button {
                showSourceDialog = true
            } label: {
                ZStack(alignment: .bottomTrailing) {
                    
                    // MARK: - Avatar Main Frame
                    Group {
                        if let selectedImage = image {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFill()
                        } else if !initials.isEmpty {
                            Text(initials.uppercased())
                                .font(.size24Semibold)
                                .foregroundColor(.primary)
                        } else {
                            Image(systemName: "person.fill")
                                .font(.system(size: 32, weight: .medium))
                                .foregroundColor(Color(uiColor: .secondaryLabel))
                        }
                    }
                    .frame(width: 84, height: 84)
                    .background(Color(uiColor: .secondarySystemBackground))
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color(uiColor: .systemBackground), lineWidth: 2)
                    )
                    .shadow(
                        color: colorScheme == .dark ? Color.black.opacity(0.4) : Color.black.opacity(0.12),
                        radius: 10,
                        x: 0,
                        y: 4
                    )
                    
                    // MARK: - Camera / Edit Badge Icon
                    ZStack {
                        Circle()
                            .fill(Color.primary)
                            .frame(width: 28, height: 28)
                            .overlay(
                                Circle()
                                    .stroke(Color(uiColor: .systemBackground), lineWidth: 2)
                            )
                            .shadow(
                                color: Color.primary.opacity(colorScheme == .dark ? 0.15 : 0.3),
                                radius: 4,
                                x: 0,
                                y: 2
                            )
                        
                        Image(systemName: image == nil ? "camera.fill" : "pencil")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Color(uiColor: .systemBackground))
                    }
                    .offset(x: 2, y: 2)
                }
            }
            .buttonStyle(.plain)
            .confirmationDialog("Profile Photo", isPresented: $showSourceDialog, titleVisibility: .visible) {
                Button("Take Photo") { showCameraDialog = true }
                Button("Choose from Library") { showImagePickerDialog = true }
                
                if image != nil {
                    Button("Remove Photo", role: .destructive) {
                        image = nil
                        onImageRemoved?()
                    }
                }
                
                Button("Cancel", role: .cancel) { }
            }
            .fullScreenCover(isPresented: $showCameraDialog) {
                ImagePicker(sourceType: .camera, selectedImage: $image)
            }
            .sheet(isPresented: $showImagePickerDialog) {
                PhotoPicker(selectedImage: $image)
            }
            .onChange(of: image) { newImage in
                guard let newImage = newImage, let data = newImage.jpegData(compressionQuality: 0.8) else { return }
                onImagePicked(data)
            }
        } else {
            // Fallback on earlier versions
        }
    }
}
