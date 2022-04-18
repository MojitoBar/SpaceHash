//
//  GameScene.swift
//  SSC
//
//  Created by judongseok on 2022/04/07.
//

import Foundation
import GameplayKit
import SwiftUI

struct PhysicsCategory {
    static let None: UInt32 = 0
    static let All: UInt32 = UInt32.max
    static let Baddy: UInt32 = 0x1 << 0
    static let Hero: UInt32 = 0x1 << 1
    static let coin: UInt32 = 0x1 << 2
    
    static let Projectile: UInt32 = 0b11
}

struct CheckDrag {
    var movableNode: CGPoint
    var dragDirection: Int
}

struct PlayerPos {
    var index: (Int, Int)
    var pos: (CGFloat, CGFloat)
    var isMove: Bool
}

let userDefaults = UserDefaults.standard
var playerPos = PlayerPos(index: (0, 0), pos: (0, 0), isMove: false)

class GameScene: SKScene, SKPhysicsContactDelegate, ObservableObject {
    @Published var gameOver: Bool = false
    @Published var score: Int = 0
    
    var background = SKSpriteNode(imageNamed: "background")
    var grid = SKSpriteNode(imageNamed: "grid2")
    var sportNode: SKSpriteNode?
    let coin = SKSpriteNode(imageNamed: "coin")
    var scoreLabel: SKLabelNode?
    
    let scoreIncrement = 10
    var heart: [SKSpriteNode] = [SKSpriteNode(imageNamed: "heart"), SKSpriteNode(imageNamed: "heart"), SKSpriteNode(imageNamed: "heart")]
    var heartCount: Int = 3
    var coinIndex = 0
    
    var coinPosition: [(CGFloat, CGFloat)]?
    override func didMove(to view: SKView) {
        playerPos = PlayerPos(index: (0, 0), pos: (0, 0), isMove: false)
        
        coinPosition = [
            (frame.size.width / 2, frame.size.height / 2),
            (frame.size.width / 2, frame.size.height / 2 + 80),
            (frame.size.width / 2, frame.size.height / 2 - 80),
            (frame.size.width / 2 + 80, frame.size.height / 2),
            (frame.size.width / 2 - 80, frame.size.height / 2),
            (frame.size.width / 2 + 80, frame.size.height / 2 + 80),
            (frame.size.width / 2 - 80, frame.size.height / 2 - 80),
            (frame.size.width / 2 + 80, frame.size.height / 2 - 80),
            (frame.size.width / 2 - 80, frame.size.height / 2 + 80)
        ]
        
        initLabels()
        
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        background.size = CGSize(width: frame.size.width, height: frame.size.height)
        addChild(background)
        
        grid.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        grid.size = CGSize(width: 210, height: 210)
        addChild(grid)
        
        sportNode = SKSpriteNode(imageNamed: "earth")
        sportNode?.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        playerPos.pos = (sportNode!.position.x, sportNode!.position.y)
        sportNode?.size = CGSize(width: 50, height: 50)
        addChild(sportNode!)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        sportNode?.physicsBody = SKPhysicsBody(circleOfRadius: (sportNode?.size.width)! / 2)
        sportNode?.physicsBody?.isDynamic = true
        sportNode?.physicsBody?.categoryBitMask = PhysicsCategory.Hero
        sportNode?.physicsBody?.contactTestBitMask = PhysicsCategory.coin | PhysicsCategory.Baddy
        sportNode?.physicsBody?.collisionBitMask = PhysicsCategory.None
        sportNode?.physicsBody?.usesPreciseCollisionDetection = true
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addBaddy), SKAction.wait(forDuration: 1)])))
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(rotationPlayer), SKAction.wait(forDuration: 2)])))
        initHeart()
        createCoin(index: 0)
        score = 0
    }
    
    func initHeart() {
        for i in 0..<heartCount {
            heart[i].size = CGSize(width: 25, height: 23)
            heart[i].position = CGPoint(x: CGFloat(i * 40 + 50), y: frame.size.height - 80)
            
            addChild(heart[i])
        }
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
    
    // 충돌 시 점수 로직
    func heroDidCollideWithBaddy(hero: SKSpriteNode, baddy: SKSpriteNode) {
        if heartCount > 1 {
            heartCount -= 1
            heart[heartCount].run(SKAction.sequence([SKAction.resize(toWidth: 0, duration: 0), SKAction.resize(toHeight: 0, duration: 0)]))
        }
        else {
            heartCount -= 1
            heart[heartCount].run(SKAction.sequence([SKAction.resize(toWidth: 0, duration: 0), SKAction.resize(toHeight: 0, duration: 0), SKAction.run { [self] in
                gameOver = true
                if userDefaults.integer(forKey: "maxValue") < score {
                    userDefaults.set(score, forKey: "maxValue")
                }
                print(userDefaults.integer(forKey: "maxValue"))
                self.speed = 0
            }]))
            
        }
    }
    
    // 충돌 체크
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
        if firstBody.categoryBitMask == PhysicsCategory.Hero && secondBody.categoryBitMask == PhysicsCategory.coin {
            changeCoinPosition(index: coinIndex)
            score += 100
            scoreLabel?.text = "SCORE: \(score)"
        }
    }
}
