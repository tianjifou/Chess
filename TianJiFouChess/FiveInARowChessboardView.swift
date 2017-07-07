//
//  FiveInARowChessboardView.swift
//  TianJiFouChess
//
//  Created by 天机否 on 2017/6/19.
//  Copyright © 2017年 tianjifou. All rights reserved.
//

import UIKit

class FiveInARowChessboardView: UIView {
    let fiveChessWidth:CGFloat = (ScreenWidth - 20)/14
    var role:Role? {
        didSet {
            if role == .blacker {
                self.isWaiting = true
            }else {
                self.isWaiting = false
            }
        }
    }
    var roleState:RoleState = .blackState
    var tiShiBlock:((String)->())?
    var fightState:FightState = .buZiState
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
    let aiRoler = TestSomeThing()
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
//        aiRoler.rank = 4
//        aiRoler.aiRole = 0
//        aiRoler.aiMove = { [weak self](point) in
//            guard  let weakSelf = self else {
//                return
//            }
//            let swsPoint = SWSPoint()
//            swsPoint.x = Int(point.x)
//            swsPoint.y = Int(point.y)
//            weakSelf.isUser = false
//            DispatchQueue.main.async {
//                 weakSelf.moveChess(swsPoint: swsPoint)
//            }
//           
//            
//        }
        let sws = SWSPoint()
        sws.x = 7
        sws.y = 7
        moveChess(swsPoint: sws)
        self.isWaiting = false
    }
    func createLine() {
        for index in 0..<15 {
            let layerCrossWise = CALayer()
            layerCrossWise.frame = CGRect.init(x: 10, y: 10+fiveChessWidth*CGFloat(index), width: (ScreenWidth - 20) , height: 0.5)
            layerCrossWise.backgroundColor = UIColor.black.cgColor
            self.layer.addSublayer(layerCrossWise)
            
            let layerVertical = CALayer()
            layerVertical.frame = CGRect.init(x: 10+fiveChessWidth*CGFloat(index), y: 10, width: 0.5 , height: (ScreenWidth - 20))
            layerVertical.backgroundColor = UIColor.black.cgColor
            self.layer.addSublayer(layerVertical)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if self.isWaiting {
//            return
//        }
        guard let location = touches.first?.location(in: self) else {
            return
        }
        let  point = ChessStepTool.touchRealFivePoint(location)
        let swsPoint = SWSPoint()
        swsPoint.x = Int(round(Double(point.x-10)/Double(fiveChessWidth)))
        swsPoint.y = Int(round(Double(point.y-10)/Double(fiveChessWidth)))
        self.isUser = true
        moveChess(swsPoint:swsPoint)
       
        
    }
    
    private func moveChess(swsPoint:SWSPoint) {
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
            AIFiveInARowChess.updateOneEffectScore(chessArray: chessArray, point: (swsPoint.x,swsPoint.y), AIScore: &AIScore, humanScore: &humanScore)
            logSomeThing()
            if self.roleState == .blackState {
                DispatchQueue.global().async { [weak self] in
                    guard let weakSelf = self else {return}
                    if  let point =  AIFiveInARowChess.getAIPoint(chessArray: &weakSelf.chessArray, role: .blackChess, AIScore: &weakSelf.AIScore, humanScore: &weakSelf.humanScore, deep: 6){
                        let sws = SWSPoint()
                        sws.x = point.0
                        sws.y = point.1
                        DispatchQueue.main.async {
                           weakSelf.moveChess(swsPoint: sws) 
                        }
                        
                        
                    }
                }
                
                
            }
            
            
            self.isWaiting =  self.isUser ? true:false
            if  ChessStepTool.isFiveChess(swsPoint, chessArray) {
                let strUser = self.isUser ? "您成功形成五子棋。" : "对方成功形成五子棋。"
                self.tiShiBlock?(strUser)
                self.isWaiting =  true
            }else {
                if self.freeChessIsNone() {
                    self.tiShiBlock?("已经无路可走，和棋。")
                }
            }
            
        }
    }
    
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
    private func canceSelectView() {
        self.subviews.forEach { (view) in
            view.transform = CGAffineTransform.identity
        }
    }
    deinit {
        print("释放五子棋棋盘")
    }
}
