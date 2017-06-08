//
//  ChessEnum.swift
//  TianJiFouChess
//
//  Created by 天机否 on 2017/6/5.
//  Copyright © 2017年 tianjifou. All rights reserved.
//

import Foundation

//游戏对战模式：人机，蓝牙，在线
enum ChessType: Int {
    case manAnMachine,bluetooth,online
}
//棋盘位置状态：空子，白棋，黑棋，被吃位置
enum FlagType:Int {
    case freeChess,whiteChess,blackChess,middleChess
}
//当前棋手角色：白棋，黑棋，等待,吃子状态
enum RoleState:Int {
    case whiteState,blackState,eatState
}
//所持棋子颜色
enum Role: Int {
    case  whiter,blacker
}
//对战状态： 布子 、移子、拔子
enum FightState:Int {
    case buZiState,yiDongState,pullState
}
//胜负状态： 白子胜、黑子胜、平局,未出胜负
enum WinState:Int {
    case whiteWin,blackWin,drawGame,noneWin
}
//获得游戏状态
enum GameState:Int {
    case challenge = 1,acceptChallenge,yiDongState,giveUpState
}
