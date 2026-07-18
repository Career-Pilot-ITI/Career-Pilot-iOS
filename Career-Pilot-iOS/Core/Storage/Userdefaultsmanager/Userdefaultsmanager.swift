//
//  Userdefaultsmanager.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 18/07/2026.
//

import Foundation

protocol UserDefaultsStorage {
    func set<T:Codable>(_ value: T, forKey key: String)
    func get<T:Codable>(forKey key: String) -> T?
    func remove(forKey key: String)
    func exists(_ key: String) -> Bool
    func clearAll()
}

final class UserDefaultsManager: UserDefaultsStorage {
    static let shared = UserDefaultsManager()
    private let defaults: UserDefaults
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    

    func set<T:Codable>(_ value: T, forKey key: String) {
        let data = try? JSONEncoder().encode(value)
        defaults.set(data, forKey: key)
    }


    func get<T:Codable>(forKey key: String) -> T? {
        guard let data = defaults.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(T.self,from: data)
    }

    func remove(forKey key: String) {
        defaults.removeObject(forKey: key)
    }
    
    func exists(_ key: String) -> Bool {
        defaults.object(forKey: key) != nil
    }
    
    func clearAll() {
        if let bundleID = Bundle.main.bundleIdentifier {
            defaults.removePersistentDomain(forName: bundleID)
        }
    }
}
