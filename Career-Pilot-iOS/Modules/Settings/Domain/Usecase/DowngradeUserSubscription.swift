//
//  DowngradeUserSubscription.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 15/08/2026.
//

import Foundation
class DowngradeUserSubscription {
    private let repo : SettingsRepo
    init(repo: SettingsRepo) {
        self.repo = repo
    }
    func execute() async {
        do{
            try await
            repo.downgradeUserSubscription()
        } catch{
            print("the error in saving local \(error)")
        }
    }
}
