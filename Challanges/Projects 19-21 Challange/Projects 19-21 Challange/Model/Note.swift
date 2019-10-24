//
//  Note.swift
//  Projects 19-21 Challange
//
//  Created by Maris Lagzdins on 24/10/2019.
//  Copyright © 2019 Developer Maris. All rights reserved.
//

import Foundation

struct Note: Codable, Equatable {
    let id: UUID = UUID()
    var title: String
    var text: String
    let created: Date = Date()
    var updated: Date = Date()

    mutating func update(title: String, text: String) {
        self.title = title
        self.text = text
        self.updated = Date()
    }
}

extension Note {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
