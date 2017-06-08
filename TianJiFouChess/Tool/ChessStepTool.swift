//
//  ChessStepTool.swift
//  TianJiFouChess
//
//  Created by 天机否 on 17/5/4.
//  Copyright © 2017年 tianjifou. All rights reserved.
//

import Foundation
import UIKit
//斜子连珠棋: 三子棋，四子棋，五子棋，六子棋,方格棋
enum LianZhuState: Int {
    case threeChess,fourChess,fiveChess,sixChess,checkChess
}
// 棋的优先级 是 六子棋(吃对方三个子) > 五子棋（吃对方两个子） > 四子棋 = 三子棋 = 方格棋（吃对方一个子）
class ChessStepTool: NSObject {
    
    static func isShunZiChess(_ point:SWSPoint,_ chessArray: [[FlagType]]) ->LianZhuState? {
        
        if let state = isSixShunZiChess(point, chessArray) {
            return state
        }
        
        if let state = isXiZiChess(point, chessArray) {
            return state
        }
        
        if let state = isCheckChess(point, chessArray) {
            return state
        }
        
        return nil
    }
    
    
    //是否形成方格棋
    static func isCheckChess(_ point:SWSPoint,_ chessArray: [[FlagType]]) ->LianZhuState? {
        let type = chessArray[point.x][point.y]
        //左上
        if point.x - 1 >= 0 && point.y - 1 >= 0 && chessArray[point.x][point.y-1] == type &&
            chessArray[point.x-1][point.y] == type && chessArray[point.x-1][point.y-1] == type {
            return .checkChess
        }
        //左下
        if point.x - 1 >= 0 && point.y + 1 <= 5 && chessArray[point.x][point.y+1] == type &&
            chessArray[point.x-1][point.y] == type && chessArray[point.x-1][point.y+1] == type {
            return .checkChess
        }
        //右上
        if point.x + 1 <= 5 && point.y - 1 >= 0 && chessArray[point.x][point.y-1] == type &&
            chessArray[point.x+1][point.y] == type && chessArray[point.x+1][point.y-1] == type {
            return .checkChess
        }
        //右下
        if point.x + 1 <= 5 && point.y + 1 <= 5 && chessArray[point.x][point.y+1] == type &&
            chessArray[point.x+1][point.y] == type && chessArray[point.x+1][point.y+1] == type {
            return .checkChess
        }
        return nil
    }
    //是否形成斜子棋（三子棋，四子棋，五子棋，六子棋）
    static func isXiZiChess(_ point:SWSPoint,_ chessArray: [[FlagType]]) ->  LianZhuState?{
        let type = chessArray[point.x][point.y]
        let pointLeft = SWSPoint()
        let pointRight = SWSPoint()
        let ponitTop = SWSPoint()
        let pointBottom = SWSPoint()
        
        // 东北方向
        var i = 0
        while point.x - i >= 0 && point.y + i <= 5 && chessArray[point.x - i][point.y + i] == type {
            pointLeft.x = point.x - i
            pointLeft.y = point.y + i
            i += 1
        }
            i = 0
        while point.x + i <= 5 && point.y - i >= 0 && chessArray[point.x + i][point.y - i] == type {
            pointRight.x = point.x + i
            pointRight.y = point.y - i
            i += 1
        }
        
        //西北方向
        i = 0
        while point.x - i >= 0 && point.y - i >= 0 && chessArray[point.x - i][point.y - i] == type {
            ponitTop.x = point.x - i
            ponitTop.y = point.y - i
            i += 1
        }
        i = 0
        while point.x + i <= 5 && point.y + i <= 5 && chessArray[point.x + i][point.y + i] == type {
            pointBottom.x = point.x + i
            pointBottom.y = point.y + i
            i += 1
        }
        print(pointRight.x,pointRight.y,pointLeft.x,pointLeft.y,ponitTop.x,ponitTop.y,pointBottom.x,pointBottom.y)
        let arr = [3,2,1,0]
        for index in arr {
            
            func condition() -> Bool {
                if pointRight.x == 2+index && pointRight.y == 0 && pointLeft.x == 0 && pointLeft.y == 2+index {
                    return true
                }
                if pointRight.x == 5  && pointRight.y == 3 - index && pointLeft.x == 3 - index && pointLeft.y == 5 {
                    return true
                }
                if ponitTop.x == 0 && ponitTop.y == 3-index && pointBottom.x == 2+index && pointBottom.y == 5 {
                    return true
                }
                if ponitTop.x == 3-index && ponitTop.y == 0 && pointBottom.x == 5 && pointBottom.y == 2+index {
                    return true
                }
                return false
            }
            
            if condition() {
                switch index {
                case 0:
                    return .threeChess
                case 1:
                    return .fourChess
                case 2:
                    return .fiveChess
                case 3:
                    return .sixChess
                default:()
                    
                }
            }
            
           
        }
        
        
        return nil
        
    }
    //横向六子连珠（除去四边线的六子连珠）
    static func isSixShunZiChess(_ point:SWSPoint,_ chessArray: [[FlagType]]) -> LianZhuState? {
        let type = chessArray[point.x][point.y]
        let pointLeft = SWSPoint()
        let pointRight = SWSPoint()
        let ponitTop = SWSPoint()
        let pointBottom = SWSPoint()
        //东西方向
        var i = 0
        while point.x - i >= 0 && chessArray[point.x - i][point.y] == type {
            pointLeft.x = point.x - i
            i += 1
        }
        i = 0
        while point.x + i <= 5 && chessArray[point.x + i][point.y] == type {
            pointRight.x = point.x + i
            i += 1
        }
        if pointRight.x - pointLeft.x == 5 {
            return .sixChess
        }
        //南北方向
        i = 0
        while point.y - i >= 0 && chessArray[point.x][point.y-i] == type {
            ponitTop.y = point.y - i
            i += 1
        }
        i = 0
        while point.y + i <= 5 && chessArray[point.x][point.y+i] == type {
            pointBottom.y = point.y + i
            i += 1
        }
        if pointBottom.y - ponitTop.y == 5 {
            return .sixChess
        }
        return nil
    }
    // 是否全部是格子棋（这样可以强行吃掉）
    static func allIsShunZiChess(chessArray: [[FlagType]]) -> Bool {
        for i in 0...5 {
            for j in 0...5 {
                let swsPoint = SWSPoint()
                swsPoint.x = i
                swsPoint.y = j
                if  isShunZiChess(swsPoint, chessArray) == nil {
                    return false
                }
            }
        }
        
        return true
    }
    
    //判断胜负
   static func whoWinChess(chessArray: [[FlagType]]) -> WinState {
        var whiteCount = 0
        var blackCount = 0
        for i in 0...5 {
            for j in 0...5 {
                if chessArray[i][j] == .whiteChess {
                    whiteCount += 1
                }
                if chessArray[i][j] == .blackChess {
                    blackCount += 1
                }
            }
        }
        
        if whiteCount>=3 && blackCount<=2 {
            return .whiteWin
        }
        
        if blackCount>=3 && whiteCount<=2 {
            return .blackWin
        }
        
        if whiteCount < 3 && blackCount < 3 {
            return .drawGame
        }
        
        return .noneWin
    }
    
    static func touchRealPoint(_ point:  CGPoint) ->CGPoint{
        var realPoint = CGPoint()
        realPoint = point
        if realPoint.x < 10 {
            realPoint.x = 10
        }
        if realPoint.x > 310 {
            realPoint.x = 310
        }
        if realPoint.y < 10 {
            realPoint.y = 10
        }
        if realPoint.y > 310 {
            realPoint.y = 310
        }
        realPoint.x -= 10
        realPoint.y -= 10
        return realPoint
       
    }
}
