//
//  GameScene.swift
//  BurnRate
//
//  Created by Arthas on 10/23/16.
//  Copyright © 2016 Arthas. All rights reserved.
//

import SpriteKit
import GameplayKit


enum gameModeEnum
{
    case single
    case hotseat
}
enum gameStateMachine
{
    case chooseStartPlayer
    case pickCards
    case playOrDiscard
    case playcards
    case discardCards
    case nothing
    case selectEmployeeInHand
    case selectOP
    case selectEmployeeOnDesk
    case selectOPEmployee
    case selectBadIdeaToRelease
    case selectSecondCard
    case confirmWarning
    case gameOver
    case menu
    case hotseatWall
    case selectEmployee
}

var animationQueue : [Int] = []
var animationNum = 0
var gameMode = gameModeEnum.single

class departmentsOfEmployees{
    var department = departmentsEnum.sales
    var cards = [EmployeeCards]()
    init(department: departmentsEnum) {
        self.department = department
    }
}
class GameScene: BaseScene {
    let positionData = GameSceneScaleData()
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    var playcardsPool : [PlayCards] = []
    var sales = departmentsOfEmployees(department: .sales)
    var finance = departmentsOfEmployees(department: .finance)
    var HR = departmentsOfEmployees(department: .HR)
    var development = departmentsOfEmployees(department: .development)
    var players : [Player] = []
    var numberOfPlayers = 3
    var currentPlayer : Int?
    var selectedPlayer : Int?
    var focusNodeName : String?
    var focusNodeZPosition : CGFloat?
    var playerAction = 0
    var gameState = gameStateMachine.chooseStartPlayer
    var lastGameState = gameStateMachine.chooseStartPlayer
    lazy var sound = SoundManager()
//    let positionData = CardsPositionData()
    private var lastUpdateTime = 0.0

    
    override func didMove(to view: SKView) {
        self.addChild(sound)
        if defaults.bool(forKey: "BGM")
        {
            sound.playBGM()
        }
    }
    func randomPlayCards(array: [PlayCards]) -> [PlayCards]{
        var temp = array
        var number = array.count
        while number > 0
        {
            let index = Int(arc4random_uniform(UInt32(number)))
//            Int(arc4random_uniform(UInt32(items.count)))
            temp.append(temp.remove(at: index))
            number -= 1
        }
        return temp
    }
    func randomEmployeeCards(array: [EmployeeCards]) -> [EmployeeCards]{
        var temp = array
        var number = array.count
        while number > 0
        {
            let index = Int(arc4random_uniform(UInt32(number)))
            temp.append(temp.remove(at: index))
            number -= 1
        }
        return temp
    }
    func createBackground()
    {
        let bgImage = SKSpriteNode(imageNamed: "background")
        bgImage.position = CGPoint(x : positionData.sceneWidth / 2, y : positionData.sceneHeight / 2)
        bgImage.zPosition = 0
        addChild(bgImage)
        
        let blackBackground = SKShapeNode(rectOf: CGSize(width: 1920, height: 1080))
        blackBackground.name = "blackBackground"
        blackBackground.fillColor = UIColor.black
        blackBackground.alpha = 0.7
        blackBackground.position = CGPoint(x: frame.midX, y: frame.midY)
        blackBackground.zPosition = -1
        addChild(blackBackground)
        
    }
    func createButtons()
    {
        createButton(name: "gameSceneButton", pos: CGPoint(x: positionData.sceneWidth - 50, y: 50) , z: 1, imgName: "GameSceneButton")
    }
    
    func createLabels()
    {
//        createLabel(text: "By Arthas", name: "author", pos: positionData.author, z: 99)
        createLabel(text: "\(self.players[0].money)", name: "player0Money", pos: positionData.player0Money, z: 1, fontSize: 65)
        createLabel(text: "\(self.players[1].money)", name: "player1Money", pos: positionData.player1Money, z: 1, fontSize: 65)
        createLabel(text: "\(self.players[2].money)", name: "player2Money", pos: positionData.player2Money, z: 1, fontSize: 65)
        createLabel(text: "player1", name: "player0", pos: positionData.player0Name, z: 1)
        createLabel(text: "player2", name: "player1", pos: positionData.player1Name, z: 1)
        createLabel(text: "player3", name: "player2", pos: positionData.player2Name, z: 1)
        createLabel(text: "Confirm", name: "confirm", pos: positionData.confirm_Restart, z: -1)
        createLabel(text: "Cancel", name: "cancel", pos: positionData.cancel, z: -1)
        createLabel(text: "", name: "win", pos: positionData.chooseStartPlayer_Win, z: -1, fontSize : 50)
        createLabel(text: "Restart", name: "restart", pos: positionData.confirm_Restart, z: -1, fontSize: 50)
        createLabel(text: "Choose start player:", name: "chooseStartPlayer", pos: positionData.chooseStartPlayer_Win, z: 1)
        createLabel(text: "Player1", name: "startFromPlayer0", pos: positionData.startFromPlayer0, z: 1)
        createLabel(text: "Player2", name: "startFromPlayer1", pos: positionData.startFromPlayer1, z: 1)
        createLabel(text: "Player3", name: "startFromPlayer2", pos: positionData.startFromPlayer2, z: 1)
        createLabel(text: "", name: "currentPlayerLabel", pos: positionData.currentPlayer, z: -1)
        createLabel(text: "Please pick an employee card:", name: "pickCard", pos: positionData.labels, z: -1)
        createLabel(text: "Play Cards", name: "playcards", pos: positionData.playcards, z: -1)
        createLabel(text: "Discard Cards", name: "discardCards", pos: positionData.discardCards, z: -1)
        createLabel(text: "Please play cards", name: "pleasePlayCards", pos: positionData.labels, z: -1)
        createLabel(text: "Please discard cards", name: "pleaseDiscardCards", pos: positionData.labels, z: -1)
        createLabel(text: "Please select an employee card in opponent's hands:", name: "selectOPEmployee", pos: positionData.labels, z: -1)
        createLabel(text: "Please select an opponent:", name: "selectOP", pos: positionData.labels, z: -1)
        createLabel(text: "Please select an employee card in your hands:", name: "selectEmployeeInHand", pos: positionData.labels, z: -1)
        createLabel(text: "Please select an employee card on Desk:", name: "selectEmployeeOnDesk", pos: positionData.labels, z: -1)
        createLabel(text: "Please select the second card to use:", name: "selectSecondCard", pos: positionData.labels, z: -1)
        createLabel(text: "Please select a Bad Idea:", name: "selectBadIdea", pos: positionData.labels, z: -1)
        createLabel(text: "You can't play this card!", name: "cardDisable", pos: positionData.labels, z: -1)
        createLabel(text: "You can't do this!", name: "OPDisable", pos: positionData.labels, z: -1)
        createLabel(text: "You can't do this!", name: "OPCardDisable", pos: positionData.labels, z: -1)
        createLabel(text: "You can't do this!", name: "fireDisable", pos: positionData.labels, z: -1)
        
        createLabel(text: "RESUME", name: "resume", pos: CGPoint(x: frame.midX, y: frame.midY + 150), z: -1, fontSize : 50)
        createLabel(text: "RESTART", name: "restartMenu", pos: CGPoint(x: frame.midX, y: frame.midY + 50 ), z: -1, fontSize : 50)
        createLabel(text: "OPTION", name: "option", pos: CGPoint(x: frame.midX, y: frame.midY - 50), z: -1, fontSize : 50)
        createLabel(text: "MAIN MENU", name: "mainMenu", pos: CGPoint(x: frame.midX, y: frame.midY - 150), z: -1, fontSize : 50)
        createLabel(text: "Please pass the device to the next player~", name: "hotseatText", pos: CGPoint(x: frame.midX, y: frame.midY), z: -1, fontSize : 60)
        
        if self.childNode(withName: "currentPlayerLabel") == nil && self.currentPlayer != nil
        {
            let currentPlayerLabel = SKLabelNode(text: "Player\(self.currentPlayer! + 1)'s Turn :")
            currentPlayerLabel.position = CGPoint(x: 500, y: 720)
            currentPlayerLabel.zPosition = CGFloat(1)
            currentPlayerLabel.name = "currentPlayerLabel"
            addChild(currentPlayerLabel)
        }
    }
    
