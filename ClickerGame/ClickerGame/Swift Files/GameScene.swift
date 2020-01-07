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
var tapCombo: Int = 0
var fastestTime: Double = 100
var bestCombo: Int = 0
var bestComboMult: Double = 1
var turtleSprites: [SKTexture] = []
//menu bools
var shopping = false
var costumes = false
var record = false
var options = false
var credits = false
var menu = false
//other bools
var fastActive = true // fast combo active
var textUp = false
var music = false
var animations = true
class GameScene: SKScene {
    //MARK - Variables
    var gameBckg = SKSpriteNode()
    var pointsLbl = SKLabelNode()
    var clickSprite = SKSpriteNode()
    var menuBtn = SKSpriteNode()
    var bckgBox = SKSpriteNode()
    var menuLbl = SKLabelNode()
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
    var pointsEarned: Double = 0
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
        gameSC.scaleMode = .aspectFill
        scrHeight = self.size.height / 2
        scrWidth = self.size.width / 2
        if(UserDefaults.standard.double(forKey: "points") != 0){ //checks for first time load
            points = UserDefaults.standard.double(forKey: "points")
            pointMult = UserDefaults.standard.double(forKey: "ptMult")
            autoPts = UserDefaults.standard.double(forKey: "autoPts")
            fastestTime = UserDefaults.standard.double(forKey: "fastTM")
            bestComboMult = UserDefaults.standard.double(forKey: "comboMult")
            music = UserDefaults.standard.bool(forKey: "music")
            animations = UserDefaults.standard.bool(forKey: "animations")
            bestCombo = UserDefaults.standard.integer(forKey: "tapCombo")
        }
        //sets up game background
        gameBckg = SKSpriteNode(texture: SKTexture(image: UIImage(named: "beachBckg")!), color: UIColor(ciColor: .clear), size: gameSC.size)
        gameBckg.zPosition = 1
        gameBckg.position = CGPoint(x: 0,y: 0)
        //points label at top of screen
        pointsLbl = self.childNode(withName: "pointsLbl") as! SKLabelNode
        pointsLbl.position = CGPoint(x: 0, y: scrHeight - safeArea.top - pointsLbl.frame.height)
        let ptString = Double(round(100 * points) / 100)
        pointsLbl.text = "Points: \(ptString)"
        pointsLbl.fontColor = UIColor(ciColor: .black)
        pointsLbl.zPosition = 3
        //sprite to be clicked
        clickSprite = self.childNode(withName: "clickSprite") as! SKSpriteNode
        clickSprite.isUserInteractionEnabled = false
        clickSprite.size = CGSize(width: 150, height: 150)
        clickSprite.zPosition = 5
        clickSprite.texture = SKTexture(image: UIImage(named: "heartTurtle")!)
        //shop button
        menuBtn = self.childNode(withName: "menuBtn") as! SKSpriteNode
        menuBtn.size = CGSize(width: scrWidth * 1.5, height: 100)
        menuBtn.color = UIColor(ciColor: .blue)
        menuBtn.position = CGPoint(x: 0, y: -scrHeight + safeArea.bottom + 50)
        menuBtn.zPosition = 2
        menuBtn.texture = SKTexture(image: UIImage(named: "menuBtn")!)
        //shop background
        bckgBox = SKSpriteNode(color: UIColor(ciColor: .white), size: CGSize(width: (scrWidth * 1.5) - safeArea.left - safeArea.right, height: (scrHeight * 1.5) - safeArea.top - safeArea.bottom))
        bckgBox.position = CGPoint(x: 0, y: 0)
        bckgBox.zPosition = 6
        bckgBox.texture = SKTexture(image: UIImage(named: "menuBckg")!)
        //shop label
        menuLbl = SKLabelNode(text: "SHOP")
        menuLbl.fontColor = UIColor(ciColor: .black)
        menuLbl.fontName = pointsLbl.fontName
        menuLbl.fontSize = 100
        menuLbl.position = CGPoint(x: 0, y: (bckgBox.size.height / 2) - menuLbl.frame.height)
        menuLbl.zPosition = 7
        let scrDiv = (bckgBox.size.height - (menuLbl.frame.height * 2)) / 2
        //fourth (next set) of options
        opt4Lbl = SKLabelNode(text: "Music: OFF")
        opt4Lbl.fontColor = UIColor(ciColor: .black)
        opt4Lbl.fontName = pointsLbl.fontName
        opt4Lbl.zPosition = 9
        opt4Box = SKSpriteNode(color: UIColor(ciColor: .red), size: CGSize(width: bckgBox.size.width / 1.5, height: 100))
        let b4Y = -(scrDiv) + (opt4Box.size.height / 2) + (menuLbl.frame.height / 2)
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
        self.addChild(gameBckg)
        for i in 1...9 {
            turtleSprites.append(SKTexture(image: UIImage(named: "turtleSprite\(i)")!))
        }
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
        let yPos: CGFloat = CGFloat.random(in: -scrHeight + 50 + safeArea.bottom + menuBtn.size.height...scrHeight - 50 - safeArea.top - pointsLbl.frame.height - comboNumLbl.frame.height - comboMultLbl.frame.height)
        clickSprite.position = CGPoint(x: xPos, y: yPos)
        clickSprite.isPaused = true
        clickSprite.removeAllActions()
        clickSprite.isPaused = false
        clickSprite.run(SKAction.animate(with: turtleSprites, timePerFrame: 0.05))
    }
    //sets up shop
    func setShop(set: Bool){
        if(set){
            menuLbl.text = "Shop"
            opt3Lbl.text = "Unlock Next Costume"
            opt2Lbl.text = "Upgrade Auto-Clicker"
            opt1Lbl.text = "Upgrade Click Worth"
            opt4Lbl.text = "Close Shop"
            shopping = true
        } else { //if closed
            menuLbl.text = "Menu"
            opt4Lbl.text = "Options"
            opt3Lbl.text = "Upgrades"
            opt2Lbl.text = "Costumes"
            opt1Lbl.text = "Records"
            shopping = false
        }
    }
    //sets up records
    func setRecords(set: Bool){
        if(set){ //if checking records
            menuLbl.text = "Records"
            let fastString = Double(round(100 * fastestTime) / 100)
            opt3Lbl.text = "Fastest Click: \(fastString)"
            opt2Lbl.text = "Best Combo: \(bestCombo)"
            opt4Lbl.text = "Close Records"
            let bestCombo = Double(round(100 * bestComboMult) / 100)
            opt1Lbl.text = "Largest Combo Multiplier: \(bestCombo)"
            bckgBox.parent?.removeChildren(in: [opt1Box, opt2Box, opt3Box])
            record = true
        } else { //if closing records
            menuLbl.text = "Menu"
            opt4Lbl.text = "Options"
            opt3Lbl.text = "Upgrades"
            opt2Lbl.text = "Costumes"
            opt1Lbl.text = "Records"
            self.addChild(opt1Box)
            self.addChild(opt2Box)
            self.addChild(opt3Box)
            record = false
        }
    }
    //sets up costumes
    func setCostumes(set: Bool){
        if(set){
            menuLbl.text = "Costumes"
            opt3Lbl.text = "Equip Costume 1"
            opt2Lbl.text = "Equip Costume 2"
            opt1Lbl.text = "Equip Costume 3"
            opt4Lbl.text = "Close Costumes"
            costumes = true
        } else {
            menuLbl.text = "Menu"
            opt4Lbl.text = "Options"
            opt3Lbl.text = "Upgrades"
            opt2Lbl.text = "Costumes"
            opt1Lbl.text = "Records"
            costumes = false
        }
    }
    //sets up credits
    func setCredits(set: Bool){
        if(set){ //if checking records
            menuLbl.text = "Credits"
            opt3Lbl.text = "Code + Music: Tristan P.-S."
            opt2Lbl.text = "Math: John Crane"
            opt4Lbl.text = "Close Credits"
            opt1Lbl.text = "Sprites: Daniel Sierra"
            bckgBox.parent?.removeChildren(in: [opt1Box, opt2Box, opt3Box])
            credits = true
        } else { //if closing records
            self.addChild(opt1Box)
            self.addChild(opt2Box)
            self.addChild(opt3Box)
            setOptions(set: true)
            credits = false
        }
    }
    //sets up options
    func setOptions(set: Bool){
        if(set){
            menuLbl.text = "Options"
            opt4Lbl.text = "Close Options"
            opt3Lbl.text = "Credits"
            opt2Lbl.text = "Animations: OFF"
            if(animations){
            opt2Lbl.text = "Animations: ON"
            }
            opt1Lbl.text = "Music: OFF"
            options = true
        } else {
            menuLbl.text = "Menu"
            opt4Lbl.text = "Options"
            opt3Lbl.text = "Upgrades"
            opt2Lbl.text = "Costumes"
            opt1Lbl.text = "Records"
            options = false
        }
    }
    func setMenu(set: Bool){
        if(set){
            tempTime = time //saves time when buttonw as clicked
            menuLbl.text = "Menu"
            opt4Lbl.text = "Options"
            opt3Lbl.text = "Upgrades"
            opt2Lbl.text = "Costumes"
            opt1Lbl.text = "Records"
            self.addChild(bckgBox)
            self.addChild(menuLbl)
            self.addChild(opt1Box)
            self.addChild(opt1Lbl)
            self.addChild(opt2Box)
            self.addChild(opt2Lbl)
            self.addChild(opt3Box)
            self.addChild(opt3Lbl)
            self.addChild(opt4Box)
            self.addChild(opt4Lbl)
            clickSprite.isHidden = true
            menuBtn.color = UIColor(ciColor: .green)
            menuBtn.texture = SKTexture(image: UIImage(named: "closeBtn")!)
            menu = true
        } else {
            time = tempTime - 0.3
            bckgBox.parent?.removeChildren(in: [bckgBox, menuLbl, opt1Box, opt1Lbl, opt2Box, opt2Lbl, opt3Box, opt3Lbl, opt4Box, opt4Lbl])
            clickSprite.isHidden = false
            menuBtn.color = UIColor(ciColor: .blue)
            menuBtn.texture = SKTexture(image: UIImage(named: "menuBtn")!)
            menu = false
        }
    }
    //makes faded text at the given location for the given text
    func fadedText(tSpot: CGPoint, message: String){
        if(animations){ //only toggles if animations are on
        earnedPointsLbl.position = tSpot
        earnedPointsLbl.text = message
        earnedPointsLbl.alpha = 1
        let fadeAction = SKAction.fadeAlpha(to: 0, duration: 0.5)
        let removeAction = SKAction.removeFromParent()
        let textChange = SKAction.run {
            textUp = !textUp
        }
        let fadeRemove = SKAction.sequence([textChange, fadeAction, removeAction, textChange])
        if(textUp){
            earnedPointsLbl.isPaused = true
            earnedPointsLbl.removeAllActions()
            earnedPointsLbl.removeFromParent()
            earnedPointsLbl.isPaused = false
            textUp = false
        }
        self.addChild(earnedPointsLbl)
        earnedPointsLbl.run(fadeRemove)
        }
    }
    //checks for records then resets combos
    func recordCheck(){
        comboNumLbl.isHidden = true
        comboMultLbl.isHidden = true
        if(tapCombo > bestCombo){
            bestCombo = tapCombo
            UserDefaults.standard.set(bestCombo, forKey: "tapCombo")
        }
        if(comboMult >= bestComboMult){
            bestComboMult = comboMult
            UserDefaults.standard.set(bestComboMult, forKey: "comboMult")
        }
        tapCombo = 0
        comboMult = 1
        fastActive = true
    }
    //Detects Tap (Beggining) TO ADD: check if touching "click Sprite"
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: gameSC)
        if(!menu){
            pointsEarned = pointMult * comboMult
            let ptString = Double(round(100 * pointsEarned) / 100)
            if (clickSprite.contains(location)) { //if clicksprite is clicked
                clickSprite.run(SKAction.animate(with: [SKTexture(image: UIImage(named: "heartTurtle")!)], timePerFrame: 0.1))
                //need to figure out a way to display the "heartTurtle" sprite for a small time period
                triggered = false
                //adds points
                points += pointsEarned
                fadedText(tSpot: clickSprite.position, message: "+\(ptString)")
                //checks combos
                if(time < fastestTime){
                    fastestTime = time
                    UserDefaults.standard.set(fastestTime, forKey: "fastTM")
                }
                if(fastActive && time < 0.5){ //on fast combo pace (top 50% of data)
                    tapCombo += 1
                    comboMult += 0.05
                    comboNumLbl.isHidden = false
                    comboMultLbl.isHidden = false
                    comboNumLbl.text = "(Fast) Combo: \(tapCombo)"
                    let ptString = Double(round(100 * comboMult) / 100)
                    comboMultLbl.text = "\(ptString)x"
                } else if (time < 1.0){ //on slow combo pace (top 50% of data)
                    fastActive = false
                    comboMult += 0.01
                    tapCombo += 1
                    comboNumLbl.isHidden = false
                    comboMultLbl.isHidden = false
                    comboNumLbl.text = "Combo: \(tapCombo)"
                    let ptString = Double(round(100 * comboMult) / 100)
                    comboMultLbl.text = "\(ptString)x"
                } else { //combo dropped
                    print("Other Tap")
                }
                time = 0
                setPos()
            }
            else if(menuBtn.contains(location)){ //if opening menu
                setMenu(set: true)
            }
            else{ //if sprite not touched
                points += -pointsEarned
                //fades point text
                fadedText(tSpot: location, message: "-\(ptString)")
                //checks for new records and resets
                recordCheck()
            }
        } else if(record){ //if checking records
            if (opt4Box.contains(location)){ //bottom option
                setRecords(set: false)
            }
            else if(menuBtn.contains(location)){
                setRecords(set: false)
                setMenu(set: false)
            }
            else{
                print("Other Tap")
            }
        } else if(costumes){ //if buying/equipping costumes
            //gameVC.makeAlert(scene: gameSC, message: "Not enough points")
            if (opt1Box.contains(location)){ //third Option
                print("third option")
            }
            else if (opt2Box.contains(location)){ //second option
                print("second option")
            }
            else if (opt3Box.contains(location)){ //top option
                print("top option")
            }
            else if (opt4Box.contains(location)){ //bottom option
                setCostumes(set: false)
            }
            else if(menuBtn.contains(location)){
                setCostumes(set: false)
                setMenu(set: false)
            }
            else{
                print("Other Tap")
            }
        } else if(shopping){
            if (opt1Box.contains(location)){ //third Option <- Clicker Multiplier
                if(points >= 50){
                    points += -50
                    pointMult += 0.1
                } else {
                   gameVC.makeAlert(scene: gameSC, message: "Not enough points (Need 50)")
                }
            }
            else if (opt2Box.contains(location)){ //second option <- Auto Clicker
                if(points >= 50){
                    points += -50
                    autoPts += 0.05
                } else {
                   gameVC.makeAlert(scene: gameSC, message: "Not enough points (Need 50)")
                }
            }
            else if (opt3Box.contains(location)){ //top option <- Costume
                if(points >= 50){
                    points += -50
                } else {
                   gameVC.makeAlert(scene: gameSC, message: "Not enough points (Need 50)")
                }
            }
            else if (opt4Box.contains(location)){ //bottom option
                setShop(set: false)
            }
            else if(menuBtn.contains(location)){
                setShop(set: false)
                setMenu(set: false)
            }
            else{
                print("Other Tap")
            }
        } else if(options){
            if (opt1Box.contains(location)){ //third Option
                music = !music
                opt1Lbl.text = "Music: OFF"
                if(music){
                    opt1Lbl.text = "Music: ON"
                }
                gameVC.playSong(song: "bckgLoop")
            }
            else if (opt2Box.contains(location)){ //second option
                if(animations){
                    opt2Lbl.text = "Animations: OFF"
                    animations = false
                } else {
                    opt2Lbl.text = "Animations: ON"
                    animations = true
                }
            }
            else if (opt3Box.contains(location)){ //top option
                setOptions(set: false)
                setCredits(set: true)
            }
            else if (opt4Box.contains(location)){ //bottom option
                setOptions(set: false)
            }
            else if(menuBtn.contains(location)){
                setOptions(set: false)
                setMenu(set: false)
            }
            else{
                print("Other Tap")
            }
        } else if(credits) {
            if (opt4Box.contains(location)){ //bottom option
                setCredits(set: false)
            }
            else if(menuBtn.contains(location)){
                setCredits(set: false)
                setOptions(set: false)
                setMenu(set: false)
            }
            else{
                print("Other Tap")
            }
        } else { //if menu
            if(menuBtn.contains(location)){
                setMenu(set: false)
            }
            else if(opt4Box.contains(location)){//opening options
                setOptions(set: true)
            }
            else if(opt3Box.contains(location)){//opening records
                setShop(set: true)
            }
            else if(opt2Box.contains(location)){//opening shop
                setCostumes(set: true)
            }
            else if(opt1Box.contains(location)){//opening costumes
                setRecords(set: true)
            }
            else{
                print("Other Tap")
            }
        }
        UserDefaults.standard.set(music, forKey: "music")
        UserDefaults.standard.set(animations, forKey: "animations")
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
        if(!triggered && !menu && time >= 1){
            //checks for new records
            recordCheck()
            triggered = true
        }
    }
}
