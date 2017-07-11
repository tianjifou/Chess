//
//  AIFiveInARowChess.swift
//  TianJiFouChess
//
//  Created by 天机否 on 2017/6/29.
//  Copyright © 2017年 tianjifou. All rights reserved.
//

import Foundation
import UIKit
//活一、活二、活三、活四、连五、眠一，眠二、眠三、眠四
enum FiveChessType:Int {
    case liveOne = 0
    case liveTwo
    case liveThree
    case liveFour
    case liveFive
    case sleepOne
    case sleepTwo
    case sleepThree
    case sleepFour
    case unknown
    var score:Int  {
        switch self {
        case .unknown:
            return un_known
        case .sleepOne:
            return sleep_One
        case .liveOne,.sleepTwo:
            return live_One
        case .liveTwo,.sleepThree:
            return live_Two
        case .liveThree:
            return live_Three
        case .sleepFour:
            return sleep_Four
        case .liveFour:
            return live_Four
        case .liveFive:
            return live_Five
            
        }
    }
    

    
}
let live_Five = 1000000
let live_Four = 100000
let sleep_Four = 10000
let live_Three = 1000
let live_Two = 100
let sleep_Three = 100
let live_One = 10
let sleep_Two = 10
let sleep_One = 1
let un_known = 0


//电脑、选手
enum FiveChessRole:Int {
    case computer=0,people
}
//方向
enum Direction:Int {
    case estAndWest=0,northAndSouth,estAndNorth,westAndNorth
}

class AIFiveInARowChess {
    
    static var searchDeep = 6//搜索深度
    static var deepDecrease = 8//按搜索深度递减分数，为了让短路径的结果比深路劲的分数高
    static var limitNum = 8//
    static var checkmateDeep = 5//算杀深度
    
    /// 判断该位置是否是有效分数位置
    ///
    /// - Parameters:
    ///   - chessArray: 棋盘数值
    ///   - point: 该空位置
    /// - Returns: 结果
    static func effectivePoint(chessArray:[[FlagType]],point:(x:Int,y:Int),chessCount:Int=2) -> Bool{
        let startX = point.x
        let startY = point.y
        let distance = 2
        var  chessCount = chessCount
        for i in startX-distance...startX+distance{
            if i < 0 || i > 14 {
                continue
            }
            for j in startY-distance...startY+distance{
                if j < 0 || j > 14 {
                    continue
                }
                if i == startX && j == startY {
                    continue
                }
                
                if chessArray[i][j] != FlagType.freeChess {
                    chessCount -= 1
                    if chessCount <= 0 {
                        return true
                    }
                }
                
            }
        }
        return false
    }
    
