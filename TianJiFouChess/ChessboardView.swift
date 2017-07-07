//
//  ChessboardView.swift
//  TianJiFouChess
//
//  Created by 天机否 on 17/4/28.
//  Copyright © 2017年 tianjifou. All rights reserved.
//

import UIKit
import Hyphenate
let ScreenWidth = UIScreen.main.bounds.width
let ScreenHeight = UIScreen.main.bounds.height
let chessWidth:CGFloat = 60


class ChessboardView: UIView {
    var role:Role? {
        didSet {
            if role == .blacker {
                self.isWaiting = true
            }else {
                self.isWaiting = false
            }
        }
    }
   var roleState:RoleState = .whiteState
   var lianZhuChess = LianZhuChess()
   var tiShiBlock:((String)->())?
   var fightState:FightState = .buZiState
   var tempView:FlagImageView?
   var viewType:ChessType?
   var toSomePeople:String?
  
   var isWaiting = false
   var isUser = true
   lazy var chessArray:[[FlagType]] = {
        var arrData:[[FlagType]] = []
        for _ in 0...5{
            var arr:[FlagType] = []
            for _ in 0...5 {
                arr.append(FlagType.freeChess)
            }
            arrData.append(arr)
        }
        return arrData
    }()
    
    fileprivate var whiteLastChessArray:[[FlagType]] = []
    fileprivate var blackLastChessArray:[[FlagType]] = []
    fileprivate var roleStateLast:RoleState = .whiteState
    fileprivate var fightStateLast:FightState = .buZiState
    fileprivate var whiteRegretChessModel = RegretChessModel()
    fileprivate var blackRegretChessModel = RegretChessModel()
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.backgroundColor = UIColor.clear
        createLine()
       
    
    }
    
    func createChessArray() ->[[FlagType]] {
        var arrData:[[FlagType]] = []
        for _ in 0...5{
            var arr:[FlagType] = []
            for _ in 0...5 {
                arr.append(FlagType.freeChess)
            }
            arrData.append(arr)
        }
        return arrData
    }
    
    
    
    func createLine() {
        for index in 0...5 {
            let layerCrossWise = CALayer()
            layerCrossWise.frame = CGRect.init(x: 10, y: 10+chessWidth*CGFloat(index), width: 300 , height: 0.5)
            layerCrossWise.backgroundColor = UIColor.black.cgColor
            self.layer.addSublayer(layerCrossWise)
            
            let layerVertical = CALayer()
            layerVertical.frame = CGRect.init(x: 10+chessWidth*CGFloat(index), y: 10, width: 0.5 , height: 300)
            layerVertical.backgroundColor = UIColor.black.cgColor
            self.layer.addSublayer(layerVertical)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if isWaiting && viewType! != .manAnMachine{
            return
        }
        guard let location = touches.first?.location(in: self) else {
            return
        }
        guard let type = viewType else {
            return
        }
        
        
        switch type {
            
        case ChessType.manAnMachine:
            manAnMachineChess(location:location)
        case ChessType.bluetooth:
            bluetoothChess(location: location)
        case ChessType.online:
            sendMessageChess(location: location)
        default:()
       
        }
       
        
    }
    
    fileprivate func manAnMachineChess(location:CGPoint) {
        let  point = ChessStepTool.touchRealPoint(location)
        let swsPoint = SWSPoint()
        swsPoint.x = Int(round(Double(point.x-10)/Double(chessWidth)))
        swsPoint.y = Int(round(Double(point.y-10)/Double(chessWidth)))
        self.bujuChess(swsPoint: swsPoint)
    }
    
    fileprivate func bluetoothChess(location:CGPoint) {
        let  point = ChessStepTool.touchRealPoint(location)
        let swsPoint = SWSPoint()
        swsPoint.x = Int(round(Double(point.x-10)/Double(chessWidth)))
        swsPoint.y = Int(round(Double(point.y-10)/Double(chessWidth)))
        
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
            self.bujuChess(swsPoint: swsPoint)
        }) { (error) in
            PAMBManager.sharedInstance.showBriefMessage(message: "\(error)")
        }
        
    }
    
    fileprivate func sendMessageChess(location:CGPoint) {
        let  point = ChessStepTool.touchRealPoint(location)
        let swsPoint = SWSPoint()
        swsPoint.x = Int(round(Double(point.x-10)/Double(chessWidth)))
        swsPoint.y = Int(round(Double(point.y-10)/Double(chessWidth)))
        let dic = ["gameType":"3","pointList":["from":EMClient.shared().currentUsername,"to":toSomePeople ?? "","xx":swsPoint.x,"yy":swsPoint.y,"role": role == .whiter ? "1" : "2"]] as [String : Any]
        guard let message = ChatHelpTool.sendTextMessage(text: "games", toUser: toSomePeople!, messageType: EMChatTypeChat, messageExt: dic)else{
            return
        }
        ChatHelpTool.senMessage(aMessage: message, progress: nil, completion: { (message, error) in
            if let error = error {
                TJFTool.errorForCode(code: error.code)
            }else{

                self.isUser = true
                self.bujuChess(swsPoint: swsPoint)
               
            }
            print(message ?? "",error ?? "")
        })
    }
    
    
    
    func bujuChess(swsPoint:SWSPoint) {
        
        if fightState == .buZiState {
            buZiState(swsPoint)
        }else if fightState == .pullState {
            pullState(swsPoint)
        }else {
            yiDongState(swsPoint)
            
        }
    }
    
    
    //布局阶段
    private func buZiState(_ swsPoint: SWSPoint) {
        if roleState == .eatState {
            if chessArray[swsPoint.x][swsPoint.y] != lianZhuChess.flagType && chessArray[swsPoint.x][swsPoint.y] != FlagType.middleChess && chessArray[swsPoint.x][swsPoint.y] != FlagType.freeChess {
                
                if ChessStepTool.isShunZiChess(swsPoint, chessArray) != nil && !ChessStepTool.allIsShunZiChess(chessArray: chessArray){
                    if self.isUser {
                        self.tiShiBlock?("对方已形成的格子棋，不能吃，请换其他的棋子。")
                    }
                   
                    return
                }
                if  let view = self.viewWithTag(swsPoint.x*10+swsPoint.y+100) as? FlagImageView{
                    view.image = #imageLiteral(resourceName: "stone_green")
                    chessArray[swsPoint.x][swsPoint.y] = FlagType.middleChess
                    lianZhuChess.eatNum -= 1
                    if lianZhuChess.eatNum == 0 {
                        self.roleState = lianZhuChess.flagType == .whiteChess ? .blackState : .whiteState
                        self.isWaiting = self.isUser ? true : false
                        if freeChessIsNone() {
                            self.fightState = .yiDongState
                            self.roleState = .blackState
                            self.tiShiBlock?("布局结束，黑子先行。")
                            self.isWaiting = self.role == .whiter ?  true : false
                            clearGreenChess()
                        }
                        
                    }
                }
                
            }
        } else{
            if chessArray[swsPoint.x][swsPoint.y] == FlagType.freeChess {
                let flagIageView = FlagImageView()
                flagIageView.tag = 10*swsPoint.x + swsPoint.y + 100
                flagIageView.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
                flagIageView.center = CGPoint.init(x: 10+swsPoint.x*60, y: 10+swsPoint.y*60)
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
                self.isWaiting = self.isUser ? true : false
                if let some = ChessStepTool.isShunZiChess(swsPoint, chessArray) {
                    
                    lianZhuChess.lianZhuType = some
                    lianZhuChess.flagType = tempFlag
                    let strUser = self.isUser ? "您成功形成\(lianZhuChess.eatStr)，请吃掉对方\(lianZhuChess.eatNum)颗棋子。" : "对方成功形成\(lianZhuChess.eatStr)，您将被吃掉\(lianZhuChess.eatNum)颗棋子。"
                    self.tiShiBlock?(strUser)
                    self.roleState = .eatState
                    self.isWaiting = self.isUser ? false : true
                }else {
                    if freeChessIsNone() {
                        if greenChessIsNone() {
                            self.fightState = .pullState
                            self.roleState = .whiteState
                            self.tiShiBlock?("无路可走啦，需要各自拔取对方一颗棋子，白子先拔。")
                            self.isWaiting = self.role == .whiter ?  false : true
                        }else {
                            self.fightState = .yiDongState
                            self.roleState = .blackState
                            self.tiShiBlock?("布局结束，黑子先行。")
                            self.isWaiting = self.role == .whiter ?  true : false
                            clearGreenChess()
                        }
                        
                    }
                }
                
            }
            
        }
    }
    //拔子阶段
    private func pullState(_ swsPoint: SWSPoint) {
        if ChessStepTool.isShunZiChess(swsPoint, chessArray) != nil && !ChessStepTool.allIsShunZiChess(chessArray: chessArray){
            if self.isUser {
               self.tiShiBlock?("对方已形成的格子棋，不能拔，请换其他的棋子。")
            }
            
            return
        }
        if chessArray[swsPoint.x][swsPoint.y] == .blackChess && self.roleState == .whiteState {
            if  let view = self.viewWithTag(swsPoint.x*10+swsPoint.y + 100) {
                view.removeFromSuperview()
                self.regretState(type: roleState)
                self.roleState = .blackState
                chessArray[swsPoint.x][swsPoint.y] = .freeChess
                self.isWaiting = true
            }
        }
        if chessArray[swsPoint.x][swsPoint.y] == .whiteChess && self.roleState == .blackState {
            if  let view = self.viewWithTag(swsPoint.x*10+swsPoint.y + 100) {
                view.removeFromSuperview()
                self.regretState(type: roleState)
                self.fightState = .yiDongState
                self.roleState = .blackState
                chessArray[swsPoint.x][swsPoint.y] = .freeChess
                clearGreenChess()
                self.isWaiting = false
            }
        }
        
    
    }
    //移子阶段
    private func yiDongState(_ swsPoint: SWSPoint) {
        if whoWin() {
            return
        }
        if self.roleState == .eatState {
            if  chessArray[swsPoint.x][swsPoint.y] != lianZhuChess.flagType && chessArray[swsPoint.x][swsPoint.y] != FlagType.middleChess && chessArray[swsPoint.x][swsPoint.y] != FlagType.freeChess {
                if ChessStepTool.isShunZiChess(swsPoint, chessArray) != nil && !ChessStepTool.allIsShunZiChess(chessArray: chessArray){
                    if self.isUser {
                        self.tiShiBlock?("对方已形成的格子棋，不能吃，请换其他的棋子。")
                    }
                    
                    return
                }
                if  let view = self.viewWithTag(swsPoint.x*10+swsPoint.y + 100) as? FlagImageView{
                    view.removeFromSuperview()
                    chessArray[swsPoint.x][swsPoint.y] = FlagType.freeChess
                    lianZhuChess.eatNum -= 1
                    if lianZhuChess.eatNum == 0 {
                        self.roleState = lianZhuChess.flagType == .whiteChess ? .blackState : .whiteState
                        self.isWaiting = self.isUser ? true : false
                        if whoWin() {
                            return
                        }
                        
                    }
                }
            }
        }else {
            if createRoleAndChess(swsPoint: swsPoint) {
                if  let view = self.viewWithTag(swsPoint.x*10+swsPoint.y + 100) as?FlagImageView {
                    canceSelectView()
                    view.transform = CGAffineTransform.identity.scaledBy(x: 1.3, y: 1.3)
                    tempView = view
                }
            }else if let tempView = tempView,chessArray[swsPoint.x][swsPoint.y] == .freeChess {
                let lastPoint = SWSPoint()
                lastPoint.x = (tempView.tag-100)/10
                lastPoint.y = (tempView.tag-100)%10
                if distanceTwoPoint(lastPoint, swsPoint) {
                    if tempView.flagType == .whiteChess {
                        self.regretState(type: .whiteState)
                        self.roleState = .blackState
                        
                    }else if tempView.flagType == .blackChess {
                        self.regretState(type: .blackState)
                        self.roleState = .whiteState
                       
                    }
                    tempView.center = CGPoint.init(x: 10+swsPoint.x*60, y: 10+swsPoint.y*60)
                    chessArray[lastPoint.x][lastPoint.y] = .freeChess
                    tempView.tag = 10*swsPoint.x + swsPoint.y + 100
                    chessArray[swsPoint.x][swsPoint.y] = tempView.flagType
                    
                    self.isWaiting = self.isUser ? true : false
                    self.tempView = nil
                    if let state = ChessStepTool.isShunZiChess(swsPoint, chessArray) {
                        lianZhuChess.lianZhuType = state
                        lianZhuChess.flagType = tempView.flagType
                         let strUser = self.isUser ? "您成功形成\(lianZhuChess.eatStr)，请吃掉对方\(lianZhuChess.eatNum)颗棋子。" : "对方成功形成\(lianZhuChess.eatStr)，您将被吃掉\(lianZhuChess.eatNum)颗棋子。"
                        self.tiShiBlock?(strUser)
                        self.roleState = .eatState
                        self.isWaiting = self.isUser ? false : true
                        
                    }
                }
                
                
            }
        }
    }
    
    
   
    
    //两点距离是否为1
    private func distanceTwoPoint(_ lastPoint: SWSPoint,_ selectPoint: SWSPoint) ->Bool{
     
        let distance = abs(selectPoint.x - lastPoint.x) + abs(selectPoint.y - lastPoint.y)
        if distance == 1 {
            return true
        }
        return false
    }
    
    private func whoWin() ->Bool{
        let some = ChessStepTool.whoWinChess(chessArray: chessArray)
        switch some {
        case .whiteWin:
            self.tiShiBlock?("恭喜白子获胜！")
            return true
        case .blackWin:
            self.tiShiBlock?("恭喜黑子获胜！")
            return true
        case .drawGame:
            self.tiShiBlock?("双方对手旗鼓相当！")
            return true
        default:
            ()
        }
        return false
    }
    
    
    private func clearGreenChess(){
        for i in 0...5 {
            for j in 0...5 {
                if chessArray[i][j] == FlagType.middleChess {
                    if  let view = self.viewWithTag(i*10+j+100) {
                        view.removeFromSuperview()
                        chessArray[i][j] = FlagType.freeChess
                    }
                }
            }
        }
    }
    
    private func createRoleAndChess(swsPoint: SWSPoint) ->Bool{
        if chessArray[swsPoint.x][swsPoint.y] == .whiteChess && self.roleState == .whiteState {
            return true
        }
        if chessArray[swsPoint.x][swsPoint.y] == .blackChess && self.roleState == .blackState {
            return true
        }
        return false
        
    }
    
    private func greenChessIsNone()->Bool {
        for i in 0...5 {
            for j in 0...5 {
                if chessArray[i][j] == FlagType.middleChess {
                    return false
                }
            }
        }
        return true
    }
    
    private func freeChessIsNone() ->Bool {
        for i in 0...5 {
            for j in 0...5 {
                if chessArray[i][j] == FlagType.freeChess {
                    return false
                }
            }
        }
        return true
    }

    
    
    private func canceSelectView() {
        self.subviews.forEach { (view) in
            view.transform = CGAffineTransform.identity
        }
    }
    
}
extension ChessboardView {
    
