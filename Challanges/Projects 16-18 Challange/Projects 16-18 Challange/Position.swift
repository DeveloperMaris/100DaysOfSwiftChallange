//
//  Position.swift
//  Projects 16-18 Challange
//
//  Created by Maris Lagzdins on 19/10/2019.
//  Copyright © 2019 Developer Maris. All rights reserved.
//

import UIKit

enum Row: CaseIterable {
    static let minPoint: CGFloat = -100
    static let maxPoint: CGFloat = 900

    case first, second, third

    func initialPosition() -> CGPoint {
        switch self {
        case .first:
            return CGPoint(x: Self.minPoint, y: 450)
        case .second:
            return CGPoint(x: Self.maxPoint, y: 300)
        case .third:
            return CGPoint(x: Self.minPoint, y: 150)
        }
    }

    func destination() -> CGFloat {
        switch self {
        case .first, .third:
            return 1100
        case .second:
            return -1100
        }
    }
}
