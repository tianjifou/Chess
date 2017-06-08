//
//  ChessViewController.swift
//  TianJiFouChess
//
//  Created by 天机否 on 17/4/28.
//  Copyright © 2017年 tianjifou. All rights reserved.
//

import UIKit
import Hyphenate
import Protobuf
class ChessViewController: BaseViewController {
    var viewType:ChessType?
    var toSomePeople:String?
    var role:Role?
    private var chessView: ChessboardView!
    @IBOutlet weak var againBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
         self.title = "顺子棋"
        // Do any additional setup after loading the view.
        chessView = ChessboardView()
        chessView.viewType = viewType
        chessView.frame = CGRect.init(x: (ScreenWidth-320)*0.5, y: 64, width: 320, height: 320)
        chessView.backgroundColor = UIColor.clear
        chessView.center = self.view.center
        chessView.role = role
        chessView.toSomePeople = toSomePeople
        chessView.tiShiBlock = { [weak self](message) in
            guard let weakSelf = self else {
                return
            }
           weakSelf.alertView(message: message)
            
        }
        self.view.addSubview(chessView)
        
        if viewType == ChessType.manAnMachine {
            againBtn.isHidden = true
        }
       let leftBtn = customLeftBackButtonItem()
       navigationItem.leftBarButtonItem = leftBtn
        getMessage()
    }
    
    func alertView(message:String) {
        let alertView = UIAlertController.init(title: "提示", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction.init(title: "知道了", style: .cancel, handler: nil)
        alertView.addAction(alertAction)
        self.present(alertView, animated: true, completion: nil)
    }
    
    private func getMessage() {
        ChatHelpTool.share.buZiChessMessage = { [weak self] (message) in
            guard let weakSelf = self else {
                return
            }
            guard let message = message else {
                return
            }
            if  let data = message.ext as? [String:Any] {
                let model = MessageModel.init(dictionary: data)
                weakSelf.chessView.isUser = false
                switch model.gameType.noneNull {
                case "3":
                    let swsPoint = SWSPoint()
                    swsPoint.x = model.pointList?.xx as? Int ?? 0
                    swsPoint.y = model.pointList?.yy as? Int ?? 0
                    weakSelf.chessView.bujuChess(swsPoint: swsPoint)
                case "4":
                    weakSelf.alertView(message: "对方已退出游戏")
                case "5":
                    
                        let alertView = UIAlertController.init(title: "悔棋", message: "您同意对方悔棋吗？", preferredStyle: .alert)
                        let alertAction = UIAlertAction.init(title: "拒绝", style: .cancel, handler: {(actin) in
                            weakSelf.createSendMessageDic(type: "7")
                            
                        })
                        alertView.addAction(alertAction)
                        let okAction = UIAlertAction.init(title: "同意", style: .default) { (action) in
                            
                            weakSelf.createSendMessageDic(type: "6",success: {
                                weakSelf.chessView.regretChess(active: false)
                            })
                        }
                        alertView.addAction(okAction)
                        weakSelf.present(alertView, animated: true, completion: nil)
                case "6":
                    PAMBManager.sharedInstance.showBriefMessage(message: "对方同意你悔棋！")
                    weakSelf.chessView.regretChess(active: true)
                case "7":
                    PAMBManager.sharedInstance.showBriefMessage(message: "对方不同意你悔棋！")
                case "8":
                    let alertView = UIAlertController.init(title: "重新来一局", message: "对方请求再来一局。", preferredStyle: .alert)
                    let alertAction = UIAlertAction.init(title: "拒绝", style: .cancel, handler: {(actin) in
                        weakSelf.createSendMessageDic(type: "10")
                        
                    })
                    alertView.addAction(alertAction)
                    let okAction = UIAlertAction.init(title: "同意", style: .default) { (action) in
                        
                        weakSelf.createSendMessageDic(type: "9", success: {
                            weakSelf.chessView.role = weakSelf.role
                            weakSelf.chessView.startAgain()
                        })
                    
                    }
                    alertView.addAction(okAction)
                    weakSelf.present(alertView, animated: true, completion: nil)
                case "9":
                    PAMBManager.sharedInstance.showBriefMessage(message: "对方同意再来一局！")
                    weakSelf.chessView.role = weakSelf.role
                    weakSelf.chessView.startAgain()
                case "10":
                    PAMBManager.sharedInstance.showBriefMessage(message: "对方不同意再来一局！")
                case "11":
                    weakSelf.alertView(message: "恭喜你赢了！")
                default:
                    ()
                }
                
            }
            
            
        }
        
        BluetoothTool.blueTooth.getMessageBlock = {[weak self](message) in
            guard let weakSelf = self else {
                return
            }
            guard let model = message as? ChallengeMessage  else {
                return
            }
             weakSelf.chessView.isUser = false
            switch model.typeRole {
            case 1,2:
                if weakSelf.chessView.role == nil {
                    if model.typeRole == 1 {
                        weakSelf.chessView.role = .blacker
                    }else {
                        weakSelf.chessView.role = .whiter
                    }
                }
                
                
                let swsPoint = SWSPoint()
                swsPoint.x = Int(model.point.xx )
                swsPoint.y = Int(model.point.yy )
                weakSelf.chessView.bujuChess(swsPoint: swsPoint)
            case 3:
                weakSelf.alertView(message: "对方已退出游戏")
            case 4:
                let alertView = UIAlertController.init(title: "悔棋", message: "您同意对方悔棋吗？", preferredStyle: .alert)
                let alertAction = UIAlertAction.init(title: "拒绝", style: .cancel, handler: {(actin) in
                    weakSelf.createBluetoothMessageVo(type: 6)
                    
                })
                alertView.addAction(alertAction)
                let okAction = UIAlertAction.init(title: "同意", style: .default) { (action) in
                    
                   weakSelf.createBluetoothMessageVo(type: 5, success: {
                       weakSelf.chessView.regretChess(active: false)
                    })
                   
                }
                alertView.addAction(okAction)
                weakSelf.present(alertView, animated: true, completion: nil)
            case 5:
                PAMBManager.sharedInstance.showBriefMessage(message: "对方同意你悔棋！")
                weakSelf.chessView.regretChess(active: true)
            case 6:
                PAMBManager.sharedInstance.showBriefMessage(message: "对方不同意你悔棋！")
            case 7:
                let alertView = UIAlertController.init(title: "重新来一局", message: "对方请求再来一局。", preferredStyle: .alert)
                let alertAction = UIAlertAction.init(title: "拒绝", style: .cancel, handler: {(actin) in
                    weakSelf.createBluetoothMessageVo(type: 9)
                    
                })
                alertView.addAction(alertAction)
                let okAction = UIAlertAction.init(title: "同意", style: .default) { (action) in
                    
                    weakSelf.createBluetoothMessageVo(type: 8, success: {
                        weakSelf.chessView.isWaiting = false
                        weakSelf.chessView.role = nil
                        weakSelf.chessView.startAgain()
                    })
                    
                    
                }
                alertView.addAction(okAction)
                weakSelf.present(alertView, animated: true, completion: nil)
            case 8:
                 PAMBManager.sharedInstance.showBriefMessage(message: "对方同意再来一局！")
                 weakSelf.chessView.role = nil
                 weakSelf.chessView.startAgain()
            case 9:
                 PAMBManager.sharedInstance.showBriefMessage(message: "对方不同意再来一局！")
            case 10:
                weakSelf.alertView(message: "恭喜你赢了！")
                
            default:()
                
            }
            
            
        }
    }
    
    
   private func customLeftBackButtonItem() -> UIBarButtonItem {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: 25.0, height: 18.0)
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        btn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        btn.setImage(#imageLiteral(resourceName: "back_leftButton"), for: .normal)
        btn.contentHorizontalAlignment = .left
        return UIBarButtonItem(customView: btn)
    }
    
    func backAction() {
        let alertView = UIAlertController.init(title: "退出", message: "你确定退出游戏吗？", preferredStyle: .alert)
        let alertAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        alertView.addAction(alertAction)
        let okAction = UIAlertAction.init(title: "退出", style: .default) { (action) in
            if self.viewType == .bluetooth {
                self.createBluetoothMessageVo(type: 3)

            }else if self.viewType == .online {
                self.createSendMessageDic(type: "4")
            }
            
             self.navigationController?.popViewController(animated: true)
        }
        alertView.addAction(okAction)
        self.present(alertView, animated: true, completion: nil)
        
        
        
    }
    
    @IBAction func startAgainAction(_ sender: Any) {
        if viewType == ChessType.manAnMachine {
            chessView.isWaiting = false
            chessView.startAgain()
        }else if viewType == ChessType.bluetooth {
            self.createBluetoothMessageVo(type: 7)
        }else if viewType == ChessType.online {
           self.createSendMessageDic(type: "8")
        }
    }

    @IBAction func regretChessActoin(_ sender: Any) {
        var whiteCount = 0
        var blackCount = 0
        for i in 0...5 {
            for j in 0...5 {
                if chessView.chessArray[i][j] == .whiteChess {
                    whiteCount += 1
                }
                if chessView.chessArray[i][j] == .blackChess {
                    blackCount += 1
                }
            }
        }
        
        if whiteCount == 0 {
            if chessView.role == .whiter {
                return
            }
            if blackCount == 0 {
                return
            }
            
        }
        
        if blackCount == 0 {
            if chessView.role == .blacker {
                return
            }
        }
        
        
        if viewType == .bluetooth {
           createBluetoothMessageVo(type: 4)
        }else {
           createSendMessageDic(type: "5")
        }
     
    }
    
    fileprivate func createBluetoothMessageVo(type:UInt32,success:(()->())? = nil) {
        let messageVo = ChallengeMessage()
        messageVo.from = UIDevice.current.name
        messageVo.to = (BluetoothTool.blueTooth.myPeer?.displayName).noneNull
        messageVo.typeRole = type
        BluetoothTool.blueTooth.sendData(messageVo, successBlock: {
            success?()
        }) { (error) in
            PAMBManager.sharedInstance.showBriefMessage(message: "\(error)")
        }
    }
    
    fileprivate func createSendMessageDic(type:String,success:(()->())? = nil) {
        let dic = ["gameType":type,"pointList":["from":EMClient.shared().currentUsername,"to":toSomePeople ?? "","role": role == .whiter ? "1" : "2"]] as [String : Any]
        guard let message = ChatHelpTool.sendTextMessage(text: "games", toUser: toSomePeople.noneNull, messageType: EMChatTypeChat, messageExt: dic)else{
            return
        }
        ChatHelpTool.senMessage(aMessage: message, progress: nil, completion: { (message, error) in
            if let error = error {
                TJFTool.errorForCode(code: error.code)
            }else{
                success?()
            }
            print(message ?? "",error ?? "")
        })
    }
    
    @IBAction func giveUpAction(_ sender: Any) {
        if viewType == ChessType.manAnMachine {
            chessView.isWaiting = false
            chessView.giveUp()
        }else if viewType == ChessType.bluetooth {
            self.createBluetoothMessageVo(type: 10)
        }else if viewType == ChessType.online {
            self.createSendMessageDic(type: "11")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 

}
