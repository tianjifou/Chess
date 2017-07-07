//
//  AIFiveStepTool+Score.swift
//  TianJiFouChess
//
//  Created by 天机否 on 2017/7/3.
//  Copyright © 2017年 tianjifou. All rights reserved.
//

import Foundation
extension AIFiveInARowChess {
    static func theScore(roleNum:Int,enemyNum:Int,empty:inout Int)  ->Int {
      
        var chessType:FiveChessType = .unknown
        //没有空位
        if empty <= 0  {
            if roleNum >= 5  {
                chessType = .liveFive
                return chessType.score
            }
            if enemyNum == 0  {
                switch roleNum  {
                case 1:
                    chessType = .liveOne
                case 2:
                    chessType = .liveTwo
                case 3:
                    chessType = .liveThree
                case 4:
                    chessType = .liveFour
                default: ()
                }
                
            } else if enemyNum == 1  {
                switch roleNum  {
                case 1:
                    chessType = .sleepOne
                case 2:
                    chessType = .sleepTwo
                case 3:
                    chessType = .sleepThree
                case 4:
                    chessType = .sleepFour
                default: ()
                }
                
            }
            
        } else if empty == 1 || empty == roleNum-1  {
            //第1个是空位
            if roleNum >= 6  {
                chessType = .liveFive
                return chessType.score
            }
            if enemyNum == 0  {
                switch roleNum  {
                case 2:
                    chessType = .liveTwo
                    return chessType.score/2
                case 3:
                    chessType = .liveThree
                case 4:
                    chessType = .sleepFour
                case 5:
                    chessType = .liveFour
                default: ()
                    
                }
               
            }else if enemyNum == 1  {
                switch roleNum  {
                case 2:
                    chessType = .sleepTwo
                case 3:
                    chessType = .sleepThree
                case 4:
                    chessType = .sleepFour
                case 5:
                    chessType = .sleepFour
                default: ()
                    
                }
               
            }
        } else if empty == 2 || empty == roleNum-2  {
            //第二个是空位
            if roleNum >= 7  {
                chessType = .liveFive
                return chessType.score
            }
            if enemyNum == 0  {
                switch roleNum  {
                case 3:
                    chessType = .liveThree
                case 4,5:
                    chessType = .sleepFour
                case 6:
                    chessType = .liveFour
                default: ()
                    
                }
               
            }else if enemyNum == 1  {
                switch roleNum  {
                case 3:
                    chessType = .sleepThree
                case 4:
                    chessType = .sleepFour
                case 5:
                    chessType = .sleepFour
                case 6:
                    chessType = .liveFour
                default: ()
                    
                }
               
                
            }else if enemyNum == 2  {
                switch roleNum  {
                case 4,5,6:
                    chessType = .sleepFour
                default: ()
                
                }
            }
        } else if empty == 3 || empty == roleNum-3  {
            if roleNum >= 8  {
                chessType = .liveFive
                return chessType.score
            }
            if enemyNum == 0  {
                switch roleNum  {
                case 4,5:
                    chessType = .liveThree
                case 6:
                    chessType = .sleepFour
                case 7:
                    chessType = .liveFour
                default: ()
                    
                }
               
                
            }else if enemyNum == 1  {
                switch roleNum  {
                case 4,5,6:
                    chessType = .sleepFour
                case 7:
                    chessType = .liveFour
                default: ()
                    
                }
               
                
            }else if enemyNum == 2  {
                switch roleNum  {
                case 4,5,6,7:
                    chessType = .sleepFour
                default: ()
                    
                }
            }
             return chessType.score
        } else if empty == 4 || empty == roleNum-4  {
            if roleNum >= 9  {
                chessType = .liveFive
                return chessType.score
            }
            if enemyNum == 0  {
                switch roleNum  {
                case 5,6,7,8:
                    chessType = .liveFour
                default: ()
                    
                }
                
            }else  if enemyNum == 1  {
                switch roleNum  {
                case 4,5,6,7:
                    chessType = .sleepFour
                case 8:
                    chessType = .liveFour
                default: ()
                    
                }
                
            }else if enemyNum == 2  {
                switch roleNum  {
                case 5,6,7,8:
                    chessType = .sleepFour
                default: ()
                    
                }
                
            }
        } else if empty == 5 || empty == roleNum-5  {
            chessType = .liveFive
            return chessType.score
        }
       
        return chessType.score
    }
    
    static func chongSiChessScore(score: Int) ->Int{
        var score = score
        //调整冲四分数，如果是单独一个冲四，则将分数将至和活三一样，如果是冲四活三或者双冲四，则分数和活四一样
        if score < live_Four && score >= sleep_Four {
            if score < sleep_Four + live_Three{//冲四
                score = live_Three
            }else if score < sleep_Four*2 {//冲四活三
                score = live_Four
            }else {//双冲四
                score = live_Four*2
            }
            
        }
        return score
    }
}