    static func  getScoreWithChess(chessArray:[[FlagType]],point:(x:Int,y:Int),role:FlagType) -> Int {
        var score = 0
        var roleNum = 1
        var enemyNum = 0
        var roleNum2 = 0
        var empty = -1
        
        func reset() {
             roleNum = 1
             enemyNum = 0
             roleNum2 = 0
             empty = -1
        }
        
        //东西向
        var i = point.x + 1
        while true {
            if i >= 15{
                enemyNum += 1
                break
            }
            if chessArray[i][point.y] == .freeChess {
                if empty == -1 && i < 14 && chessArray[i+1][point.y] == role {
                    empty = roleNum
                    i += 1
                    continue
                }else{
                    break
                }
            }
            if chessArray[i][point.y] == role {
                roleNum += 1
                i += 1
                continue
            }else{
                enemyNum += 1;
                break;
            }
        }
        i = point.x - 1
        while true {
            if i < 0 {
                enemyNum += 1
                break
            }
            if chessArray[i][point.y] == .freeChess {
                if empty == -1 && i > 0 && chessArray[i-1][point.y] == role {
                    empty = 0
                     i -= 1
                    continue
                }else {
                    break
                }
            }
            if chessArray[i][point.y] == role {
                roleNum2 += 1
                if empty != -1 {
                    empty += 1
                }
                i -= 1
                continue
            }else {
                enemyNum += 1
                break
            }
        }
        
        roleNum += roleNum2
        score += AIFiveInARowChess.theScore(roleNum: roleNum, enemyNum: enemyNum, empty: &empty)
        //南北方向
        reset()
         i = point.y + 1
        while true {
            if i >= 15{
                enemyNum += 1
                break
            }
            if chessArray[point.x][i] == .freeChess {
                if empty == -1 && i < 14 && chessArray[point.x][i+1] == role {
                    empty = roleNum
                    i += 1
                    continue
                }else{
                    break
                }
            }
            if chessArray[point.x][i] == role {
                roleNum += 1
                i += 1
                continue
            }else{
                enemyNum += 1;
                break;
            }
        }
        i = point.y - 1
        while true {
            if i < 0 {
                enemyNum += 1
                break
            }
            if chessArray[point.x][i] == .freeChess {
                if empty == -1 && i > 0 && chessArray[point.x][i-1] == role {
                    empty = 0
                    i -= 1
                    continue
                }else {
                    break
                }
            }
            if chessArray[point.x][i] == role {
                roleNum2 += 1
                if empty != -1 {
                    empty += 1
                }
                i -= 1
                continue
            }else {
                enemyNum += 1
                break
            }
        }
        
        roleNum += roleNum2
        score += AIFiveInARowChess.theScore(roleNum: roleNum, enemyNum: enemyNum, empty: &empty)
        //西北方向
        reset()
         i = 1
        while true {
            if point.x + i >= 15 || point.y + i >= 15{
                enemyNum += 1
                break
            }
            if chessArray[point.x + i][point.y + i] == .freeChess {
                if empty == -1 && point.x + i < 14 && point.y + i < 14 && chessArray[point.x + i + 1][point.y + i + 1] == role {
                    empty = roleNum
                    i += 1
                    continue
                }else{
                    break
                }
            }
            if chessArray[point.x + i][point.y + i] == role {
                roleNum += 1
                i += 1
                continue
            }else{
                enemyNum += 1;
                break;
            }
        }
        i =  1
        while true {
        
            if point.x - i < 0 || point.y - i < 0{
                enemyNum += 1
                break
            }
            if chessArray[point.x - i][point.y - i] == .freeChess {
                if empty == -1 && point.x - i > 0 && point.y - i > 0 && chessArray[point.x - i - 1][point.y - i - 1] == role {
                    empty = 0
                    i += 1
                    continue
                }else {
                    break
                }
            }
            if chessArray[point.x - i][point.y - i] == role {
                roleNum2 += 1
                if empty != -1 {
                    empty += 1
                }
                i += 1
                continue
            }else {
                enemyNum += 1
                break
            }
        }
        
        roleNum += roleNum2
        score += AIFiveInARowChess.theScore(roleNum: roleNum, enemyNum: enemyNum, empty: &empty)
        //东北方向
        reset()
        i = 1
        while true {
            if point.x + i >= 15 || point.y - i < 0{
                enemyNum += 1
                break
            }
            if chessArray[point.x + i][point.y - i] == .freeChess {
                if empty == -1 && point.x + i < 14 && point.y - i  > 0 && chessArray[point.x + i + 1][point.y - i - 1] == role {
                    empty = roleNum
                    i += 1
                    continue
                }else{
                    break
                }
            }
            if chessArray[point.x + i][point.y - i] == role {
                roleNum += 1
                i += 1
                continue
            }else{
                enemyNum += 1;
                break;
            }
        }
        i =  1
        while true {
            
            if point.x - i < 0 || point.y + i >= 15{
                enemyNum += 1
                break
            }
            if chessArray[point.x - i][point.y + i] == .freeChess {
                if empty == -1 && point.x - i > 0 && point.y + i < 14 && chessArray[point.x - i - 1][point.y + i + 1] == role {
                    empty = 0
                    i += 1
                    continue
                }else {
                    break
                }
            }
            if chessArray[point.x - i][point.y + i] == role {
                roleNum2 += 1
                if empty != -1 {
                    empty += 1
                }
                i += 1
                continue
            }else {
                enemyNum += 1
                break
            }
        }
        
        roleNum += roleNum2
        score += AIFiveInARowChess.theScore(roleNum: roleNum, enemyNum: enemyNum, empty: &empty)
        return AIFiveInARowChess.chongSiChessScore(score: score)
    }
    //更新某点相关的其他位置的估值分数
    static func updateOneEffectScore(chessArray:[[FlagType]],point:(x:Int,y:Int),AIScore:inout [[Int]],humanScore:inout [[Int]]) {
        
        func update(x:Int,y:Int) {
           let black = self.getScoreWithChess(chessArray: chessArray, point: (x,y), role: .blackChess)
           let white = self.getScoreWithChess(chessArray: chessArray, point: (x,y), role: .whiteChess)
            AIScore[x][y] = black
            humanScore[x][y] = white
        }
        
        for x in 0..<15 {
            for y in 0..<15 {
                if x == point.x || y == point.y || (x-y) == (point.x-point.y) || (x+y) == (point.y+point.x){
                    if chessArray[x][y] == .freeChess  {
                        update(x: x, y: y)
                    }
                }
                
            }
          
        }
    }
    
