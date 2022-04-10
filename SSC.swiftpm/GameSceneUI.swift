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
}
