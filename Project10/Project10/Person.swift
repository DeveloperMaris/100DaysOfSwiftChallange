//
//  Person.swift
//  Project10
//
//  Created by Maris Lagzdins on 15/09/2019.
//  Copyright © 2019 Developer Maris. All rights reserved.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String

    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
