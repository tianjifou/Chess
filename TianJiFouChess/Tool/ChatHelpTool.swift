//
//  ChatHelpTool.swift
//  TianJiFouChess
//
//  Created by 天机否 on 2017/5/17.
//  Copyright © 2017年 tianjifou. All rights reserved.
//

import UIKit
import Hyphenate

class ChatHelpTool: NSObject,EMGroupManagerDelegate,EMChatroomManagerDelegate {
    static let share = ChatHelpTool()
    var gotoChessVCBlock:((String,Role)->())?
    var reconnectTimer:Timer!
    var networkState:((EMConnectionState)->())?
    var buZiChessMessage:((EMMessage?)->())?
    var reloadFriendList:(()->())?
    private override init() {
        super.init()
        EMClient.shared().add(self, delegateQueue: nil)
        EMClient.shared().chatManager.add(self, delegateQueue: nil)
        EMClient.shared().contactManager.add(self, delegateQueue: nil)
        EMClient.shared().groupManager.add(self, delegateQueue: nil)
        EMClient.shared().roomManager.add(self, delegateQueue: nil)
       
    }
    
    fileprivate func reconnectNetwork() {
      let error =  EMClient.shared().uploadLogToServer
        print(error)
    }
   
    
    
    deinit {
        EMClient.shared().removeDelegate(self)
        EMClient.shared().chatManager.remove(self)
        EMClient.shared().contactManager.removeDelegate(self)
        EMClient.shared().groupManager.removeDelegate(self)
        EMClient.shared().roomManager.remove(self)
    }
}
extension ChatHelpTool: EMClientDelegate{
    
    func connectionStateDidChange(_ aConnectionState: EMConnectionState) {
        networkState?(aConnectionState)
        switch aConnectionState {
        case EMConnectionConnected:
            print("服务器已经连上")
            if reconnectTimer != nil {
                reconnectTimer.invalidate()
                reconnectTimer = nil
            }
           
        case EMConnectionDisconnected:
            print("服务器已断开")
            if reconnectTimer != nil {
                reconnectTimer.invalidate()
                reconnectTimer = nil
            }
            
            DispatchQueue.global().async {
                self.reconnectTimer = Timer.weak_scheduledTimerWithTimeInterval(2, selector: { [weak self] in
                    self?.reconnectNetwork()
                    
                    }, repeats: true)
                self.reconnectTimer.fire()
                RunLoop.current.add(self.reconnectTimer, forMode: RunLoopMode.defaultRunLoopMode)
                RunLoop.current.run()
            }
           
        
            
        default:
            ()
        }
    }
    func autoLoginDidCompleteWithError(_ aError: EMError!) {
        if let error = aError {
            TJFTool.errorForCode(code: error.code)
            TJFTool.loginOutMessage(message: "自动登录失败，请重新登录。")
        }else {
             PAMBManager.sharedInstance.showBriefMessage(message: "自动登录成功")
        }
    }
    //异地登录
    func userAccountDidLoginFromOtherDevice() {
       TJFTool.loginOutMessage(message: "该账号在其他设备上登录,请重新登录。")
    }
    
    func userAccountDidRemoveFromServer() {
        TJFTool.loginOutMessage(message: "当前登录账号已经被从服务器端删除,请重新登录")
    }
    
    func userDidForbidByServer() {
        TJFTool.loginOutMessage(message: "服务被禁用,请重新登录")
    }
}
//发送消息
extension ChatHelpTool {
    
   static func sendTextMessage(text:String,toUser:String,messageType:EMChatType,messageExt:[String:Any]?) ->EMMessage?{
      let body = EMTextMessageBody.init(text: text)
      let from = EMClient.shared().currentUsername
      let message  = EMMessage.init(conversationID: toUser, from: from, to: toUser, body: body, ext: messageExt)
        message?.chatType = messageType
        return message
    }
    
  static  func senMessage(aMessage:EMMessage,progress aProgressBlock:(( _ progres: Int32)->())?,completion aCompletionBlock:((_ message:EMMessage?,_ error:EMError?)->())?) {
        
        DispatchQueue.global().async {
           EMClient.shared().chatManager.send(aMessage, progress: aProgressBlock,completion:aCompletionBlock)
        }
        
    }
}

