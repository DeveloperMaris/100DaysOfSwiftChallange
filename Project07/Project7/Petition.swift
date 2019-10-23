//
//  Petition.swift
//  Project7
//
//  Created by Maris Lagzdins on 11/09/2019.
//  Copyright © 2019 Developer Maris. All rights reserved.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
