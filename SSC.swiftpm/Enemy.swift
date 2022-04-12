//
//  Enemy.swift
//  SSC
//
//  Created by judongseok on 2022/04/10.
//

import Foundation
import GameplayKit

extension GameScene {
    func random() -> UInt32 {
        return arc4random_uniform(12)
    }
    
    func addBaddy() {
        let mid: (CGFloat, CGFloat) = (frame.size.width / 2, frame.size.height / 2)
        
        // 12개 시작 포지션
        let startPos: [(CGFloat, CGFloat)] = [
            (mid.0, mid.1 + 500),
            (mid.0, mid.1 - 500),
            (mid.0 + 500, mid.1),
            (mid.0 - 500, mid.1),
            
            (mid.0 + 80, mid.1 + 500),
            (mid.0 + 80, mid.1 - 500),
            (mid.0 + 500, mid.1 + 80),
            (mid.0 - 500, mid.1 + 80),
            
            (mid.0 - 80, mid.1 + 500),
            (mid.0 - 80, mid.1 - 500),
            (mid.0 + 500, mid.1 - 80),
            (mid.0 - 500, mid.1 - 80)
        ]
        
        let endPos: [(CGFloat, CGFloat)] = [
            (mid.0, mid.1 - 500),
            (mid.0, mid.1 + 500),
            (mid.0 - 500, mid.1),
            (mid.0 + 500, mid.1),
            
            (mid.0 + 80, mid.1 - 500),
            (mid.0 + 80, mid.1 + 500),
            (mid.0 - 500, mid.1 + 80),
            (mid.0 + 500, mid.1 + 80),
            
            (mid.0 - 80, mid.1 - 500),
            (mid.0 - 80, mid.1 + 500),
            (mid.0 - 500, mid.1 - 80),
            (mid.0 + 500, mid.1 - 80)
        ]
        
        let baddy = SKSpriteNode(imageNamed: "moon")
        baddy.size = CGSize(width: 40, height: 40)
        baddy.color = .red
        baddy.xScale = baddy.xScale * -1
        
        let index = Int(random())
        
        baddy.position = CGPoint(x: startPos[index].0, y: startPos[index].1)
        addChild(baddy)
        print(baddy.position)
        
        baddy.physicsBody = SKPhysicsBody(rectangleOf: baddy.size)
        baddy.physicsBody?.isDynamic = true
        baddy.physicsBody?.categoryBitMask = PhysicsCategory.Baddy
        baddy.physicsBody?.contactTestBitMask = PhysicsCategory.Hero
        baddy.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        let actionMove = SKAction.move(to: CGPoint(x: endPos[index].0, y: endPos[index].1), duration: TimeInterval(4))
        let actionMoveDone = SKAction.removeFromParent()
        
        baddy.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
}
