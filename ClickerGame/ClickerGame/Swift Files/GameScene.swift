//
//  GameScene.swift
//  ClickerGame
//
//  Created by Tristan Pudell-Spatscheck on 12/19/19.
//  Copyright © 2019 Tristan Pudell-Spatscheck. All rights reserved.
//
// Button randomly teleports around and needs to be clicked fast, but in a combo
import UIKit
import SpriteKit
import GameplayKit
//MARK - Global Variables
var gameSC: SKScene = SKScene()
var points: Int = 0 //points the person has
var pointMult: Int = 1 //points multiplyer
var combo: Int = 0
class GameScene: SKScene {
    //MARK - Variables
    var pointsLbl = SKLabelNode()
    var clickSprite = SKSpriteNode()
    //MARK - Functions
    //Viewdid load
    override func didMove(to view: SKView) {
        gameSC = self
        pointsLbl = self.childNode(withName: "pointsLbl") as! SKLabelNode
        pointsLbl.position = CGPoint(x: 0, y: (self.view?.bounds.maxY)! - 200 )
        pointsLbl.text = "Points: \(points)"
        clickSprite = self.childNode(withName: "clickSprite") as! SKSpriteNode
        clickSprite.isUserInteractionEnabled = false
        clickSprite.size = CGSize(width: 50, height: 50)
        setPos()
    }
    //sets sprite position to random spot on screen
    func setPos(){
        var xPos: CGFloat = CGFloat(Int.random(in: (Int((gameSC.view?.bounds.minX)!) + 50)...(Int((gameSC.view?.bounds.maxX)!)) - 50))
        var yPos: CGFloat = CGFloat(Int.random(in: (Int((gameSC.view?.bounds.minY)!) + 50)...(Int((gameSC.view?.bounds.maxY)!)) - 50))
        var positive: Bool = false
        positive = Bool.random()
        if(!positive){
            xPos *= -1
        }
        positive = Bool.random()
        if(!positive){
            yPos *= -1
        }
        clickSprite.position = CGPoint(x: xPos, y: yPos)
    }
    //Detects Tap (Beggining) TO ADD: check if touching "click Sprite"
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self.view)
        if clickSprite.contains(touch.location(in: self)) { //if clicksprite is clicked
            setPos()
            points += (1 * pointMult)
        }
        else{ //if sprite not touched
            points += (-1 * pointMult)
            print("Location: \(location) , Sprite Location: \(clickSprite.position), Points: \(points)")
        }
        pointsLbl.text = "Points: \(points)"
    }
    //Update function
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
