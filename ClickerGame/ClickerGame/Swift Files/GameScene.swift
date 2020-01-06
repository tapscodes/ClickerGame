//
//  GameScene.swift
//  ClickerGame
//
//  Created by Tristan Pudell-Spatscheck on 12/19/19.
//  Copyright © 2019 Tristan Pudell-Spatscheck. All rights reserved.
//
// Button randomly teleports around and needs to be clicked fast, but in a combo
//top 10% = .4 seconds, top 50% = .55 seconds, top 95% = 1 second <- hard = top50%, easy = top95%
import UIKit
import SpriteKit
import GameplayKit
//MARK - Global Variables
var gameSC: SKScene = SKScene()
var points: Double = 0 //points the person has
var pointMult: Double = 1 //points multiplyer
var autoPts: Double = 0
var slowCombo: Int = 0
var fastCombo: Int = 0
var fastestTime: Double = 100
var bestSlowCombo: Int = 0
var bestFastCombo: Int = 0
var bestComboMult: Double = 1
var shopping = false
var costumes = false
var record = false
var fastActive = true // fast combo active
var textUp = false
var music = false
class GameScene: SKScene {
    //MARK - Variables
    var pointsLbl = SKLabelNode()
    var clickSprite = SKSpriteNode()
    var shopBtn = SKSpriteNode()
    var closeShop = SKSpriteNode()
    var recordBtn = SKSpriteNode()
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
    var comboNumLbl = SKLabelNode()
    var comboMultLbl = SKLabelNode()
    var earnedPointsLbl = SKLabelNode()
    var time: Double = 0
    var autoTime: Double = 0
    var tempTime: Double = 0
    var comboMult: Double = 1
    let safeArea = UIApplication.shared.windows[0].safeAreaInsets //gets safe area for each device
    //screen height and width
    var scrHeight: CGFloat = 0
    var scrWidth: CGFloat = 0
    var triggered: Bool = false
    //MARK - Functions
    //Viewdid load
    override func didMove(to view: SKView) {
        gameSC = self
        gameSC.size = CGSize(width: UIScreen.main.bounds.size.width * 2, height: UIScreen.main.bounds.size.height * 2)
        scrHeight = self.size.height / 2
        scrWidth = self.size.width / 2
        if(UserDefaults.standard.double(forKey: "points") != 0){ //checks for first time load
            points = UserDefaults.standard.double(forKey: "points")
            pointMult = UserDefaults.standard.double(forKey: "ptMult")
            autoPts = UserDefaults.standard.double(forKey: "autoPts")
            fastestTime = UserDefaults.standard.double(forKey: "fastTM")
            bestComboMult = UserDefaults.standard.double(forKey: "comboMult")
            music = UserDefaults.standard.bool(forKey: "music")
            bestSlowCombo = UserDefaults.standard.integer(forKey: "slowCombo")
            bestFastCombo = UserDefaults.standard.integer(forKey: "fastCombo")
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
        shopBtn = self.childNode(withName: "shopBtn") as! SKSpriteNode
        shopBtn.size = CGSize(width: scrWidth, height: 100)
        shopBtn.color = UIColor(ciColor: .blue)
        shopBtn.position = CGPoint(x: -(scrWidth / 2), y: -scrHeight + safeArea.bottom + 50)
        shopBtn.zPosition = 1
        //close shop button
        closeShop = self.childNode(withName: "closeShop") as! SKSpriteNode
        closeShop.size = shopBtn.size
        closeShop.isHidden = true
        closeShop.color = UIColor(ciColor: .green)
        closeShop.position = shopBtn.position
        closeShop.zPosition = shopBtn.zPosition
        //records button
        recordBtn = SKSpriteNode(color: UIColor(ciColor: .yellow), size: shopBtn.size)
        recordBtn.position = CGPoint(x: -shopBtn.position.x, y: shopBtn.position.y)
        recordBtn.zPosition = shopBtn.zPosition
        recordBtn.isHidden = false
        self.addChild(recordBtn)
        //shop background
        bckgBox = SKSpriteNode(color: UIColor(ciColor: .white), size: CGSize(width: (scrWidth * 1.5) - safeArea.left - safeArea.right, height: (scrHeight * 1.5) - safeArea.top - safeArea.bottom))
        bckgBox.position = CGPoint(x: 0, y: 0)
        bckgBox.zPosition = 6
        //shop label
        shopLbl = SKLabelNode(text: "SHOP")
        shopLbl.fontColor = UIColor(ciColor: .black)
        shopLbl.fontName = pointsLbl.fontName
        shopLbl.fontSize = 100
        shopLbl.position = CGPoint(x: 0, y: (bckgBox.size.height / 2) - shopLbl.frame.height)
        shopLbl.zPosition = 7
        let scrDiv = (bckgBox.size.height - (shopLbl.frame.height * 2)) / 2
        //fourth (next set) of options
        opt4Lbl = SKLabelNode(text: "Music: OFF")
        opt4Lbl.fontColor = UIColor(ciColor: .black)
        opt4Lbl.fontName = pointsLbl.fontName
        opt4Lbl.zPosition = 9
        opt4Box = SKSpriteNode(color: UIColor(ciColor: .red), size: CGSize(width: bckgBox.size.width / 1.5, height: 100))
        let b4Y = -(scrDiv) + (opt4Box.size.height / 2) + (shopLbl.frame.height / 2)
        print(scrDiv)
        opt4Box.position = CGPoint(x: 0, y: b4Y)
        opt4Box.zPosition = 8
        opt4Lbl.position = CGPoint(x: opt4Box.position.x ,y: opt4Box.position.y - (opt4Lbl.frame.height / 2))
        //first option
        opt1Lbl = SKLabelNode(text: "Upgrade Click Worth")
        opt1Lbl.fontColor = UIColor(ciColor: .black)
        opt1Lbl.fontName = pointsLbl.fontName
        opt1Lbl.zPosition = 9
        opt1Box = SKSpriteNode(color: UIColor(ciColor: .red), size: CGSize(width: bckgBox.size.width / 1.5, height: 100))
        opt1Box.position = CGPoint(x: 0, y: opt4Box.position.y + (scrDiv / 2))
        opt1Box.zPosition = 8
        opt1Lbl.position = CGPoint(x: opt1Box.position.x ,y: opt1Box.position.y - (opt1Lbl.frame.height / 2))
        //second option
        opt2Lbl = SKLabelNode(text: "Upgrade Auto-Clicker")
        opt2Lbl.fontColor = UIColor(ciColor: .black)
        opt2Lbl.fontName = pointsLbl.fontName
        opt2Lbl.zPosition = 9
        opt2Box = SKSpriteNode(color: UIColor(ciColor: .red), size: CGSize(width: bckgBox.size.width / 1.5, height: 100))
        opt2Box.position = CGPoint(x: 0, y: opt1Box.position.y + (scrDiv / 2))
        opt2Box.zPosition = 8
        opt2Lbl.position = CGPoint(x: opt2Box.position.x ,y: opt2Box.position.y - (opt2Lbl.frame.height / 2))
        //third option
        opt3Lbl = SKLabelNode(text: "Buy / Equip Costumes")
        opt3Lbl.fontColor = UIColor(ciColor: .black)
        opt3Lbl.fontName = pointsLbl.fontName
        opt3Lbl.zPosition = 9
        opt3Box = SKSpriteNode(color: UIColor(ciColor: .red), size: CGSize(width: bckgBox.size.width / 1.5, height: 100))
        opt3Box.position = CGPoint(x: 0, y: opt2Box.position.y + (scrDiv / 2))
        opt3Box.zPosition = 8
        opt3Lbl.position = CGPoint(x: opt3Box.position.x ,y: opt3Box.position.y - (opt3Lbl.frame.height / 2))
        //combo labels setup
        comboNumLbl = SKLabelNode(text: "Combo: 0")
        comboNumLbl.fontColor = pointsLbl.fontColor
        comboNumLbl.fontSize = pointsLbl.fontSize - 10
        comboNumLbl.fontName = pointsLbl.fontName
        comboNumLbl.position = CGPoint(x: pointsLbl.position.x ,y: pointsLbl.position.y - pointsLbl.frame.height - (comboNumLbl.frame.height / 2))
        comboNumLbl.zPosition = 7
        comboNumLbl.isHidden = true
        comboMultLbl = SKLabelNode(text: "\(comboMult)x")
        comboMultLbl.fontColor = pointsLbl.fontColor
        comboMultLbl.fontSize = comboNumLbl.fontSize - 10
        comboMultLbl.fontName = pointsLbl.fontName
        comboMultLbl.position = CGPoint(x: comboNumLbl.position.x ,y: comboNumLbl.position.y - (comboNumLbl.frame.height / 2) - (comboMultLbl.frame.height / 2))
        comboMultLbl.zPosition = 7
        comboMultLbl.isHidden = true
        comboNumLbl.isHidden = true
        //earned point setup
        earnedPointsLbl = SKLabelNode(text: "Point")
        earnedPointsLbl.fontColor = comboMultLbl.fontColor
        earnedPointsLbl.fontName = comboMultLbl.fontName
        earnedPointsLbl.fontSize = comboMultLbl.fontSize
        earnedPointsLbl.position = CGPoint(x: 0, y: 0)
        earnedPointsLbl.zPosition = 6
        self.addChild(comboNumLbl)
        self.addChild(comboMultLbl)
        if(music){ //changes text if music is on
            opt4Lbl.text = "Music: ON"
        }
        gameVC.playSong(song: "bckgLoop")
        setPos()
    }
    //sets sprite position to random spot on screen (above and below other things on screen)
    func setPos(){
        //print("Screen Size: \(UIScreen.main.bounds.width) , \(UIScreen.main.bounds.height) \n Scene Size: \(scrWidth) , \(scrHeight)")
        //^ Prints screen size VS scene size, used to bugs
        let xPos: CGFloat = CGFloat.random(in: -scrWidth + 50...scrWidth - 50)
        let yPos: CGFloat = CGFloat.random(in: -scrHeight + 50 + safeArea.bottom + shopBtn.size.height...scrHeight - 50 - safeArea.top - pointsLbl.frame.height - comboNumLbl.frame.height - comboMultLbl.frame.height)
        clickSprite.position = CGPoint(x: xPos, y: yPos)
    }
    //sets up shop
    func setShop(open: Bool){
        if(open){
            tempTime = time //saves time when buttonw as clicked
            shopLbl.text = "Shop"
            opt3Lbl.text = "Buy / Equip Costumes"
            opt2Lbl.text = "Upgrade Auto-Clicker"
            opt1Lbl.text = "Upgrade Click Worth"
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
            clickSprite.isHidden = true
            shopBtn.isHidden = true
            closeShop.isHidden = false
            shopping = true
            print(time)
        } else { //if closed
            time = tempTime
            bckgBox.parent?.removeChildren(in: [bckgBox, shopLbl, opt1Box, opt1Lbl, opt2Box, opt2Lbl, opt3Box, opt3Lbl, opt4Box, opt4Lbl])
            clickSprite.isHidden = false
            shopBtn.isHidden = false
            closeShop.isHidden = true
            shopping = false
            print(time)
        }
    }
    func setRecords(set: Bool){
        if(set){ //if checking records
            tempTime = time //saves time when buttonw as clicked
            shopLbl.text = "Records"
            opt3Lbl.text = "Best Fast Combo: \(bestFastCombo)"
            opt2Lbl.text = "Best Combo: \(bestSlowCombo)"
            let fastString = Double(round(100 * fastestTime) / 100)
            opt4Lbl.text = "Fastest Click: \(fastString)"
            let bestCombo = Double(round(100 * bestComboMult) / 100)
            opt1Lbl.text = "Largest Combo Multiplier: \(bestCombo)"
            self.addChild(bckgBox)
            self.addChild(shopLbl)
            self.addChild(opt1Lbl)
            self.addChild(opt2Lbl)
            self.addChild(opt3Lbl)
            self.addChild(opt4Lbl)
            recordBtn.color = UIColor(ciColor: .magenta)
            record = true
        } else { //if closing records
            time = tempTime - 0.2
            bckgBox.parent?.removeChildren(in: [bckgBox, shopLbl, opt1Lbl, opt2Lbl, opt3Lbl, opt4Lbl])
            recordBtn.color = UIColor(ciColor: .yellow)
            record = false
        }
    }
    //Cosumte Shop / Equp Setup Function
    func setCostumes(set: Bool){
        if(set){
            shopLbl.text = "Costumes"
            costumes = true
        } else {
            shopLbl.text = "Shop"
            costumes = false
        }
    }
    //Detects Tap (Beggining) TO ADD: check if touching "click Sprite"
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self.view)
        if(!shopping && !record && !costumes){
            let pointsEarned = pointMult * comboMult
            if (clickSprite.contains(touch.location(in: self))) { //if clicksprite is clicked
                triggered = false
                //adds points
                points += pointsEarned
                //fades point text
                let ptString = Double(round(100 * pointsEarned) / 100)
                earnedPointsLbl.position = clickSprite.position
                earnedPointsLbl.text = "+\(ptString)"
                earnedPointsLbl.alpha = 1
                let fadeAction = SKAction.fadeAlpha(to: 0, duration: 0.5)
                let removeAction = SKAction.removeFromParent()
                let fadeRemove = SKAction.sequence([fadeAction, removeAction])
                if(textUp){
                    earnedPointsLbl.run(removeAction)
                    textUp = false
                }
                textUp = true
                self.addChild(earnedPointsLbl)
                earnedPointsLbl.run(fadeRemove)
                //checks combos
                if(time < fastestTime){
                    fastestTime = time
                    UserDefaults.standard.set(fastestTime, forKey: "fastTM")
                }
                if(fastActive && time < 0.5){ //on fast combo pace (top 50% of data)
                    fastCombo += 1
                    slowCombo += 1
                    comboMult += 0.05
                    comboNumLbl.isHidden = false
                    comboMultLbl.isHidden = false
                    comboNumLbl.text = "(Fast) Combo: \(slowCombo)"
                    let ptString = Double(round(100 * comboMult) / 100)
                    comboMultLbl.text = "\(ptString)x"
                } else if (time < 1.0){ //on slow combo pace (top 50% of data)
                    fastActive = false
                    comboMult += 0.01
                    slowCombo += 1
                    comboNumLbl.isHidden = false
                    comboMultLbl.isHidden = false
                    comboNumLbl.text = "Combo: \(slowCombo)"
                    let ptString = Double(round(100 * comboMult) / 100)
                    comboMultLbl.text = "\(ptString)x"
                } else { //combo dropped
                    print("Other Tap")
                }
                time = 0
                setPos()
            }
            else if(shopBtn.contains(touch.location(in: self))){ //if shopping
                setShop(open: true)
            }
            else if(recordBtn.contains(touch.location(in: self))){ //if checking records
                setRecords(set: true)
            }
            else{ //if sprite not touched
                points += -pointsEarned
                //fades point text
                let ptString = Double(round(100 * pointsEarned) / 100)
                earnedPointsLbl.position = location
                earnedPointsLbl.text = "-\(ptString)"
                earnedPointsLbl.alpha = 1
                let fadeAction = SKAction.fadeAlpha(to: 0, duration: 0.5)
                let removeAction = SKAction.removeFromParent()
                let textTrue = SKAction.run {
                    textUp = true
                }
                let textFalse = SKAction.run {
                    textUp = false
                }
                let fadeRemove = SKAction.sequence([textTrue, fadeAction, removeAction, textFalse])
                if(textUp){
                    earnedPointsLbl.removeFromParent()
                }
                self.addChild(earnedPointsLbl)
                earnedPointsLbl.run(fadeRemove)
                //resets combo
                comboNumLbl.isHidden = true
                //checks for new records
                if(fastCombo > bestFastCombo){
                    bestFastCombo = fastCombo
                    UserDefaults.standard.set(bestFastCombo, forKey: "fastCombo")
                }
                if(slowCombo > bestSlowCombo){
                    bestSlowCombo = slowCombo
                    UserDefaults.standard.set(bestSlowCombo, forKey: "slowCombo")
                }
                if(comboMult >= bestComboMult){
                    bestComboMult = comboMult
                    UserDefaults.standard.set(bestComboMult, forKey: "comboMult")
                }
                fastCombo = 0
                slowCombo = 0
                comboMult = 1
                fastActive = true
            }
        } else if(record){ //if checking records
            if(recordBtn.contains(touch.location(in: self))){
                setRecords(set: false)
            } else {
                print("Other Tap")
            }
        } else if(costumes){ //if buying/equipping costumes
            if (opt3Box.contains(touch.location(in: self))){
                setCostumes(set: false)
            } else {
                print("Other Tap")
            }
        } else { //if shopping
            if (closeShop.contains(touch.location(in: self))){ //if stopping shopping
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
                setCostumes(set: true)
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
                print("Other Tap")
            }
        }
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
        if(autoTime >= 20){
            autoTime = 0
            points += autoPts
            let ptString = Double(round(100 * points) / 100)
            pointsLbl.text = "Points: \(ptString)" //changes it to 2 decimals
            UserDefaults.standard.set(points, forKey: "points")
        }
        if(!triggered && !shopping && !record && !costumes && time >= 1){
            //checks for new records
            if(fastCombo > bestFastCombo){
                bestFastCombo = fastCombo
                UserDefaults.standard.set(bestFastCombo, forKey: "fastCombo")
            }
            if(slowCombo > bestSlowCombo){
                bestSlowCombo = slowCombo
                UserDefaults.standard.set(bestSlowCombo, forKey: "slowCombo")
            }
            if(comboMult >= bestComboMult){
                bestComboMult = comboMult
                UserDefaults.standard.set(bestComboMult, forKey: "comboMult")
            }
            comboNumLbl.isHidden = true
            comboMultLbl.isHidden = true
            comboMult = 1
            fastCombo = 0
            slowCombo = 0
            fastActive = true
            triggered = true
        }
    }
}
