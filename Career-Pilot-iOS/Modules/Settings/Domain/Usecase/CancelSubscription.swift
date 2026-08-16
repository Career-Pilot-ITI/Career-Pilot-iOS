//
//  CancelSubscription.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 16/08/2026.
//

import Foundation
class CancelSubscription {
    private let repo : SettingsRepo
    init(repo: SettingsRepo) {
        self.repo = repo
    }
    func execute() async {
        do{
            try await
            repo.cancelUserSubscription()
        } catch{
            print("the error in saving local \(error)")
        }
    }
}