    func publicCardsMovePosition(card: CardSprite) -> CGPoint
    {
        if card is EmployeeCards
        {
            switch (card as! EmployeeCards).department {
            case .sales:
                return positionData.publicCards.sales
            case .finance:
                return positionData.publicCards.finance
            case .HR:
                return positionData.publicCards.HR
            case .development:
                return positionData.publicCards.development

            }
        }
        else
        {
            return positionData.publicCards.playcards
        }
    }
    func updateFront()
    {
        let departments = [self.sales, self.finance, self.HR, self.development]
        for department in departments
        {
            if department.cards.last != nil && department.cards.last!.isFront == false
            {
                department.cards.last!.setFront(isFront: true)
            }
        }
    }
    func selectEmployee(player: Player, department: departmentsEnum)
    {
        if gameState == .selectEmployee
        {
            self.childNode(withName: "blackBackground")?.zPosition = 198
            var employees : departmentsOfEmployees
            switch department {
                case .sales:
                    employees = player.sales
                case .finance:
                    employees = player.finance
                case .HR:
                    employees = player.HR
                case .development:
                    employees = player.development
            }
            let gap : CGFloat = 5
            let scale : CGFloat = 2
            // 计算每张牌位置
            var posX = (positionData.sceneWidth - CGFloat(employees.cards.count - 1) * (self.playcardsPool.first!.size.width * CGFloat(scale) + gap)) / 2
            for each in employees.cards
            {
                each.zPosition = 199
                each.setScale(scale)
                each.position = CGPoint(x: posX, y: positionData.sceneHeight / 2)
                posX += self.playcardsPool.first!.size.width * CGFloat(scale) + gap
            }
        }
    }
    func CardsPosition()
    {
        func publicCardsPosition(Array: [CardSprite], pos: CGPoint, yPlus: CGFloat)
        {
            var pos = pos
            var cardZPosition = 1
            for each in Array
            {
                if Array is [EmployeeCards] && gameState != .chooseStartPlayer      //避免开局初始化时有动画
                {
                    each.move(moveToPoint: pos)
                }
                else
                {
                    if each.position != pos
                    {
                        each.position = pos
                    }
                }
                if Int(each.zPosition) != cardZPosition
                {
                    each.zPosition = CGFloat(cardZPosition)
                }
                pos.y += yPlus
                cardZPosition += 1
            }
        }

        self.development.cards.last?.setFront(isFront: true)
        self.finance.cards.last?.setFront(isFront: true)
        self.HR.cards.last?.setFront(isFront: true)
        self.sales.cards.last?.setFront(isFront: true)
        

        publicCardsPosition(Array: self.playcardsPool, pos: positionData.publicCards.playcards, yPlus: positionData.publicCards.playcardsYPlus)
        publicCardsPosition(Array: self.sales.cards, pos: positionData.publicCards.sales, yPlus: positionData.publicCards.employeeYPlus)
        publicCardsPosition(Array: self.finance.cards, pos: positionData.publicCards.finance, yPlus: positionData.publicCards.employeeYPlus)
        publicCardsPosition(Array: self.HR.cards, pos: positionData.publicCards.HR, yPlus: positionData.publicCards.employeeYPlus)
        publicCardsPosition(Array: self.development.cards,pos: positionData.publicCards.development, yPlus: positionData.publicCards.employeeYPlus)
    }
    func playerCardsPosition(player: Int, animation: Int)
    {
        func PlayerCardsPosition(Array: [CardSprite], pos: CGPoint, xPlus: CGFloat = 0, yPlus: CGFloat = 0, zPlus: Int = 1)
        {
            var pos = pos
            var cardZPosition = 1
            for each in Array
            {

                if each.position != pos             //animation 0: none 1: move 2: move and show
                {
                    if animation == 1
                    {
                        each.move(moveToPoint: pos)
                    }
                    else if animation == 2
                    {
                        each.moveAndShow(moveToPoint: pos)
                    }
                    else
                    {
                        each.position = pos
                    }
                }
                if each.zPosition != CGFloat(cardZPosition)
                {
                    each.zPosition = CGFloat(cardZPosition)
                }
                pos.x += xPlus
                pos.y += yPlus
                cardZPosition += zPlus
            }
        }
        var pos = GameSceneScaleData.playerPosition()
        switch player
        {
        case 0:
            pos = positionData.player0Card
        case 1:
            pos = positionData.player1Card
        case 2:
            pos = positionData.player2Card
        default:
            break
        }
        PlayerCardsPosition(Array: self.players[player].sales.cards, pos: pos.sales, yPlus: pos.employeeYPlus)
        PlayerCardsPosition(Array: self.players[player].finance.cards, pos: pos.finance, yPlus: pos.employeeYPlus)
        PlayerCardsPosition(Array: self.players[player].HR.cards, pos: pos.HR, yPlus: pos.employeeYPlus)
        PlayerCardsPosition(Array: self.players[player].development.cards, pos: pos.development, yPlus: pos.employeeYPlus)
        PlayerCardsPosition(Array: self.players[player].stateCards, pos: pos.stateCards, xPlus: pos.stateCardsXPlus, yPlus: pos.stateCardsYPlus)
        PlayerCardsPosition(Array: self.players[player].cardsInHand, pos: pos.cardsInHand, xPlus: pos.cardsInHandXPlus, zPlus: 0)
        for each in self.players[player].cardsInHand
        {
            if each.chosen
            {
                each.position.y += 10
            }
        }
        let departments = [self.players[player].sales.cards, self.players[player].HR.cards, self.players[player].finance.cards ,self.players[player].development.cards, self.players[player].stateCards] as [Any]
        for department in departments
        {
            for each in department as! Array<Any>
            {
                if (each as! CardSprite).chosen
                {
                    if (each as! CardSprite) == (department as! Array<Any>).last as! CardSprite
                    {
                        (each as! CardSprite).position = CGPoint(x: (each as! CardSprite).position.x, y: (each as! CardSprite).position.y + 10)
                    }
                    else
                    {
                        (each as! CardSprite).zPosition = 99
                    }
                }
            }
        }

    }
    func turnEnd()
    {
        while self.players[self.currentPlayer!].cardsInHand.count < 6
        {
            if !self.players[self.currentPlayer!].isAI
            {
                self.playcardsPool.last!.setFront(isFront: true)
            }
            self.players[self.currentPlayer!].getCard(card: self.playcardsPool.removeLast())
        }
        self.players[self.currentPlayer!].cardsInHand.sort(by: handcardsSortRule)
        let engineer = self.players[self.currentPlayer!].engineerNum()
        if engineer < self.players[self.currentPlayer!].badIdea
        {
            self.players[self.currentPlayer!].contractor = self.players[self.currentPlayer!].badIdea - engineer
        }
        else
        {
            self.players[self.currentPlayer!].contractor = 0
        }

        let discardStateCard = self.players[self.currentPlayer!].burnThisTurn()
        for each in discardStateCard
        {
            self.playcardsPool.append(each)
        }
        
        self.players[self.currentPlayer!].enableCards = []
        self.players[self.currentPlayer!].badHireTarget = []
        self.players[self.currentPlayer!].badHireTargetOP = []
        self.players[self.currentPlayer!].badIdeaCard = nil
        self.players[self.currentPlayer!].badIdeaTargetOP = []
        self.players[self.currentPlayer!].outToPastureOrConflictOfOpnionTarget = []
        self.players[self.currentPlayer!].fireTarget = []
        self.players[self.currentPlayer!].hireTarget = []
        self.players[self.currentPlayer!].newBusinessPlanOrLayoffsTargetOP = []
        self.players[self.currentPlayer!].OP = nil
        self.players[self.currentPlayer!].OPCard = nil
        self.players[self.currentPlayer!].poachTarget = []
        self.players[self.currentPlayer!].releaseTarget = []
        self.players[self.currentPlayer!].selfCard = nil
        self.players[self.currentPlayer!].secondCard = nil
        self.players[self.currentPlayer!].secondFire = []
        self.players[self.currentPlayer!].secondPoach = []
        
        self.gameState = gameStateMachine.nothing
        self.playcardsPool = randomPlayCards(array: self.playcardsPool)
        self.playerCardsPosition(player: self.currentPlayer!, animation: 1)
        self.CardsPosition()
        self.players[self.currentPlayer!].cardsPlayedThisTurn = 0

        (self.childNode(withName: "player\(self.currentPlayer!)Money") as! SKLabelNode).text = "\(self.players[self.currentPlayer!].money)"
        writeLog(player: self.players[self.currentPlayer!], turnEnd: true)
        
        if self.players[self.currentPlayer!].money <= 0
        {
            self.playerOut(player: self.currentPlayer!)
        }
        if gameMode == .hotseat
        {
            gameState = .hotseatWall
            self.hotseat()
        }
        else
        {
            self.changeTurn()
        }
    }
    func hotseat()
    {
        if gameState == .hotseatWall
        {
        self.childNode(withName: "blackBackground")?.zPosition = 198
        self.childNode(withName: "hotseatText")?.zPosition = 199
        }
        else
        {
            self.childNode(withName: "blackBackground")?.zPosition = -1
            self.childNode(withName: "hotseatText")?.zPosition = -1
            self.changeTurn()
        }
    }
    func playerOut(player: Int)
    {
        for card in self.players[player].HR.cards
        {
            card.setFront(isFront: false)
            self.HR.cards.insert(card, at: 0)
        }
        for card in players[player].sales.cards
        {
            card.setFront(isFront: false)
            self.sales.cards.insert(card, at: 0)
        }
        for card in players[player].development.cards
        {
            card.setFront(isFront: false)
            self.development.cards.insert(card, at: 0)
        }
        for card in players[player].finance.cards
        {
            card.setFront(isFront: false)
            self.finance.cards.insert(card, at: 0)
        }
        for card in players[player].stateCards
        {
            card.setFront(isFront: false)
        }
        for card in players[player].cardsInHand
        {
            card.setFront(isFront: false)
        }
        self.playcardsPool.append(contentsOf: players[player].cardsInHand)
        self.playcardsPool.append(contentsOf: players[player].stateCards)
        self.playcardsPool = self.randomPlayCards(array: self.playcardsPool)
        self.players[player].HR.cards.removeAll()
        self.players[player].development.cards.removeAll()
        self.players[player].finance.cards.removeAll()
        self.players[player].sales.cards.removeAll()
        self.players[player].cardsInHand.removeAll()
        self.players[player].stateCards.removeAll()
        self.players[player].badIdea = 0
        self.CardsPosition()
        self.players[player].money = 0
        (self.childNode(withName: "player\(player)Money") as! SKLabelNode).text = "\(players[player].money)"
        players[player].VP = 0
        players[player].gameover = true
    }
    
