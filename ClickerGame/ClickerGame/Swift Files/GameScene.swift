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
var points: Double = 0 //points the person has
var pointMult: Double = 1 //points multiplyer
var autoPts: Double = 0
var combo: Int = 0
var fastestTime: Double = 100
var shopping = false
var music = false
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
    var opt3Lbl = SKLabelNode()
    var opt4Box = SKSpriteNode()
    var opt4Lbl = SKLabelNode()
    var time: Double = 0
    var autoTime: Double = 0
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
        if(UserDefaults.standard.double(forKey: "ptMult") != 0){ //checks for first time load
        points = UserDefaults.standard.double(forKey: "points")
        pointMult = UserDefaults.standard.double(forKey: "ptMult")
        autoPts = UserDefaults.standard.double(forKey: "autoPts")
        fastestTime = UserDefaults.standard.double(forKey: "fastTM")
        music = UserDefaults.standard.bool(forKey: "music")
        }
        //points label at top of screen
        pointsLbl = self.childNode(withName: "pointsLbl") as! SKLabelNode
        pointsLbl.position = CGPoint(x: 0, y: scrHeight - safeArea.top - pointsLbl.frame.height)
        let ptString = Double(round(100 * points) / 100)
        pointsLbl.text = "Points: \(ptString)"
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
        shopLbl.position = CGPoint(x: 0, y: (bckgBox.size.height / 2) - shopLbl.frame.height)
        shopLbl.zPosition = 7
        let scrDiv = (bckgBox.size.height - (shopLbl.frame.height * 2)) / 2
        //fourth (next set) of options
        opt4Lbl = SKLabelNode(text: "Music: OFF")
        opt4Lbl.fontColor = UIColor(ciColor: .black)
        opt4Lbl.zPosition = 9
        opt4Box = SKSpriteNode(color: UIColor(ciColor: .red), size: CGSize(width: bckgBox.size.width / 1.5, height: 100))
        let b4Y = -(scrDiv) + (opt4Box.size.height / 2) + (shopLbl.frame.height / 2)
        print(scrDiv)
        opt4Box.position = CGPoint(x: 0, y: b4Y)
        opt4Box.zPosition = 8
        opt4Lbl.position = opt4Box.position
        //first option
        opt1Lbl = SKLabelNode(text: "Upgrade Click Worth")
        opt1Lbl.fontColor = UIColor(ciColor: .black)
        opt1Lbl.zPosition = 9
        opt1Box = SKSpriteNode(color: UIColor(ciColor: .red), size: CGSize(width: bckgBox.size.width / 1.5, height: 100))
        opt1Box.position = CGPoint(x: 0, y: opt4Box.position.y + (scrDiv / 2))
        opt1Box.zPosition = 8
        opt1Lbl.position = opt1Box.position
        //second option
        opt2Lbl = SKLabelNode(text: "Upgrade Auto-Clicker")
        opt2Lbl.fontColor = UIColor(ciColor: .black)
        opt2Lbl.zPosition = 9
        opt2Box = SKSpriteNode(color: UIColor(ciColor: .red), size: CGSize(width: bckgBox.size.width / 1.5, height: 100))
        opt2Box.position = CGPoint(x: 0, y: opt1Box.position.y + (scrDiv / 2))
        opt2Box.zPosition = 8
        opt2Lbl.position = opt2Box.position
        //third option
        opt3Lbl = SKLabelNode(text: "Remove ADS")
        opt3Lbl.fontColor = UIColor(ciColor: .black)
        opt3Lbl.zPosition = 9
        opt3Box = SKSpriteNode(color: UIColor(ciColor: .red), size: CGSize(width: bckgBox.size.width / 1.5, height: 100))
        opt3Box.position = CGPoint(x: 0, y: opt2Box.position.y + (scrDiv / 2))
        opt3Box.zPosition = 8
        opt3Lbl.position = opt3Box.position
        if(music){ //changes text if music is on
            opt4Lbl.text = "Music: ON"
        }
        gameVC.playSong(song: "bckgLoop")
        setPos()
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
            self.addChild(opt3Box)
            self.addChild(opt3Lbl)
            self.addChild(opt4Box)
            self.addChild(opt4Lbl)
            shopButton.isHidden = true
            closeShop.isHidden = false
            shopping = true
        } else { //if closed
            time = tempTime
            bckgBox.parent?.removeChildren(in: [bckgBox, shopLbl, opt1Box, opt1Lbl, opt2Box, opt2Lbl, opt3Box, opt3Lbl, opt4Box, opt4Lbl])
            shopButton.isHidden = false
            closeShop.isHidden = true
            shopping = false
        }
    }
    //Detects Tap (Beggining) TO ADD: check if touching "click Sprite"
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self.view)
        if(!shopping){
            if (clickSprite.contains(touch.location(in: self))) { //if clicksprite is clicked
                setPos()
                points += pointMult
                if(time < fastestTime){
                    fastestTime = time
                    UserDefaults.standard.set(fastestTime, forKey: "fastTm")
                }
                time = 0
            }
            else if (shopButton.contains(touch.location(in: self))){ //if shopping
                print("shopping")
                setShop(open: true)
            }
            else{ //if sprite not touched
                points += -pointMult
                print("Locatin: \(location) , Sprite Location: \(clickSprite.position), Points: \(points)")
                pointsLbl.text = "Points: \(points)"
            }
        } else { //if shopping
            if (closeShop.contains(touch.location(in: self))){ //if stopping shopping
                print("stopping")
                setShop(open: false)
            }
            else if (opt1Box.contains(touch.location(in: self))){ //first option
                if(points >= 50){
                    points += -50
                    pointMult *= 1.05
                } else {
                    gameVC.makeAlert(scene: gameSC, message: "Not enough points")
                }
            }
            else if (opt2Box.contains(touch.location(in: self))){ //second option
                if(points >= 50){
                    points += -50
                    autoPts += 0.1
                } else {
                    gameVC.makeAlert(scene: gameSC, message: "Not enough points")
                }
            }
            else if (opt3Box.contains(touch.location(in: self))){ //third option
                print("ADs Removed")
            }
            else if (opt4Box.contains(touch.location(in: self))){ //fourth option
                music = !music
                opt4Lbl.text = "Music: OFF"
                if(music){
                    opt4Lbl.text = "Music: ON"
                }
                gameVC.playSong(song: "bckgLoop")
            }
            else{
                print("Other click")
            }
        }
        //save here to not cause problems with first time loads
        UserDefaults.standard.set(music, forKey: "music")
        UserDefaults.standard.set(pointMult, forKey: "ptMult")
        UserDefaults.standard.set(autoPts, forKey: "autoPts")
        UserDefaults.standard.set(points, forKey: "points")
        let ptString = Double(round(100 * points) / 100)
        pointsLbl.text = "Points: \(ptString)" //changes it to 2 decimals
    }
    //Update function
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        time += (1/60)
        autoTime += (1/60)
        if(autoTime > 20){
            autoTime = 0
            points += autoPts
            UserDefaults.standard.set(points, forKey: "points")
        }
    }
}
