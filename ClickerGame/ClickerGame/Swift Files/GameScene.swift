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
var testData: [Double] = [] //TEST DATA FOR TESTING PURPOSES, REMOVE IN REAL GAME
var fastestTime: Double = 100
var shopping = false
class GameScene: SKScene {
    //MARK - Variables
    var pointsLbl = SKLabelNode()
    var clickSprite = SKSpriteNode()
    var shopButton = SKSpriteNode()
    var closeShop = SKSpriteNode()
    var time: Double = 0
    let safeArea = UIApplication.shared.windows[0].safeAreaInsets //gets safe area for each device
    //screen height and width
    var scrHeight: CGFloat = 0
    var scrWidth: CGFloat = 0
    //MARK - Functions
    //Viewdid load
    override func didMove(to view: SKView) {
        gameSC = self
        gameSC.size = CGSize(width: UIScreen.main.bounds.size.width * 2, height: UIScreen.main.bounds.size.height * 2)
        scrHeight = self.size.height / 2
        scrWidth = self.size.width / 2
        pointsLbl = self.childNode(withName: "pointsLbl") as! SKLabelNode
        pointsLbl.position = CGPoint(x: 0, y: scrHeight - safeArea.top - pointsLbl.frame.height)
        pointsLbl.text = "Points: \(points)"
        clickSprite = self.childNode(withName: "clickSprite") as! SKSpriteNode
        clickSprite.isUserInteractionEnabled = false
        clickSprite.size = CGSize(width: 100, height: 100)
        clickSprite.zPosition = 1
        shopButton = self.childNode(withName: "shopButton") as! SKSpriteNode
        shopButton.isUserInteractionEnabled = false
        shopButton.size = CGSize(width: 200, height: 100)
        shopButton.color = UIColor(ciColor: .blue)
        shopButton.position = CGPoint(x: 0, y: -scrHeight + safeArea.bottom + 50)
        closeShop = self.childNode(withName: "closeShop") as! SKSpriteNode
        closeShop.size = CGSize(width: 200, height: 100)
        closeShop.isUserInteractionEnabled = false
        closeShop.isHidden = true
        closeShop.color = UIColor(ciColor: .green)
        closeShop.position = shopButton.position
        setPos()
    }
    //sets sprite position to random spot on screen
    func setPos(){
        print("Screen Size: \(UIScreen.main.bounds.width) , \(UIScreen.main.bounds.height) \n Scene Size: \(scrWidth) , \(scrHeight)")
        let xPos: CGFloat = CGFloat.random(in: -scrWidth + 40...scrWidth - 40)
        let yPos: CGFloat = CGFloat.random(in: -scrHeight + 40 + safeArea.bottom...scrHeight - 40 - safeArea.top)
        clickSprite.position = CGPoint(x: xPos, y: yPos)
    }
    //sets up shop
    func setShop(){
        print("bruh")
    }
    //Detects Tap (Beggining) TO ADD: check if touching "click Sprite"
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self.view)
        if clickSprite.contains(touch.location(in: self)) { //if clicksprite is clicked
            testData.append(time)
            setPos()
            points += (1 * pointMult)
            if(time < fastestTime){
                fastestTime = time
            }
            time = 0
            pointsLbl.text = "Points: \(points)"
        }
        else if (!shopping && shopButton.contains(touch.location(in: self))){ //if shopping
            print("shopping")
            shopButton.isHidden = true
            closeShop.isHidden = false
            shopping = true
            setShop()
        }
        else if (shopping && closeShop.contains(touch.location(in: self))){ //if stopping shopping
            print("stopping")
            shopButton.isHidden = false
            closeShop.isHidden = true
            shopping = false
        }
        else{ //if sprite not touched
            points += (-1 * pointMult)
            print("Location: \(location) , Sprite Location: \(clickSprite.position), Points: \(points)")
            pointsLbl.text = "Points: \(points)"
        }
    }
    //Update function
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        time += (1/60)
    }
}
