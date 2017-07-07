//
//  TestSomeThing.h
//  TianJiFouChess
//
//  Created by 天机否 on 2017/6/19.
//  Copyright © 2017年 tianjifou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface TestSomeThing : NSObject
@property(nonatomic,assign)int rank;//难度等级
@property(nonatomic,assign)int aiRole;//1表示AI先手 0表示棋手先手
@property(nonatomic,assign)int whoWin;//谁赢了
@property(nonatomic,copy)void (^aiMove)(CGPoint point);
-(void)test;
-(void)peopleMoveX:(int)x Y:(int)y;
@end
