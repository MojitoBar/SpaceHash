//
//  GameScene.swift
//  SSC
//
//  Created by judongseok on 2022/04/07.
//

import Foundation
import GameplayKit

struct PhysicsCategory {
    static let None: UInt32 = 0
    static let All: UInt32 = UInt32.max
    static let Baddy: UInt32 = 0b1
    static let Hero: UInt32 = 0b10
    
    static let Projectile: UInt32 = 0b11
}

struct CheckDrag {
    var movableNode: CGPoint
    // 0, 1, 2, 3
    // 상, 하, 좌, 우
    var dragDirection: Int
}

struct PlayerPos {
    var index: (Int, Int)
    var pos: (CGFloat, CGFloat)
    var isMove: Bool
}
// 0  1  2
// 1  x  x
// 2  x  x
var playerPos = PlayerPos(index: (0, 0), pos: (0, 0), isMove: false)


class GameScene: SKScene, SKPhysicsContactDelegate {
    var background = SKSpriteNode(imageNamed: "city")
    var sportNode: SKSpriteNode?
    
    var score: Int?
    let scoreIncrement = 10
    var lblScore = SKLabelNode()
    var lblTitle = SKLabelNode()
    
    func initLabels() {
        lblScore.name = "lblScore"
        lblScore.text = "Score: "
        lblScore.fontSize = 64
        lblScore.fontColor = .red
        lblScore.position = CGPoint(x: 200, y: 200)
        lblScore.zPosition = 11
        addChild(lblScore)
        
        lblTitle.name = "lblTitle"
        lblTitle.text = "My Game"
        lblTitle.fontSize = 64
        lblTitle.fontColor = .red
        lblTitle.position = CGPoint(x: 500, y: 500)
        lblTitle.zPosition = 11
        addChild(lblTitle)
        
    }
    
    override func didMove(to view: SKView) {
        initLabels()
        
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        background.alpha = 0.3
        addChild(background)
        
        lblTitle.alpha = 0.0
        lblTitle.run(SKAction.fadeIn(withDuration: 2.0))
        
        sportNode = SKSpriteNode(imageNamed: "pika")
        sportNode?.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        playerPos.pos = (sportNode!.position.x, sportNode!.position.y)
        sportNode?.size = CGSize(width: 50, height: 50)
        addChild(sportNode!)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        sportNode?.physicsBody = SKPhysicsBody(circleOfRadius: (sportNode?.size.width)! / 2)
        sportNode?.physicsBody?.isDynamic = true
        sportNode?.physicsBody?.categoryBitMask = PhysicsCategory.Hero
        sportNode?.physicsBody?.contactTestBitMask = PhysicsCategory.Baddy
        sportNode?.physicsBody?.collisionBitMask = PhysicsCategory.None
        sportNode?.physicsBody?.usesPreciseCollisionDetection = true
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addBaddy), SKAction.wait(forDuration: 0.5)])))
        
        score = 0
        lblScore.text = "Score: \(score!)"
        
        lblScore.alpha = 0.0
        lblScore.run(SKAction.fadeIn(withDuration: 2.0))
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addBaddy() {
        let baddy = SKSpriteNode(imageNamed: "pika")
        baddy.size = CGSize(width: 40, height: 40)
        baddy.color = .red
        baddy.xScale = baddy.xScale * -1
        
        let actualY = random(min: baddy.size.height / 2, max: size.height - baddy.size.height / 2)
        
        baddy.position = CGPoint(x: size.width + baddy.size.width / 2, y: actualY)
        
        addChild(baddy)
        
        baddy.physicsBody = SKPhysicsBody(rectangleOf: baddy.size)
        baddy.physicsBody?.isDynamic = true
        baddy.physicsBody?.categoryBitMask = PhysicsCategory.Baddy
        baddy.physicsBody?.contactTestBitMask = PhysicsCategory.Hero
        baddy.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        let actionMove = SKAction.move(to: CGPoint(x: -baddy.size.width / 2, y: actualY), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        
        baddy.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    func moveGoodGuy(pos: CGPoint) {
        playerPos.isMove = true
        let actionMove = SKAction.move(to: pos, duration: TimeInterval(0.4))
        let actionMoveDone = SKAction.run {
            playerPos.isMove = false
        }
        sportNode?.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    var drag = CheckDrag(movableNode: CGPoint.zero, dragDirection: -1)
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let pos: CGPoint = (touches.first?.location(in: self))!
        drag.movableNode = pos
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let pos: CGPoint = (touches.first?.location(in: self))!
        let difference = CGPoint(x: drag.movableNode.x - pos.x, y: drag.movableNode.y - pos.y)
        
        if !playerPos.isMove {
            // 좌, 우 둘 중 하나라는 뜻
            if abs(difference.x) > abs(difference.y) {
                // 우 라는 뜻
                if abs(difference.x) > 50 {
                    if difference.x < 0 {
                        if checkPossible(player: playerPos, go: (1, 0)) {
                            moveGoodGuy(pos: CGPoint(x: playerPos.pos.0 + 80, y: playerPos.pos.1))
                            playerPos.pos = (playerPos.pos.0 + 80, playerPos.pos.1)
                            playerPos.index = (playerPos.index.0 + 1, playerPos.index.1)
                        }
                    }
                    // 좌 라는 뜻
                    else {
                        if checkPossible(player: playerPos, go: (-1, 0)) {
                            moveGoodGuy(pos: CGPoint(x: playerPos.pos.0 - 80, y: playerPos.pos.1))
                            playerPos.pos = (playerPos.pos.0 - 80, playerPos.pos.1)
                            playerPos.index = (playerPos.index.0 - 1, playerPos.index.1)
                        }
                    }
                }
            }
            // 상, 하 둘 중 하나라는 뜻
            else {
                if abs(difference.y) > 50 {
                    // 상 라는 뜻
                    if difference.y < 0 {
                        if checkPossible(player: playerPos, go: (0, 1)) {
                            moveGoodGuy(pos: CGPoint(x: playerPos.pos.0, y: playerPos.pos.1 + 80))
                            playerPos.pos = (playerPos.pos.0, playerPos.pos.1 + 80)
                            playerPos.index = (playerPos.index.0, playerPos.index.1 + 1)
                        }
                    }
                    // 하 라는 뜻
                    else {
                        if checkPossible(player: playerPos, go: (0, -1)) {
                            moveGoodGuy(pos: CGPoint(x: playerPos.pos.0, y: playerPos.pos.1 - 80))
                            playerPos.pos = (playerPos.pos.0, playerPos.pos.1 - 80)
                            playerPos.index = (playerPos.index.0, playerPos.index.1 - 1)
                        }
                    }
                }
            }
        }
    }
    
    func checkPossible(player: PlayerPos, go: (Int, Int)) -> Bool {
        if playerPos.index.0 + go.0 > -2 && playerPos.index.0 + go.0 < 2 && playerPos.index.1 + go.1 > -2 && playerPos.index.1 + go.1 < 2 {
            return true
        }
        return false
    }
    
    func heroDidCollideWithBaddy(hero: SKSpriteNode, baddy: SKSpriteNode) {
        
        score = score! + scoreIncrement
        lblScore.text = "Score: \(score!)"
        lblScore.alpha = 0.0
        lblScore.run(SKAction.fadeIn(withDuration: 2.0))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.Baddy != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Hero != 0)) {
            heroDidCollideWithBaddy(hero: firstBody.node as! SKSpriteNode, baddy: secondBody.node as! SKSpriteNode)
        }
    }
}
