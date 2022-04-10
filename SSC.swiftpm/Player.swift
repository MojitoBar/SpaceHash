//
//  Player.swift
//  SSC
//
//  Created by judongseok on 2022/04/10.
//

import Foundation
import GameplayKit

extension GameScene {
    // 플레이어가 움직일 수 있는지 체크
    func checkPossible(player: PlayerPos, go: (Int, Int)) -> Bool {
        if playerPos.index.0 + go.0 > -2 && playerPos.index.0 + go.0 < 2 && playerPos.index.1 + go.1 > -2 && playerPos.index.1 + go.1 < 2 {
            return true
        }
        return false
    }
    
    // 플레이어 Move함수
    func moveGoodGuy(pos: CGPoint) {
        playerPos.isMove = true
        let actionMove = SKAction.move(to: pos, duration: TimeInterval(0.4))
        let actionMoveDone = SKAction.run {
            playerPos.isMove = false
        }
        sportNode?.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
}
