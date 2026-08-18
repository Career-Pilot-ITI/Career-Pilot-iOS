//
//  CoverLetterView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 12/08/2026.
//

import SwiftUI
import UIKit
import MessageUI

struct CoverLetterView: View {
    @EnvironmentObject var viewModel: ATSViewModel
    @EnvironmentObject var toastManager: ToastManager
    @State private var editableBody = ""
    @State private var editDraft = ""
    @State private var isEditing = false
    @State private var mailDraft: MailDraft?
    @State private var showNoMailAccountAlert = false

    var body: some View {
        Group {
            if viewModel.isCoverLetterLoading {
                CoverLetterSkeletonView()
                .background(Color.screenBackground.ignoresSafeArea())

            } else if let data = viewModel.coverLetterData {
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: Radius.r16) {
                            CoverLetterCardView(
                                data: displayedData(from: data),
                                onEdit: {
                                    editDraft = editableBody
                                    isEditing = true
                                },
                                onCopy: {
                                    UIPasteboard.general.string = completeLetter(from: data)
                                    toastManager.show("Copied to clipboard.", type: .success)
                                }
                            )
                            NextStepsCard(steps: data.nextSteps)
                            SendEmailButton(onSend: {
                                sendEmail(with: completeLetter(from: data))
                            })
                                .padding(.top, 4)
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 24)
                    }
                }
                .background(Color.screenBackground.ignoresSafeArea())

            } else if let error = viewModel.errorMessage {
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundStyle(Color.matchRed)
                    Text(error)
                        .font(Font.size14Regular)
                        .foregroundStyle(Color.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                    Button("Retry") {
                        Task { await viewModel.generateCoverLetter() }
                    }
                    .buttonStyle(.bordered)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.screenBackground.ignoresSafeArea())

            } else {
                CoverLetterSkeletonView()
                    .background(Color.screenBackground.ignoresSafeArea())
            }
        }
        .task {
            // Only generate if we don't already have a result
            guard viewModel.coverLetterData == nil else { return }
            await viewModel.generateCoverLetter()
        }
        .onAppear {
            guard editableBody.isEmpty, let data = viewModel.coverLetterData else { return }
            editableBody = data.bodyText
        }
        .onChange(of: viewModel.coverLetterData?.bodyText) { bodyText in
            guard let bodyText, editableBody.isEmpty else { return }
            editableBody = bodyText
        }
        .sheet(isPresented: $isEditing) {
            NavigationStack {
                TextEditor(text: $editDraft)
                    .padding(16)
                    .navigationTitle("Edit Cover Letter")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { isEditing = false }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") {
                                editableBody = editDraft.trimmingCharacters(in: .whitespacesAndNewlines)
                                isEditing = false
                                toastManager.show("Changes saved.", type: .success)
                            }
                            .disabled(editDraft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        }
                    }
            }
        }
        .sheet(item: $mailDraft) { draft in
            MailComposeView(draft: draft) {
                mailDraft = nil
            }
        }
        .alert("No Mail Account Configured", isPresented: $showNoMailAccountAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Gmail isn't installed and no Mail account is configured on this device. Set up an account in Mail and try again.")
        }
        .operationGuard(isOperationActive: $viewModel.isCoverLetterLoading)
    }

    private func displayedData(from data: CoverLetterData) -> CoverLetterData {
        data.replacingBodyText(editableBody.isEmpty ? data.bodyText : editableBody)
    }

    private func completeLetter(from data: CoverLetterData) -> String {
        let body = editableBody.isEmpty ? data.bodyText : editableBody
        let signature = [data.signature.name, data.signature.email, data.signature.phone]
            .filter { !$0.isEmpty }
            .joined(separator: "\n")
        return signature.isEmpty ? body : "\(body)\n\n\(signature)"
    }

    private func sendEmail(with body: String) {
        let recipient = "" // The imported job model does not currently include a recruiter email.
        let jobTitle = viewModel.currentJob?.title ?? "this role"
        let company = viewModel.currentJob?.companyName ?? "your company"
        let subject = "Application for \(jobTitle) at \(company)"

        var gmailComponents = URLComponents()
        gmailComponents.scheme = "googlegmail"
        gmailComponents.host = "co"
        gmailComponents.queryItems = [
            URLQueryItem(name: "to", value: recipient),
            URLQueryItem(name: "subject", value: subject),
            URLQueryItem(name: "body", value: body)
        ]

        if let gmailURL = gmailComponents.url, UIApplication.shared.canOpenURL(gmailURL) {
            UIApplication.shared.open(gmailURL)
            return
        }

        if MFMailComposeViewController.canSendMail() {
            mailDraft = MailDraft(recipient: recipient, subject: subject, body: body)
        } else {
            showNoMailAccountAlert = true
        }
    }
}

private struct MailDraft: Identifiable {
    let id = UUID()
    let recipient: String
    let subject: String
    let body: String
}

private struct MailComposeView: UIViewControllerRepresentable {
    let draft: MailDraft
    let onFinish: () -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onFinish: onFinish)
    }

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = context.coordinator
        composer.setToRecipients(draft.recipient.isEmpty ? nil : [draft.recipient])
        composer.setSubject(draft.subject)
        composer.setMessageBody(draft.body, isHTML: false)
        return composer
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}

    final class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        private let onFinish: () -> Void

        init(onFinish: @escaping () -> Void) {
            self.onFinish = onFinish
        }

        func mailComposeController(
            _ controller: MFMailComposeViewController,
            didFinishWith result: MFMailComposeResult,
            error: Error?
        ) {
            onFinish()
        }
    }
}

private struct CoverLetterSkeletonView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: Radius.r16) {
                SkeletonBlock(height: 440)
                SkeletonBlock(height: 180)
                SkeletonBlock(height: 56)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
    }
}

//#Preview {
//    CoverLetterView()
//}