    static func udateAllScore(chessArray:[[FlagType]],AIScore:inout [[Int]],humanScore:inout [[Int]]){
        func update(x:Int,y:Int) {
            let black = self.getScoreWithChess(chessArray: chessArray, point: (x,y), role: .blackChess)
            let white = self.getScoreWithChess(chessArray: chessArray, point: (x,y), role: .whiteChess)
            AIScore[x][y] = black
            humanScore[x][y] = white
        }
        for i in 0..<15 {
            for j in 0..<15 {
                if chessArray[i][j] == .freeChess && self.effectivePoint(chessArray: chessArray, point: (i,j)) {
                    update(x: i, y: j)
                }
            }
        }
    }
    
    
    //判断棋盘格局
    static func getFiveChessType(chessArray:[[FlagType]],AIScore:inout [[Int]],humanScore:inout [[Int]]) ->[(x:Int,y:Int)]{
        var twos:[(Int,Int)] = []
        var threes:[(Int,Int)] = []
        var doubleThrees:[(Int,Int)] = []
        var sleepFours:[(Int,Int)] = []
        var fours:[(Int,Int)] = []
        var fives:[(Int,Int)] = []
        var oters:[(Int,Int)] = []
        
        for i in 0..<15{
            for j in 0..<15{
                if chessArray[i][j] == .freeChess && self.effectivePoint(chessArray: chessArray, point: (x: i, y: j)) {
                    let aiScore = AIScore[i][j]
                    let humScore = humanScore[i][j]
                    if aiScore>=live_Five {
                        return[(i,j)]
                    }else if humScore >= live_Five {
                        fives.append((i,j))
                    }else if aiScore >= live_Four {
                        fours.insert((i,j), at: 0)
                    }else if humScore >= live_Four {
                        fours.append((i,j))
                    }else if aiScore >= sleep_Four{
                        sleepFours.insert((i,j), at: 0)
                    }else if humScore >= sleep_Four{
                        sleepFours.append((i,j))
                    }else if aiScore >= 2*live_Three{
                        doubleThrees.insert((i,j), at: 0)
                    }else if humScore >= 2*live_Three{
                        doubleThrees.append((i,j))
                    }else if aiScore >= live_Three {
                        threes.insert((i,j), at: 0)
                    }else if humScore >= live_Three {
                        threes.append((i, j))
                    }else if aiScore >= live_Two{
                        twos.insert((i,j), at: 0)
                    }else if humScore >= live_Two{
                        twos.append((i,j))
                    }else {
                        oters.append((i,j))
                    }
                }
            }
        }
        
        if fives.count > 0 {
            return [fives[0]]
        }
        if fours.count > 0 {
            return fours
        }
        if sleepFours.count > 0{
            return [sleepFours[0]]
        }
        if doubleThrees.count > 0{
            return doubleThrees + threes
        }
        let result = threes + twos + oters
        var realy:[(Int,Int)] = []
        if result.count > limitNum {
            realy += result.prefix(limitNum)
            return realy
        }
        return result
    }
    
