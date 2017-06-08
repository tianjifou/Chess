//
//  UserModel.swift
//  TianJiFouChess
//
//  Created by 天机否 on 2017/5/17.
//  Copyright © 2017年 tianjifou. All rights reserved.
//

import Foundation
class UserModel: NSObject {
    
    var userName: String?
    var type:Int = 0// 0 == 添加好友 1== 收到好友申请
}

class MessageModel: NSObject {
    // 1 == 收到挑战书信息 2 == 收到接受挑战信息 3 == 对方布子信息
    // 4:对方已退出游戏 5:对方请求悔棋 6:接受对方悔棋 7:拒绝对方悔棋 8:对方请求重来一局 9:接受对方重新来 10: 拒绝对方重新来 11对方认输
    var  gameType:String?
    var challengeList:ChallengeList?
    var pointList:PointList?
        init(dictionary:[String:Any]) {
            super.init()
            setValuesForKeys(dictionary)
            if let  value = dictionary["challengeList"] {
               challengeList = ChallengeList.init(dictionary: value as! [String : Any])
            }
            if let  value = dictionary["pointList"] {
                pointList = PointList.init(dictionary: value as! [String : Any])
            }
        }
        
        override func setValue(_ value: Any?, forUndefinedKey key: String) {
            
        }
        
    
}

class PointList: NSObject {
    var from:String?
    var to:String?
    var message:String?
    var xx: NSNumber?
    var yy: NSNumber?
    var role:String = "0" // 0==无角色 1== 白子 2 == 黑子
    init(dictionary:[String:Any]) {
        super.init()
        setValuesForKeys(dictionary)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

class ChallengeList: NSObject {
    var from:String?
    var to:String?
    var message:String?
    init(dictionary:[String:Any]) {
        super.init()
        setValuesForKeys(dictionary)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
