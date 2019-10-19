//
//  GameScene.swift
//  Projects 16-18 Challange
//
//  Created by Maris Lagzdins on 19/10/2019.
//  Copyright © 2019 Developer Maris. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    private var scoreLabel: SKLabelNode!
    private var remainingTimeLabel: SKLabelNode!

    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var remainingTime: Int = 60 {
        didSet {
            remainingTimeLabel.text = "\(remainingTime)"
        }
    }
    var isGameOver: Bool {
        return remainingTime == 0
    }
    var targetTimer: Timer?
    var gameTimer: Timer?

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "wood-background")
        background.position = CGPoint(x: 400, y: 300)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)

        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 20, y: 560)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)

        score = 0

        remainingTimeLabel = SKLabelNode(fontNamed: "Chalkduster")
        remainingTimeLabel.position = CGPoint(x: 760, y: 560)
        remainingTimeLabel.horizontalAlignmentMode = .right
        addChild(remainingTimeLabel)

        remainingTime = 60

        targetTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(createTarget), userInfo: nil, repeats: true)
        gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(gameCountdown), userInfo: nil, repeats: true)
    }

    override func update(_ currentTime: TimeInterval) {
        for node in children where node.position.x < Position.Side.minPoint || node.position.x > Position.Side.maxPoint {
            node.removeFromParent()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)

        for node in tappedNodes {
            guard let target = node.parent as? Target, target.isHit == false else {
                continue
            }

            target.hit()
            score += 1
        }
    }

    @objc
    private func createTarget() {
        let targetPosition = Position.randomPosition()

        let target = Target()
        target.configure(at: targetPosition.initialPosition)
        addChild(target)
        target.move(to: targetPosition.distanceToMove)
    }

    @objc
    private func gameCountdown() {
        remainingTime -= 1

        guard isGameOver else {
            return
        }

        gameTimer?.invalidate()
        targetTimer?.invalidate()

        let gameOverNode = SKSpriteNode(imageNamed: "game-over")
        gameOverNode.position = CGPoint(x: 400, y: 300)
        gameOverNode.zPosition = 1
        addChild(gameOverNode)
    }
}
