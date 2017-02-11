//
//  CardSprite.swift
//  BurnRate
//
//  Created by Arthas on 10/23/16.
//  Copyright © 2016 Arthas. All rights reserved.
//

import Foundation
import SpriteKit
enum departmentsEnum {
    case sales
    case finance
    case HR
    case development
}
enum statusEnum {
    case VP
    case Manager
    case Engineer
}

var employeeCardTexture : Dictionary<String, SKTexture> = ["EmployeeCardBack": SKTexture(imageNamed: "EmployeeCardBack")]
var playCardTexture : Dictionary<String, SKTexture> = ["PlayCardBack": SKTexture(imageNamed: "PlayCardBack")]
public class CardSprite: SKSpriteNode {
    let TimeInterval = 0.25
    var chosen = false
    var isFront = false
    public func moveCard(moveToPoint: CGPoint) {
        let num = animationNum
        animationQueue.append(num)
        animationNum += 1
//        print(self.name!,moveToPoint)
        let move = SKAction.move(to: moveToPoint, duration: TimeInterval)
//        let rotate = SKAction.rotate(byAngle: 6, duration: TimeInterval*10)
        self.run(move){ () in
            animationQueue.remove(at: animationQueue.index(of: num)!)
        }
//        self.run(rotate)
//        print("*** Moving \(self)")
    }
}

public class EmployeeCards : CardSprite {
    var department = departmentsEnum.sales
    var status = statusEnum.VP
    var skill : Int?
    var salary : Int?
    var employeeCardFront = ""
    var employeeName : String?
    

    public func setFront(isFront: Bool)
    {
        self.isFront = isFront
        if isFront
        {
            self.texture = employeeCardTexture[self.employeeCardFront]
//            print(self.name!,employeeCardFront)
        }
        else
        {
            self.texture = employeeCardTexture["EmployeeCardBack"]
        }
    }
    
}
public class PlayCards : CardSprite {
    var type : String?
    var isOffensive : Bool?
    var needSkill : [Int]?
    var value : Int?
    var action : SKAction?
    var playCardFront = ""

