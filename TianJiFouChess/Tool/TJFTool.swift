//
//  TJFTool.swift
//  TianJiFouChess
//
//  Created by 天机否 on 2017/5/16.
//  Copyright © 2017年 tianjifou. All rights reserved.
//

import Foundation
import Hyphenate
class TJFTool {
    static func errorForCode(code:EMErrorCode){
        switch code {
        case EMErrorNetworkUnavailable:
            PAMBManager.sharedInstance.showBriefMessage(message: "网络异常")
        case EMErrorInvalidUsername:
            PAMBManager.sharedInstance.showBriefMessage(message: "用户名无效")
        case EMErrorInvalidPassword:
            PAMBManager.sharedInstance.showBriefMessage(message: "密码无效")
        case EMErrorUserAlreadyLogin:
            PAMBManager.sharedInstance.showBriefMessage(message: "用户已登录")
        case EMErrorUserAuthenticationFailed:
            PAMBManager.sharedInstance.showBriefMessage(message: "密码验证失败")
        case EMErrorUserAlreadyExist:
            PAMBManager.sharedInstance.showBriefMessage(message: "用户已存在")
        case EMErrorUserNotFound:
            PAMBManager.sharedInstance.showBriefMessage(message: "用户不存在")
        case EMErrorUserLoginOnAnotherDevice:
            PAMBManager.sharedInstance.showBriefMessage(message: "当前用户在另一台设备上登录")
        case EMErrorUserRegisterFailed:
            PAMBManager.sharedInstance.showBriefMessage(message: "用户注册失败")
        case EMErrorServerNotReachable:
            PAMBManager.sharedInstance.showBriefMessage(message: "服务器未连接 ")
        case EMErrorServerTimeout:
            PAMBManager.sharedInstance.showBriefMessage(message: "服务器超时")
        case EMErrorServerBusy:
            PAMBManager.sharedInstance.showBriefMessage(message: "服务器忙碌")
            
        default:
            PAMBManager.sharedInstance.showBriefMessage(message: "网络异常,请稍后再试！")
        }
    }
    
    static func setRootVCToViewController(identifier:String){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: identifier)
        let nvc = UINavigationController.init(rootViewController: vc)
        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = nvc
    }
    
    static func setRootVCInitialViewController(storyboardName: String) {
        let storyBoard = UIStoryboard(name: storyboardName, bundle: nil)
        if  let vc = storyBoard.instantiateInitialViewController() {
           
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = vc
        }
       
    }
    
    static func loginOutMessage(message:String) {
        TJFTool.setRootVCInitialViewController(storyboardName: "Login")
        let alertView = UIAlertController.init(title: "提示", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction.init(title: "知道了", style: .cancel, handler: nil)
        alertView.addAction(alertAction)
        let vc =  (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController
        vc?.present(alertView, animated: true, completion: nil)
    }
    
    static func timeWithTimeInterVal(time:Int64) -> String {
      let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
         formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = Date.init(timeIntervalSince1970: Double(time)/1000.0)
        let str = formatter.string(from: date)
        return str
    }
    
    static func greatThan(a:Float,b:Float)->Bool {
        return a >= b*1.1
    }
    
    static func greatOrEqualThan(a:Float,b:Float)->Bool {
        return a * 1.1 >= b
    }
    static func littleThan(a:Float,b:Float)->Bool {
        return a * 1.1 <= b
    }
    static func littleOrEqualThan(a:Float,b:Float)->Bool {
        return a <= b * 1.1
    }
    static func equal(a:Float,b:Float)->Bool {
       return (a * 1.1 >= b) && (a <= b * 1.1)
    }
    
   static func pushToChessChatRoom(_ name:String,_ role: Role,chessType:GameType) {
       guard  let cureentVc = self.getCurrentVC() else {
          return
       }
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ChessViewcontrollerID") as! ChessViewController
        vc.toSomePeople = name
        vc.role = role
        vc.viewType = .online
        vc.chessType = chessType
        vc.hidesBottomBarWhenPushed = true
        cureentVc.navigationController?.pushViewController(vc, animated: true)
        
    }
   static func getCurrentVC() -> UIViewController?{
        if let topController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarViewController{
            if let topSelectVC = topController.selectedViewController as? UINavigationController,let currentMainVC = topSelectVC.viewControllers.last{
                return currentMainVC.navigationController?.viewControllers.last
            }
        }
        return nil
    }
}
