//
//  GameSceneUI.swift
//  SSC
//
//  Created by judongseok on 2022/04/10.
//

import Foundation
import GameplayKit

extension GameScene {
    func initLabels() {
        scoreLabel = SKLabelNode()
        scoreLabel?.name = "lbScore"
        scoreLabel?.text = "SCORE: 0"
        scoreLabel?.fontSize = 18
        scoreLabel?.fontName = "Courier-Bold"
        scoreLabel?.horizontalAlignmentMode = .right
        scoreLabel?.fontColor = .white
        scoreLabel?.position = CGPoint(x: 350, y: frame.size.height - 80)
        scoreLabel?.zPosition = 20
        
        scoreLabel?.run(SKAction.repeatForever(SKAction.sequence([SKAction.run { [self] in
            score += 10
            scoreLabel!.text = "SCORE: \(score)"
        }, SKAction.wait(forDuration: 0.5)])))
        addChild(scoreLabel!)
    }
}
