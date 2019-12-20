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
    //MARK - Functions
    //Viewdid load
    override func didMove(to view: SKView) {
        gameSC = self
        pointsLbl = self.childNode(withName: "pointsLbl") as! SKLabelNode
        pointsLbl.position = CGPoint(x: 0, y: (self.view?.bounds.maxY)! - 200 )
        pointsLbl.text = "Points: \(points)"
        clickSprite = self.childNode(withName: "clickSprite") as! SKSpriteNode
        clickSprite.isUserInteractionEnabled = false
        clickSprite.size = CGSize(width: 75, height: 75)
        clickSprite.zPosition = 1
        shopButton = self.childNode(withName: "shopButton") as! SKSpriteNode
        shopButton.isUserInteractionEnabled = false
        shopButton.size = CGSize(width: 100, height: 50)
        shopButton.color = UIColor(ciColor: .blue)
        shopButton.position = CGPoint(x: 0, y: -(gameSC.view?.bounds.height)! + 175)
        closeShop = self.childNode(withName: "closeShop") as! SKSpriteNode
        closeShop.size = CGSize(width: 100, height: 50)
        closeShop.isUserInteractionEnabled = false
        closeShop.isHidden = true
        closeShop.color = UIColor(ciColor: .green)
        closeShop.position = shopButton.position
        setPos()
    }
    //sets sprite position to random spot on screen
    func setPos(){
        //print(shopButton.position.y)
        //print("Screen Size: \(UIScreen.main.bounds) \n Scene Size: \(gameSC.view?.bounds)")
        var xPos: CGFloat = CGFloat.random(in: -(gameSC.view?.bounds.width)! + 75...(gameSC.view?.bounds.width)! - 75)
        var yPos: CGFloat = CGFloat.random(in: -(gameSC.view?.bounds.height)! + 75...(gameSC.view?.bounds.height)! - 75)
        /*while((xPos < shopButton.position.x + 50 || xPos > shopButton.position.x - 50) && (yPos < shopButton.position.y + 25 || yPos > shopButton.position.y - 25)){ //makes sure it doesn't spawn fully in the button
            xPos = CGFloat.random(in: -(gameSC.view?.bounds.width)! + 75...(gameSC.view?.bounds.width)! - 75)
            yPos = CGFloat.random(in: -(gameSC.view?.bounds.height)! + 75...(gameSC.view?.bounds.height)! - 75)
        } */
        clickSprite.position = CGPoint(x: xPos, y: yPos)
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
            //ONLY FOR TESTING PURPOSES (REMOVE AFTER)
            /*
            if(testData.count == 10){ //attempts to share String of first 20 test results
                var resultString: String = ""
                for n in 0...testData.count - 1{
                    let data: String = String(format: "%.3f", testData[n]) //formats data
                    resultString = "\(resultString) \n\(data)"
                }
                let textToShare = [ resultString ] //converts image to "Any"
                //sets up VC so it works for all devices
                let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                // present the view controller
                gameVC.present(activityViewController, animated: true, completion: nil)
                testData = []
            }
            */
            //REMOVE TESTING STOPS HERE
            pointsLbl.text = "Points: \(points)"
        }
        else if (!shopping && shopButton.contains(touch.location(in: self))){ //if shopping
            print("shopping")
            shopButton.isHidden = true
            closeShop.isHidden = false
            shopping = true
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
