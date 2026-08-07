//
//  LoadStates.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 22/07/2026.
//

import Foundation
enum LoadState<T> {
    case idle
    case loading
    case success(T)
    case failure(Error)
    
    var value: T? {
        if case .success(let value) = self { return value }
        return nil
    }
    
    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
}
extension LoadState {
    var isSuccess: Bool {
        if case .success = self { return true }
        return false
    }
}
