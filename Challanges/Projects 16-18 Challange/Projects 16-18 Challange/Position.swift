//
//  Position.swift
//  Projects 16-18 Challange
//
//  Created by Maris Lagzdins on 19/10/2019.
//  Copyright © 2019 Developer Maris. All rights reserved.
//

import UIKit

struct Position {
    enum Side: CaseIterable {
        static let minPoint: CGFloat = -100
        static let maxPoint: CGFloat = 900

        case left, right
    }

    enum Row: CaseIterable {
        case first, second, third

        func position(on side: Side) -> CGPoint {
            let initialPoint = side == .left ? Side.minPoint : Side.maxPoint
            switch self {
            case .first:
                return CGPoint(x: initialPoint, y: 450)
            case .second:
                return CGPoint(x: initialPoint, y: 300)
            case .third:
                return CGPoint(x: initialPoint, y: 150)
            }
        }
    }

    let row: Row
    let initialPosition: CGPoint
    let distanceToMove: CGFloat

    private init(row: Row, initialPosition: CGPoint, distanceToMove: CGFloat) {
        self.row = row
        self.initialPosition = initialPosition
        self.distanceToMove = distanceToMove
    }


    static func randomPosition() -> Position {
        let row = Row.allCases.randomElement()!
        let initialSide = Side.allCases.randomElement()!
        let initialPosition = row.position(on: initialSide)
        let distanceToMove: CGFloat = initialSide == .left ? 1100 : -1100

        return Position(row: row, initialPosition: initialPosition, distanceToMove: distanceToMove)
    }
}
