//
//  GameViewController.swift
//  BurnRate
//
//  Created by Arthas on 10/23/16.
//  Copyright © 2016 Arthas. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
class GameViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if #available(iOS 10.0, *) {

            if let scene = GKScene(fileNamed: "WelcomeScene") {
                
                // Get the SKScene from the loaded GKScene
                if let sceneNode = scene.rootNode as! WelcomeScene? {
                    
                    // Copy gameplay related content over to the scene
                    sceneNode.entities = scene.entities
                    sceneNode.graphs = scene.graphs
                    
                    // Set the scale mode to scale to fit the window
                    sceneNode.scaleMode = .fill
                    sceneNode.anchorPoint = CGPoint(x:0, y:0)
                    
                    // Present the scene
                    if let view = self.view as! SKView? {
                        view.presentScene(sceneNode)
                        view.ignoresSiblingOrder = true
                        view.showsFPS = true
                        view.showsNodeCount = true
                    }
                }
            }


        }
        else
        {
            // Fallback on earlier versions
            if let view = self.view as! SKView? {
                // Load the SKScene from 'GameScene.sks'
                if let scene = SKScene(fileNamed: "WelcomeScene") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .fill
                    scene.anchorPoint = CGPoint(x:0, y:0)
                    // Present the scene
                    view.presentScene(scene)
                    
                }
                
                view.ignoresSiblingOrder = true
                
                view.showsFPS = true
                view.showsNodeCount = true
            }
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
