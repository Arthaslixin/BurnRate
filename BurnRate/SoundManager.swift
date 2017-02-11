//
//  SoundManager.swift
//  BurnRate
//
//  Created by Arthas on 2017/2/5.
//  Copyright © 2017年 Arthas. All rights reserved.
//

import SpriteKit
//引入多媒体框架
import AVFoundation

class SoundManager :SKNode{
    //申明一个播放器
    var BGMPlayer = AVAudioPlayer()
    //播放点击的动作音效
    let hitAct = SKAction.playSoundFileNamed("SE1.wav", waitForCompletion: false)
    
    //播放背景音乐的音效
    func playBGM(play: Bool = true){

        let url = Bundle.main.url(forResource: "BGM_1", withExtension: "mp3")
//        let BGMURL : URL =  URL(string: "BGM_1.mp3")!
        //根据背景音乐地址生成播放器
        BGMPlayer = try! AVAudioPlayer(contentsOf: url!)
        if play
        {
        //设置为循环播放
        BGMPlayer.numberOfLoops = -1
        //准备播放音乐
        BGMPlayer.prepareToPlay()
        //播放音乐
        BGMPlayer.play()
        }


        


    }
    
    //播放点击音效动作的方法
    func playHit(){
        self.run(hitAct)
    }
}
