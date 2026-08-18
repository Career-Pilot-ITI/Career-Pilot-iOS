//
//  CoverLetterModels.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 12/08/2026.
//

import Foundation

struct SignatureContact {
    let name: String
    let email: String
    let phone: String
}

struct CoverLetterData {
    let paragraphs: [String]
    let signature: SignatureContact
    let nextSteps: [Recommendation]

    var bodyText: String {
        paragraphs.joined(separator: "\n\n")
    }

    func replacingBodyText(_ bodyText: String) -> CoverLetterData {
        let paragraphs = bodyText
            .components(separatedBy: "\n\n")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        return CoverLetterData(
            paragraphs: paragraphs.isEmpty ? self.paragraphs : paragraphs,
            signature: signature,
            nextSteps: nextSteps
        )
    }

    static func fallback(
        jobTitle: String,
        companyName: String,
        signature: SignatureContact
    ) -> CoverLetterData {
        CoverLetterData(
            paragraphs: [
                "Dear Hiring Manager,",
                "I am writing to express my interest in the \(jobTitle) position at \(companyName). My experience and enthusiasm for delivering thoughtful, high-quality work would allow me to contribute meaningfully to your team.",
                "I would welcome the opportunity to discuss how my skills and background align with this role. Thank you for your time and consideration.",
                "Sincerely,"
            ],
            signature: signature,
            nextSteps: []
        )
    }
}

extension CoverLetterData {
    /// Sample data mirroring the provided design mockups.
    static let sample = CoverLetterData(
        paragraphs: [
            "Dear Hiring Manager,",
            "I am writing to express my strong interest in the Senior Frontend Engineer position at Google. With over 6 years of experience architecting scalable React applications and leading cross-functional engineering teams, I am confident I can make a meaningful contribution to your Search team.",
            "In my current role at XYZ Corp, I designed and implemented a React-based component library adopted by 8 product teams, reducing UI development time by 40%. I also led a platform-wide TypeScript migration that lifted type coverage from 12% to 94% and cut production bugs by 60%.",
            "Your emphasis on system design and performance engineering resonates deeply with my background. I am particularly excited by Google's commitment to user-centric innovation and the opportunity to build at scale.",
            "Thank you for your time and consideration. I would welcome the opportunity to discuss how my experience aligns with this exciting role.",
            "Sincerely,"
        ],
        signature: SignatureContact(
            name: "Sarah Chen",
            email: "sarah@email.com",
            phone: "+20 10 1234 5678"
        ),
        nextSteps: [
            Recommendation(index: 1, text: "Add Kubernetes to your Skills with a brief hands-on description"),
            Recommendation(index: 2, text: "Quantify AWS impact — e.g. 'Reduced latency 40% via Lambda + CloudFront'"),
            Recommendation(index: 3, text: "Expand project entries with business metrics and user impact"),
            Recommendation(index: 4, text: "Rewrite Summary to lead with large-scale React architecture experience"),
            Recommendation(index: 5, text: "Add a Certifications section if you hold AWS or cloud certs")
        ]
    )
}
