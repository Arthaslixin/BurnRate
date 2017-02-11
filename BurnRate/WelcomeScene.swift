//
//  WelcomeScene.swift
//  BurnRate
//
//  Created by Arthas on 2017/1/22.
//  Copyright © 2017年 Arthas. All rights reserved.
//

import SpriteKit
import GameplayKit
class WelcomeScene: BaseScene {
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    lazy var sound = SoundManager()
    
    override func didMove(to view: SKView) {
        initUserData()
        positionData.sceneScale()
        self.size = CGSize(width: positionData.sceneWidth, height: positionData.sceneHeight)
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
        bgImage.position = CGPoint(x : positionData.sceneWidth / 2, y : positionData.sceneHeight / 2)
        bgImage.zPosition = 0
        addChild(bgImage)
        
        let blackBackground = SKShapeNode(rectOf: CGSize(width: 400, height: 500), cornerRadius: 30)
        blackBackground.name = "blackBackground"
        blackBackground.fillColor = UIColor.black
        blackBackground.alpha = 0.8
        blackBackground.position = CGPoint(x: frame.midX, y: frame.midY - 100)
        blackBackground.zPosition = -1
        addChild(blackBackground)
    }
    private func createLabels()
    {
        createLabel(text: "Burn Rate", name: "title", pos: CGPoint(x: frame.midX, y: frame.midY + 200), z: 1, fontSize: 150)
        createLabel(text: "BGM", name: "BGM", pos: CGPoint(x: frame.midX - 100, y: frame.midY + 30), z: -1, fontSize: 60)
        createLabel(text: "Back", name: "back", pos: CGPoint(x: frame.midX, y: frame.midY - 230), z: -1, fontSize: 60)
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
            goToScene(newScene: SceneType.GameScene)
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
//        sound.playHit()
        let touchPoint = touches.first?.location(in: self)
        let touchNode = nodes(at: touchPoint!)
        let node = touchNode.first!
        process(node: node)
    }

}