    func startAgain() {
        roleState = .whiteState
        lianZhuChess = LianZhuChess()
        fightState = .buZiState
        isUser = true
        self.subviews.forEach {
            $0.removeFromSuperview()
        }
        self.layer.sublayers?.forEach{
            $0.removeFromSuperlayer()
        }
        self.createLine()
        chessArray = createChessArray()
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
        
    }
    
    fileprivate func createChessImage() {
        
        for i in 0...5 {
            for j in 0...5 {
                
                if chessArray[i][j] != .freeChess {
                    let flagIageView = FlagImageView()
                    flagIageView.tag = 10*i + j + 100
                    flagIageView.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
                    flagIageView.center = CGPoint.init(x: 10+i*60, y: 10+j*60)
                    self.addSubview(flagIageView)
                    
                    var tempFlag = FlagType.blackChess
                    self.regretState(type: roleState)
                    if chessArray[i][j] == .whiteChess {
                        flagIageView.image = #imageLiteral(resourceName: "stone_white")
                        tempFlag = FlagType.whiteChess
                        
                    }else if chessArray[i][j] == .blackChess{
                        flagIageView.image = #imageLiteral(resourceName: "stone_black")
                        tempFlag = FlagType.blackChess
                        
                    }else if chessArray[i][j] == .middleChess {
                        flagIageView.image = #imageLiteral(resourceName: "stone_green")
                        tempFlag = FlagType.middleChess
                    }
                    flagIageView.flagType = tempFlag
                }
               
            }
        }
        
    }
    