    static func findMaxScore(chessArray:[[FlagType]],role:FlagType,aiScore:[[Int]],humanScore:[[Int]],score:Int)->[(Int,Int,Int)]{
        var result:[(Int,Int,Int)] = []
        for i in 0..<15{
            for j in 0..<15{
                if chessArray[i][j] == .freeChess {
                    if self.effectivePoint(chessArray: chessArray, point: (i,j),chessCount: 1) {
                        let score1 =  role == .blackChess ?  aiScore[i][j] : humanScore[i][j]
                        if score1 >= live_Five {
                            return [(i,j,score1)]
                        }
                        if score1 >= score {
                            result.append((i,j,score1))
                            
                        }
                    }
                }
            }
        }
      return  result.sorted { (a, b) -> Bool in
            return b.2 > a.2
        }
        
    }
    
    static func findEnemyMaxScore(chessArray:[[FlagType]],role:FlagType,aiScore:[[Int]],humanScore:[[Int]],score:Int)->[(Int,Int,Int)]{
        var result:[(Int,Int,Int)] = []
        var fours:[(Int,Int,Int)] = []
        var fives:[(Int,Int,Int)] = []
        for i in 0..<15{
            for j in 0..<15{
                if chessArray[i][j] == .freeChess {
                    if  self.effectivePoint(chessArray: chessArray, point: (i,j),chessCount: 1) {
                        let score1 =  role == .blackChess ?  aiScore[i][j] : humanScore[i][j]
                        let score2 = role == .blackChess ?  humanScore[i][j] : aiScore[i][j]
                        if score1 >= live_Five {
                            return [(i,j,-score1)]
                        }
                        if score1 >= live_Four {
                            fours.insert((i,j,-score1), at: 0)
                            continue
                        }
                        if score2 >= live_Five {
                         fives.append((i,j,score2))
                            continue
                        }
                        if score2 >= live_Four{
                            fours.append((i,j,score2))
                            continue
                        }
                        if score1 > score || score2 > score {
                            result.append((i,j,score1))
                        }
                    }
                }
            }
        }
        if fives.count > 0 {
            return [fives[0]]
        }
        if fours.count > 0 {
            return [fours[0]]
        }
      return  result.sorted { (a, b) -> Bool in
            return abs(b.2) > abs(a.2)
        }
    }
    
