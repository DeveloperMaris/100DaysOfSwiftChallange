//
//  GameScene.swift
//  Project17
//
//  Created by Maris Lagzdins on 17/10/2019.
//  Copyright © 2019 Developer Maris. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    static let enemyLimitInRound: Int = 20

    var starfield: SKEmitterNode!
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!

    var possibleEnemies: [String] = ["ball", "hammer", "tv"]
    var gameTimer: Timer?
    var enemyCreationTime: TimeInterval = 1.0
    var isGameOver: Bool = false
    var canMovePlayer: Bool = true
    var enemiesCreatedInRound: Int = 0

    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }

    override func didMove(to view: SKView) {
        backgroundColor = .black

        starfield = SKEmitterNode(fileNamed: "starfield")!
        starfield.position = CGPoint(x: 1024, y: 384)

        starfield.advanceSimulationTime(10)
        addChild(starfield)
        starfield.zPosition = -1

        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        addChild(player)

        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)

        score = 0

        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self

        gameTimer = Timer.scheduledTimer(timeInterval: enemyCreationTime, target: self, selector: #selector(playRound), userInfo: nil, repeats: true)
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children where node.position.x < -300 {
            node.removeFromParent()
        }

        if !isGameOver {
            score += 1
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard canMovePlayer else {
            return
        }

        guard let touch = touches.first else {
            return
        }

        var location = touch.location(in: self)

        if location.y < 100 {
            location.y = 100
        } else if location.y > 668 {
            location.y = 668
        }

        player.position = location
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        canMovePlayer = false
    }

    @objc
    private func playRound() {
        guard !isGameOver else {
            gameTimer?.invalidate()
            return
        }
        resetRoundIfNecessary()
        createEnemy()
    }

    private func resetRoundIfNecessary() {
        if enemiesCreatedInRound == Self.enemyLimitInRound && enemyCreationTime > 0.1 {
            gameTimer?.invalidate()
            enemyCreationTime -= 0.1
            enemiesCreatedInRound = 0
            gameTimer = Timer.scheduledTimer(timeInterval: enemyCreationTime, target: self, selector: #selector(playRound), userInfo: nil, repeats: true)
        }
    }

    @objc
    private func createEnemy() {
        guard let enemy = possibleEnemies.randomElement() else {
            return
        }

        let sprite = SKSpriteNode(imageNamed: enemy)
        sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
        addChild(sprite)
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0) // Move to right
        sprite.physicsBody?.angularVelocity = 5 // Constant spin (gives spin)
        sprite.physicsBody?.linearDamping = 0 // Means how fast things slow down over time (slow down never)
        sprite.physicsBody?.angularDamping = 0 // Gives that thing will never stop spinning

        enemiesCreatedInRound += 1
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)

        player.removeFromParent()
        isGameOver = true
    }
}
