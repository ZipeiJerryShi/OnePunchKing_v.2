//
//  GameScene.swift
//  OnePunchKing2
//
//  Created by Jerry Shi on 1/24/16.
//  Copyright (c) 2016 jerryszp. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
    init(size: CGSize, playerWon:Bool) {
        super.init(size: size)
        
        let background = SKSpriteNode(imageNamed: "bg")
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        self.addChild(background)
        
        
        let gameOverLabel = SKLabelNode(fontNamed: "Avenir-Black")
        gameOverLabel.color = UIColor.blue
        gameOverLabel.fontSize = 36
        gameOverLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        
        if playerWon {
            gameOverLabel.text = "You defeated Harden Glider"
        }else{
            gameOverLabel.text = "GG WP but you lost"
        }
        
        self.addChild(gameOverLabel)
        
    }
    
    /*override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
    let breakoutGameScene = GameScene(size: self.size)
    self.view?.presentScene(breakoutGameScene)
    }*/
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let breakoutGameScene = GameScene(size: self.size)
        self.view?.presentScene(breakoutGameScene)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