    static func deepingSearch(chessArray:inout[[FlagType]],role:FlagType,AIScore:inout [[Int]],humanScore:inout [[Int]],deep:Int,score: Int ,enemyScore:Int) ->[(Int,Int,Int)]{
        var debugCount = 0
        var result:[(Int,Int,Int)] = []
        
        func aiMaxSearch(deep2:Int) ->[(Int,Int,Int)]?{
            debugCount += 1
            if deep2 <= 0 {
                return nil
            }
            
            var points = findMaxScore(chessArray: chessArray,role: role,aiScore: AIScore,humanScore: humanScore, score: score)
            if points.count > 0 && points[0].2 >= live_Four {
                return [points[0]]
            }
            if points.count == 0{
                return nil
            }
            for i in 0..<points.count{
                chessArray[points[i].0][points[i].1] = role
               self.updateOneEffectScore(chessArray: chessArray, point: (points[i].0,points[i].1), AIScore: &AIScore, humanScore: &humanScore)
                let hum =  humanMaxSearch(deep3: deep2-1)
                chessArray[points[i].0][points[i].1] = .freeChess
                self.updateOneEffectScore(chessArray: chessArray, point: (points[i].0,points[i].1), AIScore: &AIScore, humanScore: &humanScore)
                if var hum = hum {
                    if hum.count > 0{
                        hum.insert(points[i], at: 0)
                        return hum
                    }else{
                        return [points[i]]
                    }
                }
            }
            return nil
        }
        
        func humanMaxSearch(deep3:Int)->[(Int,Int,Int)]? {
            debugCount += 1
            if deep <= 0 {
                return nil
            }
            if let winR = ChessStepTool.woWin(chessArray: chessArray)  {
                if winR == role {
                    return []
                }else{
                    return nil
                }
            }
            
            let points = findEnemyMaxScore(chessArray: chessArray,role: self.reverseRole(role: role), aiScore: AIScore, humanScore: humanScore, score: enemyScore)
            if points.count == 0{
                return nil
            }
            if points[0].2 <= -live_Four {
                return nil
            }
            var tempArr:[[(Int,Int,Int)]] = []
            let currentRole = self.reverseRole(role: role)
            for i in 0..<points.count {
                chessArray[points[i].0][points[i].1] = currentRole
                self.updateOneEffectScore(chessArray: chessArray, point: (points[i].0,points[i].1), AIScore: &AIScore, humanScore: &humanScore)
                let ai = aiMaxSearch(deep2: deep3 - 1)
                 chessArray[points[i].0][points[i].1] = .freeChess
                self.updateOneEffectScore(chessArray: chessArray, point: (points[i].0,points[i].1), AIScore: &AIScore, humanScore: &humanScore)
                if var ai = ai {
                    ai.insert(points[i], at: 0)
                    tempArr.append(ai)
                    continue
                }else {
                    return nil
                }
            }
            let some = arc4random()%uint(tempArr.count)
            return tempArr[Int(some)]
            
        }
        
        
        
        for i in 0...deep{
           
            if let result = aiMaxSearch(deep2: i) , result.count > 0 {
                return result
            }
        }
        
        return []
    }
    static func reverseRole(role: FlagType) -> FlagType {
        if role == .whiteChess{
            return .blackChess
        }else {
            return .whiteChess
        }
    }
    
