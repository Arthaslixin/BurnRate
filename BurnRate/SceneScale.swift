//
//  SceneScale.swift
//  BurnRate
//
//  Created by Arthas on 2017/1/19.
//  Copyright © 2017年 Arthas. All rights reserved.
//

import Foundation
import SpriteKit
class SceneScale
{
    var sceneWidth: CGFloat = 0.0
    var sceneHeight: CGFloat = 0.0
}



class GameSceneScaleData: SceneScale {
    struct playerPosition {
        var sales = CGPoint(x: 0, y: 0)
        var finance = CGPoint(x: 0, y: 0)
        var HR = CGPoint(x: 0, y: 0)
        var development = CGPoint(x: 0, y: 0)
        var stateCards = CGPoint(x: 0, y: 0)
        var cardsInHand = CGPoint(x: 0, y: 0)
        var employeeXPlus: CGFloat = 0
        var employeeYPlus: CGFloat = 0
        var stateCardsXPlus: CGFloat = 0
        var stateCardsYPlus: CGFloat = 0
        var cardsInHandXPlus: CGFloat = 0
        var cardsInHandYPlus: CGFloat = 0
    }
    struct publicCardsPosition {
        var sales = CGPoint(x: 0, y: 0)
        var finance = CGPoint(x: 0, y: 0)
        var HR = CGPoint(x: 0, y: 0)
        var development = CGPoint(x: 0, y: 0)
        var playcards = CGPoint(x: 0, y: 0)
        var employeeYPlus : CGFloat = 2
        var playcardsYPlus : CGFloat = 1
    }
    var author = CGPoint(x: 0, y: 0)
    var publicCards = publicCardsPosition()
    var player0Card = playerPosition()
    var player1Card = playerPosition()
    var player2Card = playerPosition()
    var player0Money = CGPoint(x: 0, y: 0)
    var player1Money = CGPoint(x: 0, y: 0)
    var player2Money = CGPoint(x: 0, y: 0)
    var player0Name = CGPoint(x: 0, y: 0)
    var player1Name = CGPoint(x: 0, y: 0)
    var player2Name = CGPoint(x: 0, y: 0)
    var startFromPlayer0 = CGPoint(x: 0, y: 0)
    var startFromPlayer1 = CGPoint(x: 0, y: 0)
    var startFromPlayer2 = CGPoint(x: 0, y: 0)
    var confirm_Restart = CGPoint(x: 0, y: 0)
    var cancel = CGPoint(x: 0, y: 0)
    var chooseStartPlayer_Win = CGPoint(x: 0, y: 0)
    var playcards = CGPoint(x: 0, y: 0)
    var discardCards = CGPoint(x: 0, y: 0)
    var labels = CGPoint(x: 0, y: 0)
    var currentPlayer = CGPoint(x: 0, y: 0)


