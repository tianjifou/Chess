//
//  ChessModel.swift
//  TianJiFouChess
//
//  Created by 天机否 on 17/4/28.
//  Copyright © 2017年 tianjifou. All rights reserved.
//

import Foundation
import UIKit
class ChessModel: NSObject {
    
}
class SWSPoint: NSObject {
    var x:Int = 0
    var y:Int = 0
}

class LianZhuChess: NSObject {
    var lianZhuType:LianZhuState? {
        didSet {
            if let lianZhuType = lianZhuType{
                switch lianZhuType {
                case .checkChess:
                    self.eatStr = "方格棋"
                    self.eatNum = 1
                case .threeChess:
                    self.eatStr = "三子棋"
                    self.eatNum = 1
                case .fourChess:
                    self.eatStr = "四子棋"
                    self.eatNum = 1
                case .fiveChess:
                    self.eatStr = "五子棋"
                    self.eatNum = 2
                case .sixChess:
                    self.eatStr = "六子棋"
                    self.eatNum = 3
                    
                }
            }
            
        }
    }
    var flagType: FlagType?
    var eatStr:String = ""
    var eatNum:Int = 0
}

class RegretChessModel {
     var lastChessArray:[[FlagType]] = []
     var roleStateLast:RoleState = .whiteState
     var fightStateLast:FightState = .buZiState
    
}
