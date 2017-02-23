//
//  WelcomeScene.swift
//  BurnRate
//
//  Created by Arthas on 2017/1/22.
//  Copyright © 2017年 Arthas. All rights reserved.
//

import SpriteKit
import GameplayKit
class WelcomeScene: BaseScene
{
    let scaleData = WelcomeSceneScaleData()
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    lazy var sound = SoundManager()
    
    override func didMove(to view: SKView) {
        initUserData()
        scaleData.welcomeSceneScaleData()
        self.size = CGSize(width: scaleData.sceneWidth, height: scaleData.sceneHeight)
        self.addChild(sound)
        if defaults.bool(forKey: "BGM")
        {
            sound.playBGM()
        }
        
        createBackground()
        createLabels()
        createButtons()
    }
    func createBackground()
    {
        let bgImage = SKSpriteNode(imageNamed: "background")
        bgImage.position = CGPoint(x : scaleData.sceneWidth / 2, y : scaleData.sceneHeight / 2)
        bgImage.name = "background"
        bgImage.zPosition = 0
        addChild(bgImage)
        
        let blackBackground = SKShapeNode(rectOf: scaleData.blackBackgroundScale , cornerRadius: 30)
        blackBackground.name = "blackBackground"
        blackBackground.fillColor = UIColor.black
        blackBackground.alpha = 0.8
        blackBackground.position = scaleData.blackBackgroundPosition
        blackBackground.zPosition = -1
        addChild(blackBackground)
    }
    private func createLabels()
    {
        createLabel(text: "Burn Rate", name: "title", pos: scaleData.title, z: 1, fontSize: 150)
        createLabel(text: "BGM", name: "BGM", pos: scaleData.BGMLabel, z: -1, fontSize: 60)
        createLabel(text: "Back", name: "back", pos: scaleData.backLabel, z: -1, fontSize: 60)
        createLabel(text: "Single Game", name: "singleGame",pos: scaleData.singleGameLabel, z: -1, fontSize: 60)
        createLabel(text: "Hotseat", name: "hotseat", pos: scaleData.hotseatLabel, z: -1, fontSize: 60)
    }
    private func createButtons()
    {

        createButton(name: "start", pos: CGPoint(x: frame.midX, y: frame.midY), z: 1, imgName: "Start")
        createButton(name: "option", pos: CGPoint(x: frame.midX, y: frame.midY - 150), z: 1, imgName: "Option")
        createButton(name: "BGMOn", pos: CGPoint(x: frame.midX + 100 , y: frame.midY + 50), z: -1, imgName: "ON")
        createButton(name: "BGMOff", pos: CGPoint(x: frame.midX + 100, y: frame.midY + 50), z: -1, imgName: "OFF")
        
    }
    private func process(node: SKNode)
    {
        if node.name == "start"
        {
            self.childNode(withName: "blackBackground")?.zPosition = 2
            self.childNode(withName: "singleGame")?.zPosition = 3
            self.childNode(withName: "hotseat")?.zPosition = 3
            self.childNode(withName: "back")?.zPosition = 3
//            goToScene(newScene: SceneType.GameScene)
        }
        else if node.name == "option"
        {
            self.childNode(withName: "blackBackground")?.zPosition = 2
            self.childNode(withName: "BGM")?.zPosition = 3
            self.childNode(withName: "back")?.zPosition = 3
            if defaults.bool(forKey: "BGM")
            {
                self.childNode(withName: "BGMOn")?.zPosition = 3
            }
            else
            {
                self.childNode(withName: "BGMOff")?.zPosition = 3
            }
        }
        else if node.name == "BGMOn"
        {
            self.childNode(withName: "BGMOn")?.zPosition = -1
            self.childNode(withName: "BGMOff")?.zPosition = 3
            sound.playBGM(play: false)
            defaults.set(false, forKey: "BGM")
        }
        else if node.name == "BGMOff"
        {
            self.childNode(withName: "BGMOn")?.zPosition = 3
            self.childNode(withName: "BGMOff")?.zPosition = -1
            sound.playBGM()
            defaults.set(true, forKey: "BGM")
        }
        else if node.name == "back"
        {
            self.childNode(withName: "BGM")?.zPosition = -1
            self.childNode(withName: "BGMOn")?.zPosition = -1
            self.childNode(withName: "BGMOff")?.zPosition = -1
            self.childNode(withName: "blackBackground")?.zPosition = -1
            self.childNode(withName: "back")?.zPosition = -1
            self.childNode(withName: "singleGame")?.zPosition = -1
            self.childNode(withName: "hotseat")?.zPosition = -1
        }
        else if node.name == "singleGame"
        {
            gameMode = .single
            goToScene(newScene: SceneType.GameScene)
        }
        else if node.name == "hotseat"
        {
            gameMode = .hotseat
            goToScene(newScene: SceneType.GameScene)
        }
    }
    private func initUserData()
    {
        if defaults.string(forKey: "Init") == nil
        {
            for each in achievements
            {
                defaults.set(0, forKey: each)
            }
            defaults.set(true, forKey: "BGM")
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touchPoint = touches.first?.location(in: self)
        let touchNode = nodes(at: touchPoint!)
        let node = touchNode.first!
        if node != self.childNode(withName: "blackBackground") && node != self.childNode(withName: "background")
        {
            sound.playHit()
        }
        process(node: node)
    }

}