    static func getAIPoint(chessArray:inout[[FlagType]],role:FlagType,AIScore:inout [[Int]],humanScore:inout [[Int]],deep:Int) ->(Int,Int,Int)? {
        
        let maxScore = 10*live_Five
        let minScore = -1*maxScore
        let checkmateDeep = self.checkmateDeep
       var total=0, //总节点数
        steps=0,  //总步数
        count = 0,  //每次思考的节点数
        PVcut = 0,
        ABcut = 0 //AB剪枝次数
        
        
        func humMax(deep:Int)->(Int,Int,Int)? {
            let points = self.getFiveChessType(chessArray: chessArray, AIScore: &AIScore, humanScore: &humanScore)
            var bestPoint:[(Int,Int)] = []
            var best = minScore
            count = 0
            ABcut = 0
            PVcut = 0
            for i in 0..<points.count {
                let p = points[i]
                chessArray[p.x][p.y] = role
                self.updateOneEffectScore(chessArray: chessArray, point: (p.x,p.y), AIScore: &AIScore, humanScore: &humanScore)
                var score = -aiMaxS(deep: deep-1, alpha: -maxScore, beta: -best, role: self.reverseRole(role: role))
                if p.x < 3 || p.x > 11 || p.y < 3 || p.y > 11 {
                    score = score/2
                }
                if TJFTool.equal(a: Float(score), b: Float(best)){
                    bestPoint.append((p.x,p.y))
                }
                if TJFTool.greatThan(a: Float(score), b: Float(best)){
                    best = score
                    bestPoint.removeAll()
                    bestPoint.append((p.x,p.y))
                }
                chessArray[p.x][p.y] = .freeChess
                self.updateOneEffectScore(chessArray: chessArray, point: (p.x,p.y), AIScore: &AIScore, humanScore: &humanScore)
                
            }
            steps += 1
            total += count
            if bestPoint.count > 0 {
                let num = arc4random()%UInt32(bestPoint.count)
                return (bestPoint[Int(num)].0,bestPoint[Int(num)].1,best)
            }
            return nil
           
        }
        
        func aiMaxS(deep:Int,alpha:Int,beta:Int,role:FlagType) -> Int{
            var score = 0
            var aiMax = 0
            var humMax = 0
            var best = minScore
            for i in 0..<15{
                for j in 0..<15{
                    if chessArray[i][j] == .freeChess{
                        aiMax = max(AIScore[i][j], aiMax)
                        humMax = max(humanScore[i][j], humMax)
                    }
                }
            }
            score = (role == .blackChess ? 1 : -1) * (aiMax-humMax)
            count += 1
            if deep <= 0 || TJFTool.greatOrEqualThan(a: Float(score), b: Float(live_Five)){
                return score
            }
            let points =  self.getFiveChessType(chessArray: chessArray, AIScore: &AIScore, humanScore: &humanScore)
            for i in 0..<points.count{
                let p = points[i]
                chessArray[p.x][p.y] = role
                self.updateOneEffectScore(chessArray: chessArray, point: (p.x,p.y), AIScore: &AIScore, humanScore: &humanScore)
                let some = -aiMaxS(deep: deep-1, alpha: -beta, beta: -1 * ( best > alpha ? best : alpha), role: self.reverseRole(role: role)) * deepDecrease
                chessArray[p.x][p.y] = .freeChess
                self.updateOneEffectScore(chessArray: chessArray, point: (p.x,p.y), AIScore: &AIScore, humanScore: &humanScore)
                if TJFTool.greatThan(a: Float(some), b: Float(best)) {
                    best = some
                }
                if TJFTool.greatOrEqualThan(a: Float(some), b: Float(beta)){
                    ABcut += 1
                    return some
                }
            }
            if (deep == 2 || deep == 3) && TJFTool.littleThan(a: Float(best), b: Float(live_Three*2)) && TJFTool.greatThan(a: Float(best), b: -(Float)(live_Three)){
                
                if let result = self.checkmateDeeping(chessArray: &chessArray, role: role, AIScore: &AIScore, humanScore: &humanScore, deep: deep) {
                   return result[0].2 * Int(pow(0.8, Double(result.count))) * (role == .blackChess ? 1:-1)
                }
            }
            return best
        }
        
        var i = 2
        var result:(Int,Int,Int)?
        while i <= deep {
            if let test = humMax(deep: i) {
                result = test
                if TJFTool.greatOrEqualThan(a: Float(test.2), b: Float(live_Four)) {
                    return test
                }
            }
            i += 2
        }
        if result == nil {
            var maxAiScore = 0
            for i in 0..<15{
                for j in 0..<15 {
                    if chessArray[i][j] == .freeChess && maxAiScore < AIScore[i][j] {
                        maxAiScore = AIScore[i][j]
                        result = (i,j,maxAiScore)
                    }
                }
            }
        }
        
        return result
    }
    
    static func checkmateDeeping(chessArray:inout[[FlagType]],role:FlagType,AIScore:inout [[Int]],humanScore:inout [[Int]],deep:Int) ->[(Int,Int,Int)]?{
        if deep < 0 {
            return nil
        }
        var result = self.deepingSearch(chessArray: &chessArray, role: role, AIScore: &AIScore, humanScore: &humanScore, deep: deep, score: live_Four, enemyScore: live_Five)
        
        if result.count > 0 {
           result[0].2 = live_Four
            return result
        }
        var result2 = self.deepingSearch(chessArray: &chessArray, role: role, AIScore: &AIScore, humanScore: &humanScore, deep: deep, score: live_Three, enemyScore: live_Four)
        
        if result2.count > 0 {
            result2[0].2 = live_Three*2
            return result2
        }
        return nil
    }
    
    
    
}
