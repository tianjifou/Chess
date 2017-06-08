//
//  PADeviceSize.swift
//  TianJiFouChess
//
//  Created by 天机否 on 2017/5/15.
//  Copyright © 2017年 tianjifou. All rights reserved.
//

import UIKit
class PADeviceSize: NSObject {
    static let screenWidth: CGFloat = UIScreen.main.bounds.size.width
    static let screenHeight: CGFloat = UIScreen.main.bounds.size.height
    static let navigationHeight: CGFloat = 64
    
    static let separatorSize = 1.0 / UIScreen.main.scale
    
    static let roundRectButtonBorderWidth = 1.5 / UIScreen.main.scale
    
    static var deviceIsIpad: Bool {
        return UIDevice.current.model.hasPrefix("iPad")
    }
    
    static var RETIAN_3_5: Bool {
        return UIScreen.instancesRespond(to: #selector(getter: UIDynamicItem.bounds)) ? CGSize(width: 320, height: 480).equalTo(UIScreen.main.bounds.size) : false
    }
    
    static var RETIAN_4_0: Bool {
        return UIScreen.instancesRespond(to: #selector(getter: UIDynamicItem.bounds)) ? CGSize(width: 320, height: 568).equalTo(UIScreen.main.bounds.size) : false
    }
    
    static var IPHONE_4_7: Bool {
        return UIScreen.instancesRespond(to: #selector(getter: UIDynamicItem.bounds)) ? CGSize(width: 375, height: 667).equalTo(UIScreen.main.bounds.size) : false
    }
    
    static var IPHONE_5_5: Bool {
        return UIScreen.instancesRespond(to: #selector(getter: UIDynamicItem.bounds)) ? CGSize(width: 414, height: 736).equalTo(UIScreen.main.bounds.size) : false
    }
    
    static func scaleSizeIphone6(_ size: CGFloat) -> CGFloat {
        return floor((size) / 375.0 * screenWidth)
    }
    
    static func scaleFontIphone6(_ size: CGFloat) -> CGFloat {
        return IPHONE_4_7 ? size : (IPHONE_5_5 ? floor(size * 1.1) : floor(size * 0.9))
    }
    
    static let greatestSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
}