    fileprivate func regretState(type:RoleState) {
    
        switch type {
        case .whiteState:
            whiteRegretChessModel.lastChessArray.removeAll()
            whiteRegretChessModel.lastChessArray += chessArray
            whiteRegretChessModel.roleStateLast = roleState
            whiteRegretChessModel.fightStateLast = fightState
        case .blackState:
            blackRegretChessModel.lastChessArray.removeAll()
            blackRegretChessModel.lastChessArray += chessArray
            blackRegretChessModel.roleStateLast = roleState
            blackRegretChessModel.fightStateLast = fightState
        default:
            ()
        }
        
        
    
    }
    
    fileprivate func regretExchangeState(type:Role?) {
       
        chessArray.removeAll()
        if type == .blacker {
            chessArray  +=  blackRegretChessModel.lastChessArray
            roleState = blackRegretChessModel.roleStateLast
            fightState = blackRegretChessModel.fightStateLast
        }else {
            chessArray  += whiteRegretChessModel.lastChessArray
            roleState = whiteRegretChessModel.roleStateLast
            fightState = whiteRegretChessModel.fightStateLast
        }
        
        if chessArray.count == 0 {
            chessArray = createChessArray()
        }
    }
    
   
}
class FlagImageView: UIImageView {
    var selectBlock:(()->())?
    var panBlock:((CGPoint)->())?
    var flagType:FlagType = .whiteChess
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(FlagImageView.panView(pan:)))
        self.addGestureRecognizer(pan)
        
    }
    
    func panView(pan:UIPanGestureRecognizer) {
        
        var point = pan.location(in: self.superview)
        switch pan.state {
        case .began:
             self.transform = self.transform.scaledBy(x: 1.3, y: 1.3)
        case .changed:()
           self.center = point
        case .ended:
            point = ChessStepTool.touchRealPoint(point)
            point.x = CGFloat(round(Double(point.x)/Double(chessWidth)))*chessWidth + 10
            point.y = CGFloat(round(Double(point.y)/Double(chessWidth)))*chessWidth + 10
            self.center = point
            self.transform = CGAffineTransform.identity
            panBlock?(point)
        case .failed,.cancelled:
            self.transform = CGAffineTransform.identity
        default:
            ()
        }
        
    }
}

