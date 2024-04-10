//
//  GameScene.swift
//  Avia Game
//
//  Created by Anton on 10/4/24.
//

import Foundation
import SpriteKit
import GameKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private let gameId = UUID().uuidString
    
    private var planePlayer = SKSpriteNode()
    private var playerFire = SKSpriteNode()
    
    var playerFireTimer = Timer()
    var enemyTimer = Timer()
    var gameTimer = Timer()
    
    var objectiveToHit = Int.random(in: 20..<40)
    var objectivePlane = ""
    var currentObjectiveCompleted = 0 {
        didSet {
            objectiveMissionLabel.text = "\(currentObjectiveCompleted)/\(objectiveToHit)"
        }
    }
    
    var gameTime = 90 {
        didSet {
            gameTimeLabel.text = "\(gameTime) Seconds"
        }
    }
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    private var objectiveMissionLabel: SKLabelNode!
    private var gameTimeLabel: SKLabelNode!
    private var scoreLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        scene?.size = CGSize(width: 750, height: 1335)
        createBack()
        createPlayer()
        
        gameTimeLabel = SKLabelNode(text: "90 Seconds left")
        gameTimeLabel.position = CGPoint(x: size.width / 2, y: size.height - 200)
        gameTimeLabel.fontName = "Chalkdaster"
        gameTimeLabel.fontSize = 72
        addChild(gameTimeLabel)
        
        objectivePlane = planes.randomElement() ?? "plane_2"
        
        playerFireTimer = .scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(makePlayerFire), userInfo: nil, repeats: true)
        enemyTimer = .scheduledTimer(timeInterval: 1, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        gameTimer = .scheduledTimer(timeInterval: 1, target: self, selector: #selector(addGameTime), userInfo: nil, repeats: true)
        
        createObjectiveMissionLabel()
    }
    
    @objc private func addGameTime() {
        gameTime -= 1
        if gameTime == 0 {
            playerFireTimer.invalidate()
            enemyTimer.invalidate()
            gameTimer.invalidate()
            NotificationCenter.default.post(name: Notification.Name("GAME_OVER"), object: nil, userInfo: ["data": currentObjectiveCompleted, "planeId": objectivePlane, "gameId": self.gameId, "score": score])
        }
    }
    
    private func createObjectiveMissionLabel() {
        objectiveMissionLabel = SKLabelNode(text: "\(currentObjectiveCompleted)/\(objectiveToHit)")
        objectiveMissionLabel.position = CGPoint(x: 100, y: size.height - 80)
        objectiveMissionLabel.fontName = "Chalkdaster"
        objectiveMissionLabel.fontSize = 42
        addChild(objectiveMissionLabel)
        
        let planeObjective = SKSpriteNode(imageNamed: objectivePlane)
        planeObjective.position = CGPoint(x: objectiveMissionLabel.position.x + 70, y: size.height - 65)
        planeObjective.size = CGSize(width: 32, height: 32)
        addChild(planeObjective)
        
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: 100, y: size.height - 120)
        scoreLabel.fontName = "Chalkdaster"
        scoreLabel.fontSize = 42
        addChild(scoreLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let locaation = touch.location(in: self)
            planePlayer.position.x = locaation.x
            planePlayer.position.y = locaation.y
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "plane" {
            if nodeB.name?.contains("enemy") ?? false {
                print("game over")
                gameOverPlayerDie(enemy: nodeB, player: nodeA)
            }
        } else if nodeB.name == "player_fire" {
            print("playerFireHitEnemy \(nodeA.name)")
            if nodeA.name?.contains("enemy") ?? false {
                print("playerFireHitEnemy destroed")
                playerFireHitEnemy(enemy: nodeA, playerFire: nodeB)
            }
        }
    }
    
    private func gameOverPlayerDie(enemy: SKNode, player: SKNode) {
        enemy.removeFromParent()
        player.removeFromParent()
        
        if let fileParticles = SKEmitterNode(fileNamed: "Fire") {
            fileParticles.position = player.position
            fileParticles.zPosition = 12
            addChild(fileParticles)
        }
        
        addSoundEffect(for: "explosion")
        
        playerFireTimer.invalidate()
        enemyTimer.invalidate()
        gameTimer.invalidate()
        
        NotificationCenter.default.post(name: Notification.Name("GAME_OVER"), object: nil, userInfo: ["data": currentObjectiveCompleted, "planeId": objectivePlane, "gameId": self.gameId, "score": score])
    }
    
    private func playerFireHitEnemy(enemy: SKNode, playerFire: SKNode) {
        enemy.removeFromParent()
        playerFire.removeFromParent()
        
        if let fileParticles = SKEmitterNode(fileNamed: "Fire") {
            fileParticles.position = enemy.position
            fileParticles.zPosition = 12
            addChild(fileParticles)
        }
        
        addSoundEffect(for: "explosion")
        
        score += 10
        
        let enemyHitPlaneId = enemy.name?.components(separatedBy: "_")[1] ?? ""
        let planeId = "plane_\(enemyHitPlaneId)"
        if planeId == objectivePlane {
            currentObjectiveCompleted += 1
        }
    }
    
    private func addSoundEffect(for file: String) {
        if UserDefaults.standard.bool(forKey: "sounds_enabled") {
            let soundAction = SKAction.playSoundFileNamed(file, waitForCompletion: false)
            run(soundAction)
        }
    }
    
    private func createBack() {
        let background = SKSpriteNode(imageNamed: "game_back_avia")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(background)
    }
    
    private func createPlayer() {
        planePlayer = .init(imageNamed: UserDefaults.standard.string(forKey: "currentPlane") ?? "plane")
        planePlayer.position = CGPoint(x: size.width / 2, y: 100)
        planePlayer.physicsBody = SKPhysicsBody(rectangleOf: planePlayer.size)
        planePlayer.physicsBody?.affectedByGravity = false
        planePlayer.physicsBody?.isDynamic = true
        planePlayer.physicsBody?.categoryBitMask = GameInfo.player
        planePlayer.physicsBody?.contactTestBitMask = GameInfo.enemy | GameInfo.playerFire
        planePlayer.physicsBody?.collisionBitMask = GameInfo.enemy | GameInfo.playerFire
        planePlayer.name = "plane"
        addChild(planePlayer)
    }
    
    @objc private func makePlayerFire() {
        playerFire = .init(imageNamed: "bullet")
        playerFire.position = planePlayer.position
        playerFire.size = CGSize(width: 24, height: 24)
        playerFire.zPosition = 3
        playerFire.physicsBody = SKPhysicsBody(rectangleOf: playerFire.size)
        playerFire.physicsBody?.affectedByGravity = false
        playerFire.physicsBody?.isDynamic = true
        playerFire.physicsBody?.categoryBitMask = GameInfo.playerFire
        playerFire.physicsBody?.contactTestBitMask = GameInfo.enemy
        playerFire.physicsBody?.collisionBitMask = GameInfo.enemy
        playerFire.name = "player_fire"
        addChild(playerFire)
        
        let moveAction = SKAction.moveTo(y: 1400, duration: 1)
        let deleteAction = SKAction.removeFromParent()
        let combine = SKAction.sequence([moveAction, deleteAction])
        playerFire.run(combine)
        
        addSoundEffect(for: "blaster")
    }
    
    private let planes = ["plane_2", "plane_3", "plane_4", "plane_5", "plane_6", "plane_7", "plane_8"]
    
    @objc private func createEnemy() {
        let randomPlane = planes.randomElement() ?? "plane_2"
        let enemy = SKSpriteNode(imageNamed: randomPlane)
        let random = GKRandomDistribution(lowestValue: 50, highestValue: 700)
        enemy.position = CGPoint(x: random.nextInt(), y: 1400)
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        let planeId = randomPlane.components(separatedBy: "_")[1]
        enemy.name = "enemy_\(planeId)"
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.categoryBitMask = GameInfo.enemy
        enemy.physicsBody?.contactTestBitMask = GameInfo.player | GameInfo.playerFire
        enemy.physicsBody?.collisionBitMask = GameInfo.player | GameInfo.playerFire
        addChild(enemy)
        
        let moveAction = SKAction.moveTo(y: -100, duration: 2)
        let deleteAction = SKAction.removeFromParent()
        let combine = SKAction.sequence([moveAction, deleteAction])
        enemy.run(combine)
    }
    
}

struct GameInfo {
    static let player: UInt32 = 0x00
    static let playerFire: UInt32 = 0x001
    static let enemy: UInt32 = 0x0010
}
