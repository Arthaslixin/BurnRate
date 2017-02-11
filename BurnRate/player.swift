//
//  player.swift
//  BurnRate
//
//  Created by Arthas on 10/27/16.
//  Copyright © 2016 Arthas. All rights reserved.
//

import Foundation
import SpriteKit

public class Player {
    var name : String?
    var money = 100
    var badIdea = 0
    var cardsInHand : [PlayCards] = []
    var sales = departmentsOfEmployees(department: .sales)
    var finance = departmentsOfEmployees(department: .finance)
    var HR = departmentsOfEmployees(department: .HR)
    var development = departmentsOfEmployees(department: .development)
    var contractor = 0
    var stateCards : [PlayCards] = []
    var HRSkill = 0
    var financeSKill = 0
    var developmentSkill = 0
    var salesSkill = 0
    var gameover = false
    var cardsChosen = 0
    var cardsPlayedThisTurn = 0
    var currentCard : PlayCards?
    var OPCard : EmployeeCards?
    var OP : Int?
    var selfCard : EmployeeCards?
    var secondCard : PlayCards?
    var publicCards : EmployeeCards?
    var badIdeaCard : PlayCards?
    var VP = 0
    var isAI = false
    var enableCards : [PlayCards] = []
    var fireTarget : [EmployeeCards] = []
    var poachTarget : [EmployeeCards] = []
    var hireTarget : [EmployeeCards] = []
    var badHireTarget : [EmployeeCards] = []
    var badHireTargetOP : [Int] = []
    var badIdeaTargetOP : [Int] = []
    var releaseTarget : [PlayCards] = []
    var outToPastureOrConflictOfOpnionTarget : [EmployeeCards] = []
    var newBusinessPlanOrLayoffsTargetOP : [Int] = []
    var secondFire : [PlayCards] = []
    var secondPoach : [PlayCards] = []
    func bubble(arg: [EmployeeCards]) -> [EmployeeCards]
    {
        var array = arg
        var change = true
        while change
        {
            change = false
            for i in 1...(array.count - 1)
            {
                if array[i].skill! < array[i - 1].skill!
                {
                    change = true
                    let temp = array[i]
                    array[i] = array[i - 1]
                    array[i - 1] = temp
                }
            }
        }
        return array
    }
    func sort(department: departmentsOfEmployees)
    {
        
        var maxSkill = 0
        var tempVP = [EmployeeCards]()
        var tempManager = [EmployeeCards]()
        var tempEngineer = [EmployeeCards]()
        switch department.department{
        case .sales:
            maxSkill = self.salesSkill
        case .finance:
            maxSkill = self.financeSKill
        case .development:
            maxSkill = self.developmentSkill
        case .HR:
            maxSkill = self.HRSkill
        }
        
        for each in department.cards
        {
            switch each.status
            {
                case .VP:
                    tempVP.append(each)
                case .Manager:
                    tempManager.append(each)
                case .Engineer:
                    tempEngineer.append(each)
            }

        }

        if tempVP.count > 1
        {
            tempVP = bubble(arg: tempVP)
        }
        
        if tempManager.count > 1
        {
            tempManager = bubble(arg: tempManager)
        }
        
        if tempEngineer.count > 1
        {
            tempEngineer = bubble(arg: tempEngineer)
        }
        if !tempVP.isEmpty
        {
            maxSkill = tempVP.last!.skill!
        }
        else if !tempManager.isEmpty
        {
            maxSkill = tempManager.last!.skill!
        }
        switch department.department
        {
            case .sales:
                self.salesSkill = maxSkill
                self.sales.cards = tempManager + tempVP
            case .finance:
                self.financeSKill = maxSkill
                self.finance.cards = tempManager + tempVP
            case .development:
                self.developmentSkill = maxSkill
                self.development.cards = tempEngineer + tempManager + tempVP
            case .HR:
                self.HRSkill = maxSkill
                self.HR.cards = tempManager + tempVP
        }
    }
    public func burnThisTurn() -> [PlayCards]
    {
        var discard : [PlayCards] = []
        var burn = 0
        let departments = [self.sales.cards, self.development.cards, self.HR.cards, self.finance.cards]
        for department in departments
        {
            for each in department
            {
                burn += each.salary!
            }
        }
        burn += self.contractor * 3
        for each in self.stateCards
        {
            if each.type == "LAYOFFS" || each.type == "NEW BUSINESS PLAN"
            {
                burn *= 2
                discard.append(self.loseState(card: each))
            }
        }
        self.money -= burn
        writeLog(player: self, burn: burn)
        return discard
    }
    public func getCard(card: Any)
    {
        writeLog(player: self, card: (card as! CardSprite), getCard: true)

        if card is PlayCards
        {
            self.cardsInHand.append(card as! PlayCards)
        }
        else
        {
            if (card as! EmployeeCards).status == .VP
            {
                self.VP += 1
            }
            switch (card as! EmployeeCards).department {
                case .sales:
                    self.sales.cards.append(card as! EmployeeCards)
                    if self.isAI
                    {
                        self.sales.cards.last?.setFront(isFront: true)
                    }
                    self.sort(department: self.sales)
                case .finance:
                    self.finance.cards.append(card as! EmployeeCards)
                    if self.isAI
                    {
                        self.finance.cards.last?.setFront(isFront: true)
                    }
                    self.sort(department: self.finance)
                case .development:
                    self.development.cards.append(card as! EmployeeCards)
                    if self.isAI
                    {
                        self.development.cards.last?.setFront(isFront: true)
                    }
                    self.sort(department: self.development)
                case .HR:
                    self.HR.cards.append(card as! EmployeeCards)
                    if self.isAI
                    {
                        self.HR.cards.last?.setFront(isFront: true)
                    }
                    self.sort(department: self.HR)
            }
        }
    }
    public func discardCard(card: Any) -> Any
    {
        writeLog(player: self, card: (card as! CardSprite), discard: true)
        if card is EmployeeCards
        {
            let temp = card as! EmployeeCards
            if temp.status == .VP
            {
                self.VP -= 1
            }
            switch (temp).department {
            case .sales:
                for i in 0...(self.sales.cards.count - 1)
                {
                    if self.sales.cards[i] == temp
                    {
                        self.sales.cards[i].setFront(isFront: false)
                        self.sales.cards.remove(at: i)
                        break
                    }
                }
                if self.sales.cards.count > 0
                {
                    self.sort(department: self.sales)
                }
                else
                {
                    self.salesSkill = 0
                }
            case .finance:
                for i in 0...(self.finance.cards.count - 1)
                {
                    if self.finance.cards[i] == temp
                    {
                        self.finance.cards[i].setFront(isFront: false)
                        self.finance.cards.remove(at: i)
                        break
                    }
                }
                if self.finance.cards.count > 0
                {
                    self.sort(department: self.finance)
                }
                else
                {
                    self.financeSKill = 0
                }
            case .development:
                for i in 0...(self.development.cards.count - 1)
                {
                    if self.development.cards[i] == temp
                    {
                        self.development.cards[i].setFront(isFront: false)
                        self.development.cards.remove(at: i)
                        break
                    }
                }
                if self.development.cards.count > 0
                {
                    self.sort(department: self.development)
                    break
                }
                else
                {
                    self.developmentSkill = 0
                }
            case .HR:
                for i in (0...self.HR.cards.count - 1)
                {
                    if self.HR.cards[i] == temp
                    {
                        self.HR.cards[i].setFront(isFront: false)
                        self.HR.cards.remove(at: i)
                        break
                    }
                }
                if self.HR.cards.count > 0
                {
                    self.sort(department: self.HR)
                }
                else
                {
                    self.HRSkill = 0
                }
            }
        }
        else
        {
            for i in 0...(self.cardsInHand.count - 1)
            {
                if self.cardsInHand[i] == card as! PlayCards
                {
                    self.cardsInHand[i].setFront(isFront: false)
                    self.cardsInHand.remove(at: i)
                    break
                }
            }
        }
        return card
    }
    
    public func getState(card: PlayCards)
    {
        writeLog(player: self, card: card, getState: true)
        if card.type == "BAD IDEA"
        {
            self.badIdea += card.value!
        }
        card.setFront(isFront: true)
        self.stateCards.append(card)
//        let position = self.playerCardMovePosition(card: card)
//        card.moveCard(moveToPoint: position)
    }
    public func loseState(card: PlayCards) -> PlayCards
    {
        writeLog(player: self, card: card, loseState: true)
        for i in 0...self.stateCards.count - 1
        {
            if self.stateCards[i] == card
            {
                if card.type == "BAD IDEA"
                {
                    self.badIdea -= card.value!
                }
                self.stateCards[i].setFront(isFront: false)
                self.stateCards.remove(at: i)
                break
            }
        }
        return card 
    }
    public func engineerNum() -> Int
    {
        var num = 0
        for card in self.development.cards
        {
            if card.status == .Engineer
            {
                num += 1
            }
        }
        return num
    }
}
