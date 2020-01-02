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
    var bckgBox = SKSpriteNode()
    var shopLbl = SKLabelNode()
    var opt1Box = SKSpriteNode()
    var opt1Lbl = SKLabelNode()
    var opt2Box = SKSpriteNode()
    var opt2Lbl = SKLabelNode()
    var opt3Box = SKSpriteNode()
    var opt3Lbl = SKLableNode()
    var opt4Box = SKSpriteNode()
    var opt4Lbl = SKLabelNode()
    var time: Double = 0
    var tempTime: Double = 0
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
        points = UserDefaults.standard.integer(forKey: "points")
        //points label at top of screen
        pointsLbl = self.childNode(withName: "pointsLbl") as! SKLabelNode
        pointsLbl.position = CGPoint(x: 0, y: scrHeight - safeArea.top - pointsLbl.frame.height)
        pointsLbl.text = "Points: \(points)"
        pointsLbl.zPosition = 2
        //sprite to be clicked
        clickSprite = self.childNode(withName: "clickSprite") as! SKSpriteNode
        clickSprite.isUserInteractionEnabled = false
        clickSprite.size = CGSize(width: 100, height: 100)
        clickSprite.zPosition = 5
        //shop button
        shopButton = self.childNode(withName: "shopButton") as! SKSpriteNode
        shopButton.isUserInteractionEnabled = false
        shopButton.size = CGSize(width: 200, height: 100)
        shopButton.color = UIColor(ciColor: .blue)
        shopButton.position = CGPoint(x: 0, y: -scrHeight + safeArea.bottom + 50)
        shopButton.zPosition = 1
        //close shop button
        closeShop = self.childNode(withName: "closeShop") as! SKSpriteNode
        closeShop.size = CGSize(width: 200, height: 100)
        closeShop.isUserInteractionEnabled = false
        closeShop.isHidden = true
        closeShop.color = UIColor(ciColor: .green)
        closeShop.position = shopButton.position
        closeShop.zPosition = shopButton.zPosition
        //shop background
        bckgBox = SKSpriteNode(color: UIColor(ciColor: .white), size: CGSize(width: (scrWidth * 1.5) - safeArea.left - safeArea.right, height: (scrHeight * 1.5) - safeArea.top - safeArea.bottom))
        bckgBox.position = CGPoint(x: 0, y: 0)
        bckgBox.zPosition = 6
        //shop label
        shopLbl = SKLabelNode(text: "SHOP")
        shopLbl.fontColor = UIColor(ciColor: .black)
        shopLbl.position = CGPoint(x: 0, y: bckgBox.size.height / 2 - shopLbl.frame.height)
        shopLbl.zPosition = 7
        //first option
        opt1Lbl = SKLabelNode(text: "Option 1 : 5 Points")
        opt1Lbl.fontColor = UIColor(ciColor: .black)
        opt1Lbl.zPosition = 9
        opt1Box = SKSpriteNode(color: UIColor(ciColor: .red), size: CGSize(width: bckgBox.size.width / 1.5, height: 100))
        opt1Box.position = CGPoint(x: 0, y: shopLbl.position.y - (shopLbl.frame.height / 2) - 100)
        opt1Box.zPosition = 8
        opt1Lbl.position = opt1Box.position
        setPos()
        //second option
        opt2Lbl = SKLabelNode(text: "Option 2 : 10 Points")
        opt2Lbl.fontColor = UIColor(ciColor: .black)
        opt2Lbl.zPosition = 9
        opt2Box = SKSpriteNode(color: UIColor(ciColor: .red), size: CGSize(width: bckgBox.size.width / 1.5, height: 100))
        opt2Box.position = CGPoint(x: 0, y: shopLbl.position.y - (shopLbl.frame.height / 2) - 300)
        opt2Box.zPosition = 8
        opt2Lbl.position = opt2Box.position
        setPos()
        //third option
        //fourth (next set) of options
        
    }
    //sets sprite position to random spot on screen
    func setPos(){
        //print("Screen Size: \(UIScreen.main.bounds.width) , \(UIScreen.main.bounds.height) \n Scene Size: \(scrWidth) , \(scrHeight)")
        //^ Prints screen size VS scene size, used to cause bugs
        let xPos: CGFloat = CGFloat.random(in: -scrWidth + 50...scrWidth - 50)
        let yPos: CGFloat = CGFloat.random(in: -scrHeight + 50 + safeArea.bottom...scrHeight - 50 - safeArea.top)
        clickSprite.position = CGPoint(x: xPos, y: yPos)
    }
    //sets up shop
    func setShop(open: Bool){
        if(open){
            tempTime = time //saves time when buttonw as clicked
            self.addChild(bckgBox)
            self.addChild(shopLbl)
            self.addChild(opt1Box)
            self.addChild(opt1Lbl)
            self.addChild(opt2Box)
            self.addChild(opt2Lbl)
            shopButton.isHidden = true
            closeShop.isHidden = false
            shopping = true
        } else { //if closed
            time = tempTime
            bckgBox.parent?.removeChildren(in: [bckgBox, shopLbl, opt1Box, opt1Lbl, opt2Box, opt2Lbl])
            shopButton.isHidden = false
            closeShop.isHidden = true
            shopping = false
        }
    }
    //Detects Tap (Beggining) TO ADD: check if touching "click Sprite"
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self.view)
        if (!shopping && clickSprite.contains(touch.location(in: self))) { //if clicksprite is clicked
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
            setShop(open: true)
        }
        else if (shopping && closeShop.contains(touch.location(in: self))){ //if stopping shopping
            print("stopping")
            setShop(open: false)
        }
        else if (shopping){
            print("Other click")
        }
        else{ //if sprite not touched
            points += (-1 * pointMult)
            print("Location: \(location) , Sprite Location: \(clickSprite.position), Points: \(points)")
            pointsLbl.text = "Points: \(points)"
        }
        UserDefaults.standard.set(points, forKey: "points")
    }
    //Update function
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        time += (1/60)
    }
}
