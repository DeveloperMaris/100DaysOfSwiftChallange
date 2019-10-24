//
//  FileDatabase.swift
//  Projects 19-21 Challange
//
//  Created by Maris Lagzdins on 24/10/2019.
//  Copyright © 2019 Developer Maris. All rights reserved.
//

import Foundation

struct FileDatabase: Database {
    private let fileManager = FileManager.default
    private let path: URL
    private let fileName = "notes.txt"

    init() {
        path = FileManager.documents.appendingPathComponent(fileName)
    }

    func load() -> Data? {
        return try? Data(contentsOf: path)
    }

    func save(_ data: Data) {
        try? data.write(to: path)
    }
}

extension FileManager {
    static var documents: URL { // This document directory is synchronized with Apple iCloud
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths.first!
    }
}
