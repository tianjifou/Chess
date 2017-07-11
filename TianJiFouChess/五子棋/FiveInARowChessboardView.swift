//
//  FiveInARowChessboardView.swift
//  TianJiFouChess
//
//  Created by 天机否 on 2017/6/19.
//  Copyright © 2017年 tianjifou. All rights reserved.
//

import UIKit
import Hyphenate
class FiveInARowChessboardView: UIView {
    let fiveChessWidth:CGFloat = (ScreenWidth - 20)/14
    var role:Role? {
        didSet {
            if role == .whiter {
                self.isWaiting = true
            }else {
                self.isWaiting = false
            }
        }
    }
    var roleState:RoleState = .blackState
    var tiShiBlock:((String)->())?
    var loadingViewBlock:((String)->())?
    var tempView:FlagImageView?
    var viewType:ChessType?
    var toSomePeople:String?
    var AIScore:[[Int]] = Array.init(repeating: Array.init(repeating: 0, count: 15), count: 15)
    var humanScore:[[Int]] = Array.init(repeating: Array.init(repeating: 0, count: 15), count: 15)
    var isWaiting = false
    var isUser = true
    lazy var chessArray:[[FlagType]] = {
        var arrData:[[FlagType]] = []
        for _ in 0..<15{
            var arr:[FlagType] = []
            for _ in 0..<15 {
                arr.append(FlagType.freeChess)
            }
            arrData.append(arr)
        }
        return arrData
    }()
 
