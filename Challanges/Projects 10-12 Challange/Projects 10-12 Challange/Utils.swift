//
//  Utils.swift
//  Projects 10-12 Challange
//
//  Created by Maris Lagzdins on 18/09/2019.
//  Copyright © 2019 Developer Maris. All rights reserved.
//

import Foundation

enum Utils {
    static func getDocumentsDirectory() -> URL {
        // This document directory is synchronized with Apple iCloud
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let path = paths.first else {
            fatalError("Could not find Documents folder")
        }
        return path
    }
}
