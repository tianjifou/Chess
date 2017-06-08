//
//  BaseViewController.swift
//  TianJiFouChess
//
//  Created by 天机否 on 2017/5/15.
//  Copyright © 2017年 tianjifou. All rights reserved.
//

import UIKit
import MBProgressHUD
import Hyphenate
class BaseViewController: UIViewController {
    static let letterOfChallenge = NSNotification.Name.init("letterOfChallenge")
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(letterOfChallengeAction(_:)), name: BaseViewController.letterOfChallenge, object: nil)
        
        
        ChatHelpTool.share.gotoChessVCBlock = { [weak self] (userName,role)in
            self?.pushToChessChatRoom(userName,role)
        }
        ChatHelpTool.share.networkState = { (state) in
            switch state {
            case EMConnectionConnected:()
                
            case EMConnectionDisconnected:
                PAMBManager.sharedInstance.showBriefMessage(message: "服务器已断开连接，请重试")
            default:
                ()
            }
        }
        
    }
    
    fileprivate  func pushToChessChatRoom(_ name:String,_ role: Role) {
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyBoard.instantiateViewController(withIdentifier: "ChessViewcontrollerID") as! ChessViewController
        vc.toSomePeople = name
        vc.role = role
        vc.viewType = .online
    self.navigationController?.pushViewController(vc, animated: true)
       
    }
    
    func letterOfChallengeAction(_ notification: NSNotification) {
        guard let info = notification.userInfo  else{return}
        guard let userName = info["userName"] else {
            return
        }
        let message = info["message"] as? String
        let alertView = UIAlertController.init(title: "\(userName)向你发起了挑战", message: message.noneNull , preferredStyle: .alert)
        let alertAction = UIAlertAction.init(title: "拒绝", style: .cancel, handler: nil)
       
        alertView.addAction(alertAction)
        let challengeAction = UIAlertAction.init(title: "接受", style: .default) { (action) in
            
            let dic = ["gameType":"2","challengeList":["from":EMClient.shared().currentUsername,"to":userName,"message":""]] as [String : Any]
            guard let message = ChatHelpTool.sendTextMessage(text: "games", toUser: userName as! String, messageType: EMChatTypeChat, messageExt: dic)else{
                return
            }
            ChatHelpTool.senMessage(aMessage: message, progress: nil, completion: { (message, error) in
                if let error = error {
                    TJFTool.errorForCode(code: error.code)
                }else{
                    PAMBManager.sharedInstance.showBriefMessage(message: "发送成功")
                    self.pushToChessChatRoom(userName as! String,.whiter)
                }
                print(message ?? "",error ?? "")
            })
        }
        alertView.addAction(challengeAction)
        self.present(alertView, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
      
    }

}