    func selectOP(card: EmployeeCards) -> Int
    {
        for num in 0...self.numberOfPlayers - 1
        {
            for card in self.players[num].HR.cards
            {
                if self.players[self.currentPlayer!].OPCard == card
                {
                    return num
                }
            }
            for card in self.players[num].development.cards
            {
                if self.players[self.currentPlayer!].OPCard == card
                {
                    return num
                }
            }
            for card in self.players[num].finance.cards
            {
                if self.players[self.currentPlayer!].OPCard == card
                {
                    return num
                }
            }
            for card in self.players[num].sales.cards
            {
                if self.players[self.currentPlayer!].OPCard == card
                {
                    return num
                }
            }
        }
        return 99
    }
    func playNextCard()
    {
        self.players[self.currentPlayer!].currentCard!.chosen = false
        self.players[self.currentPlayer!].currentCard = nil
        self.players[self.currentPlayer!].cardsChosen = 0
        self.players[self.currentPlayer!].OP = nil
        if self.players[self.currentPlayer!].OPCard != nil
        {
            self.players[self.currentPlayer!].OPCard!.chosen = false
            self.players[self.currentPlayer!].OPCard = nil
        }
        if self.players[self.currentPlayer!].selfCard != nil
        {
            self.players[self.currentPlayer!].selfCard!.chosen = false
            self.players[self.currentPlayer!].selfCard = nil
        }
        if self.players[self.currentPlayer!].secondCard != nil
        {
            self.players[self.currentPlayer!].secondCard!.chosen = false
            self.players[self.currentPlayer!].secondCard = nil
        }
        if self.players[self.currentPlayer!].publicCards != nil
        {
            self.players[self.currentPlayer!].publicCards!.chosen = false
            self.players[self.currentPlayer!].publicCards = nil
        }
        if self.players[self.currentPlayer!].badIdeaCard != nil
        {
            self.players[self.currentPlayer!].badIdeaCard!.chosen = false
            self.players[self.currentPlayer!].badIdeaCard = nil
        }
        self.childNode(withName: "selectOP")?.zPosition = -1
        self.childNode(withName: "selectOPEmployee")?.zPosition = -1
        self.childNode(withName: "cancel")?.zPosition = -1
        self.childNode(withName: "cancel")?.position.x = 520
        if !self.players[self.currentPlayer!].isAI
        {
            self.childNode(withName: "confirm")?.zPosition = 1
        }
        if self.players[self.currentPlayer!].cardsPlayedThisTurn < 4
        {
            self.CardsPosition()
            self.playerCardsPosition(player: 0, animation: 2)
            self.playerCardsPosition(player: 1, animation: 2)
            self.playerCardsPosition(player: 2, animation: 2)
        }

        if self.players[self.currentPlayer!].cardsPlayedThisTurn >= 4
        {
            self.childNode(withName: "confirm")?.zPosition = -1
            self.childNode(withName: "cancel")?.zPosition = -1
            self.turnEnd()
        }
        else
        {
            self.gameState = gameStateMachine.playcards
            if !self.players[self.currentPlayer!].isAI
            {
                self.childNode(withName: "pleasePlayCards")?.zPosition = 1
            }
        }
    }
    func AI()
    {
        let AIPlayer = self.players[self.currentPlayer!]
        func pickCard() -> EmployeeCards
        {
            let marking =
                {
                    (card: EmployeeCards,department: [EmployeeCards]) -> Int in
                    var mark = card.skill! * 100
                    if department.count > 0
                    {
                        mark -= 80
                        if department.last!.status == .VP && card.status == .VP
                        {
                            mark = -1000
                        }
                        else if department.last!.skill! >= card.skill!
                        {
                            mark -= 50
                        }
                    }
                    if card.status == .VP
                    {
                        if card.skill! < 1
                        {
                            mark = -500
                        }
                        else
                        {
                            mark += 25
                        }
                    }
                    if card.status == .Engineer && AIPlayer.engineerNum() == 0
                    {
                        mark += 80
                    }
                    switch card.department { //HR > SALES > DEVELOPMENT > FINANCE
                    case .HR:
                        mark += 10
                        if AIPlayer.HR.cards.count == 0
                        {
                            mark += 100
                        }
                    case .sales:
                        mark += 5
                        if AIPlayer.sales.cards.count == 0
                        {
                            mark += 100
                        }
                    case .development:
                        mark -= 5
                        if AIPlayer.development.cards.count == 0 && card.status != .Engineer
                        {
                            mark += 100
                        }
                    case.finance:
                        mark -= 10
                        if AIPlayer.finance.cards.count == 0
                        {
                            mark += 100
                        }
                    }

                    return mark
            }
            var salesMark = -1000
            var financeMark = -1000
            var HRMark = -1000
            var developmentMark = -1000
            if self.sales.cards.count > 0
            {
                salesMark = marking(self.sales.cards.last!,AIPlayer.sales.cards)
            }
            if self.finance.cards.count > 0
            {
                financeMark = marking(self.finance.cards.last!,AIPlayer.finance.cards)
            }
            if self.HR.cards.count > 0
            {
                HRMark = marking(self.HR.cards.last!,AIPlayer.HR.cards)
            }
            if self.development.cards.count > 0
            {
                developmentMark = marking(self.development.cards.last!,AIPlayer.development.cards)
            }
            var queue = [salesMark, HRMark, developmentMark, financeMark]
            queue.sort()
            switch queue.last! {
            case salesMark:
                return self.sales.cards.last!
            case HRMark:
                return self.HR.cards.last!
            case developmentMark:
                return self.development.cards.last!
            case financeMark:
                return self.finance.cards.last!
            default:
                break
            }
            return self.HR.cards.last!
        }
        
        func enableCards()
        {
            let playerDepartments = [AIPlayer.sales, AIPlayer.finance, AIPlayer.HR, AIPlayer.development]
            let publicDepartments = [self.sales, self.finance, self.HR, self.development]
            var OP = 0
            var point   = 0
            for num in 0...self.numberOfPlayers - 1
            {
                if self.players[num].name != AIPlayer.name && point < self.players[num].money - self.players[num].contractor * 3
                {
                    point = self.players[num].money - self.players[num].contractor * 3
                    OP = num
                }
            }
            for card in AIPlayer.cardsInHand
            {
                if card.type == "RELEASE" && card.needSkill!.contains(AIPlayer.developmentSkill) && AIPlayer.badIdea > 0    //只考虑了有bad Idea可以release就release 并且没有考虑先hire或poach一个高级development的情况
                {
                    var worstBadIdea : PlayCards? = nil
                    for each in AIPlayer.stateCards       //which BadIdea is worst
                    {
                        if !AIPlayer.releaseTarget.contains(each)
                        {
                            if worstBadIdea == nil
                            {
                                worstBadIdea = each
                            }
                            else
                            {
                                if each.value! > worstBadIdea!.value!
                                {
                                    worstBadIdea = each
                                }
                            }
                        }
                    }
                    if worstBadIdea != nil
                    {
                        AIPlayer.enableCards.append(card)
                        AIPlayer.releaseTarget.append(worstBadIdea!)
                    }
                }
                else if card.type == "FIRE" && card.needSkill!.contains(AIPlayer.HRSkill) && !AIPlayer.secondFire.contains(card)    //不fire工程师
                {
                    for department in playerDepartments       //VP
                    {
                        let last = department.cards.last
                        if last?.status == .VP  && !AIPlayer.fireTarget.contains(last!) && ((last?.skill)! == 0 || department.cards.count >= 2 && department.cards[department.cards.count - 2].skill! >= last!.skill!)  //VP是0 或 有一张manager >= VP
                        {
                            var secondFire = false
                            for each in AIPlayer.cardsInHand
                            {
                                if each.type == "FIRE" && each.needSkill!.contains(AIPlayer.HRSkill) && card.name! != each.name!
                                {
                                    AIPlayer.secondFire.append(each)
                                    secondFire = true
                                    break
                                }
                            }
                            if secondFire
                            {
                                AIPlayer.fireTarget.append(department.cards.last!)
                                AIPlayer.enableCards.append(card)
                                break
                            }
                        }
                    }
                    if !AIPlayer.enableCards.contains(card) //Manager
                    {
                        var flag = false
                        for department in playerDepartments
                        {
                            for each in department.cards
                            {
                                if each.status == .Manager && each != department.cards.last && !AIPlayer.fireTarget.contains(each)
                                {
                                    AIPlayer.fireTarget.append(each)
                                    AIPlayer.enableCards.append(card)
                                    flag = true
                                    break
                                }
                            }
                            if flag
                            {
                                break
                            }
                        }
                    }
                }
                else if card.type == "HIRE" && card.needSkill!.contains(AIPlayer.HRSkill)
                {
                    for department in publicDepartments
                    {
                        if department.cards.last == nil
                        {
                            continue
                        }
                        let last = department.cards.last
                        if AIPlayer.hireTarget.contains(last!) || self.if2VP(node: department.cards.last!, player: self.currentPlayer!)

                        {
                            continue
                        }
                        switch department.department
                        {
                            case .sales:
                                if last?.skill != nil && (last?.skill)! > AIPlayer.salesSkill + 1
                                {
                                    AIPlayer.enableCards.append(card)
                                    AIPlayer.hireTarget.append(last!)
                                }
                            case .finance:
                                if last?.skill != nil && (last?.skill)! > AIPlayer.financeSKill + 1
                                {
                                    AIPlayer.enableCards.append(card)
                                    AIPlayer.hireTarget.append(last!)
                                }
                            case .HR:
                                if last?.skill != nil && (last?.skill)! > AIPlayer.HRSkill + 1
                                {
                                    AIPlayer.enableCards.append(card)
                                    AIPlayer.hireTarget.append(last!)
                                }
                            case .development:
                                if last?.skill != nil && (last?.status == .Engineer && AIPlayer.engineerNum() < (AIPlayer.badIdea + AIPlayer.releaseTarget.count) ||  (last?.skill)! > AIPlayer.developmentSkill + 1)
                                {
                                    AIPlayer.enableCards.append(card)
                                    AIPlayer.hireTarget.append(last!)
                                }
                        }
                        if AIPlayer.hireTarget.contains(last!)
                        {
                            break
                        }
                    }
                }
                else if card.type == "FUNDING" && card.needSkill!.contains(AIPlayer.financeSKill)
                {
                    AIPlayer.enableCards.append(card)
                }
                else if card.type == "BAD IDEA"
                {
                    if card.needSkill!.contains(self.players[OP].salesSkill)  && !self.players[OP].gameover
                    {
                        AIPlayer.badIdeaTargetOP.append(OP)
                        AIPlayer.enableCards.append(card)
                    }
                    else
                    {
                        for num in 0...numberOfPlayers - 1
                        {
                            if self.players[num].name! != AIPlayer.name! && num != OP && card.needSkill!.contains(self.players[num].salesSkill) && !self.players[num].gameover
                            {
                                AIPlayer.badIdeaTargetOP.append(num)
                                AIPlayer.enableCards.append(card)
                                break
                            }
                        }
                    }
                }
                else if card.type == "BAD HIRE"
                {
                    for department in publicDepartments
                    {
                        if department.cards.last == nil
                        {
                            continue
                        }
                        if department.cards.last?.status == .VP && (department.cards.last?.skill)! <= 1 && !AIPlayer.badHireTarget.contains(department.cards.last!) //  只有技能小于等于1的VP
                        {
                            if card.needSkill!.contains(self.players[OP].HRSkill) && !self.if2VP(node: department.cards.last!, player: OP) && !self.players[OP].gameover
                            {
                                AIPlayer.badHireTargetOP.append(OP)
                                AIPlayer.badHireTarget.append(department.cards.last!)
                                AIPlayer.enableCards.append(card)
                            }
                            else
                            {
                                for num in 0...numberOfPlayers - 1
                                {
                                    if self.players[num].name! != AIPlayer.name! && num != OP && card.needSkill!.contains(self.players[num].HRSkill) && !self.if2VP(node: department.cards.last!, player: num) && !self.players[num].gameover

                                    {
                                        AIPlayer.badHireTargetOP.append(num)
                                        AIPlayer.badHireTarget.append(department.cards.last!)
                                        AIPlayer.enableCards.append(card)
                                        break
                                    }
                                }
                            }
                            break
                        }
                    }
                }
                else if card.type == "POACH" && !AIPlayer.secondPoach.contains(card)
                {
                    func chooseTarget(player: Int) -> Bool
                    {
                        var target : EmployeeCards?
                        let departments = [self.players[player].HR, self.players[player].sales, self.players[player].finance, self.players[player].development]
                        for department in departments
                        {
                            switch department.department    //只看最后一个(没有考虑最后一张是VP不能poach而后一张是技能2的manager的情况)
                            {
                                case .sales:
                                    if department.cards.last != nil && department.cards.last!.skill! >= AIPlayer.salesSkill + 2 && !AIPlayer.poachTarget.contains(department.cards.last!) && !(department.cards.last?.status == .VP && (AIPlayer.sales.cards.last?.status == .VP || AIPlayer.enableCards.count >= 3))
                                    {
                                        target = department.cards.last!
                                    }
                                case .finance:
                                    if department.cards.last != nil && department.cards.last!.skill! >= AIPlayer.financeSKill + 2 && !AIPlayer.poachTarget.contains(department.cards.last!) && !(department.cards.last?.status == .VP && (AIPlayer.finance.cards.last?.status == .VP || AIPlayer.enableCards.count >= 3))
                                    {
                                        target = department.cards.last!
                                    }
                                case .HR:
                                    if department.cards.last != nil && department.cards.last!.skill! >= AIPlayer.HRSkill + 2 && !AIPlayer.poachTarget.contains(department.cards.last!) && !(department.cards.last?.status == .VP && (AIPlayer.HR.cards.last?.status == .VP || AIPlayer.enableCards.count >= 3))
                                    {
                                        target = department.cards.last!
                                    }
                                case .development:
                                    if department.cards.last != nil && department.cards.last!.skill! >= AIPlayer.developmentSkill + 2 && !AIPlayer.poachTarget.contains(department.cards.last!) && !(department.cards.last?.status == .VP && (AIPlayer.development.cards.last?.status == .VP || AIPlayer.enableCards.count >= 3))
                                    {
                                        target = department.cards.last!
                                    }
                            }
                            if target?.status == .VP
                            {
                                for each in AIPlayer.cardsInHand
                                {
                                    if each.type! == "POACH" && each.needSkill!.contains(self.players[player].HRSkill) && each.name! != card.name! && !AIPlayer.secondPoach.contains(each)
                                    {
                                        AIPlayer.secondPoach.append(each)
                                        AIPlayer.poachTarget.append(target!)
                                        AIPlayer.enableCards.append(card)
                                        return true
                                    }
                                }
                            }
                            else if target != nil
                            {
                                AIPlayer.poachTarget.append(target!)
                                AIPlayer.enableCards.append(card)
                                return true
                            }
                        }
                        return false
                    }
                    var releaseTotalBadIdea = 0
                    var poachEngeneer = 0
                    for each in AIPlayer.releaseTarget
                    {
                        releaseTotalBadIdea += each.value!
                    }
                    for each in AIPlayer.poachTarget
                    {
                        if each.status == .Engineer
                        {
                            poachEngeneer += 1
                        }
                    }
                    if AIPlayer.badIdea - AIPlayer.engineerNum() - releaseTotalBadIdea - poachEngeneer > 0
                    {
                        var flag = false //是否poach了Engeneer
                        if card.needSkill!.contains(self.players[OP].HRSkill) && !self.players[OP].gameover
                        {
                            for each in self.players[OP].development.cards
                            {
                                if each.status == .Engineer && !AIPlayer.poachTarget.contains(each)
                                {
                                    AIPlayer.poachTarget.append(each)
                                    AIPlayer.enableCards.append(card)
                                    flag = true
                                    break
                                }
                            }
                            if flag
                            {
                                break
                            }
                        }
                        else
                        {
                            for num in 0...numberOfPlayers - 1
                            {
                                if self.players[num].name! != AIPlayer.name! && num != OP && card.needSkill!.contains(self.players[num].HRSkill) && !self.players[OP].gameover
                                {
                                    var flag2 = false
                                    for each in self.players[num].development.cards
                                    {
                                        if each.status == .Engineer && !AIPlayer.poachTarget.contains(each)
                                        {
                                            AIPlayer.poachTarget.append(each)
                                            AIPlayer.enableCards.append(card)
                                            flag = true
                                            flag2 = true
                                            break
                                        }
                                    }
                                    if flag2
                                    {
                                        break
                                    }
                                }
                            }
                            if flag
                            {
                                continue
                            }
                        }
                    }
                    for num in 0...numberOfPlayers - 1
                    {
                        if card.needSkill!.contains(self.players[num].HRSkill) && chooseTarget(player: num)
                        {
                            break
                        }
                    }
                }
                else if card.type == "CONFLICT OF OPINION" || card.type == "OUT TO PASTURE"
                {
                    
                    if card.needSkill![0] <= self.players[OP].VP - AIPlayer.newBusinessPlanOrLayoffsTargetOP.count
                    {
                        let departments = [
                            self.players[OP].sales,
                            self.players[OP].finance,
                            self.players[OP].HR,
                            self.players[OP].development]
                        for department in departments
                        {
                            if department.cards.last?.status == .VP && department.cards.last!.skill! >= 2 && !AIPlayer.outToPastureOrConflictOfOpnionTarget.contains(department.cards.last!)
                            {
                                AIPlayer.enableCards.append(card)
                                AIPlayer.outToPastureOrConflictOfOpnionTarget.append(department.cards.last!)
                                break
                            }
                        }
                    }
                    else
                    {
                        for num in 0...numberOfPlayers - 1
                        {
                            if self.players[num].name! != AIPlayer.name! && num != OP && card.needSkill![0] <= self.players[num].VP
                            {
                                let departments = [self.players[num].sales, self.players[num].finance, self.players[num].HR, self.players[num].development]
                                for department in departments
                                {
                                    if department.cards.last?.status == .VP && department.cards.last!.skill! >= 2 && !AIPlayer.outToPastureOrConflictOfOpnionTarget.contains(department.cards.last!)
                                    {
                                        AIPlayer.enableCards.append(card)
                                        AIPlayer.outToPastureOrConflictOfOpnionTarget.append(department.cards.last!)
                                        break
                                    }
                                }
                                if AIPlayer.enableCards.contains(card)
                                {
                                    break
                                }
                            }
                        }
                    }
                }
                else if card.type == "LAYOFFS" || card.type == "NEWBUSINESSPLAN"
                {
                    if card.needSkill![0] <= self.players[OP].VP  && !self.players[OP].gameover
                    {
                        AIPlayer.newBusinessPlanOrLayoffsTargetOP.append(OP)
                        AIPlayer.enableCards.append(card)
                    }
                    else
                    {
                        for num in 0...numberOfPlayers - 1
                        {
                            if self.players[num].name! != AIPlayer.name! && num != OP && card.needSkill![0] <= self.players[num].VP  && !self.players[num].gameover
                            {
                                AIPlayer.newBusinessPlanOrLayoffsTargetOP.append(num)
                                AIPlayer.enableCards.append(card)
                                break
                            }
                        }
                    }
                }
            }
        }
        if self.gameState == .pickCards
        {
            self.gameProcess(touchNode: [pickCard()])
        }
        else if self.gameState == .playOrDiscard
        {
            enableCards()
            for each in AIPlayer.enableCards
            {
                NSLog(each.name!)
            }
//            print("badHireTarget",AIPlayer.badHireTarget)
//            print("badHireTargetOP",AIPlayer.badHireTargetOP)
//            print("badIdeaTargetOP",AIPlayer.badIdeaTargetOP)
//            print("outToPastureOrConflictOfOpnionTarget",AIPlayer.outToPastureOrConflictOfOpnionTarget)
//            print("fireTarget",AIPlayer.fireTarget)
//            print("secondFire",AIPlayer.secondFire)
//            print("hireTarget",AIPlayer.hireTarget)
//            print("newBusinessPlanOrLayoffsTargetOP",AIPlayer.newBusinessPlanOrLayoffsTargetOP)
            if AIPlayer.releaseTarget.count > 0 || AIPlayer.enableCards.count + AIPlayer.secondFire.count + AIPlayer.secondPoach.count > 3
            {
                self.gameProcess(touchNode: [self.childNode(withName: "playcards")!])
            }
            else
            {
                self.gameProcess(touchNode: [self.childNode(withName: "discardCards")!])
            }
        }
        else if gameState == .playcards
        {
            AIPlayer.enableCards = []
            AIPlayer.badHireTarget = []
            AIPlayer.badHireTargetOP = []
            AIPlayer.badIdeaCard = nil
            AIPlayer.badIdeaTargetOP = []
            AIPlayer.outToPastureOrConflictOfOpnionTarget = []
            AIPlayer.fireTarget = []
            AIPlayer.hireTarget = []
            AIPlayer.newBusinessPlanOrLayoffsTargetOP = []
            AIPlayer.OP = nil
            AIPlayer.OPCard = nil
            AIPlayer.poachTarget = []
            AIPlayer.releaseTarget = []
            AIPlayer.selfCard = nil
            AIPlayer.secondCard = nil
            AIPlayer.secondFire = []
            AIPlayer.secondPoach = []
            enableCards()
            if AIPlayer.enableCards.count > 0
            {
                AIPlayer.currentCard = AIPlayer.enableCards.removeFirst()
                AIPlayer.currentCard?.setFront(isFront: true)
                gameProcess(touchNode: [AIPlayer.currentCard!])
            }
            else
            {
                self.turnEnd()
            }
        }
        else if gameState == .discardCards
        {
            var discardCards = [PlayCards]()
            var num = 0
            for card in  AIPlayer.cardsInHand
            {
                if !AIPlayer.enableCards.contains(card) && num <= 3
                {
                    discardCards.append(card)
                    num += 1
                }
            }
            self.gameProcess(touchNode: discardCards)
        }
        else if gameState == .selectBadIdeaToRelease
        {
            AIPlayer.badIdeaCard = AIPlayer.releaseTarget.removeFirst()
            self.gameProcess(touchNode: [])
        }
        else if gameState == .selectEmployeeInHand
        {
            AIPlayer.selfCard = AIPlayer.fireTarget.removeFirst()
            gameProcess(touchNode: AIPlayer.fireTarget)
        }
        else if gameState == .selectEmployeeOnDesk
        {
            if AIPlayer.currentCard!.type == "HIRE"
            {
                AIPlayer.publicCards = AIPlayer.hireTarget.removeFirst()
                gameProcess(touchNode: AIPlayer.hireTarget)
            }
            else   //BAD HIRE
            {
                AIPlayer.publicCards = AIPlayer.badHireTarget.removeFirst()
                gameProcess(touchNode: AIPlayer.badHireTarget)
            }
        }
        else if gameState == .selectOP
        {
            if AIPlayer.currentCard!.type == "BAD IDEA"
            {
                AIPlayer.OP = AIPlayer.badIdeaTargetOP.removeFirst()
                gameProcess(touchNode: [])
            }
            else if AIPlayer.currentCard!.type == "BAD HIRE"
            {
                AIPlayer.OP = AIPlayer.badHireTargetOP.removeFirst()
                gameProcess(touchNode: [])
            }
            else if AIPlayer.currentCard!.type == "LAYOFFS" || AIPlayer.currentCard!.type == "NEWBUSINESSPLAN"
            {
                AIPlayer.OP = AIPlayer.newBusinessPlanOrLayoffsTargetOP.removeFirst()
                gameProcess(touchNode: [])
            }
        }
        else if gameState == .selectOPEmployee
        {
            if AIPlayer.currentCard!.type == "POACH"
            {
                AIPlayer.OPCard = AIPlayer.poachTarget.removeFirst()
            }
            else if AIPlayer.currentCard!.type == "OUT TO PASTURE" || AIPlayer.currentCard!.type == "CONFLICT OF OPINION"
            {
                AIPlayer.OPCard = AIPlayer.outToPastureOrConflictOfOpnionTarget.removeFirst()
            }
            gameProcess(touchNode: [])
        }
        else if gameState == .selectSecondCard
        {
            if AIPlayer.currentCard!.type == "FIRE"
            {
                AIPlayer.secondCard = AIPlayer.secondFire.removeFirst()
            }
            else //POACH
            {
                AIPlayer.secondCard = AIPlayer.secondPoach.removeFirst()
            }
            gameProcess(touchNode: [])
        }

    }
    func cardAction(card: PlayCards)
    {
        if self.gameState == gameStateMachine.playcards
        {
            if card.isOffensive!
            {
                if card.type! == "POACH" || card.type! == "CONFLICT OF OPINION" || card.type! == "OUT TO PASTURE"
                {
                    if !self.players[self.currentPlayer!].isAI
                    {
                        self.childNode(withName: "pleasePlayCards")?.zPosition = -1
                        self.childNode(withName: "selectOPEmployee")?.zPosition = 1
                        self.childNode(withName: "cancel")?.zPosition = 1
                    }
                    self.gameState = gameStateMachine.selectOPEmployee
                }
                else              //BAD IDEA, BAD HIRE, LAYOFFS and NEW BUSINESS PLAN
                {
                    if !self.players[self.currentPlayer!].isAI
                    {
                        self.childNode(withName: "pleasePlayCards")?.zPosition = -1
                        self.childNode(withName: "selectOP")?.zPosition = 1
                        self.childNode(withName: "cancel")?.zPosition = 1
                        self.childNode(withName: "cancel")?.position.x = 630
                        self.childNode(withName: "confirm")?.zPosition = -1
                    }
                    self.gameState = gameStateMachine.selectOP
                }
            }
            else
            {
                switch card.type!
                {
                case "FIRE":
                    if card.needSkill!.contains(self.players[self.currentPlayer!].HRSkill)
                    {
                        if !self.players[self.currentPlayer!].isAI
                        {
                            self.childNode(withName: "pleasePlayCards")?.zPosition = -1
                            self.childNode(withName: "selectEmployeeInHand")?.zPosition = 1
                            self.childNode(withName: "cancel")?.zPosition = 1
                        }
                        self.gameState = gameStateMachine.selectEmployeeInHand
                    }
                    else
                    {
                        self.warning()
                    }
                case "HIRE":
                    if card.needSkill!.contains(self.players[self.currentPlayer!].HRSkill)
                    {
                        if !self.players[self.currentPlayer!].isAI
                        {
                            self.childNode(withName: "pleasePlayCards")?.zPosition = -1
                            self.childNode(withName: "selectEmployeeOnDesk")?.zPosition = 1
                            self.childNode(withName: "cancel")?.zPosition = 1
                            self.childNode(withName: "cancel")?.position.x = 630
                            self.childNode(withName: "confirm")?.zPosition = -1
                        }
                        self.gameState = gameStateMachine.selectEmployeeOnDesk
                    }
                    else
                    {
                        self.warning()
                    }
                case "FUNDING":
                    if card.needSkill!.contains(self.players[self.currentPlayer!].financeSKill)
                    {
                        if !self.players[self.currentPlayer!].isAI
                        {
                            self.childNode(withName: "pleasePlayCards")?.zPosition = -1
                        }
                        self.players[self.currentPlayer!].money += card.value!
                        (self.childNode(withName: "player\(self.currentPlayer!)Money") as! SKLabelNode).text = "\(self.players[self.currentPlayer!].money)"
                        self.playcardsPool.append(self.players[self.currentPlayer!].discardCard(card: card) as! PlayCards)
                        self.playcardsPool = randomPlayCards(array: self.playcardsPool)
                        writeLog(player: self.players[self.currentPlayer!], card: self.players[self.currentPlayer!].currentCard!)
                        self.playNextCard()
                    }
                    else
                    {
                        self.warning()
                    }
                case "RELEASE":
                    if card.needSkill!.contains(self.players[self.currentPlayer!].developmentSkill) && self.players[self.currentPlayer!].badIdea > 0
                    {
                        if !self.players[self.currentPlayer!].isAI
                        {
                            self.childNode(withName: "pleasePlayCards")?.zPosition = -1
                            self.childNode(withName: "selectBadIdea")?.zPosition = 1
                        }
                        self.gameState = gameStateMachine.selectBadIdeaToRelease
                    }
                    else
                    {
                        self.warning()
                    }
                default:
                    break
                }
            }
        }
        else if self.gameState == gameStateMachine.selectEmployeeInHand             //FIRE
        {
            if self.players[self.currentPlayer!].selfCard!.status != .VP
            {
                self.players[self.currentPlayer!].selfCard!.setFront(isFront: false)
                switch self.players[self.currentPlayer!].selfCard!.department
                {
                    case .sales:
                        self.sales.cards.insert(self.players[self.currentPlayer!].discardCard(card: self.players[self.currentPlayer!].selfCard!) as! EmployeeCards, at: 0)
                    case .HR:
                        self.HR.cards.insert(self.players[self.currentPlayer!].discardCard(card: self.players[self.currentPlayer!].selfCard!) as! EmployeeCards, at: 0)
                    case .development:
                        self.development.cards.insert(self.players[self.currentPlayer!].discardCard(card: self.players[self.currentPlayer!].selfCard!) as! EmployeeCards, at: 0)
                    case .finance:
                        self.finance.cards.insert(self.players[self.currentPlayer!].discardCard(card: self.players[self.currentPlayer!].selfCard!) as! EmployeeCards, at: 0)
                }
                self.players[self.currentPlayer!].currentCard!.setFront(isFront: false)
                self.playcardsPool.append(self.players[self.currentPlayer!].discardCard(card: self.players[self.currentPlayer!].currentCard!) as! PlayCards)
                self.playcardsPool = randomPlayCards(array: self.playcardsPool)
                writeLog(player: self.players[self.currentPlayer!], card: self.players[self.currentPlayer!].currentCard!, targetCard: self.players[self.currentPlayer!].selfCard!)
                self.playNextCard()
            }
            else
            {
                if self.players[self.currentPlayer!].isAI
                {
                    self.gameState = .selectSecondCard
                    return
                }
                if self.players[self.currentPlayer!].cardsPlayedThisTurn >= 4
                {
                    warning()
                }
                else
                {
                    var num = 0
                    var cardToPlay : [PlayCards] = []
                    for each in self.players[self.currentPlayer!].cardsInHand
                    {
                        if each.type == "FIRE" && each.needSkill!.contains(self.players[self.currentPlayer!].HRSkill)
                        {
                            num += 1
                            cardToPlay.append(each)
                        }
                    }
                    if num == 1
                    {
                        self.warning()
                    }
                    else if num == 2
                    {
                        self.players[self.currentPlayer!].selfCard!.setFront(isFront: false)
                        switch self.players[self.currentPlayer!].selfCard!.department
                        {
                        case .sales:
                            self.sales.cards.insert(self.players[self.currentPlayer!].discardCard(card: self.players[self.currentPlayer!].selfCard!) as! EmployeeCards, at: 0)
                        case .HR:
                            self.HR.cards.insert(self.players[self.currentPlayer!].discardCard(card: self.players[self.currentPlayer!].selfCard!) as! EmployeeCards, at: 0)
                        case .development:
                            self.development.cards.insert(self.players[self.currentPlayer!].discardCard(card: self.players[self.currentPlayer!].selfCard!) as! EmployeeCards, at: 0)
                        case .finance:
                            self.finance.cards.insert(self.players[self.currentPlayer!].discardCard(card: self.players[self.currentPlayer!].selfCard!) as! EmployeeCards, at: 0)
                        }
                        self.players[self.currentPlayer!].cardsPlayedThisTurn += 1
                        for each in cardToPlay
                        {
                            each.setFront(isFront: false)
                            self.playcardsPool.append(self.players[self.currentPlayer!].discardCard(card: each) as! PlayCards)
                            if each != self.players[self.currentPlayer!].currentCard!
                            {
                                self.players[self.currentPlayer!].secondCard = each
                            }
                        }
                        self.playcardsPool = randomPlayCards(array: self.playcardsPool)
                        writeLog(player: self.players[self.currentPlayer!], card: self.players[self.currentPlayer!].currentCard!, card2: self.players[self.currentPlayer!].secondCard!, targetCard: self.players[self.currentPlayer!].selfCard!)
                        self.playNextCard()
                    }
                    else
                    {
                        self.childNode(withName: "selectEmployeeInHand")?.zPosition = -1
                        self.childNode(withName: "selectSecondCard")?.zPosition = 1
                        self.gameState = gameStateMachine.selectSecondCard
                    }
                }
            }
        }
        else if self.gameState == gameStateMachine.selectOP
        {
            if card.type == "BAD IDEA"
            {
                if card.needSkill!.contains(self.players[self.players[self.currentPlayer!].OP!].salesSkill)
                {
                    self.players[self.players[self.currentPlayer!].OP!].getState(card: self.players[self.currentPlayer!].discardCard(card: card) as! PlayCards)
                    writeLog(player: self.players[self.currentPlayer!], card: self.players[self.currentPlayer!].currentCard!, opponent: self.players[self.players[self.currentPlayer!].OP!])
                    self.playNextCard()
                }
                else
                {
                    self.warning()
                }
            }
            else if card.type == "BAD HIRE"
            {
                if card.needSkill!.contains(self.players[self.players[self.currentPlayer!].OP!].HRSkill)
                {
                    if !self.players[self.currentPlayer!].isAI
                    {
                        self.childNode(withName: "selectOP")?.zPosition = -1
                        self.childNode(withName: "selectEmployeeOnDesk")?.zPosition = 1
                        self.childNode(withName: "cancel")?.zPosition = 1
                    }
                    self.gameState = gameStateMachine.selectEmployeeOnDesk
                }
                else
                {
                    self.warning()
                }
            }
            else       //LAYOFFS and NEW BUSINESS PLAN
            {
                if card.needSkill![0] <= self.players[self.players[self.currentPlayer!].OP!].VP
                {
                    self.players[self.players[self.currentPlayer!].OP!].getState(card: self.players[self.currentPlayer!].discardCard(card: card) as! PlayCards)
                    writeLog(player: self.players[self.currentPlayer!], card: self.players[self.currentPlayer!].currentCard!, opponent: self.players[self.players[self.currentPlayer!].OP!])
                    self.playNextCard()
                }
                else
                {
                    self.warning()
                }
            }

        }
        else if self.gameState == gameStateMachine.selectEmployeeOnDesk
        {
            if card.type! == "HIRE"
            {
                switch self.players[self.currentPlayer!].publicCards!.department {
                case .sales:
                    self.players[self.currentPlayer!].getCard(card: self.sales.cards.removeLast())
                    self.sales.cards.last?.setFront(isFront: true)
                case .HR:
                    self.players[self.currentPlayer!].getCard(card: self.HR.cards.removeLast())
                    self.HR.cards.last?.setFront(isFront: true)
                case .finance:
                    self.players[self.currentPlayer!].getCard(card: self.finance.cards.removeLast())
                    self.finance.cards.last?.setFront(isFront: true)
                case .development:
                    self.players[self.currentPlayer!].getCard(card: self.development.cards.removeLast())
                    self.development.cards.last?.setFront(isFront: true)
                }
                self.playcardsPool.append(self.players[self.currentPlayer!].discardCard(card: self.players[self.currentPlayer!].currentCard!) as! PlayCards)
                self.playcardsPool = randomPlayCards(array: self.playcardsPool)
                writeLog(player: self.players[self.currentPlayer!], card: self.players[self.currentPlayer!].currentCard!, targetCard: self.players[self.currentPlayer!].publicCards!)
                self.playNextCard()
                
            }
            else                //BAD HIRE
            {
                switch self.players[self.currentPlayer!].publicCards!.department {
                case .sales:
                    self.players[self.players[self.currentPlayer!].OP!].getCard(card: self.sales.cards.removeLast())
                    self.sales.cards.last?.setFront(isFront: true)
                case .HR:
                    self.players[self.players[self.currentPlayer!].OP!].getCard(card: self.HR.cards.removeLast())
                    self.HR.cards.last?.setFront(isFront: true)
                case .finance:
                    self.players[self.players[self.currentPlayer!].OP!].getCard(card: self.finance.cards.removeLast())
                    self.finance.cards.last?.setFront(isFront: true)
                case .development:
                    self.players[self.players[self.currentPlayer!].OP!].getCard(card: self.development.cards.removeLast())
                    self.development.cards.last?.setFront(isFront: true)
                }
                self.playcardsPool.append(self.players[self.currentPlayer!].discardCard(card: self.players[self.currentPlayer!].currentCard!) as! PlayCards)
                self.playcardsPool = randomPlayCards(array: self.playcardsPool)
                writeLog(player: self.players[self.currentPlayer!], card: self.players[self.currentPlayer!].currentCard!, opponent: self.players[self.players[self.currentPlayer!].OP!], targetCard: self.players[self.currentPlayer!].publicCards!)
                self.playNextCard()
            }

            
        }
        else if self.gameState == gameStateMachine.selectOPEmployee
        {
            if card.type == "POACH"
            {
                if card.needSkill!.contains(self.players[self.selectOP(card: self.players[self.currentPlayer!].OPCard!)].HRSkill)
                {
                    if self.players[self.currentPlayer!].OPCard!.status != .VP
                    {
                        self.players[self.currentPlayer!].getCard(card: self.players[self.selectOP(card: self.players[self.currentPlayer!].OPCard!)].discardCard(card: self.players[self.currentPlayer!].OPCard!))
                        self.playcardsPool.append(self.players[self.currentPlayer!].discardCard(card: self.players[self.currentPlayer!].currentCard!) as! PlayCards)
                        self.playcardsPool = randomPlayCards(array: self.playcardsPool)
                        writeLog(player: self.players[self.currentPlayer!], card: self.players[self.currentPlayer!].currentCard!, opponent: self.players[self.selectOP(card: self.players[self.currentPlayer!].OPCard!)], targetCard: self.players[self.currentPlayer!].OPCard!)
                        self.playNextCard()
                    }
                    else
                    {
                        if self.players[self.currentPlayer!].isAI
                        {
                            self.gameState = .selectSecondCard
                            return
                        }
                        if self.players[self.currentPlayer!].cardsPlayedThisTurn >= 4
                        {
                            warning()
                        }
                        else
                        {
                            var num = 0
                            var cardToPlay : [PlayCards] = []
                            for each in self.players[self.currentPlayer!].cardsInHand
                            {
                                if each.type == "POACH" && each.needSkill!.contains(self.players[self.currentPlayer!].HRSkill)
                                {
                                    num += 1
                                    cardToPlay.append(each)
                                }
                            }
                            if num == 1
                            {
                                self.warning()
                            }
                            else if num == 2
                            {
                                self.players[self.currentPlayer!].getCard(card: self.players[self.selectOP(card: self.players[self.currentPlayer!].OPCard!)].discardCard(card: self.players[self.currentPlayer!].OPCard!))
                                self.players[self.currentPlayer!].cardsPlayedThisTurn += 1
                                for each in cardToPlay
                                {
                                    self.playcardsPool.append(self.players[self.currentPlayer!].discardCard(card: each) as! PlayCards)
                                    if each != self.players[self.currentPlayer!].currentCard!
                                    {
                                        self.players[self.currentPlayer!].secondCard = each
                                    }
                                }
                                self.playcardsPool = randomPlayCards(array: self.playcardsPool)
                                writeLog(player: self.players[self.currentPlayer!], card: self.players[self.currentPlayer!].currentCard!, opponent: self.players[self.selectOP(card: self.players[self.currentPlayer!].OPCard!)],
                                         card2: self.players[self.currentPlayer!].secondCard!, targetCard: self.players[self.currentPlayer!].OPCard!)
                                self.playNextCard()
                            }
                            else
                            {
                                if !self.players[self.currentPlayer!].isAI
                                {
                                    self.childNode(withName: "selectEmployeeInHand")?.zPosition = -1
                                    self.childNode(withName: "selectSecondCard")?.zPosition = 1
                                }
                                self.gameState = gameStateMachine.selectSecondCard
                            }
                        }
                    }
                }
                else
                {
                    self.warning()
                }
            }
            else        //Conflict of opinion  and   Out to pasture
            {
                
                if card.needSkill![0] <= self.players[self.selectOP(card: self.players[self.currentPlayer!].OPCard!)].VP
                {
                    writeLog(player: self.players[self.currentPlayer!], card: self.players[self.currentPlayer!].currentCard!, opponent: self.players[self.selectOP(card: self.players[self.currentPlayer!].OPCard!)])
                    var department : departmentsOfEmployees?
                    switch self.players[self.currentPlayer!].OPCard!.department
                    {
                        case .sales:
                            department = self.sales
                        case .HR:
                            department = self.HR
                        case .finance:
                            department = self.finance
                        case .development:
                            department = self.development
                    }
                    self.players[self.currentPlayer!].OPCard!.setFront(isFront: false)
                    department!.cards.insert(self.players[self.selectOP(card: self.players[self.currentPlayer!].OPCard!)].discardCard(card: self.players[self.currentPlayer!].OPCard!) as! EmployeeCards, at: 0)

                    self.playcardsPool.append(self.players[self.currentPlayer!].discardCard(card: self.players[self.currentPlayer!].currentCard!) as! PlayCards)
                    self.playcardsPool = randomPlayCards(array: self.playcardsPool)
                    self.playNextCard()

                }
                else
                {
                    self.warning()
                }
            }
        }
        else if self.gameState == gameStateMachine.selectBadIdeaToRelease
        {
            self.playcardsPool.append(self.players[self.currentPlayer!].loseState(card: self.players[self.currentPlayer!].badIdeaCard!))
            self.childNode(withName: "selectBadIdea")?.zPosition = -1
            self.playcardsPool.append(self.players[self.currentPlayer!].discardCard(card: self.players[self.currentPlayer!].currentCard!) as! PlayCards)
            self.playcardsPool = self.randomPlayCards(array: self.playcardsPool)
            writeLog(player: self.players[self.currentPlayer!], card: self.players[self.currentPlayer!].currentCard!, targetCard: self.players[self.currentPlayer!].badIdeaCard!)

            self.playNextCard()
        }
        else if self.gameState == gameStateMachine.selectSecondCard
        {
            if card.type == "FIRE"
            {
                self.players[self.currentPlayer!].selfCard!.setFront(isFront: false)
                switch self.players[self.currentPlayer!].selfCard!.department
                {
                case .sales:
                    self.sales.cards.append(self.players[self.currentPlayer!].discardCard(card: self.players[self.currentPlayer!].selfCard!) as! EmployeeCards)
                case .HR:
                    self.HR.cards.append(self.players[self.currentPlayer!].discardCard(card: self.players[self.currentPlayer!].selfCard!) as! EmployeeCards)
                case .development:
                    self.development.cards.append(self.players[self.currentPlayer!].discardCard(card: self.players[self.currentPlayer!].selfCard!) as! EmployeeCards)
                case .finance:
                    self.finance.cards.append(self.players[self.currentPlayer!].discardCard(card: self.players[self.currentPlayer!].selfCard!) as! EmployeeCards)
                }
                self.players[self.currentPlayer!].currentCard!.setFront(isFront: false)
                self.players[self.currentPlayer!].secondCard!.setFront(isFront: false)
                self.playcardsPool.append(self.players[self.currentPlayer!].discardCard(card: self.players[self.currentPlayer!].currentCard!) as! PlayCards)
                self.playcardsPool.append(self.players[self.currentPlayer!].discardCard(card: self.players[self.currentPlayer!].secondCard!) as! PlayCards)
                self.playcardsPool = randomPlayCards(array: self.playcardsPool)
                writeLog(player: self.players[self.currentPlayer!], card: self.players[self.currentPlayer!].currentCard!, card2: self.players[self.currentPlayer!].secondCard!, targetCard: self.players[self.currentPlayer!].selfCard!)
                self.playNextCard()
            }
            else       //POACH
            {
                self.players[self.currentPlayer!].getCard(card: self.players[self.selectOP(card: self.players[self.currentPlayer!].OPCard!)].discardCard(card: self.players[self.currentPlayer!].OPCard!))
                self.playcardsPool.append(self.players[self.currentPlayer!].discardCard(card: self.players[self.currentPlayer!].currentCard!) as! PlayCards)
                self.playcardsPool.append(self.players[self.currentPlayer!].discardCard(card: self.players[self.currentPlayer!].secondCard!) as! PlayCards)
                self.playcardsPool = randomPlayCards(array: self.playcardsPool)
                writeLog(player: self.players[self.currentPlayer!], card: self.players[self.currentPlayer!].currentCard!, opponent: self.players[self.selectOP(card: self.players[self.currentPlayer!].OPCard!)], card2: self.players[self.currentPlayer!].secondCard!, targetCard: self.players[self.currentPlayer!].OPCard!)
                self.playNextCard()
            }
        }
    }
    
