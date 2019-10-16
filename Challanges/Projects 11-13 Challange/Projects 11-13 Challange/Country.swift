//
//  Country.swift
//  Projects 11-13 Challange
//
//  Created by Maris Lagzdins on 16/10/2019.
//  Copyright © 2019 Developer Maris. All rights reserved.
//

import Foundation

struct Country: Codable {
    struct Size: Codable {
        let total: Int
        let land: Int
        let water: Int
    }

    let name: String
    let size: Size
    let note: String?
}