extension ChatHelpTool: EMChatManagerDelegate{
    //会话列表发生变化<EMConversation>
    func conversationListDidUpdate(_ aConversationList: [Any]!) {
         print("会话列表发生变化")
    }
    //收到消息
    func messagesDidReceive(_ aMessages: [Any]!) {
        aMessages.forEach { (message) in
            if let message = message as? EMMessage {
              
                if  let data = message.ext as? [String:Any] {
                    let model = MessageModel.init(dictionary: data)
                    if model.gameType == "1" {
                    
                    NotificationCenter.default.post(name: BaseViewController.letterOfChallenge, object: self, userInfo: ["userName":message.from,"message":(model.challengeList?.message).noneNull])
                    }else if model.gameType == "2" {
                       gotoChessVCBlock?(message.from,.blacker)
                    }else {
                       self.buZiChessMessage?(message)
                    }
                }
                
            }
        }
    }
    //收到已读回执
    func messagesDidRead(_ aMessages: [Any]!) {
        print("收到已读回执")
    }
    //收到消息送达回执
    func messagesDidDeliver(_ aMessages: [Any]!) {
        print("收到消息送达回执")
        aMessages.forEach { (message) in
            if let message = message as? EMMessage {
                if  let data = message.ext as? [String:Any] {
                    let model = MessageModel.init(dictionary: data)
                     if model.gameType == "3" {
                       
                    }
                }
               print(message.messageId)
               print(TJFTool.timeWithTimeInterVal(time: message.timestamp),TJFTool.timeWithTimeInterVal(time: message.localTime))
                
            }
        }
    }
    //消息状态发生变化
    func messageStatusDidChange(_ aMessage: EMMessage!, error aError: EMError!){
         print("消息状态发生变化")
    }
    
    
    
}
extension ChatHelpTool: EMContactManagerDelegate {
    //用户B同意用户A的加好友请求后，用户A会收到这个回调
    func friendRequestDidApprove(byUser aUsername: String!) {
        print("同意\(aUsername)申请加好友")
        PAMBManager.sharedInstance.showBriefMessage(message: "对方同意了你的好友请求！")
    }

    // 用户B拒绝用户A的加好友请求后，用户A会收到这个回调
    func friendRequestDidDecline(byUser aUsername: String!) {
        print("拒绝\(aUsername)申请加好友")
        PAMBManager.sharedInstance.showBriefMessage(message: "对方拒绝了你的好友请求！")
    }
    //用户B删除与用户A的好友关系后，用户A，B会收到这个回调
    func friendshipDidRemove(byUser aUsername: String!) {
        
    }
    //用户B同意用户A的好友申请后，用户A和用户B都会收到这个回调
    func friendshipDidAdd(byUser aUsername: String!) {
         print("\(aUsername)同意申请加好友")
    }
    //用户B申请加A为好友后，用户A会收到这个回调
    func friendRequestDidReceive(fromUser aUsername: String!, message aMessage: String!) {
        print("\(aUsername)申请加好友,原因是\(aMessage)")
        let alertView = UIAlertController.init(title: "\(aUsername!)申请加好友", message: "\(aMessage!)", preferredStyle: .alert)
        let alertAction = UIAlertAction.init(title: "同意", style: .default) { (action) in
            EMClient.shared().contactManager.acceptInvitation(forUsername: aUsername)
            self.reloadFriendList?()
        }
        let rejectAction = UIAlertAction.init(title: "拒绝", style: .default) { (action) in
            EMClient.shared().contactManager.declineInvitation(forUsername: aUsername)
        }
        alertView.addAction(rejectAction)
        alertView.addAction(alertAction)
        let vc =  (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController
        if let currentVC = vc?.navigationController?.viewControllers.last {
            currentVC.present(alertView, animated: true, completion: nil)
        }else{
           vc!.present(alertView, animated: true, completion: nil)
        }
        
        
    }
}