    func warning()
    {
        self.childNode(withName: "cancel")?.zPosition = -1
        if self.gameState == gameStateMachine.playcards
        {
            self.childNode(withName: "cardDisable")?.zPosition = 1
            self.childNode(withName: "pleasePlayCards")?.zPosition = -1
            self.gameState = gameStateMachine.confirmWarning
            
        }
        else if self.gameState == gameStateMachine.selectEmployeeInHand
        {
            self.childNode(withName: "fireDisable")?.zPosition = 1
            self.childNode(withName: "selectEmployeeInHand")?.zPosition = -1
            self.childNode(withName: "cancel")?.zPosition = -1
            self.gameState = gameStateMachine.confirmWarning
        }
        else if self.gameState == gameStateMachine.selectOP
        {
            self.childNode(withName: "OPDisable")?.zPosition = 1
            self.childNode(withName: "selectOP")?.zPosition = -1
            self.childNode(withName: "cancel")?.zPosition = -1
            self.childNode(withName: "cancel")?.position.x = 520
            self.childNode(withName: "confirm")?.zPosition = 1
            self.gameState = gameStateMachine.confirmWarning
        }
        else if self.gameState == gameStateMachine.selectOPEmployee
        {
            self.childNode(withName: "OPCardDisable")?.zPosition = 1
            self.childNode(withName: "selectOPEmployee")?.zPosition = -1
            self.childNode(withName: "cancel")?.zPosition = -1
            self.gameState = gameStateMachine.confirmWarning
        }
        else if self.gameState == gameStateMachine.confirmWarning
        {
            if self.childNode(withName: "cardDisable")?.zPosition == 1
            {
                self.childNode(withName: "cardDisable")?.zPosition = -1
                self.players[self.currentPlayer!].currentCard?.chosen = false
                self.players[self.currentPlayer!].currentCard = nil
                self.playerCardsPosition(player: self.currentPlayer!, animation: 1)
                self.childNode(withName: "pleasePlayCards")?.zPosition = 1
                self.players[self.currentPlayer!].cardsPlayedThisTurn -= 1
                if self.players[self.currentPlayer!].cardsPlayedThisTurn == 0
                {
                    self.childNode(withName: "cancel")?.zPosition = 1
                }
                else
                {
                    self.childNode(withName: "cancel")?.zPosition = -1
                }
                self.gameState = gameStateMachine.playcards
            }
            else if self.childNode(withName: "OPDisable")?.zPosition == 1
            {
                self.childNode(withName: "OPDisable")?.zPosition = -1
                self.childNode(withName: "selectOP")?.zPosition = 1
                self.childNode(withName: "cancel")?.zPosition = 1
                self.childNode(withName: "cancel")?.position.x = 630
                self.childNode(withName: "confirm")?.zPosition = -1
                self.players[self.currentPlayer!].OP = nil
                self.gameState = gameStateMachine.selectOP
            }
            else if self.childNode(withName: "OPCardDisable")?.zPosition == 1
            {
                self.childNode(withName: "OPCardDisable")?.zPosition = -1
                self.childNode(withName: "selectOPEmployee")?.zPosition = 1
                self.childNode(withName: "cancel")?.zPosition = 1
                self.players[self.currentPlayer!].OPCard!.chosen = false
                self.players[self.currentPlayer!].OPCard = nil
                for each in 0...self.numberOfPlayers - 1
                {
                    self.playerCardsPosition(player: each, animation: 1)
                }
                self.gameState = gameStateMachine.selectOPEmployee
            }
            else if let _ = self.childNode(withName: "fireDisable")
            {
                self.childNode(withName: "fireDisable")?.zPosition = -1
                self.childNode(withName: "selectEmployeeInHand")?.zPosition = 1
                self.childNode(withName: "cancel")?.zPosition = 1
                self.players[self.currentPlayer!].selfCard!.chosen = false
                self.players[self.currentPlayer!].selfCard = nil
                self.playerCardsPosition(player: self.currentPlayer!, animation: 1)
                self.gameState = gameStateMachine.selectEmployeeInHand
            }
        }

    }
    func handcardsSortRule(arg1 : PlayCards, arg2: PlayCards) -> Bool
    {
        func score(arg: PlayCards) -> Int
        {
            switch arg.type!
            {
            case "RELEASE":
                return 70
            case "BAD IDEA":
                return 60
            case "BAD HIRE":
                return 50
            case "FIRE":
                return 40
            case "POACH":
                return 30
            case "HIRE":
                return 20
            case "FUNDING":
                return 10
            default:
                if arg.type! == "OUT TO PASTURE" ||  arg.type! == "CONFLICT OF OPINION"
                {
                    return 80
                }
                else
                {
                    return 90
                }
            }
        }
        let s1 = score(arg: arg1) - arg1.needSkill!.count
        let s2 = score(arg: arg2) - arg2.needSkill!.count
        if s1 > s2
        {
            return true
        }
        else
        {
            return false
        }
    }
    func printHandCards()
    {
        if self.currentPlayer! == 0
        {
            print("-------------player",self.currentPlayer!)
            for each in self.players[self.currentPlayer!].cardsInHand
            {
                print(each.name!)
            }
        }
    }
    func gameProcess(touchNode: [SKNode])
    {
        
        
        let node : SKNode? = touchNode.first

        if self.players.count == 0
        {
            positionData.gameSceneScaleData()
            self.size = CGSize(width: positionData.sceneWidth, height: positionData.sceneHeight)
            (self.development.cards, self.sales.cards, self.finance.cards ,self.HR.cards ,self.playcardsPool) = initCards()
            self.playcardsPool = randomPlayCards(array: self.playcardsPool)
            self.development.cards  = randomEmployeeCards(array: self.development.cards)
            self.sales.cards = randomEmployeeCards(array: self.sales.cards)
            self.finance.cards = randomEmployeeCards(array: self.finance.cards)
            self.HR.cards = randomEmployeeCards(array: self.HR.cards)
            let cards = [self.playcardsPool, self.sales.cards, self.finance.cards, self.HR.cards, self.development.cards] as [Any]
            for each in cards
            {
                for card in each as! [CardSprite]
                {
                    addChild(card)
                }
            }
            for i in 0...self.numberOfPlayers - 1
            {
                let newPlayer = Player()
                newPlayer.name = "player\(i)"
                if gameMode == .single
                {
                    if i != 1
                    {
                        newPlayer.isAI = true
                    }
                }
                
                self.players.append(newPlayer)
            }
            self.createBackground()
            self.createLabels()
            self.createButtons()
            self.CardsPosition()
            self.childNode(withName: "chooseStartPlayer")?.zPosition = 1
            self.childNode(withName: "startFromPlayer0")?.zPosition = 1
            self.childNode(withName: "startFromPlayer1")?.zPosition = 1
            self.childNode(withName: "startFromPlayer2")?.zPosition = 1
            achievement()
            
            
        }

        else if self.gameState == .gameOver
        {
            if node == nil
            {
                achievement()
                (self.childNode(withName: "win") as! SKLabelNode).text = "Player \(self.currentPlayer! + 1) Win!"
                self.childNode(withName: "win")?.zPosition = 1
                self.childNode(withName: "restart")?.zPosition = 1
                self.childNode(withName: "currentPlayerLabel")?.zPosition = -1
            }
            else if node == self.childNode(withName: "restart")
            {
                self.restart()
            }
            
        }
        else if self.gameState == .chooseStartPlayer    //Choose which player to start
        {
            self.gameState = .pickCards

        }
        else if self.gameState == .pickCards  //Every player pick employee by turn
        {
            let departments = [self.sales, self.finance, self.HR, self.development]
            for department in departments
            {
                if node == department.cards.last
                {
                    self.players[self.currentPlayer!].getCard(card: department.cards.removeLast())
                }
            }
            self.updateFront()
            self.playerCardsPosition(player: self.currentPlayer!, animation: 2)
            if self.sales.cards.count + self.finance.cards.count + self.HR.cards.count + self.development.cards.count == 40 - self.numberOfPlayers * 4
            {
                self.childNode(withName: "pickCard")?.zPosition = -1
                for _ in 0...(self.numberOfPlayers * 6 - 1)
                {
                    self.currentPlayer! += 1
                    if self.currentPlayer == self.numberOfPlayers
                    {
                        self.currentPlayer = 0
                    }
                    self.players[self.currentPlayer!].getCard(card: self.playcardsPool.removeLast())
                    if !self.players[self.currentPlayer!].isAI
                    {
                        self.players[self.currentPlayer!].cardsInHand.last?.setFront(isFront: true)
                    }
                }
                for num in 0...self.numberOfPlayers - 1
                {
                    self.players[num].cardsInHand.sort(by: handcardsSortRule)
                    
                    self.playerCardsPosition(player: num, animation: 1)

                    
                }
                self.gameState = .nothing
                self.changeTurn()
            }
            else
            {
                self.changeTurn()
            }

        }
        else if self.gameState == .nothing
        {
            self.gameState = gameStateMachine.playOrDiscard
            if !self.players[self.currentPlayer!].isAI
            {
                self.childNode(withName: "playcards")?.zPosition = 1
                self.childNode(withName: "discardCards")?.zPosition = 1
            }
            else
            {
                self.childNode(withName: "cancel")?.zPosition = -1
                self.childNode(withName: "confirm")?.zPosition = -1
            }
        }
        else if self.gameState == .playOrDiscard    //Decide to play cards or to discard cards
        {
            if node == self.childNode(withName: "playcards")
            {
                self.gameState = .playcards
                if !self.players[self.currentPlayer!].isAI
                {
                    self.childNode(withName: "pleasePlayCards")?.zPosition = 1
                }
            }
            else if node == self.childNode(withName: "discardCards")
            {
                self.gameState = .discardCards
                if !self.players[self.currentPlayer!].isAI
                {
                    self.childNode(withName: "pleaseDiscardCards")?.zPosition = 1
                }
            }
            
        }
        else if self.gameState == .playcards   //Play cards
        {
            if node == nil
            {
                self.turnEnd()
            }
            else if node == self.childNode(withName: "cancel")
            {
                self.gameState = .playOrDiscard
            }
            else
            {
                self.players[self.currentPlayer!].cardsPlayedThisTurn += 1
                self.cardAction(card: self.players[self.currentPlayer!].currentCard!)
            }
        }
        else if self.gameState == .discardCards  //Discard cards
        {
            if node == self.childNode(withName: "cancel")
            {
                self.gameState = .playOrDiscard

            }
            else
            {
                for card in touchNode
                {
                    (card as! PlayCards).setFront(isFront: false)
                    self.playcardsPool.append(self.players[self.currentPlayer!].discardCard(card: card) as! PlayCards)
                }
                self.playcardsPool = randomPlayCards(array: self.playcardsPool)
//                self.CardsPosition()
//                self.playerCardsPosition(player: self.currentPlayer!)
                self.turnEnd()
            }
            
        }
        else if self.gameState == .selectEmployeeInHand   //select an employee card in hand
        {
            if node == self.childNode(withName: "cancel")
            {
                self.gameState = gameStateMachine.playcards

            }
            else
            {
                self.cardAction(card: self.players[self.currentPlayer!].currentCard!)
            }
        }
        else if self.gameState == gameStateMachine.selectOP         //select OP
        {
            if node == self.childNode(withName: "cancel")
            {
                self.gameState = gameStateMachine.playcards
            }
            else
            {
                self.cardAction(card: self.players[self.currentPlayer!].currentCard!)
            }
        }
        else if self.gameState == gameStateMachine.selectEmployeeOnDesk      //select employee on desk
        {
            if node == self.childNode(withName: "cancel")
            {
                if self.players[self.currentPlayer!].currentCard!.type! == "HIRE"
                {
                    self.gameState = gameStateMachine.playcards
                }
                else            //BAD HIRE
                {
                    self.gameState = gameStateMachine.selectOP
                }
                self.players[self.currentPlayer!].currentCard = nil

            }
            else
            {
                self.cardAction(card: self.players[self.currentPlayer!].currentCard!)
            }
        }
        else if self.gameState == gameStateMachine.selectOPEmployee     //select OP card
        {
            if node == self.childNode(withName: "cancel")
            {
                self.gameState = gameStateMachine.playcards
            }
            else if node == self.childNode(withName: "confirm")
            {
                self.cardAction(card: self.players[self.currentPlayer!].currentCard!)
            }
            else
            {
                self.cardAction(card: self.players[self.currentPlayer!].currentCard!)
            }
        }
        else if self.gameState == gameStateMachine.selectBadIdeaToRelease          //select a Bad Idea on self
        {
            if node == self.childNode(withName: "cancel")
            {
                self.gameState = gameStateMachine.playcards
            }
            else
            {
                self.cardAction(card: self.players[self.currentPlayer!].currentCard!)
            }
        }
        else if self.gameState == gameStateMachine.selectSecondCard         //select second card
        {
            if node == self.childNode(withName: "cancel")
            {
                if self.players[self.currentPlayer!].currentCard!.type! == "FIRE"
                {
                    self.gameState = .selectEmployeeInHand
                }
                else                        //poach
                {
                    self.gameState = .selectOPEmployee
                }
            }
            else
            {
                self.players[self.currentPlayer!].cardsPlayedThisTurn += 1
                self.cardAction(card: self.players[self.currentPlayer!].currentCard!)
            }
        }
    }
    func userInterface(node: SKNode)
    {
        if node == self.childNode(withName: "gameSceneButton")
        {
            self.lastGameState = self.gameState
            self.gameState = .menu
            self.childNode(withName: "blackBackground")?.zPosition = 198
            self.childNode(withName: "resume")?.zPosition = 199
            self.childNode(withName: "restartMenu")?.zPosition = 199
            self.childNode(withName: "option")?.zPosition = 199
            self.childNode(withName: "mainMenu")?.zPosition = 199
        }
        else if self.gameState == .menu
        {
            if node == self.childNode(withName: "resume")
            {
                self.gameState = self.lastGameState
                self.childNode(withName: "blackBackground")?.zPosition = -1
                self.childNode(withName: "resume")?.zPosition = -1
                self.childNode(withName: "restartMenu")?.zPosition = -1
                self.childNode(withName: "option")?.zPosition = -1
                self.childNode(withName: "mainMenu")?.zPosition = -1
            }
            else if node == self.childNode(withName: "restartMenu")
            {
                self.restart()
            }
            else if node == self.childNode(withName: "mainMenu")
            {
                goToScene(newScene: SceneType.WelcomeScene)
            }
        }
        if gameState == .chooseStartPlayer    //Choose which player to start
        {
            for player in 0...self.numberOfPlayers - 1
            {
                if node == self.childNode(withName: "startFromPlayer\(player)")
                {
                    self.currentPlayer = player
                    self.childNode(withName: "chooseStartPlayer")?.zPosition = -1
                    self.childNode(withName: "startFromPlayer0")?.zPosition = -1
                    self.childNode(withName: "startFromPlayer1")?.zPosition = -1
                    self.childNode(withName: "startFromPlayer2")?.zPosition = -1
                    (self.childNode(withName: "currentPlayerLabel") as! SKLabelNode).text = "Player\(self.currentPlayer! + 1)'s Turn :"
                    self.childNode(withName: "currentPlayerLabel")?.zPosition = 1
                    self.childNode(withName: "pickCard")?.zPosition = 1
                    self.gameProcess(touchNode: [])
                    break
                }
            }
        }
        else if gameState == .gameOver
        {
            if node == self.childNode(withName: "restart")
            {
                self.gameProcess(touchNode: [node])
            }
        }
        else if gameState == .hotseatWall
        {
            if node == self.childNode(withName: "blackBackground")
            {
                gameState = .nothing
                self.hotseat()
            }
        }
        else if gameState == .pickCards
        {
            if node is EmployeeCards
            {
                let departments = [self.sales, self.finance, self.HR, self.development]
                for department in departments
                {
                    if department.cards.last != nil && department.cards.last! == node && !self.if2VP(node: node as! EmployeeCards, player: self.currentPlayer!)
                    {
                        self.gameProcess(touchNode: [node])
                        break
                    }
                }

            }
        }
        else if gameState == .playOrDiscard
        {
            if node == self.childNode(withName: "playcards") || node == self.childNode(withName: "discardCards")
            {
                self.childNode(withName: "confirm")?.zPosition = 1
                self.childNode(withName: "cancel")?.zPosition = 1
                self.childNode(withName: "playcards")?.zPosition = -1
                self.childNode(withName: "discardCards")?.zPosition = -1
                gameProcess(touchNode: [node])
            }
        }
        else if gameState == .playcards
        {
            if node == self.childNode(withName: "confirm") && self.players[self.currentPlayer!].currentCard == nil
            {
                self.childNode(withName: "confirm")?.zPosition = -1
                self.childNode(withName: "cancel")?.zPosition = -1
                self.childNode(withName: "pleasePlayCards")?.zPosition = -1
                self.gameProcess(touchNode: [])
            }
            else if node == self.childNode(withName: "confirm") && self.players[self.currentPlayer!].currentCard != nil
            {
                self.childNode(withName: "pleasePlayCards")?.zPosition = -1
                self.gameProcess(touchNode: [node])
            }
            else if node == self.childNode(withName: "cancel") && self.players[self.currentPlayer!].cardsPlayedThisTurn == 0
            {
                if self.players[self.currentPlayer!].currentCard != nil
                {
                    self.players[self.currentPlayer!].currentCard!.chosen = false
                    self.players[self.currentPlayer!].currentCard = nil
                    self.playerCardsPosition(player: self.currentPlayer!, animation: 1)
                }
                self.childNode(withName: "pleasePlayCards")?.zPosition = -1
                self.childNode(withName: "confirm")?.zPosition = -1
                self.childNode(withName: "cancel")?.zPosition = -1
                self.childNode(withName: "playcards")?.zPosition = 1
                self.childNode(withName: "discardCards")?.zPosition = 1
                self.gameProcess(touchNode: [node])
            }
            else
            {
                for cardInHand in self.players[self.currentPlayer!].cardsInHand
                {
                    if node == cardInHand
                    {
                        if cardInHand.chosen
                        {
                            self.players[self.currentPlayer!].currentCard = nil
                            cardInHand.chosen = false
                        }
                        else
                        {
                            self.players[self.currentPlayer!].currentCard = cardInHand
                            self.players[self.currentPlayer!].currentCard!.chosen = true
                            for each in self.players[self.currentPlayer!].cardsInHand
                            {
                                if each != self.players[self.currentPlayer!].currentCard
                                {
                                    each.chosen = false
                                }
                            }

                        }
                        self.playerCardsPosition(player: self.currentPlayer!, animation: 0)
                    }
                }
            }

        }
        else if self.gameState == .discardCards
        {
            if node == self.childNode(withName: "confirm")
            {
                self.players[self.currentPlayer!].cardsChosen = 0
                self.childNode(withName: "confirm")?.zPosition = -1
                self.childNode(withName: "cancel")?.zPosition = -1
                self.childNode(withName: "pleaseDiscardCards")?.zPosition = -1
                var discard = [PlayCards]()
                for card in self.players[self.currentPlayer!].cardsInHand
                {
                    if card.chosen
                    {
                        card.chosen = false
                        discard.append(card)
                    }
                }
                self.gameProcess(touchNode: discard)
            }
            else if node == self.childNode(withName: "cancel")
            {
                for card in self.players[self.currentPlayer!].cardsInHand
                {
                    card.chosen = false
                }
                self.players[self.currentPlayer!].cardsChosen = 0
                self.playerCardsPosition(player: self.currentPlayer!, animation: 1)
                self.childNode(withName: "pleaseDiscardCards")?.zPosition = -1
                self.childNode(withName: "confirm")?.zPosition = -1
                self.childNode(withName: "cancel")?.zPosition = -1
                self.childNode(withName: "playcards")?.zPosition = 1
                self.childNode(withName: "discardCards")?.zPosition = 1
                self.gameProcess(touchNode: [node])
            }
            else
            {
                for cardInHand in self.players[self.currentPlayer!].cardsInHand
                {
                    if node == cardInHand && !(node as! PlayCards).chosen && self.players[self.currentPlayer!].cardsChosen < 4
                    {
                        (node as! PlayCards).chosen = true
                        self.players[self.currentPlayer!].cardsChosen += 1
                        self.playerCardsPosition(player: self.currentPlayer!, animation: 0)
                    }
                    else if node == cardInHand && (node as! PlayCards).chosen
                    {
                        (node as! PlayCards).chosen = false
                        self.players[self.currentPlayer!].cardsChosen -= 1
                        self.playerCardsPosition(player: self.currentPlayer!, animation: 0)
                    }
                }
            }
        }
        else if self.gameState == .selectEmployeeInHand   //select an employee card in hand
        {
            if node == self.childNode(withName: "cancel")
            {
                if let card = self.players[self.currentPlayer!].selfCard
                {
                    card.chosen = false
                    self.players[self.currentPlayer!].selfCard = nil
                    self.players[self.currentPlayer!].currentCard!.chosen = false
                    self.players[self.currentPlayer!].currentCard = nil
                    self.playerCardsPosition(player: self.currentPlayer!, animation: 1)
                }
                self.players[self.currentPlayer!].cardsPlayedThisTurn -= 1
                self.players[self.currentPlayer!].currentCard!.chosen = false
                self.players[self.currentPlayer!].currentCard = nil
                self.childNode(withName: "selectEmployeeInHand")?.zPosition = -1
                self.childNode(withName: "pleasePlayCards")?.zPosition = 1
                self.gameProcess(touchNode: [node])

            }
            else if node == childNode(withName: "confirm") && self.players[self.currentPlayer!].selfCard != nil
            {
                self.childNode(withName: "selectEmployeeInHand")?.zPosition = -1
                self.childNode(withName: "cancel")?.zPosition = -1
                self.gameProcess(touchNode: [node])
            }
            else
            {
//                let player = self.players[self.currentPlayer!]
//                let departments = [player.HR.cards, player.sales.cards, player.finance.cards, player.development.cards]
//                for department in departments
//                {
//                    for card in department
//                    {
//                        if card == node
//                        {
//                            card.chosen = true
//                            self.players[self.currentPlayer!].selfCard = card
//                        }
//                        else if card != node && card.chosen
//                        {
//                            card.chosen = false
//                        }
//                    }
//                }
//                self.playerCardsPosition(player: self.currentPlayer!, animation: false)
                let player = self.players[self.currentPlayer!]
                let departments = [player.HR, player.sales, player.finance, player.development]
                for department in departments
                {
                    if node is EmployeeCards && department.cards .contains(node as! EmployeeCards)
                    {
                        self.lastGameState = self.gameState
                        self.gameState = .selectEmployee
                        self.selectEmployee(player: player, department: department.department)
                    }
                }
            }
        }
        else if self.gameState == .selectOP         //select OP
        {
            if node == self.childNode(withName: "cancel")
            {
                self.players[self.currentPlayer!].cardsPlayedThisTurn -= 1
                self.players[self.currentPlayer!].currentCard!.chosen = false
                self.players[self.currentPlayer!].currentCard = nil
                self.playerCardsPosition(player: self.currentPlayer!, animation: 1)
                self.childNode(withName: "cancel")?.position.x = 520
                self.childNode(withName: "confirm")?.zPosition = 1
                self.childNode(withName: "selectOP")?.zPosition = -1
                self.childNode(withName: "pleasePlayCards")?.zPosition = 1
                self.gameState = .playcards
            }
            else
            {
                var op = self.currentPlayer! + 1
                if op == self.players.count
                {
                    op = 0
                }
                while op != self.currentPlayer
                {
                    if node == childNode(withName: "player\(op)") && !self.players[op].gameover
                    {
                        self.players[self.currentPlayer!].OP = op
                        self.gameProcess(touchNode: [])
                        break
                    }
                    op += 1
                    if op == self.players.count
                    {
                        op = 0
                    }
                }
            }
        }
        else if self.gameState == .selectEmployeeOnDesk      //select employee on desk
        {
            if node == self.childNode(withName: "cancel")
            {
                if self.players[self.currentPlayer!].currentCard!.type! == "HIRE"
                {
                    self.players[self.currentPlayer!].cardsPlayedThisTurn -= 1
                    self.players[self.currentPlayer!].currentCard!.chosen = false
                    self.playerCardsPosition(player: self.currentPlayer!,animation: 1)
                    self.childNode(withName: "cancel")?.position.x = 520
                    self.childNode(withName: "confirm")?.zPosition = 1
                    self.childNode(withName: "selectEmployeeOnDesk")?.zPosition = -1
                    self.childNode(withName: "pleasePlayCards")?.zPosition = 1                    
                }
                else            //BAD HIRE
                {
                    self.childNode(withName: "selectEmployeeOnDesk")?.zPosition = -1
                    self.childNode(withName: "selectOP")?.zPosition = 1
                }
                self.gameProcess(touchNode: [node])
                
            }
            else
            {
                let departments = [self.HR.cards, self.sales.cards, self.development.cards, self.finance.cards]
                for department in departments
                {
                    if department.last == node && ((self.players[self.currentPlayer!].currentCard!.type! == "HIRE" && !self.if2VP(node: node as! EmployeeCards, player: self.currentPlayer!)) || self.players[self.currentPlayer!].currentCard!.type! == "BAD HIRE" && !self.if2VP(node: node as! EmployeeCards, player: self.players[self.currentPlayer!].OP!))
                    {
                        self.players[self.currentPlayer!].publicCards = department.last
                        self.childNode(withName: "selectEmployeeOnDesk")?.zPosition = -1
                        self.childNode(withName: "cancel")?.position.x = 520
                        self.childNode(withName: "confirm")?.zPosition = 1
                        self.gameProcess(touchNode: [node])
                        break
                    }
                }
            }
        }
        else if self.gameState == .selectOPEmployee     //select OP card
        {
            if node == self.childNode(withName: "cancel")
            {
                if let card = self.players[self.currentPlayer!].OPCard
                {
                    card.chosen = false
                    self.players[self.currentPlayer!].OPCard = nil
                    self.players[self.currentPlayer!].currentCard!.chosen = false
                }
                self.players[self.currentPlayer!].cardsPlayedThisTurn -= 1
                self.players[self.currentPlayer!].currentCard!.chosen = false
                self.players[self.currentPlayer!].currentCard = nil
                self.playerCardsPosition(player: self.currentPlayer!, animation: 1)
                self.childNode(withName: "selectOPEmployee")?.zPosition = -1
                self.childNode(withName: "pleasePlayCards")?.zPosition = 1
                self.gameProcess(touchNode: [node])
            }
            else if node == self.childNode(withName: "confirm") && self.players[self.currentPlayer!].OPCard != nil
            {
                self.childNode(withName: "selectOPEmployee")?.zPosition = -1
                self.gameProcess(touchNode: [node])
            }
            else
            {
                var op = self.currentPlayer! + 1
                if op == self.players.count
                {
                    op = 0
                }
                while op != self.currentPlayer
                {
                    let departments = [self.players[op].sales.cards, self.players[op].development.cards, self.players[op].HR.cards, self.players[op].finance.cards]
                    for department in departments
                    {
                        for card in department
                        {
                            if self.players[self.currentPlayer!].currentCard?.type == "POACH"
                            {
                                if card == node && (card.status != .VP || card.status == .VP && !self.if2VP(node: card, player: self.currentPlayer!))
                                {
                                    card.chosen = true
                                    self.players[self.currentPlayer!].OPCard = card
                                }
                                else if card != node && card.chosen
                                {
                                    card.chosen = false
                                }
                            }
                            else
                            {
                                if card == node && card.status == .VP
                                {
                                    card.chosen = true
                                    self.players[self.currentPlayer!].OPCard = card
                                }
                                else if card != node && card.chosen
                                {
                                    card.chosen = false

                                }
                            }
                        }
                    }
                    op += 1
                    if op == self.players.count
                    {
                        op = 0
                    }
                }
                for each in 0...self.numberOfPlayers - 1
                {
                    self.playerCardsPosition(player: each, animation: 0)
                }
            }
        }
        else if self.gameState == .confirmWarning         //confirm warning
        {
            if node == self.childNode(withName: "confirm")
            {
                self.warning()
            }
        }
        else if self.gameState == .selectBadIdeaToRelease          //select a Bad Idea on self
        {
            if node == self.childNode(withName: "cancel")
            {
                if let card = self.players[self.currentPlayer!].badIdeaCard
                {
                    card.chosen = false
                    self.players[self.currentPlayer!].badIdeaCard = nil
                    self.players[self.currentPlayer!].currentCard!.chosen = false
                }
                self.players[self.currentPlayer!].cardsPlayedThisTurn -= 1
                self.players[self.currentPlayer!].currentCard!.chosen = false
                self.players[self.currentPlayer!].currentCard = nil
                self.playerCardsPosition(player: self.currentPlayer!, animation: 1)
                self.childNode(withName: "selectBadIdea")?.zPosition = -1
                self.childNode(withName: "pleasePlayCards")?.zPosition = 1
                self.gameProcess(touchNode: [node])
            }
            else if node == self.childNode(withName: "confirm") && self.players[self.currentPlayer!].badIdeaCard != nil
            {
                self.gameProcess(touchNode: [node])
            }
            else
            {
                for card in self.players[self.currentPlayer!].stateCards
                {
                    if node == card && card.type! == "BAD IDEA"
                    {
                        self.players[self.currentPlayer!].badIdeaCard = card
                        self.players[self.currentPlayer!].badIdeaCard!.chosen = true
                    }
                    else if node != card && card.chosen
                    {
                        card.chosen = false
                    }
                }
                self.playerCardsPosition(player: self.currentPlayer!, animation: 0)
            }
        }
        else if self.gameState == .selectSecondCard         //select second card
        {
            if node == self.childNode(withName: "cancel")
            {
                self.childNode(withName: "selectSecondCard")?.zPosition = -1
                if self.players[self.currentPlayer!].currentCard!.type! == "FIRE"
                {
                    self.childNode(withName: "selectEmployeeInHand")?.zPosition = 1
                }
                else                        //poach
                {
                    self.childNode(withName: "selectOPEmployee")?.zPosition = 1
                }
            }
            else if node == self.childNode(withName: "confirm") && self.players[self.currentPlayer!].secondCard != nil
            {
                self.gameProcess(touchNode: [node])
            }
            else if self.players[self.currentPlayer!].currentCard!.type == "FIRE"
            {
                for card in self.players[self.currentPlayer!].cardsInHand
                {
                    if node == card && card != self.players[self.currentPlayer!].currentCard! && card.type == "FIRE" && card.needSkill!.contains(self.players[self.currentPlayer!].HRSkill) && self.players[self.currentPlayer!].currentCard!.type == "FIRE"
                    {
                        card.chosen = true
                        self.players[self.currentPlayer!].secondCard = card
                    }
                    else if node == card && card != self.players[self.currentPlayer!].currentCard! && card.type == "POACH" && card.needSkill!.contains(self.players[self.currentPlayer!].HRSkill) && self.players[self.currentPlayer!].currentCard!.type == "POACH"
                    {
                        card.chosen = true
                        self.players[self.currentPlayer!].secondCard = card
                    }
                    else if node != card && card.chosen && card != self.players[self.currentPlayer!].currentCard!
                    {
                        card.chosen = false
                    }
                }
                self.playerCardsPosition(player: self.currentPlayer!, animation: 2)
            }
        }
    }
    func gameover() -> Bool
    {
        var alive = 0
        for player in self.players
        {
            if !player.gameover
            {
                alive += 1
            }
        }
        if alive == 1
        {
            return true
        }
        else
        {
            return false
        }
    }
    func restart()
    {
        if self.gameState == .gameOver
        {
            self.childNode(withName: "win")?.zPosition = -1
            self.childNode(withName: "restart")?.zPosition = -1
            self.playerOut(player: self.currentPlayer!)
        }
        else if self.gameState == .menu
        {
            self.childNode(withName: "blackBackground")?.zPosition = -1
            let presentLabels = ["player0", "player1", "player2", "player0Money", "player1Money", "player2Money"]
            for each in self.labels
            {
                if !presentLabels.contains(each.name!) && each.zPosition != -1
                {
                    each.zPosition = -1
                }
            }
            for player in 0...self.numberOfPlayers - 1
            {
                self.playerOut(player: player)
            }
        }
        for player in 0...self.numberOfPlayers - 1
        {
            self.players[player].money = 100
            (self.childNode(withName: "player\(player)Money") as! SKLabelNode).text = "\(self.players[player].money)"
            self.players[player].gameover = false
            self.playerCardsPosition(player: player, animation: 0)
        }
        self.CardsPosition()
        self.childNode(withName: "chooseStartPlayer")?.zPosition = 1
        self.childNode(withName: "startFromPlayer0")?.zPosition = 1
        self.childNode(withName: "startFromPlayer1")?.zPosition = 1
        self.childNode(withName: "startFromPlayer2")?.zPosition = 1
        self.currentPlayer = nil
        self.gameState = .chooseStartPlayer
    }
    func changeTurn()
    {

        self.currentPlayer! += 1
        if self.currentPlayer == self.numberOfPlayers
        {
            self.currentPlayer = 0
        }
        if self.players[self.currentPlayer!].gameover
        {
            changeTurn()
        }
        else
        {
            (self.childNode(withName: "currentPlayerLabel") as! SKLabelNode).text = "Player\(self.currentPlayer! + 1)'s Turn :"
            if gameMode == .hotseat
            {
                for player in 0...self.numberOfPlayers - 1
                {
                    if player != self.currentPlayer!
                    {
                        for each in self.players[player].cardsInHand
                        {
                            each.setFront(isFront: false)
                        }
                    }
                    else
                    {
                        for each in self.players[player].cardsInHand
                        {
                            each.setFront(isFront: true)
                        }
                    }
                }
            }
            if self.gameover()
            {
                self.gameState = .gameOver
                self.gameProcess(touchNode: [])
                return
            }
            if self.gameState == .nothing
            {
                self.gameProcess(touchNode: [])
            }
        }
        
    }
    func if2VP(node: EmployeeCards, player: Int) -> Bool
    {
        if node.status != .VP
        {
            return false
        }
        else
        {
            switch node.department
            {
                case .sales:
                    if self.players[player].sales.cards.last?.status == .VP
                    {
                        return true
                    }
                case .finance:
                    if self.players[player].finance.cards.last?.status == .VP
                    {
                        return true
                    }
                case .HR:
                    if self.players[player].HR.cards.last?.status == .VP
                    {
                        return true
                    }
                case .development:
                    if self.players[player].development.cards.last?.status == .VP
                    {
                        return true
                    }
            }
            return false
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        sound.playHit()
        if self.currentPlayer != nil && self.players[self.currentPlayer!].isAI && self.gameState != .gameOver && animationQueue.count != 0
        {
            return
        }
        let touchPoint = touches.first?.location(in: self)
        let touchNode = nodes(at: touchPoint!)
        let card = touchNode.first!
        if self.focusNodeName != nil
        {
            self.childNode(withName: self.focusNodeName!)?.zPosition = self.focusNodeZPosition!
        }
        if card is EmployeeCards && !self.sales.cards.contains(card as! EmployeeCards) && !self.finance.cards.contains(card as! EmployeeCards) && !self.HR.cards.contains(card as! EmployeeCards) && !self.development.cards.contains(card as! EmployeeCards)
        {
            self.focusNodeName = card.name!
            self.focusNodeZPosition = card.zPosition
            card.zPosition = 99
        }
        self.userInterface(node: card)

    }
    
    override func update(_ currentTime: TimeInterval) {
        
        
        if self.players.count == 0
        {
            gameProcess(touchNode: [])
        }
        else if self.gameState == .gameOver
        {
            self.CardsPosition()
        }
        
        if self.currentPlayer != nil && self.players[self.currentPlayer!].isAI && animationQueue.count == 0
        {
            AI()
        }

//         Called before each frame is rendered
//         Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
//        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
//        for entity in self.entities {
//            entity.update(deltaTime: dt)
//        }
        self.lastUpdateTime = currentTime
        
    }
    func achievement()
    {
        if gameState == .gameOver
        {
            if self.currentPlayer == 0
            {
                defaults.set(defaults.integer(forKey: a_win) + 1, forKey: a_win)
                switch defaults.integer(forKey: a_win)
                {
                    case 1:
                        achievementsObtained(achievement: a_win1)
                    case 10:
                        achievementsObtained(achievement: a_win10)
                    case 100:
                        achievementsObtained(achievement: a_win100)
                    case 1000:
                        achievementsObtained(achievement: a_win1000)
                    default:
                        break
                }
                if self.players[self.currentPlayer!].money >= 100
                {
                    achievementsObtained(achievement: a_winWith100)
                }
            }
            else
            {
                defaults.set(defaults.integer(forKey: a_lose) + 1, forKey: a_lose)
                switch defaults.integer(forKey: a_lose)
                {
                    case 1:
                        achievementsObtained(achievement: a_lose1)
                    case 10:
                        achievementsObtained(achievement: a_lose10)
                    case 100:
                        achievementsObtained(achievement: a_lose100)
                    case 1000:
                        achievementsObtained(achievement: a_lose1000)
                    default:
                        break
                }
            }
        }
        else
        {
            return
        }
    }
    func achievementsObtained (achievement: String)
    {
        switch achievement
        {
        case a_win1:
            print("A New Star!")
        default:
            return
        }
    }
}

