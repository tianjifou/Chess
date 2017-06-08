//
//  UIViewController+ShowMessage.m
//  TianJiFouChess
//
//  Created by 天机否 on 2017/5/15.
//  Copyright © 2017年 tianjifou. All rights reserved.
//

#import "UIViewController+ShowMessage.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <objc/runtime.h>
#import <HexColors/HexColors.h>
#import "TianJiFouChess-Swift.h"
static const NSInteger kErrorViewTag = 3001;
@implementation UIViewController (ShowMessage)
- (void)setRetryBlock:(void (^)(void))retryBlock {
    objc_setAssociatedObject(self, @selector(retryBlock), retryBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(void))retryBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)showExceptionWithMessage:(NSString *)message
                       marginTop:(CGFloat)marginTop
                     buttonTitle:(NSString *)title
                         imgName:(NSString *)imageName
                          action:(void (^)(void))action {
    [self hideNothingView];
    CGRect mainScreenBounds = [UIScreen mainScreen].bounds;
    UIView *coverView = [[UIView alloc]
                         initWithFrame:CGRectMake(0, marginTop, mainScreenBounds.size.width, mainScreenBounds.size.height - marginTop)];
    coverView.backgroundColor = [HXColor colorWithHexString:@"F8F8F8"];
    coverView.tag = kErrorViewTag;
    
    UIImageView *logoView =
    [[UIImageView alloc] initWithImage:[UIImage imageNamed:isEmpty(imageName) ? @"InventoryWarn" : imageName]];
    
    CGPoint center = coverView.center;
    center.y = 180;
    if (marginTop > 0) {
        center.y = 30 + CGRectGetHeight(coverView.frame) * .2;
    }
    logoView.center = center;
    
    UILabel *messageLabel = [[UILabel alloc] init];
    CGRect frame = self.view.frame;
    frame.origin.x = (frame.size.width - 160) / 2;
    frame.origin.y = logoView.frame.origin.y + logoView.frame.size.height + 10;
    frame.size.width = 160;
    frame.size.height = [self calcLabelHeight:message LabelWith:160 FontSize:12] + 10;
    messageLabel.frame = frame;
    messageLabel.textColor = [HXColor colorWithHexString:@"#999999"];
    messageLabel.backgroundColor = [HXColor clearColor];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.numberOfLines = 0;
    messageLabel.font = [UIFont systemFontOfSize:12];
    messageLabel.text = message;
    
    if (action != nil && title != nil) {
        UIButton *retryButton = [[UIButton alloc] init];
        CGRect buttonFrame = CGRectZero;
        buttonFrame.origin.x = (self.view.frame.size.width - 130) / 2;
        buttonFrame.origin.y = messageLabel.frame.origin.y + messageLabel.frame.size.height + 10;
        buttonFrame.size.width = 130;
        buttonFrame.size.height = 35;
        retryButton.frame = buttonFrame;
        retryButton.titleLabel.font = [UIFont systemFontOfSize:15];
        retryButton.backgroundColor = [UIColor whiteColor];
        retryButton.layer.borderColor = [HXColor colorWithHexString:@"dfdfdf"].CGColor;
        retryButton.layer.borderWidth = 0.5;
        
        [retryButton setTitle:title forState:UIControlStateNormal];
        [retryButton setTitleColor:[HXColor colorWithHexString:@"#ff6602"] forState:UIControlStateNormal];
        [retryButton setTitleColor:[HXColor colorWithHexString:@"#cccccc"] forState:UIControlStateHighlighted];
        [self setRetryBlock:action];
        [retryButton addTarget:self action:@selector(exceptionAction) forControlEvents:UIControlEventTouchUpInside];
        
        [coverView addSubview:retryButton];
    }
    
    [coverView addSubview:messageLabel];
    [coverView addSubview:logoView];
    [self.view addSubview:coverView];
    [self.view bringSubviewToFront:coverView];
    if ([self.view isKindOfClass:[UIScrollView class]]) {
        [(UIScrollView *) self.view setScrollEnabled:NO];
    }
}

- (void)showExceptionWithMessage:(NSString *)message
                     buttonTitle:(NSString *)title
                         imgName:(NSString *)imageName
                          action:(void (^)(void))action {
    [self showExceptionWithMessage:message
                         marginTop:0
                       buttonTitle:title
                           imgName:imageName
                            action:action];
}

- (void)exceptionAction {
    if (self.retryBlock != nil) {
        UIView *coverView = [self.view viewWithTag:kErrorViewTag];
        [coverView removeFromSuperview];
        self.retryBlock();
    }
}

