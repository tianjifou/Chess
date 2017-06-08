//
//  NSDataTool.h
//  TianJiFouChess
//
//  Created by 天机否 on 2017/5/19.
//  Copyright © 2017年 tianjifou. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GPBMessage;
@interface NSDataTool : NSObject
@property (strong, nonatomic) NSMutableData*halfData;
@property (strong, nonatomic) NSMutableArray*dictData;
@property(assign,nonatomic)   int header_count;
+(NSDataTool *)shareInstance;
-(void)startParse:(NSData*)data success:(void(^)(GPBMessage*message))successBlock;
-(NSMutableData*)returnData:(GPBMessage*)req messageId:(int)messageId;
@end
