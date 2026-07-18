//
//  Userdefaultsmanager.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 18/07/2026.
//

import Foundation

final class UserDefaultsManager {

    static let shared = UserDefaultsManager()

    private let defaults: UserDefaults
    private let namespace: String
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(suiteName: String? = nil, namespace: String = "com.app") {
        self.defaults = suiteName.flatMap { UserDefaults(suiteName: $0) } ?? .standard
        self.namespace = namespace
    }

    private func key(_ key: String) -> String {
        "\(namespace).\(key)"
    }

    
    func exists(_ key: String) -> Bool {
        defaults.object(forKey: self.key(key)) != nil
    }

    func remove(_ key: String) {
        defaults.removeObject(forKey: self.key(key))
    }

    func clearAll() {
        let keys = defaults.dictionaryRepresentation().keys
        keys.filter { $0.hasPrefix("\(namespace).") }
            .forEach { defaults.removeObject(forKey: $0) }
    }

    
    func set(_ value: Bool, forKey key: String) {
        defaults.set(value, forKey: self.key(key))
    }

    func bool(forKey key: String, default defaultValue: Bool = false) -> Bool {
        exists(key) ? defaults.bool(forKey: self.key(key)) : defaultValue
    }

    func set(_ value: Int, forKey key: String) {
        defaults.set(value, forKey: self.key(key))
    }

    func int(forKey key: String, default defaultValue: Int = 0) -> Int {
        exists(key) ? defaults.integer(forKey: self.key(key)) : defaultValue
    }

    func set(_ value: Double, forKey key: String) {
        defaults.set(value, forKey: self.key(key))
    }

    func double(forKey key: String, default defaultValue: Double = 0) -> Double {
        exists(key) ? defaults.double(forKey: self.key(key)) : defaultValue
    }

    func set(_ value: String, forKey key: String) {
        defaults.set(value, forKey: self.key(key))
    }

    func string(forKey key: String, default defaultValue: String = "") -> String {
        defaults.string(forKey: self.key(key)) ?? defaultValue
    }

    @discardableResult
    func set<T: Codable>(_ value: T, forKey key: String) -> Bool {
        guard let data = try? encoder.encode(value) else { return false }
        defaults.set(data, forKey: self.key(key))
        return true
    }

    func object<T: Codable>(forKey key: String, as type: T.Type, default defaultValue: T? = nil) -> T? {
        guard let data = defaults.data(forKey: self.key(key)),
              let decoded = try? decoder.decode(T.self, from: data) else {
            return defaultValue
        }
        return decoded
    }
}
