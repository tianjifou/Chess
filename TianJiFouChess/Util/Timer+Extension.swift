//
//  Timer+Extension.swift
//  TianJiFouChess
//
//  Created by 天机否 on 2017/5/27.
//  Copyright © 2017年 tianjifou. All rights reserved.
//

import Foundation
import UIKit

class ObjectWrapper<T> {
    var value :T
    init(value:T) {
        self.value = value
    }
}
// MARK: - 解决nstimer循环引用问题（只能用weak修饰，不能用unowned修饰）
public extension Timer {
    
    public class func weak_scheduledTimerWithTimeInterval(_ ti:TimeInterval,selector: (()->())?,repeats:Bool) -> Timer {
        let action = ObjectWrapper(value: selector)
        return Timer.scheduledTimer(timeInterval: ti, target: self, selector: #selector(Timer.weak_timerAction(_:)), userInfo: action , repeats: repeats)
    }
    
    public class func weak_timeInterval(_ ti:TimeInterval,selector: (()->())?,repeats:Bool) -> Timer {
        let action = ObjectWrapper(value: selector)
        return Timer.init(timeInterval: ti, target: self, selector: #selector(Timer.weak_timerAction(_:)), userInfo: action, repeats: repeats)
    }
    
    public class func weak_timerAction(_ timer:Timer){
        if timer.userInfo != nil {
            let timerUserInfo = timer.userInfo! as! ObjectWrapper<(()->())?>
            if timerUserInfo.value != nil {
                timerUserInfo.value!()
            }
        }
    }
    
}
