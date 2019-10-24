//
//  Database.swift
//  Projects 19-21 Challange
//
//  Created by Maris Lagzdins on 24/10/2019.
//  Copyright © 2019 Developer Maris. All rights reserved.
//

import Foundation

protocol Database {
    func load() -> Data?
    func save(_ data: Data)
}
