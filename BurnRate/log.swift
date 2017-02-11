//
//  log.swift
//  BurnRate
//
//  Created by Arthas on 12/6/16.
//  Copyright © 2016 Arthas. All rights reserved.
//

import Foundation

var gameProcessLog = [String]()
func writeLog(player: Player, card: CardSprite? = nil, opponent: Player? = nil, card2: CardSprite? = nil,
         targetCard : CardSprite? = nil,getCard : Bool = false, discard: Bool = false,
         turnEnd: Bool = false,getState : Bool = false, loseState : Bool = false, burn : Int = 0){
    var log = ""
    func cardInfo(card: CardSprite) -> String
    {
        var info = ""
        if card.isMember(of: EmployeeCards.self)
        {
            let card = card as! EmployeeCards
            info = card.employeeName! + "(\(card.department) \(card.status) Skill:\(card.skill!) Burn:\(card.salary!))"
        }
        else
        {
            let card = card as! PlayCards
            info = card.type! + "\(card.needSkill!)"
            if card.type! == "BAD IDEA"
            {
                info += " x\(card.value!)"
            }
            else if card.type! == "FUNDING"
            {
                info += " +\(card.value!)"
            }
        }
        return info
    }
    if turnEnd
    {
        log = player.name! + "'s turn ends."
    }
    else if getCard
    {
        log = player.name! + " gets " + cardInfo(card: card!)
    }
    else if discard
    {
        log = player.name! + " discards " + cardInfo(card: card!)
    }
    else if getState
    {
        log = player.name! + " gets a state of " + cardInfo(card: card!)
    }
    else if loseState
    {
        log = player.name! + " loses a state of " + cardInfo(card: card!)
    }
    else if burn != 0
    {
        log = player.name! + "burn: \(burn) rest money: \(player.money)"
    }
    else
    {
        log = player.name! + " uses " + cardInfo(card: card!)
        if card2 != nil
        {
            log += " and " + cardInfo(card: card2!)
        }
        switch (card! as! PlayCards).type! {
            case "FIRE":
                log += " to fire \(cardInfo(card: targetCard!))"
            case "HIRE":
                log += " to hire \(cardInfo(card: targetCard!))"
            case "POACH":
                log += " to poach \(cardInfo(card: targetCard!)) from \(opponent!.name!)"
            case "FUNDING":
                log += ",money: \(player.money)"
            case "BAD IDEA":
                log += " to set a Bad Idea to \(opponent!.name!)"
            case "BAD HIRE":
                log += " to hire \(cardInfo(card: targetCard!)) to \(opponent!.name!)"
            case "RELEASE":
                log += " to release \(cardInfo(card: targetCard!))"
            case "LAYOFFS":
                log += " to make \(opponent!.name!) lay employees off"
            case "OUT TO PASTURE":
                log += " to make \(opponent!.name!)'s employees out to pasture"
            case "CONFLICT OF OPINION":
                log += " to make \(opponent!.name!)'s employees conflict of opinion"
            case "NEW BUSINESS PLAN":
                log += " to make \(opponent!.name!) have a new business plan"
        default:
            break
        }
    }
    gameProcessLog.append(log)
    NSLog(log)
}
