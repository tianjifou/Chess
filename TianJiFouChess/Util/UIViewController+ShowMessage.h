//
//  UIViewController+ShowMessage.h
//  TianJiFouChess
//
//  Created by 天机否 on 2017/5/15.
//  Copyright © 2017年 tianjifou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ShowMessage)
// 数据请求失败@property (nonatomic,copy) void (^retryBlock)(void);

- (void)dismissKeyboard;

// 首次加载之后，更新数据(背景透明)
- (void)updatingWithMessage:(NSString *)message;
- (void)updatingWithNoBackgroundWithMessage:(NSString *)message;
- (void)updatingWithMessage:(NSString *)message isTranslucent:(BOOL)isTranslucent;
- (void)updatingWithMessage:(NSString *)message marginTop:(CGFloat)marginTop isTranslucent:(BOOL)isTranslucent;
- (void)updatingEnd;

- (void)updatingEndInWindow;
- (void)updatingInWindowWithMessage:(NSString *)message;

// 没有数据，action 为 nil时，不显示按钮
/**
 *
 *
 *  @param message 提示内容
 *  @param action  按钮动作（默认按钮标题为“刷新”）
 */
- (void)nothingWithMessage:(NSString *)message action:(void (^)(void))action;


- (void)nothingWithMessage:(NSString *)message buttonTitle:(NSString *)title action:(void (^)(void))action;

- (void)nothingWithMessage:(NSString *)message marginTop:(CGFloat)marginTop action:(void (^)(void))action;

- (void)nothingWithMessage:(NSString *)message
                 marginTop:(CGFloat)marginTop
                 imageName:(NSString *)imageName
                    action:(void (^)(void))action;
/**
 *
 *
 *  @param message 提示内容
 *  @param marginTop   开始位置与屏幕顶部的距离
 *  @param imageName   图片名称 !!! 默认Default_empty，没有特殊说明的界面，统一用Default_empty图片。
 *  @param title   按钮标题
 *  @param action  按钮动作
 */
- (void)nothingWithMessage:(NSString *)message
               buttonTitle:(NSString *)title
                 marginTop:(CGFloat)marginTop
                 imageName:(NSString *)imageName
                    action:(void (^)(void))action;

- (void)hideNothingView;
@end
