//
//  Userdefaultsmanager.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 18/07/2026.
//

import Foundation

protocol UserDefaultsStorage {
    func set<T:Codable>(_ value: T, forKey key: String)
    func get<T:Codable>(forKey key: String, as type: T.Type, default: T?) -> T?
    func remove(_ key: String)
    func exists(_ key: String) -> Bool
    func clearAll()
}

final class UserDefaultsManager: UserDefaultsStorage {
    static let shared = UserDefaultsManager()
    private let defaults: UserDefaults
    private let namespace: String?
    
    init(suiteName: String? = nil, namespace: String? = nil) {
        self.defaults = suiteName != nil ? UserDefaults(suiteName: suiteName!)! : .standard
        self.namespace = namespace
    }
    
    private func prefixed(_ key: String) -> String {
        return namespace.map { "\($0).\(key)" } ?? key
    }

    func set<T>(_ value: T, forKey key: String) {
        if let codable = value as? Codable, !(value is String || value is Int || value is Double || value is Bool || value is Float) {
            let data = try? JSONEncoder().encode(codable)
            defaults.set(data, forKey: prefixed(key))
        } else {
            defaults.set(value, forKey: prefixed(key))
        }
    }

    func get<T: Codable>(forKey key: String, as type: T.Type, default: T? = nil) -> T? {
        let fullKey = prefixed(key)
        guard let data = defaults.data(forKey: fullKey),
              let decoded = try? JSONDecoder().decode(T.self, from: data) else {
            return `default`
        }
        return decoded
    }

    func remove(_ key: String) { defaults.removeObject(forKey: prefixed(key)) }
    func exists(_ key: String) -> Bool { defaults.object(forKey: prefixed(key)) != nil }
    
    func clearAll() {
        defaults.dictionaryRepresentation().keys.filter {
            namespace == nil || $0.hasPrefix("\(namespace!).")
        }.forEach { defaults.removeObject(forKey: $0) }
    }
}
