//
//  TJFString.swift
//  TianJiFouChess
//
//  Created by 天机否 on 2017/5/15.
//  Copyright © 2017年 tianjifou. All rights reserved.
//

import Foundation
import UIKit

protocol  OptionalSting {}
extension String : OptionalSting {}
extension Optional where Wrapped: OptionalSting {
    /// 对可选类型的String(String?)安全解包
    var noneNull: String {
        if let value = self as? String {
            return value
        } else {
            return ""
        }
    }
}

extension String {
    
    func isChenese() ->Bool {
        let match = "(^[\\u4e00-\\u9fa5]+$)"
        let predicate =  NSPredicate.init(format: "SELF matches %@", match)
        return predicate.evaluate(with:self)
    }
   
}

class TJFString:NSObject {
    class func cleanString(_ text: String) -> String {
        return text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    class func heightForString(_ text: String, width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox.height
    }
    
    class func widthForString(_ text: String, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: UIScreen.main.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox.width
    }
    
    class func heightForString(_ text: String, width: CGFloat, attributes: [String: Any]) -> CGFloat {
        var attr = attributes
        if let paragraphStyle = attr[NSParagraphStyleAttributeName] as? NSMutableParagraphStyle {
            if paragraphStyle.lineBreakMode != .byWordWrapping && paragraphStyle.lineBreakMode != .byCharWrapping {
                paragraphStyle.lineBreakMode = .byWordWrapping
            }
            attr[NSParagraphStyleAttributeName] = paragraphStyle
        }
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attr, context: nil)
        return boundingBox.height
    }
    
    /**
     等同于Objective-C的str.length > 0
     
     - parameter str: source string
     
     - returns: is not null && not empty string
     */
    class func isEmptyString(_ str: String?) -> Bool {
        if let str = str {
            let str3 = TJFString.cleanString(str)
            return str3.isEmpty
        } else {
            return true
        }
    }
    
    class func getNotNullString(_ str: String?)->String {
        return str ?? ""
    }
    
    
    class func substringWithNSRange(_ range: NSRange, text: String?) -> String? {
        guard let text = text, range.location != NSNotFound && (range.location + range.length <= (text as NSString).length)
            else { return nil }
        return (text as NSString).substring(with: range)
    }
    
    
    class func filterStringWithAnyObject(_ obj: AnyObject?) -> String {
        if obj is NSNull {
            return ""
        }
        if obj == nil {
            return ""
        }
        let str = obj as? String
        return str ?? ""
    }
    
    // isEmpty
    class func isEmptyForStrings(_ strings: String?...) -> Bool {
        for string in strings {
            if string == nil {
                return true
            }
            if string!.isEmpty {
                return true
            }
            if (string! as NSObject) is NSNull {
                return true
            }
            if string == "null" {
                return true
            }
        }
        return false
    }
    //空字符串转换成空格（防止自动布局计算高度失败）
    class func cannotEmptyString(str:String?) -> String {
        if TJFString.isEmptyString(str) {
            return " "
        }else {
            return str!
        }
    }
}
