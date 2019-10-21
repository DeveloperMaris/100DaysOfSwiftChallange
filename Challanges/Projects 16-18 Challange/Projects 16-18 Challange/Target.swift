//
//  Target.swift
//  Projects 16-18 Challange
//
//  Created by Maris Lagzdins on 19/10/2019.
//  Copyright © 2019 Developer Maris. All rights reserved.
//

import SpriteKit
import UIKit

class Target: SKNode {
    private let possibleTargetSkins: [String] = ["target0", "target1"]
    private var targetNode: SKSpriteNode!
    
    var row: Row!
    var isHit: Bool = false

    func configure(at row: Row) {
        self.row = row
        self.position = row.initialPosition()

        guard let targetImage = possibleTargetSkins.randomElement() else {
            return
        }

        targetNode = SKSpriteNode(imageNamed: targetImage)
        targetNode.zPosition = 1

        addChild(targetNode)
    }

    func move() {
        assert(targetNode != nil, "Target node must exist!")
        assert(row != nil, "Row must be provided!")

        let scale = CGFloat.random(in: 0.3...1)
        let speed = TimeInterval(scale) * 5

        targetNode.xScale = scale
        targetNode.yScale = scale

        run(SKAction.moveBy(x: row.destination(), y: 0, duration: speed))
    }

    func hit() {
        isHit = true
        let spin = SKAction.rotate(byAngle: .pi / 2, duration: 0.3)
        let spinForever = SKAction.repeatForever(spin)

        targetNode.run(spinForever)
    }
}