    func gameSceneScaleData()
    {
        self.sceneWidth = UIScreen.main.bounds.size.width
        self.sceneHeight = UIScreen.main.bounds.size.height
        if sceneWidth / sceneHeight == CGFloat(4.0/3.0)
        {
            self.author = CGPoint(x: 950, y: 50)
            self.player0Money = CGPoint(x: 70, y: 600)
            self.player1Money = CGPoint(x: 100, y: 50)
            self.player2Money = CGPoint(x: 950, y: 600)
            self.player0Name = CGPoint(x: 70, y: 660)
            self.player1Name = CGPoint(x: 100, y: 110)
            self.player2Name = CGPoint(x: 950, y: 660)
            self.startFromPlayer0 = CGPoint(x: 350, y: 650)
            self.startFromPlayer1 = CGPoint(x: 500, y: 650)
            self.startFromPlayer2 = CGPoint(x: 650, y: 650)
            self.confirm_Restart = CGPoint(x: 630, y: 580)
            self.cancel = CGPoint(x: 520, y: 580)
            self.chooseStartPlayer_Win = CGPoint(x: 500, y: 720)
            self.playcards = CGPoint(x: 400, y: 650)
            self.discardCards = CGPoint(x: 600, y: 650)
            self.labels = CGPoint(x: 500, y: 650)
            self.currentPlayer = CGPoint(x: 500, y: 720)
            self.publicCards.sales = CGPoint(x: 400, y: 300)
            self.publicCards.finance = CGPoint(x: 400, y: 400)
            self.publicCards.HR = CGPoint(x: 500, y: 300)
            self.publicCards.development = CGPoint(x: 500, y: 400)
            self.publicCards.playcards = CGPoint(x: 600, y: 300)
            self.player0Card.sales = CGPoint(x: 70, y: 460)
            self.player0Card.finance = CGPoint(x: 170, y: 460)
            self.player0Card.HR = CGPoint(x: 70, y: 280)
            self.player0Card.development = CGPoint(x: 170, y: 280)
            self.player0Card.stateCards = CGPoint(x: 270, y: 280)
            self.player0Card.cardsInHand = CGPoint(x: -50, y: sceneHeight / 2)
            self.player0Card.employeeYPlus = 10
            self.player0Card.stateCardsYPlus = 25
            self.player0Card.cardsInHandXPlus = 0
            self.player1Card.sales = CGPoint(x: 350, y: 50)
            self.player1Card.finance = CGPoint(x: 450, y: 50)
            self.player1Card.HR = CGPoint(x: 550, y: 50)
            self.player1Card.development = CGPoint(x: 650, y: 50)
            self.player1Card.stateCards = CGPoint(x: 750, y: 50)
            self.player1Card.cardsInHand = CGPoint(x: 290, y: 150)
            self.player1Card.employeeYPlus = 10
            self.player1Card.stateCardsXPlus = 35
            self.player1Card.cardsInHandXPlus = 60
            self.player2Card.sales = CGPoint(x: 950, y: 460)
            self.player2Card.finance = CGPoint(x: 850, y: 460)
            self.player2Card.HR = CGPoint(x: 950, y: 280)
            self.player2Card.development = CGPoint(x: 850, y: 280)
            self.player2Card.stateCards = CGPoint(x: 750, y: 280)
            self.player2Card.cardsInHand = CGPoint(x: sceneWidth + 50, y: sceneHeight / 2)
            self.player2Card.employeeYPlus = 10
            self.player2Card.stateCardsYPlus = 25
            self.player2Card.cardsInHandXPlus = 0
        }
        //1.6 <= sceneWidth / sceneHeight && sceneWidth / sceneHeight <= 1.8
        else
        {
            self.sceneWidth = 1024
            self.sceneHeight = 578
            self.author = CGPoint(x: 950, y: 40)
            self.player0Money = CGPoint(x: 80, y: 470)
            self.player1Money = CGPoint(x: 100, y: 50)
            self.player2Money = CGPoint(x: 940, y: 470)
            self.player0Name = CGPoint(x: 80, y: 530)
            self.player1Name = CGPoint(x: 100, y: 110)
            self.player2Name = CGPoint(x: 940, y: 530)
            self.startFromPlayer0 = CGPoint(x: 350, y: 500)
            self.startFromPlayer1 = CGPoint(x: 500, y: 500)
            self.startFromPlayer2 = CGPoint(x: 650, y: 500)
            self.confirm_Restart = CGPoint(x: 630, y: 440)
            self.cancel = CGPoint(x: 520, y: 440)
            self.chooseStartPlayer_Win = CGPoint(x: 500, y: 530)
            self.playcards = CGPoint(x: 400, y: 500)
            self.discardCards = CGPoint(x: 600, y: 500)
            self.labels = CGPoint(x: 500, y: 500)
            self.currentPlayer = CGPoint(x: 500, y: 550)
            self.publicCards.sales = CGPoint(x: 400, y: 260)
            self.publicCards.finance = CGPoint(x: 400, y: 360)
            self.publicCards.HR = CGPoint(x: 500, y: 260)
            self.publicCards.development = CGPoint(x: 500, y: 360)
            self.publicCards.playcards = CGPoint(x: 600, y: 260)
            self.player0Card.sales = CGPoint(x: 60, y: 370)
            self.player0Card.finance = CGPoint(x: 140, y: 370)
            self.player0Card.HR = CGPoint(x: 60, y: 220)
            self.player0Card.development = CGPoint(x: 140, y: 220)
            self.player0Card.stateCards = CGPoint(x: 220, y: 220)
            self.player0Card.cardsInHand = CGPoint(x: -50, y: sceneHeight / 2)
            self.player0Card.employeeYPlus = 10
            self.player0Card.stateCardsYPlus = 25
            self.player0Card.cardsInHandXPlus = 0
            self.player1Card.sales = CGPoint(x: 360, y: 40)
            self.player1Card.finance = CGPoint(x: 460, y: 40)
            self.player1Card.HR = CGPoint(x: 560, y: 40)
            self.player1Card.development = CGPoint(x: 660, y: 40)
            self.player1Card.stateCards = CGPoint(x: 720, y: 40)
            self.player1Card.cardsInHand = CGPoint(x: 300, y: 160)
            self.player1Card.employeeYPlus = 10
            self.player1Card.stateCardsXPlus = 35
            self.player1Card.cardsInHandXPlus = 60
            self.player2Card.sales = CGPoint(x: 950, y: 370)
            self.player2Card.finance = CGPoint(x: 870, y: 370)
            self.player2Card.HR = CGPoint(x: 950, y: 220)
            self.player2Card.development = CGPoint(x: 870, y: 220)
            self.player2Card.stateCards = CGPoint(x: 790, y: 220)
            self.player2Card.cardsInHand = CGPoint(x: sceneWidth + 50, y: sceneHeight / 2)
            self.player2Card.employeeYPlus = 10
            self.player2Card.stateCardsYPlus = 25
            self.player2Card.cardsInHandXPlus = 0
        }
    }

}
class WelcomeSceneScaleData : SceneScale
{
    var title = CGPoint(x: 0, y: 0)
    var BGMLabel = CGPoint(x: 0, y: 0)
    var backLabel = CGPoint(x: 0, y: 0)
    var singleGameLabel = CGPoint(x: 0, y: 0)
    var hotseatLabel = CGPoint(x: 0, y: 0)
    var blackBackgroundScale = CGSize(width: 0, height: 0)
    var blackBackgroundPosition = CGPoint(x : 0, y: 0)
    func welcomeSceneScaleData()
    {
        
        self.sceneWidth = UIScreen.main.bounds.size.width
        self.sceneHeight = UIScreen.main.bounds.size.height
//        print(self.sceneWidth, self.sceneHeight)
        if sceneWidth / sceneHeight == CGFloat(4.0/3.0)
        {
            self.title = CGPoint(x: sceneWidth / 2, y: sceneHeight / 2 + 200)
            self.blackBackgroundScale = CGSize(width: 400, height: 500)
            self.blackBackgroundPosition = CGPoint(x : sceneWidth / 2, y: sceneHeight / 2 - 100)
            self.BGMLabel = CGPoint(x: sceneWidth / 2 - 100, y: sceneHeight / 2 + 30)
            self.backLabel = CGPoint(x: sceneWidth / 2, y:sceneHeight / 2 - 230)
            self.singleGameLabel = CGPoint(x: sceneWidth / 2, y: sceneHeight / 2 + 30)
            self.hotseatLabel = CGPoint(x: sceneWidth / 2, y: sceneHeight / 2 - 60)
        }
        else
        {
            self.sceneWidth = 1024
            self.sceneHeight = 578
            self.title = CGPoint(x: sceneWidth / 2, y: sceneHeight / 2 + 150)
            self.blackBackgroundScale = CGSize(width: 500, height: 400)
            self.blackBackgroundPosition = CGPoint(x : sceneWidth / 2, y: sceneHeight / 2 - 80)
            self.BGMLabel = CGPoint(x: sceneWidth / 2 - 100, y: sceneHeight / 2 + 30)
            self.backLabel = CGPoint(x: sceneWidth / 2, y:sceneHeight / 2 - 230)
            self.singleGameLabel = CGPoint(x: sceneWidth / 2, y: sceneHeight / 2 + 30)
            self.hotseatLabel = CGPoint(x: sceneWidth / 2, y: sceneHeight / 2 - 60)

            
        }
        
    }
}
