//
//  Coin.swift
//  SSC
//
//  Created by judongseok on 2022/04/12.
//

import Foundation
import GameplayKit

extension GameScene {
    func coinRandom(n: Int) -> UInt32 {
        while true {
            let temp = arc4random_uniform(9)
            if temp != n {
                return temp
            }
        }
    }
    
    func createCoin(index: Int) {
        let posIndex = coinRandom(n: index)
        coinIndex = Int(posIndex)
        
        coin.size = CGSize(width: 25, height: 25)
        coin.position = CGPoint(x: coinPosition![Int(posIndex)].0, y: coinPosition![Int(posIndex)].1)
        
        coin.physicsBody = SKPhysicsBody(rectangleOf: coin.size)
        coin.physicsBody?.isDynamic = true
        coin.physicsBody?.categoryBitMask = PhysicsCategory.coin
        coin.physicsBody?.contactTestBitMask = PhysicsCategory.Hero
        coin.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        addChild(coin)
    }
    
    func changeCoinPosition(index: Int) {
        let posIndex = coinRandom(n: index)
        coinIndex = Int(posIndex)
        coin.run(SKAction.move(to: CGPoint(x: coinPosition![Int(posIndex)].0, y: coinPosition![Int(posIndex)].1), duration: 0))
    }
}