    public static func newInstance() -> PlayCards{
        let Card = PlayCards()
        return Card
    }
//    func setAction()
//    {
//        let fire : SKAction?
//        let hire : SKAction?
//        let poach : SKAction?
//        let funding : SKAction?
//        
//        switch self.type!
//        {
//            case "FIRE":
//                self.action = fire
//        }
//    }
    public func setFront(isFront: Bool)
    {
        self.isFront = isFront
        if isFront
        {
            self.texture = playCardTexture[self.playCardFront]
        }
        else
        {
            self.texture = playCardTexture["PlayCardBack"]
        }
    }
}
class PlayCardInfo
{
    var type: String?
    var needSkill: [Int]?
    var count: Int?
    var value: Int?
    var isOffensive: Bool?
    init(type: String, isOffensive: Bool, needSkill : [Int], count : Int, value : Int)
    {
        self.type = type
        self.isOffensive = isOffensive
        self.needSkill = needSkill
        self.count = count
        self.value = value
    }
}
class EmployeeCardInfo
{
    var department: departmentsEnum
    var status: statusEnum
    var employeeName: String?
    var salary: Int?
    var skill: Int?
    init(department: departmentsEnum, status: statusEnum, employeeName: String, salary: Int, skill: Int)
    {
        self.department = department
        self.status = status
        self.employeeName = employeeName
        self.salary = salary
        self.skill = skill
    }
}
func initCards() -> (development : [EmployeeCards], sales : [EmployeeCards], finance : [EmployeeCards], HR : [EmployeeCards], playcardsPool : [PlayCards]){
    var playcardsPool : [PlayCards] = []
    var development : [EmployeeCards] = []
    var sales : [EmployeeCards] = []
    var finance : [EmployeeCards] = []
    var HR : [EmployeeCards] = []

    var allPlayCards = [PlayCardInfo]()
    allPlayCards.append(PlayCardInfo(type: "FIRE", isOffensive: false, needSkill: [0,1,2,3], count: 2, value: 0))
    allPlayCards.append(PlayCardInfo(type: "FIRE", isOffensive: false, needSkill: [1,2,3], count: 4, value: 0))
    allPlayCards.append(PlayCardInfo(type: "FIRE", isOffensive: false, needSkill: [2,3], count: 2, value: 0))
    allPlayCards.append(PlayCardInfo(type: "FIRE", isOffensive: false, needSkill: [3], count: 2, value: 0))
    allPlayCards.append(PlayCardInfo(type: "HIRE", isOffensive: false, needSkill: [0,1,2,3], count: 6, value: 0))
    allPlayCards.append(PlayCardInfo(type: "HIRE", isOffensive: false, needSkill: [1,2,3], count: 4, value: 0))
    allPlayCards.append(PlayCardInfo(type: "HIRE", isOffensive: false, needSkill: [2,3], count: 2, value: 0))
    allPlayCards.append(PlayCardInfo(type: "HIRE", isOffensive: false, needSkill: [3], count: 2, value: 0))
    allPlayCards.append(PlayCardInfo(type: "POACH", isOffensive: true, needSkill: [0], count: 2, value: 0))
    allPlayCards.append(PlayCardInfo(type: "POACH", isOffensive: true, needSkill: [0,1], count: 2, value: 0))
    allPlayCards.append(PlayCardInfo(type: "POACH", isOffensive: true, needSkill: [0,1,2], count: 3, value: 0))
    allPlayCards.append(PlayCardInfo(type: "POACH", isOffensive: true, needSkill: [0,1,2,3], count: 2, value: 0))
    allPlayCards.append(PlayCardInfo(type: "FUNDING", isOffensive: false, needSkill: [0,1,2,3], count: 3, value: 5))
    allPlayCards.append(PlayCardInfo(type: "FUNDING", isOffensive: false, needSkill: [0,1,2,3], count: 2, value: 10))
    allPlayCards.append(PlayCardInfo(type: "FUNDING", isOffensive: false, needSkill: [1,2,3], count: 3, value: 5))
    allPlayCards.append(PlayCardInfo(type: "FUNDING", isOffensive: false, needSkill: [1,2,3], count: 2, value: 10))
    allPlayCards.append(PlayCardInfo(type: "FUNDING", isOffensive: false, needSkill: [2,3], count: 2, value: 5))
    allPlayCards.append(PlayCardInfo(type: "FUNDING", isOffensive: false, needSkill: [2,3], count: 2, value: 10))
    allPlayCards.append(PlayCardInfo(type: "FUNDING", isOffensive: false, needSkill: [2,3], count: 1, value: 15))
    allPlayCards.append(PlayCardInfo(type: "FUNDING", isOffensive: false, needSkill: [3], count: 1, value: 10))
    allPlayCards.append(PlayCardInfo(type: "FUNDING", isOffensive: false, needSkill: [3], count: 1, value: 15))
    allPlayCards.append(PlayCardInfo(type: "FUNDING", isOffensive: false, needSkill: [3], count: 1, value: 20))
    allPlayCards.append(PlayCardInfo(type: "BAD IDEA", isOffensive: true, needSkill: [0], count: 1, value: 1))
    allPlayCards.append(PlayCardInfo(type: "BAD IDEA", isOffensive: true, needSkill: [0], count: 2, value: 2))
    allPlayCards.append(PlayCardInfo(type: "BAD IDEA", isOffensive: true, needSkill: [0], count: 1, value: 3))
    allPlayCards.append(PlayCardInfo(type: "BAD IDEA", isOffensive: true, needSkill: [0], count: 1, value: 4))
    allPlayCards.append(PlayCardInfo(type: "BAD IDEA", isOffensive: true, needSkill: [0,1], count: 3, value: 1))
    allPlayCards.append(PlayCardInfo(type: "BAD IDEA", isOffensive: true, needSkill: [0,1], count: 2, value: 2))
    allPlayCards.append(PlayCardInfo(type: "BAD IDEA", isOffensive: true, needSkill: [0,1], count: 1, value: 3))
    allPlayCards.append(PlayCardInfo(type: "BAD IDEA", isOffensive: true, needSkill: [0,1,2], count: 2, value: 1))
    allPlayCards.append(PlayCardInfo(type: "BAD IDEA", isOffensive: true, needSkill: [0,1,2], count: 2, value: 2))
    allPlayCards.append(PlayCardInfo(type: "BAD IDEA", isOffensive: true, needSkill: [0,1,2], count: 1, value: 3))
    allPlayCards.append(PlayCardInfo(type: "BAD IDEA", isOffensive: true, needSkill: [0,1,2,3], count: 2, value: 1))
    allPlayCards.append(PlayCardInfo(type: "BAD IDEA", isOffensive: true, needSkill: [0,1,2,3], count: 2, value: 2))
    allPlayCards.append(PlayCardInfo(type: "BAD HIRE", isOffensive: true, needSkill: [0], count: 2, value: 0))
    allPlayCards.append(PlayCardInfo(type: "BAD HIRE", isOffensive: true, needSkill: [0,1], count: 3, value: 0))
    allPlayCards.append(PlayCardInfo(type: "BAD HIRE", isOffensive: true, needSkill: [0,1,2], count: 3, value: 0))
    allPlayCards.append(PlayCardInfo(type: "BAD HIRE", isOffensive: true, needSkill: [0,1,2,3], count: 2, value: 0))
    allPlayCards.append(PlayCardInfo(type: "RELEASE", isOffensive: false, needSkill: [0,1,2,3], count: 5, value: 0))
    allPlayCards.append(PlayCardInfo(type: "RELEASE", isOffensive: false, needSkill: [1,2,3], count: 5, value: 0))
    allPlayCards.append(PlayCardInfo(type: "RELEASE", isOffensive: false, needSkill: [2,3], count: 3, value: 0))
    allPlayCards.append(PlayCardInfo(type: "RELEASE", isOffensive: false, needSkill: [3], count: 3, value: 0))
    allPlayCards.append(PlayCardInfo(type: "CONFLICT OF OPINION", isOffensive: true, needSkill: [2], count: 1, value: 0))
    allPlayCards.append(PlayCardInfo(type: "OUT TO PASTURE", isOffensive: true, needSkill: [3], count: 1, value: 0))
    allPlayCards.append(PlayCardInfo(type: "LAYOFFS", isOffensive: true, needSkill: [2], count: 1, value: 0))
    allPlayCards.append(PlayCardInfo(type: "NEW BUSINESS PLAN", isOffensive: true, needSkill: [3], count: 1, value: 0))


    var currentPoint = 0
    var tempCount = 0
    
    for _ in 0...100 //100
    {
        if tempCount == Int(allPlayCards[currentPoint].count!)
        {
            currentPoint += 1
            tempCount = 1
        }
        else
        {
            tempCount += 1
        }
        let newPlayCard = PlayCards()
        newPlayCard.size = CGSize(width: 50, height: 69)
        newPlayCard.type = allPlayCards[currentPoint].type!
        newPlayCard.isOffensive = allPlayCards[currentPoint].isOffensive
        newPlayCard.needSkill = allPlayCards[currentPoint].needSkill
        newPlayCard.value = allPlayCards[currentPoint].value
        newPlayCard.zPosition = 1        
        newPlayCard.texture = playCardTexture["PlayCardBack"]
        var needSkill = ""
        for each in newPlayCard.needSkill!
        {
            needSkill += String(each)
        }
        newPlayCard.playCardFront = "\(newPlayCard.type!)_" + needSkill + "_\(newPlayCard.value!)"
        if playCardTexture["\(newPlayCard.playCardFront)"] == nil
        {
            playCardTexture[newPlayCard.playCardFront] = SKTexture(imageNamed: newPlayCard.playCardFront)
        }
        newPlayCard.name = "\(newPlayCard.type!)_" + needSkill + "_\(newPlayCard.value!)" + "-\(tempCount)"
        playcardsPool.append(newPlayCard)
        
    }
    
    var allEmployeeCards = [EmployeeCardInfo]()
    allEmployeeCards.append(EmployeeCardInfo(department: departmentsEnum.sales, status: statusEnum.VP, employeeName: "Vern Slick", salary: 2, skill: 1))
    allEmployeeCards.append(EmployeeCardInfo(department: departmentsEnum.sales, status: statusEnum.VP, employeeName: "Brad Duke", salary: 2, skill: 1))
    allEmployeeCards.append(EmployeeCardInfo(department: departmentsEnum.sales, status: statusEnum.VP, employeeName: "Dawn Ledbetter", salary: 2, skill: 0))
    allEmployeeCards.append(EmployeeCardInfo(department: departmentsEnum.sales, status: statusEnum.Manager, employeeName: "Grant Stone", salary: 1, skill: 2))
    allEmployeeCards.append(EmployeeCardInfo(department: departmentsEnum.sales, status: statusEnum.Manager, employeeName: "Charles Jackson", salary: 1, skill: 2))
    allEmployeeCards.append(EmployeeCardInfo(department: departmentsEnum.sales, status: statusEnum.Manager, employeeName: "Steve Swifte", salary: 1, skill: 1))
    allEmployeeCards.append(EmployeeCardInfo(department: departmentsEnum.sales, status: statusEnum.Manager, employeeName: "Andrew Chung", salary: 1, skill: 1))
    allEmployeeCards.append(EmployeeCardInfo(department: departmentsEnum.sales, status: statusEnum.Manager, employeeName: "Martha Thule", salary: 1, skill: 1))
    allEmployeeCards.append(EmployeeCardInfo(department: departmentsEnum.finance, status: statusEnum.VP, employeeName: "Ben Zhao", salary: 2, skill: 3))
    allEmployeeCards.append(EmployeeCardInfo(department: departmentsEnum.finance, status: statusEnum.VP, employeeName: "Shannon Tyrell", salary: 2, skill: 2))
    allEmployeeCards.append(EmployeeCardInfo(department: departmentsEnum.finance, status: statusEnum.VP, employeeName: "Michael Debeers", salary: 2, skill: 2))
    allEmployeeCards.append(EmployeeCardInfo(department: departmentsEnum.finance, status: statusEnum.Manager, employeeName: "Mary DeLany", salary: 1, skill: 1))
    allEmployeeCards.append(EmployeeCardInfo(department: departmentsEnum.finance, status: statusEnum.Manager, employeeName: "Annette Chung", salary: 1, skill: 1))
    allEmployeeCards.append(EmployeeCardInfo(department: departmentsEnum.finance, status: statusEnum.Manager, employeeName: "Hans Welch", salary: 1, skill: 1))
    allEmployeeCards.append(EmployeeCardInfo(department: departmentsEnum.finance, status: statusEnum.Manager, employeeName: "Wendell Hauser", salary: 1, skill: 1))
    allEmployeeCards.append(EmployeeCardInfo(department: departmentsEnum.finance, status: statusEnum.Manager, employeeName: "Sam Winters", salary: 1, skill: 1))
    allEmployeeCards.append(EmployeeCardInfo(department: departmentsEnum.HR, status: statusEnum.VP, employeeName: "Lacy Labonte", salary: 2, skill: 3))
    allEmployeeCards.append(EmployeeCardInfo(department: departmentsEnum.HR, status: statusEnum.VP, employeeName: "Georgia Gordon", salary: 2, skill: 2))
    allEmployeeCards.append(EmployeeCardInfo(department: departmentsEnum.HR, status: statusEnum.VP, employeeName: "James Feasel", salary: 2, skill: 2))
    allEmployeeCards.append(EmployeeCardInfo(department: departmentsEnum.HR, status: statusEnum.Manager, employeeName: "Martin Able", salary: 1, skill: 2))
    allEmployeeCards.append(EmployeeCardInfo(department: departmentsEnum.HR, status: statusEnum.Manager, employeeName: "Chuck DeGaul", salary: 1, skill: 1))
    allEmployeeCards.append(EmployeeCardInfo(department: departmentsEnum.HR, status: statusEnum.Manager, employeeName: "Brenda Swift", salary: 1, skill: 1))
    allEmployeeCards.append(EmployeeCardInfo(department: departmentsEnum.HR, status: statusEnum.Manager, employeeName: "Joel Jones", salary: 1, skill: 1))
    allEmployeeCards.append(EmployeeCardInfo(department: departmentsEnum.HR, status: statusEnum.Manager, employeeName: "Barbara McNerny", salary: 1, skill: 1))
    allEmployeeCards.append(EmployeeCardInfo(department: departmentsEnum.development, status: statusEnum.VP, employeeName: "Niles Wheatly", salary: 2, skill: 3))
    allEmployeeCards.append(EmployeeCardInfo(department: departmentsEnum.development, status: statusEnum.VP, employeeName: "Sally Hartwell", salary: 2, skill: 2))
    allEmployeeCards.append(EmployeeCardInfo(department: departmentsEnum.development, status: statusEnum.VP, employeeName: "Bob Headstein", salary: 2, skill: 0))
    allEmployeeCards.append(EmployeeCardInfo(department: departmentsEnum.development, status: statusEnum.Manager, employeeName: "Lance Slocum", salary: 1, skill: 1))
    allEmployeeCards.append(EmployeeCardInfo(department: departmentsEnum.development, status: statusEnum.Manager, employeeName: "Lawrence Smythe", salary: 1, skill: 1))
    allEmployeeCards.append(EmployeeCardInfo(department: departmentsEnum.development, status: statusEnum.Manager, employeeName: "Carrie Becker", salary: 1, skill: 1))
    allEmployeeCards.append(EmployeeCardInfo(department: departmentsEnum.development, status: statusEnum.Engineer, employeeName: "Morton Baker", salary: 1, skill: 0))
    allEmployeeCards.append(EmployeeCardInfo(department: departmentsEnum.development, status: statusEnum.Engineer, employeeName: "Tony Fuji", salary: 1, skill: 0))
    allEmployeeCards.append(EmployeeCardInfo(department: departmentsEnum.development, status: statusEnum.Engineer, employeeName: "Casey Close", salary: 1, skill: 0))
    allEmployeeCards.append(EmployeeCardInfo(department: departmentsEnum.development, status: statusEnum.Engineer, employeeName: "Smedley Wilson", salary: 1, skill: 0))
    allEmployeeCards.append(EmployeeCardInfo(department: departmentsEnum.development, status: statusEnum.Engineer, employeeName: "Harry Chin", salary: 1, skill: 0))
    allEmployeeCards.append(EmployeeCardInfo(department: departmentsEnum.development, status: statusEnum.Engineer, employeeName: "Ed Syljik", salary: 1, skill: 0))
    allEmployeeCards.append(EmployeeCardInfo(department: departmentsEnum.development, status: statusEnum.Engineer, employeeName: "Bert Windage", salary: 1, skill: 0))
    allEmployeeCards.append(EmployeeCardInfo(department: departmentsEnum.development, status: statusEnum.Engineer, employeeName: "Carl Versace", salary: 1, skill: 0))
    allEmployeeCards.append(EmployeeCardInfo(department: departmentsEnum.development, status: statusEnum.Engineer, employeeName: "Doogle Scott", salary: 1, skill: 0))
    allEmployeeCards.append(EmployeeCardInfo(department: departmentsEnum.development, status: statusEnum.Engineer, employeeName: "Julie Malone", salary: 1, skill: 0))

    currentPoint = 0
    for each in allEmployeeCards
    {
        let newEmployeeCard = EmployeeCards()
        newEmployeeCard.name = each.employeeName
        newEmployeeCard.size = CGSize(width: 50, height: 69)
        newEmployeeCard.department = each.department
        newEmployeeCard.status = each.status
        newEmployeeCard.employeeName = each.employeeName
        newEmployeeCard.salary = each.salary
        newEmployeeCard.skill = each.skill
        newEmployeeCard.zPosition = 1
        newEmployeeCard.texture = employeeCardTexture["EmployeeCardBack"]

        
        switch newEmployeeCard.department
        {
            case .sales:
                newEmployeeCard.employeeCardFront = "SALES_" + newEmployeeCard.employeeName!
                sales.append(newEmployeeCard)
            case .finance:
                newEmployeeCard.employeeCardFront = "FINANCE_" + newEmployeeCard.employeeName!
                finance.append(newEmployeeCard)
            case .HR:
                newEmployeeCard.employeeCardFront = "HR_" + newEmployeeCard.employeeName!
                HR.append(newEmployeeCard)
            case .development:
                newEmployeeCard.employeeCardFront = "DEVELOPMENT_" + newEmployeeCard.employeeName!
                development.append(newEmployeeCard)
        }
        
        employeeCardTexture[newEmployeeCard.employeeCardFront] = SKTexture(imageNamed: newEmployeeCard.employeeCardFront)

        
    }
    return (development,sales,finance,HR,playcardsPool)
    

}



