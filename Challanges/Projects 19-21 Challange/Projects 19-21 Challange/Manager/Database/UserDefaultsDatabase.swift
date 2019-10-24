//
//  DatabaseManager.swift
//  Projects 19-21 Challange
//
//  Created by Maris Lagzdins on 24/10/2019.
//  Copyright © 2019 Developer Maris. All rights reserved.
//

import Foundation

struct UserDefaultsDatabase: Database {
    private let userDefaults = UserDefaults.standard

    func load() -> Data? {
        return userDefaults.object(forKey: .notes) as? Data
    }

    func save(_ data: Data) {
        userDefaults.set(data, forKey: .notes)
    }
}

// MARK: - Database keys
fileprivate extension String {
    static let notes = "notes"
}
