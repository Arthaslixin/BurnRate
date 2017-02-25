//
//  BaseScene.swift
//  BurnRate
//
//  Created by Arthas on 2017/2/3.
//  Copyright © 2017年 Arthas. All rights reserved.
//
import SpriteKit
enum SceneType: Int {
    
    case WelcomeScene   = 0
    case GameScene      //1
}

struct GlobalData
{
    static var previousScene:SceneType?
    //Other global data...
}

class BaseScene:SKScene
    {
    var labels : [SKLabelNode] = []
    func createLabel(text: String, name: String, pos: CGPoint, z: CGFloat,
                     color: UIColor = UIColor.white, fontSize: CGFloat = 32)
    {
        let newlabel = SKLabelNode(text: text)
        newlabel.name = name
        newlabel.position = pos
        newlabel.zPosition = z
        newlabel.fontColor = color
        newlabel.fontSize = fontSize
        self.addChild(newlabel)
        self.labels.append(newlabel)
    }
    
    func createButton(name: String, pos: CGPoint, z: CGFloat, imgName: String, scale: CGFloat = 1.0)
    {
        let newbutton = SKSpriteNode(imageNamed: imgName)
        newbutton.name = name
        newbutton.position = pos
        newbutton.zPosition = z
        newbutton.setScale(scale)
        self.addChild(newbutton)
    }
    
    func goToScene(newScene: SceneType){
        
        var sceneToLoad:SKScene?
        
        switch newScene {
            
        case SceneType.GameScene:
            
            sceneToLoad = GameScene(fileNamed: "GameScene")
            
        case SceneType.WelcomeScene:
            
            sceneToLoad = WelcomeScene(fileNamed:"WelcomeScene")
            
        }
        
        if let scene = sceneToLoad {
            scene.scaleMode = .fill
            scene.anchorPoint = CGPoint(x:0, y:0)
            let transition = SKTransition.fade(withDuration: 0.5)
            self.view?.presentScene(scene, transition: transition)
        }
    }
}