- (void)dismissKeyboard {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (void)updatingWithMessage:(NSString *)message marginTop:(CGFloat)marginTop isTranslucent:(BOOL)isTranslucent {
    [MBProgressHUD hideHUDForView: ((AppDelegate *) ([UIApplication sharedApplication].delegate)).window animated:false];
    [MBProgressHUD hideHUDForView:self.view animated:false];
    [PALoadingView showLoadingViewWithView:self.view labelText:message isTranslucent: isTranslucent animated: YES];
}

- (void)updatingWithMessage:(NSString *)message {
    [self updatingWithMessage:message marginTop:0 isTranslucent:YES];
}

- (void)updatingWithNoBackgroundWithMessage:(NSString *)message {
    [MBProgressHUD hideHUDForView: ((AppDelegate *) ([UIApplication sharedApplication].delegate)).window animated:false];
    [MBProgressHUD hideHUDForView:self.view animated:false];
    MBProgressHUD *hud = [PALoadingView showLoadingViewWithView:self.view labelText:message isTranslucent: YES animated: YES];
    PALoadingView *loadingView = (PALoadingView *)hud.customView;
    loadingView.containerView.backgroundColor = [UIColor clearColor];
}

- (void)updatingWithMessage:(NSString *)message isTranslucent:(BOOL)isTranslucent{
    [self updatingWithMessage:message marginTop:0 isTranslucent:isTranslucent];
}

- (void)updatingEnd {
    [MBProgressHUD hideHUDForView:self.view animated:true];
}


- (void)updatingInWindowWithMessage:(NSString *)message {
    UIView *view = ((AppDelegate *) ([UIApplication sharedApplication].delegate)).window;
    [MBProgressHUD hideHUDForView:view animated:true];
    [PALoadingView showLoadingViewWithView:view labelText:message isTranslucent:YES animated: YES];
}

- (void)updatingEndInWindow {
    UIView *view = ((AppDelegate *) ([UIApplication sharedApplication].delegate)).window;
    [MBProgressHUD hideHUDForView:view animated:true];
}

- (void)nothingWithMessage:(NSString *)message marginTop:(CGFloat)marginTop action:(void (^)(void))action {
    [self showExceptionWithMessage:message
                         marginTop:marginTop
                       buttonTitle:@"刷新"
                           imgName:nil
                            action:action];
}

- (void)nothingWithMessage:(NSString *)message
               buttonTitle:(NSString *)title
                 marginTop:(CGFloat)marginTop
                 imageName:(NSString *)imageName
                    action:(void (^)(void))action {
    [self showExceptionWithMessage:message
                         marginTop:marginTop
                       buttonTitle:title
                           imgName:imageName
                            action:action];
}

- (void)nothingWithMessage:(NSString *)message
                 marginTop:(CGFloat)marginTop
                 imageName:(NSString *)imageName
                    action:(void (^)(void))action {
    [self showExceptionWithMessage:message
                         marginTop:marginTop
                       buttonTitle:@"刷新"
                           imgName:imageName
                            action:action];
}
- (void)nothingWithMessage:(NSString *)message action:(void (^)(void))action {
    [self showExceptionWithMessage:message buttonTitle:@"刷新" imgName:nil action:action];
}

- (void)nothingWithMessage:(NSString *)message buttonTitle:(NSString *)title action:(void (^)(void))action {
    [self showExceptionWithMessage:message buttonTitle:title imgName:nil action:action];
}

- (void)hideNothingView {
    [[self.view viewWithTag:kErrorViewTag] removeFromSuperview];
}

//随着字数变化的label高度
- (NSInteger)calcLabelHeight:(NSString *)strText LabelWith:(NSInteger)with FontSize:(NSInteger)fontSize {
    NSInteger nLableHeight = 0;
    CGSize size = [strText boundingRectWithSize:CGSizeMake(with, 10000)
                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading |
                   NSStringDrawingTruncatesLastVisibleLine
                                     attributes:@{
                                                  NSFontAttributeName : [UIFont systemFontOfSize:fontSize]
                                                  }
                                        context:nil]
    .size;
    nLableHeight = size.height;
    return nLableHeight;
}
BOOL isEmpty(NSString *str) {
    
    if (!str || [str isEqual:[NSNull null]]) {
        return YES;
    } else {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            return YES;
        } else {
            return NO;
        }
    }
}
@end
