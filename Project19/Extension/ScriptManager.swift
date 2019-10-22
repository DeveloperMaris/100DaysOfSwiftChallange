//
//  ScriptManager.swift
//  Extension
//
//  Created by Maris Lagzdins on 21/10/2019.
//  Copyright © 2019 Developer Maris. All rights reserved.
//

import Foundation

class ScriptManager {
    static let savedScriptsKey = "com.developermaris.Project19.Extension.userDefaults.savedScriptsData"

    private let queue = DispatchQueue(label: "com.developermaris.Project19.Extension.ScriptManager", qos: .utility, attributes: .concurrent)
    private let userDefaults: UserDefaults

    private var scripts: [Script] = []

    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            self.scripts = self.getScripts()
        }
    }



    func loadScripts() -> [Script] {
        queue.sync {
            return self.getScripts()
        }
    }

    func saveScript(_ script: String, withTitle title: String) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }

            let script = Script(title: title, code: script)
            self.scripts.append(script)

            let encoder = JSONEncoder()
            if let dataToSave = try? encoder.encode(self.scripts) {
                self.userDefaults.set(dataToSave, forKey: Self.savedScriptsKey)
            }
        }
    }

    private func getScripts() -> [Script] {
        let savedScriptsData = self.userDefaults.data(forKey: Self.savedScriptsKey)
        var savedScripts: [Script] = []

        if let data = savedScriptsData {
            let decoder = JSONDecoder()
            if let scripts = try? decoder.decode([Script].self, from: data) {
                savedScripts = scripts
            }
        }

        return savedScripts
    }
}
