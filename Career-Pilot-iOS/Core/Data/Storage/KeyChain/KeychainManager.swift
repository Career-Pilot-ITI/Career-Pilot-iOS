//
//  KeychainManager.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 17/07/2026.
//

import Foundation
import Security

enum KeychainError: Error {
    case encodingFailed
    case decodingFailed
    case unhandledError(status: OSStatus)
}

protocol KeychainManaging {
    func save<T: Codable>(_ value: T, forKey key: String) throws
    func get<T: Codable>(_ type: T.Type, forKey key: String) throws -> T?
    func delete(forKey key: String) throws
}


final class KeychainManager: KeychainManaging {
    private let service: String

    init(service: String = Bundle.main.bundleIdentifier ?? "CareerPilot-iOS") {
        self.service = service
    }

    func save<T: Codable>(_ value: T, forKey key: String) throws {
        let data: Data
        do {
            data = try JSONEncoder().encode(value)
        } catch {
            throw KeychainError.encodingFailed
        }

        let baseQuery = query(forKey: key)
        SecItemDelete(baseQuery as CFDictionary)

        var attributes = baseQuery
        attributes[kSecValueData as String] = data
        attributes[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly

        let status = SecItemAdd(attributes as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }
    }

    func get<T: Codable>(_ type: T.Type, forKey key: String) throws -> T? {
        var attributes = query(forKey: key)
        attributes[kSecReturnData as String] = true
        attributes[kSecMatchLimit as String] = kSecMatchLimitOne

        var result: AnyObject?
        let status = SecItemCopyMatching(attributes as CFDictionary, &result)

        if status == errSecItemNotFound {
            return nil
        }
        guard status == errSecSuccess, let data = result as? Data else {
            throw KeychainError.unhandledError(status: status)
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw KeychainError.decodingFailed
        }
    }

    func delete(forKey key: String) throws {
        let status = SecItemDelete(query(forKey: key) as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unhandledError(status: status)
        }
    }

    private func query(forKey key: String) -> [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
    }
}

