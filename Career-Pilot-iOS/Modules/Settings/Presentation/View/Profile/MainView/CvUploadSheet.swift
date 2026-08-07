//
//  CvUploadSheet.swift
//  Career-Pilot-iOS
//

import SwiftUI
import UniformTypeIdentifiers

struct CvUploadSheet: View {
    let onCVPicked: (URL) -> Void
    
    @State private var isImporterPresented = false
    @State private var didPick = false
    @State private var pickedFileName: String?
    @Environment(\.dismiss) private var dismiss
    
    private var docxType: UTType {
        UTType(filenameExtension: "docx") ?? .data
    }
    
    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Spacer()
                Button("Cancel") { dismiss() }
                    .foregroundColor(.gray400)
            }
            .padding(.horizontal)
            
            Spacer()
            
            CvUploadingView(
                didUpload: didPick,
                baseSentance: didPick ? (pickedFileName ?? "CV selected") : "Tap to upload your CV",
                subSentanceOne: didPick ? "Ready to analyze" : "PDF or DOC · Max 10 MB"
            )
            .onTapGesture { isImporterPresented = true }
            
            Spacer()
            
            Button(action: { isImporterPresented = true }) {
                Text(didPick ? "Choose a different file" : "Select File")
                    .font(.size16Bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Capsule().fill(Color.orange))
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 20)
        .fileImporter(isPresented: $isImporterPresented, allowedContentTypes: [.pdf, docxType]) { result in
            handlePickedFile(result)
        }
    }
    
    private func handlePickedFile(_ result: Result<URL, Error>) {
        switch result {
        case .success(let pickedURL):
            do {
                let localURL = try copyToLocalSandbox(from: pickedURL)
                didPick = true
                pickedFileName = pickedURL.lastPathComponent
                onCVPicked(localURL)
                dismiss()
            } catch {
                print("Failed to copy picked file: \(error)")
            }
            
        case .failure(let error):
            print("File picker failed: \(error)")
        }
    }
    
    private func copyToLocalSandbox(from sourceURL: URL) throws -> URL {
        guard sourceURL.startAccessingSecurityScopedResource() else {
            throw CvPickError.accessDenied
        }
        defer { sourceURL.stopAccessingSecurityScopedResource() }
        
        let destination = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension(sourceURL.pathExtension)
        
        try FileManager.default.copyItem(at: sourceURL, to: destination)
        return destination
    }
}

enum CvPickError: Error {
    case accessDenied
}