    fileprivate var whiteLastChessArray:[[FlagType]] = []
    fileprivate var blackLastChessArray:[[FlagType]] = []
    fileprivate var roleStateLast:RoleState = .blackState
    fileprivate var whiteRegretChessModel = RegretChessModel()
    fileprivate var blackRegretChessModel = RegretChessModel()
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.backgroundColor = UIColor.clear
        createLine()
        
      
    }
    func createLine() {
        for index in 0..<15 {
            let layerCrossWise = CALayer()
            layerCrossWise.frame = CGRect.init(x: 10, y: 10+fiveChessWidth*CGFloat(index), width: (ScreenWidth - 20) , height: 1)
            layerCrossWise.backgroundColor = UIColor.black.cgColor
            self.layer.addSublayer(layerCrossWise)
            
            let layerVertical = CALayer()
            layerVertical.frame = CGRect.init(x: 10+fiveChessWidth*CGFloat(index), y: 10, width: 1 , height: (ScreenWidth - 20))
            layerVertical.backgroundColor = UIColor.black.cgColor
            self.layer.addSublayer(layerVertical)
        }
        if self.viewType == .aiGame && self.role == .blacker && chessArray[7][7] == .freeChess{
            let sws = SWSPoint()
            sws.x = 7
            sws.y = 7
            self.isWaiting = true
            moveChess(swsPoint: sws)
            self.isWaiting = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      
        guard let location = touches.first?.location(in: self) else {
            return
        }
        
        guard let type = viewType else {
            return
        }
        if isWaiting{
            return
        }
        switch type {
        case ChessType.aiGame:
            manAnMachineChess(location:location)
        case ChessType.manAnMachine:
            manAnMachineChess(location:location)
        case ChessType.bluetooth:
            bluetoothChess(location: location)
        case ChessType.online:
            sendMessageChess(location: location)
            
        }
        
       
      
        
    }
    fileprivate func manAnMachineChess(location:CGPoint) {
        let  point = ChessStepTool.touchRealFivePoint(location)
        let swsPoint = SWSPoint()
        swsPoint.x = Int(round(Double(point.x-10)/Double(fiveChessWidth)))
        swsPoint.y = Int(round(Double(point.y-10)/Double(fiveChessWidth)))
        moveChess(swsPoint:swsPoint)
       
    }
    
    fileprivate func bluetoothChess(location:CGPoint) {
        let  point = ChessStepTool.touchRealFivePoint(location)
        let swsPoint = SWSPoint()
        swsPoint.x = Int(round(Double(point.x-10)/Double(fiveChessWidth)))
        swsPoint.y = Int(round(Double(point.y-10)/Double(fiveChessWidth)))
        
        
        let messageVo = ChallengeMessage()
        messageVo.from = UIDevice.current.name
        messageVo.to = (BluetoothTool.blueTooth.myPeer?.displayName).noneNull
        messageVo.typeRole = self.role == .blacker ? 2 : 1
        let sendPoint = PointMessage()
        sendPoint.xx = Float(swsPoint.x)
        sendPoint.yy  = Float(swsPoint.y)
        messageVo.point = sendPoint
        
        BluetoothTool.blueTooth.sendData(messageVo, successBlock: {
            self.isUser = true
            self.moveChess(swsPoint: swsPoint)
        }) { (error) in
            PAMBManager.sharedInstance.showBriefMessage(message: "\(error)")
        }
        
    }
    
    fileprivate func sendMessageChess(location:CGPoint) {
        let  point = ChessStepTool.touchRealFivePoint(location)
        let swsPoint = SWSPoint()
        swsPoint.x = Int(round(Double(point.x-10)/Double(fiveChessWidth)))
        swsPoint.y = Int(round(Double(point.y-10)/Double(fiveChessWidth)))
       
        let dic = ["gameType":"3","pointList":["from":EMClient.shared().currentUsername,"to":toSomePeople ?? "","xx":swsPoint.x,"yy":swsPoint.y,"role": role == .whiter ? "1" : "2"]] as [String : Any]
        guard let message = ChatHelpTool.sendTextMessage(text: "games", toUser: toSomePeople!, messageType: EMChatTypeChat, messageExt: dic)else{
            return
        }
        ChatHelpTool.senMessage(aMessage: message, progress: nil, completion: { (message, error) in
            if let error = error {
                TJFTool.errorForCode(code: error.code)
            }else{
                self.isUser = true
                self.moveChess(swsPoint: swsPoint)
            }
            print(message ?? "",error ?? "")
        })
    }
    
    
     func moveChess(swsPoint:SWSPoint) {
        if chessArray[swsPoint.x][swsPoint.y] == FlagType.freeChess
        {
            let flagIageView = FlagImageView()
            flagIageView.tag = 10*swsPoint.x + swsPoint.y + 100
            flagIageView.frame = CGRect.init(x: 0, y: 0, width: fiveChessWidth/2, height: fiveChessWidth/2)
            flagIageView.center = CGPoint.init(x: 10+CGFloat(swsPoint.x)*fiveChessWidth, y: 10+CGFloat(swsPoint.y)*fiveChessWidth)
            self.addSubview(flagIageView)
            canceSelectView()
            flagIageView.transform = CGAffineTransform.identity.scaledBy(x: 1.3, y: 1.3)
            var tempFlag = FlagType.blackChess
            self.regretState(type: roleState)
            if self.roleState == .whiteState {
                flagIageView.image = #imageLiteral(resourceName: "stone_white")
                self.roleState = .blackState
                tempFlag = FlagType.whiteChess
                
            }else if self.roleState == .blackState{
                flagIageView.image = #imageLiteral(resourceName: "stone_black")
                self.roleState = .whiteState
                tempFlag = FlagType.blackChess
                
            }
            flagIageView.flagType = tempFlag
            chessArray[swsPoint.x][swsPoint.y] = tempFlag
            if self.viewType == .aiGame{
               AIFiveInARowChess.updateOneEffectScore(chessArray: chessArray, point: (swsPoint.x,swsPoint.y), AIScore: &AIScore, humanScore: &humanScore)
                logSomeThing()
                self.isWaiting = true
            }else {
                self.isWaiting = self.isUser ? true : false
            }
            if self.viewType == .manAnMachine{
                self.isWaiting = false
            }

            if  ChessStepTool.isFiveChess(swsPoint, chessArray) {
                let strUser = self.isUser ? "您成功形成五子棋。" : "对方成功形成五子棋。"
                self.tiShiBlock?(strUser)
                self.isWaiting =  true
            }else {
                if self.freeChessIsNone() {
                    self.tiShiBlock?("已经无路可走，和棋。")
                    self.isWaiting =  true
                }else{
                    if self.roleState == .blackState && self.viewType == .aiGame {
                        DispatchQueue.global().async { [weak self] in
                            guard let weakSelf = self else {return}
                            DispatchQueue.main.async{
                             PAMBManager.sharedInstance.showLoadingInView(view: weakSelf.superview, labelText: "电脑真在思考中。。。")
                                                           }
                            if  let point =  AIFiveInARowChess.getAIPoint(chessArray: &weakSelf.chessArray, role: .blackChess, AIScore: &weakSelf.AIScore, humanScore: &weakSelf.humanScore, deep: weakSelf.getDeep()){
                                let sws = SWSPoint()
                                sws.x = point.0
                                sws.y = point.1
                                DispatchQueue.main.async {
                                    weakSelf.moveChess(swsPoint: sws)
                                    weakSelf.isWaiting = false
                                  PAMBManager.sharedInstance.hideAlert(view: weakSelf.superview)
                                    
                                }
                                
                                
                            }
                        }
                    }
                }
            }
           
        }
    }
    
    private func getDeep()->Int{
        var count = 0
        for i in 0..<15{
            for j in 0..<15{
                if chessArray[i][j] == .blackChess{
                    count += 1
                }
            }
        }
        if count <= 5{
            return 4
        }else if count <= 10 {
            return 5
        }else if count <= 20 {
            return 6
        }else if count <= 40 {
            return 7
        }else {
            return 8
        }
    }
    
    #if DEBUG
    func logSomeThing() {
        for x in 0..<15 {
            for y in 0..<15 {
               let str = String(AIScore[x][y])
                var strSpace = ""
                for _ in 0...7-str.characters.count{
                   strSpace = strSpace.appending(" ")
                }
                
                print(str+strSpace, terminator: "")
            }
            print("")
        }
    }
    #endif
    private func freeChessIsNone() -> Bool {
        for i in 0..<15 {
            for j in 0..<15 {
                if chessArray[i][j] == FlagType.freeChess {
                    return false
                }
            }
        }
        return true
    }
    
    func startAgain() {
        roleState = .blackState
        isUser = true
        self.subviews.forEach {
            $0.removeFromSuperview()
        }
        self.layer.sublayers?.forEach{
            $0.removeFromSuperlayer()
        }
         chessArray = createChessArray()
        self.createLine()
       
        if viewType == .aiGame{
            AIScore.removeAll()
            humanScore.removeAll()
            AIScore = Array.init(repeating: Array.init(repeating: 0, count: 15), count: 15)
            humanScore = Array.init(repeating: Array.init(repeating: 0, count: 15), count: 15)
            self.role = .blacker
        
        }
       
       
    }
    
    func regretChess(active:Bool) {
       
        self.subviews.forEach {
            $0.removeFromSuperview()
        }
        self.layer.sublayers?.forEach{
            $0.removeFromSuperlayer()
        }
        self.createLine()
        if active {
            regretExchangeState(type: self.role)
        }else {
            
            regretExchangeState(type: self.role == .blacker ? .whiter : .blacker)
        }
        
        createChessImage()
        if active {
            self.isWaiting = false
        }else {
            self.isWaiting = true
        }
        if self.viewType == .aiGame{
           AIFiveInARowChess.udateAllScore(chessArray: chessArray, AIScore: &AIScore, humanScore: &humanScore)
            self.isWaiting = false
        }
        
        
    }
    fileprivate func createChessImage() {
        
        for i in 0..<15 {
            for j in 0..<15 {
                
                if chessArray[i][j] != .freeChess {
                    let flagIageView = FlagImageView()
                    flagIageView.tag = 10*i + j + 100
                    flagIageView.frame = CGRect.init(x: 0, y: 0, width: fiveChessWidth/2, height: fiveChessWidth/2)
                    flagIageView.center = CGPoint.init(x: 10+CGFloat(i)*fiveChessWidth, y: 10+CGFloat(j)*fiveChessWidth)
                    self.addSubview(flagIageView)
                    
                    var tempFlag = FlagType.blackChess
                    self.regretState(type: roleState)
                    if chessArray[i][j] == .whiteChess {
                        flagIageView.image = #imageLiteral(resourceName: "stone_white")
                        tempFlag = FlagType.whiteChess
                        
                    }else if chessArray[i][j] == .blackChess{
                        flagIageView.image = #imageLiteral(resourceName: "stone_black")
                        tempFlag = FlagType.blackChess
                        
                    }
                    flagIageView.flagType = tempFlag
                }
                
            }
        }
        
    }
    fileprivate func regretExchangeState(type:Role?) {
        
        chessArray.removeAll()
        if type == .blacker {
            chessArray  +=  blackRegretChessModel.lastChessArray
            roleState = blackRegretChessModel.roleStateLast
        }else {
            chessArray  += whiteRegretChessModel.lastChessArray
            roleState = whiteRegretChessModel.roleStateLast
        }
        
        if chessArray.count == 0 {
            chessArray = createChessArray()
        }
    }
    
    func createChessArray() ->[[FlagType]] {
        var arrData:[[FlagType]] = []
        for _ in 0..<15{
            var arr:[FlagType] = []
            for _ in 0..<15 {
                arr.append(FlagType.freeChess)
            }
            arrData.append(arr)
        }
        return arrData
    }
    
    fileprivate func regretState(type:RoleState) {
        
        switch type {
        case .whiteState:
            whiteRegretChessModel.lastChessArray.removeAll()
            whiteRegretChessModel.lastChessArray += chessArray
            whiteRegretChessModel.roleStateLast = roleState
        case .blackState:
            blackRegretChessModel.lastChessArray.removeAll()
            blackRegretChessModel.lastChessArray += chessArray
            blackRegretChessModel.roleStateLast = roleState
        default:
            ()
        }
        
        
        
    }
    private func canceSelectView() {
        self.subviews.forEach { (view) in
            view.transform = CGAffineTransform.identity
        }
    }
    deinit {
        print("释放五子棋棋盘")
    }
}
