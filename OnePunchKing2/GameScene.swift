//
//  GameScene.swift
//  OnePunchKing2
//
//  Created by Jerry Shi on 1/24/16.
//  Copyright (c) 2016 jerryszp. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let ballCategoryName = "ball"
    let onePunchCategoryName = "onePunch"
    let hardkingCategoryName = "hardking"
    
    let ballCategory:UInt32 = 0x1 << 0              // 000000001
    let bottomCategory:UInt32 = 0x1 << 1            // 000000010
    let hardCategory:UInt32 = 0x1 << 2             // 000000100
    let onePunchCategory:UInt32 = 0x1 << 3            // 000001000
    
    var holdingOnePunch = false
    
    override init(size: CGSize){
        super.init(size: size)
        
        self.physicsWorld.contactDelegate = self
        
        let backgroundImage = SKSpriteNode(imageNamed: "bg")
        backgroundImage.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        self.addChild(backgroundImage)
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        let worldBorder = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody = worldBorder
        self.physicsBody!.friction = 0
        
        let ball = SKSpriteNode(imageNamed: "ball")
        ball.name = ballCategoryName
        ball.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/4)
        self.addChild(ball)
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.size.width/2)
        ball.physicsBody!.restitution = 1
        ball.physicsBody!.linearDamping = 0
        ball.physicsBody!.allowsRotation = true
        ball.physicsBody!.applyImpulse(CGVector(dx: 6, dy: 3))
        
        let OnePunch = SKSpriteNode(imageNamed: "onePunch")
        OnePunch.name = onePunchCategoryName
        OnePunch.position = CGPoint(x: self.frame.midX, y: OnePunch.frame.size.height * 0.36)
        
        self.addChild(OnePunch)
        
        OnePunch.physicsBody = SKPhysicsBody(rectangleOf: OnePunch.frame.size)
        OnePunch.physicsBody?.friction = 0
        OnePunch.physicsBody?.restitution = 1
        OnePunch.physicsBody?.isDynamic = false
        
        let bottomRect = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: 1)
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFrom: bottomRect)
        
        self.addChild(bottom)
        
        bottom.physicsBody?.categoryBitMask = bottomCategory
        ball.physicsBody?.categoryBitMask = ballCategory
        OnePunch.physicsBody?.categoryBitMask = onePunchCategory
        
        ball.physicsBody?.contactTestBitMask = bottomCategory | hardCategory
        
        let numberOfRows = 2
        let numberOfHards = 5
        let hardWidth = SKSpriteNode(imageNamed: "hard4").size.width
        let unoPunch:Float = 20
        
        let offset:Float = (Float(self.frame.size.width) - (Float(hardWidth) * Float(numberOfHards) + unoPunch * (Float(numberOfHards) - 1) ) ) / 2
        
        for index in 1 ... numberOfRows{
            
            var yOffset:CGFloat{
                switch index {
                case 1:
                    return self.frame.size.height * 0.8
                case 2:
                    return self.frame.size.height * 0.6
                case 3:
                    return self.frame.size.height * 0.4
                default:
                    return 0
                }
            }
            
            
            for index in 1 ... numberOfHards {
                let hardKing = SKSpriteNode(imageNamed: "hard4")
                
                let calc1:Float = Float(index) - 0.5
                let calc2:Float = Float(index) - 1
                
                hardKing.position = CGPoint(x: CGFloat(calc1 * Float(hardKing.frame.size.width) + calc2 * unoPunch + offset), y: yOffset)
                
                hardKing.physicsBody = SKPhysicsBody(rectangleOf: hardKing.frame.size)
                hardKing.physicsBody?.allowsRotation = false
                hardKing.physicsBody?.friction = 0
                hardKing.name = hardkingCategoryName
                hardKing.physicsBody?.categoryBitMask = hardCategory
                
                self.addChild(hardKing)
                
                
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        //let touch = touches.anyObject() as! UITouch
        let touchLocation = touch.location(in: self)
        
        let body:SKPhysicsBody? = self.physicsWorld.body(at: touchLocation)
        
        if body?.node?.name == onePunchCategoryName {
            print("OnePunch touched")
            holdingOnePunch = true
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if holdingOnePunch {
            let touch = touches.first! as UITouch
            let touchLoc = touch.location(in: self)
            let prevTouchLoc = touch.previousLocation(in: self)
            
            let onePunch = self.childNode(withName: onePunchCategoryName) as! SKSpriteNode
            
            var newXPos = onePunch.position.x + (touchLoc.x - prevTouchLoc.x)
            
            newXPos = max(newXPos, onePunch.size.width / 2)
            newXPos = min(newXPos, self.size.width - onePunch.size.width / 2)
            
            onePunch.position = CGPoint(x: newXPos, y: onePunch.position.y)
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        holdingOnePunch = false
    }
    
    func isGameWon() -> Bool{
        var numberOfBricks = 0
        
        for nodeObject in self.children{
            let node = nodeObject as SKNode
            if node.name == hardkingCategoryName {
                numberOfBricks += 1
            }
            
        }
        
        return numberOfBricks <= 0
    }

    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        
        if firstBody.categoryBitMask == ballCategory && secondBody.categoryBitMask == bottomCategory{
            let gameOverScene = GameOverScene(size: self.frame.size, playerWon:false)
            self.view?.presentScene(gameOverScene)
        }
        
        if firstBody.categoryBitMask == ballCategory && secondBody.categoryBitMask == hardCategory {
            secondBody.node?.removeFromParent()
            
            if isGameWon(){
                let youWinScene = GameOverScene(size: self.frame.size, playerWon: true)
                self.view?.presentScene(youWinScene)
            }
            
        }
    }
}
