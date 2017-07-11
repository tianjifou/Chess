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
    var chessType:GameType = .fiveInRowChess
    private var chessView: ChessboardView!
    private var fiveChessView:FiveInARowChessboardView!
    @IBOutlet weak var againBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        if chessType == .fiveInRowChess{
            self.title = "五子棋"
            test()
        }else {
            self.title = "六洲棋"
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
            
           
        }
        
        if viewType == ChessType.manAnMachine {
            againBtn.isHidden = true
        }
        getMessage()
       
    }
    
    func test() {
        fiveChessView = FiveInARowChessboardView()
        fiveChessView.frame = CGRect.init(x: 10, y: 64, width: ScreenWidth, height: ScreenWidth)
        fiveChessView.backgroundColor = UIColor.clear
        fiveChessView.center = self.view.center
        fiveChessView.viewType = viewType
        fiveChessView.role = .blacker
        fiveChessView.toSomePeople = toSomePeople
        fiveChessView.tiShiBlock = { [weak self](message) in
            guard let weakSelf = self else {
                return
            }
            weakSelf.alertView(message: message)
            
        }
        self.view.addSubview(fiveChessView)
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
                if weakSelf.chessType == .LiuZhouChess{
                     weakSelf.chessView.isUser = false
                }else if weakSelf.chessType == .fiveInRowChess{
                     weakSelf.fiveChessView.isUser = false
                }
               
                switch model.gameType.noneNull {
                case "3":
                    let swsPoint = SWSPoint()
                    swsPoint.x = model.pointList?.xx as? Int ?? 0
                    swsPoint.y = model.pointList?.yy as? Int ?? 0
                    if weakSelf.chessType == .LiuZhouChess{
                         weakSelf.chessView.bujuChess(swsPoint: swsPoint)
                    }else if weakSelf.chessType == .fiveInRowChess{
                        weakSelf.fiveChessView.moveChess(swsPoint: swsPoint)
                    }
                   
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
                                if weakSelf.chessType == .LiuZhouChess{
                                    weakSelf.chessView.regretChess(active: false)
                                }else if weakSelf.chessType == .fiveInRowChess{
                                    weakSelf.fiveChessView.regretChess(active: false)
                                }
                                
                            })
                        }
                        alertView.addAction(okAction)
                        weakSelf.present(alertView, animated: true, completion: nil)
                case "6":
                    PAMBManager.sharedInstance.showBriefMessage(message: "对方同意你悔棋！")
                    if weakSelf.chessType == .LiuZhouChess{
                        weakSelf.chessView.regretChess(active: true)
                    }else if weakSelf.chessType == .fiveInRowChess{
                         weakSelf.fiveChessView.regretChess(active: true)
                    }
                  
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
                            if weakSelf.chessType == .LiuZhouChess{
                                weakSelf.chessView.role = weakSelf.role
                                weakSelf.chessView.startAgain()
                            }else if weakSelf.chessType == .fiveInRowChess{
                                weakSelf.fiveChessView.role = weakSelf.role
                                weakSelf.fiveChessView.startAgain()
                            }
                            
                        })
                    
                    }
                    alertView.addAction(okAction)
                    weakSelf.present(alertView, animated: true, completion: nil)
                case "9":
                    PAMBManager.sharedInstance.showBriefMessage(message: "对方同意再来一局！")
                    if weakSelf.chessType == .LiuZhouChess{
                        weakSelf.chessView.role = weakSelf.role
                        weakSelf.chessView.startAgain()
                    }else if weakSelf.chessType == .fiveInRowChess{
                        weakSelf.fiveChessView.role = weakSelf.role
                        weakSelf.fiveChessView.startAgain()
                    }
                    
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
            if weakSelf.chessType == .LiuZhouChess{
                weakSelf.chessView.isUser = false
            }else if weakSelf.chessType == .fiveInRowChess{
                weakSelf.fiveChessView.isUser = false
            }
            switch model.typeRole {
            case 1,2:
                
                    if weakSelf.chessType == .LiuZhouChess{
                        if weakSelf.chessView.role == nil {
                            if model.typeRole == 1 {
                                weakSelf.chessView.role = .blacker
                            }else {
                                weakSelf.chessView.role = .whiter
                            }
                        }
                        
                    }else if weakSelf.chessType == .fiveInRowChess{
                        if weakSelf.fiveChessView.role == nil {
                            if model.typeRole == 1 {
                                weakSelf.fiveChessView.role = .blacker
                            }else {
                                weakSelf.fiveChessView.role = .whiter
                            }
                        }
                        
                    }
                    
               
                
                
                let swsPoint = SWSPoint()
                swsPoint.x = Int(model.point.xx )
                swsPoint.y = Int(model.point.yy )
                if weakSelf.chessType == .LiuZhouChess{
                    weakSelf.chessView.bujuChess(swsPoint: swsPoint)
                }else if weakSelf.chessType == .fiveInRowChess{
                   weakSelf.fiveChessView.moveChess(swsPoint: swsPoint)
                }
                
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
                    if weakSelf.chessType == .LiuZhouChess{
                        weakSelf.chessView.regretChess(active: false)
                    }else if weakSelf.chessType == .fiveInRowChess{
                        weakSelf.fiveChessView.regretChess(active: false)
                    }
                    
                    })
                   
                }
                alertView.addAction(okAction)
                weakSelf.present(alertView, animated: true, completion: nil)
            case 5:
                PAMBManager.sharedInstance.showBriefMessage(message: "对方同意你悔棋！")
                if weakSelf.chessType == .LiuZhouChess{
                   weakSelf.chessView.regretChess(active: true)
                }else if weakSelf.chessType == .fiveInRowChess{
                    weakSelf.fiveChessView.regretChess(active: true)
                }
                
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
                        if weakSelf.chessType == .LiuZhouChess{
                            weakSelf.chessView.isWaiting = false
                            weakSelf.chessView.role = nil
                            weakSelf.chessView.startAgain()
                        }else if weakSelf.chessType == .fiveInRowChess{
                            weakSelf.fiveChessView.isWaiting = false
                            weakSelf.fiveChessView.role = nil
                            weakSelf.fiveChessView.startAgain()
                        }
                       
                    })
                    
                    
                }
                alertView.addAction(okAction)
                weakSelf.present(alertView, animated: true, completion: nil)
            case 8:
                 PAMBManager.sharedInstance.showBriefMessage(message: "对方同意再来一局！")
                 if weakSelf.chessType == .LiuZhouChess{
                    weakSelf.chessView.role = nil
                    weakSelf.chessView.startAgain()
                 }else if weakSelf.chessType == .fiveInRowChess{
                    weakSelf.fiveChessView.role = nil
                    weakSelf.fiveChessView.startAgain()
                 }
                
            case 9:
                 PAMBManager.sharedInstance.showBriefMessage(message: "对方不同意再来一局！")
            case 10:
                weakSelf.alertView(message: "恭喜你赢了！")
                
            default:()
                
            }
            
            
        }
    }
    
        
    override func backAction() {
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
                if self.chessType == .LiuZhouChess{
                    chessView.isWaiting = false
                    chessView.startAgain()
                }else if self.chessType == .fiveInRowChess{
                    fiveChessView.isWaiting = false
                    fiveChessView.startAgain()
                }
               
            }else if viewType == ChessType.bluetooth {
                self.createBluetoothMessageVo(type: 7)
            }else if viewType == ChessType.online {
                self.createSendMessageDic(type: "8")
            }else if viewType == ChessType.aiGame{/////to do
                
        }
        
    }

    @IBAction func regretChessActoin(_ sender: Any) {
        if chessType == .LiuZhouChess{
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
            
            
        }else{
            var whiteCount = 0
            var blackCount = 0
            for i in 0..<15 {
                for j in 0..<15 {
                    if fiveChessView.chessArray[i][j] == .whiteChess {
                        whiteCount += 1
                    }
                    if fiveChessView.chessArray[i][j] == .blackChess {
                        blackCount += 1
                    }
                }
            }
            
            if whiteCount == 0 {
                if fiveChessView.role == .whiter {
                    return
                }
                if blackCount == 0 {
                    return
                }
                
            }
            
            if blackCount == 0 {
                if fiveChessView.role == .blacker {
                    return
                }
            }
        }
        
        if viewType == .bluetooth {
            createBluetoothMessageVo(type: 4)
        }else if viewType == .online{
            createSendMessageDic(type: "5")
        }else if viewType == .aiGame {
            self.fiveChessView.regretChess(active: false)
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
                if chessType == .LiuZhouChess{
                    chessView.isWaiting = true
                }else if chessType == .fiveInRowChess {
                    fiveChessView.isWaiting = true
                }
                
                PAMBManager.sharedInstance.showBriefMessage(message: "对方认输，游戏结束。")
            }else if viewType == ChessType.bluetooth {
                self.createBluetoothMessageVo(type: 10)
            }else if viewType == ChessType.online {
                self.createSendMessageDic(type: "11")
            }else if viewType == .aiGame {
                PAMBManager.sharedInstance.showBriefMessage(message: "别灰心，再接再厉。")
                fiveChessView.isWaiting = true
        }
        
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("释放五子棋棋室")
    }

 

}
