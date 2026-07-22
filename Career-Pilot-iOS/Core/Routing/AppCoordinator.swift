//
//  AppCoordinator.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 19/07/2026.
//

import Foundation
import SwiftUI

final class AppCoordinator<Route: Hashable>: ObservableObject {
    @Published var path = NavigationPath()

    func push(_ route: Route) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
}
