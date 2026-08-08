//
//  DIContainer+Sessions.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 08/08/2026.
//

import Foundation
@MainActor
extension DIContainer{
    func  registerSessions() {
        container.register(UserSession.self) { r in
            UserSession(getUserDataUseCase: r.resolve(GetUserDataUseCase.self)!, refreshUseCase: r.resolve(RefreshUserDataUseCase.self)!)
        }
    }
}
