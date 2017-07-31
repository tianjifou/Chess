//
//  NSDataTool.m
//  TianJiFouChess
//
//  Created by 天机否 on 2017/5/19.
//  Copyright © 2017年 tianjifou. All rights reserved.
//

#import "NSDataTool.h"
#import <Protobuf/GPBProtocolBuffers.h>
#import "ShunZiChess.pbobjc.h"
@implementation NSDataTool{
    dispatch_queue_t serialQueue;
    BOOL isAnalysis;
}
struct message_header
{
    uint32_t magic;//magic number, 0x98765432
    uint32_t total;//包长度，从这一字段头算起
    uint32_t msgid;//消息ID
    uint32_t seqnum;//客户端使用
    uint32_t version;//协议版本，目前为1
    
};
+(NSDataTool *)shareInstance{
    static NSDataTool *dataTool = nil;
    if (dataTool == nil)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            dataTool = [[NSDataTool alloc] init];
            dataTool.halfData=[[NSMutableData alloc]init];
            dataTool.header_count=0;
            dataTool.dictData=[[NSMutableArray alloc]init];
            
        });
    }
    return dataTool;
}
-(instancetype)init {
    self = [super init];
    if (self) {
        serialQueue=dispatch_queue_create("serialMessagae",DISPATCH_QUEUE_SERIAL);
    }
    return self;
}
-(GPBMessage*)sendMessageToServer:(NSData*)dicData messageId:(int)messageId{
     if(messageId == tianJiFouMessageId_KChallenge) {
        NSError* error;
        ChallengeMessage*getMessage=[ChallengeMessage parseFromData:dicData error:&error];
        if (!error) {
            return getMessage;
        }
       
    }
    return nil;
}
-(NSMutableData*)returnData:(GPBMessage*)req messageId:(int)messageId {
    NSString *header=[NSString stringWithFormat:@"98765432%08lx%08x%08lx00000001",(unsigned long)req.data.length+20,messageId,(unsigned long)++self.header_count];
    Byte bytes[40];
    int j=0;
    for(int i=0;i*2+1<header.length;i++)
    {
        int int_ch;  /// 两位16进制数转化后的10进制数
        const char* hex_char=[[header substringWithRange:NSMakeRange(i*2, 2)] UTF8String];
        int_ch = (int)strtoul(hex_char, 0, 16);
        //        DLog(@"int_ch=%d",int_ch);
        bytes[j] = int_ch;  ///将转化后的数放入Byte数组里
        j++;
    }
    NSMutableData *data = [[NSMutableData alloc] init];
    [data appendBytes:bytes length:j];
    [data appendData:req.data];
    return data;
}

-(void)startParse:(NSData*)data success:(void(^)(GPBMessage*message))successBlock{
        if(data)
        [self.dictData addObject:data];
    if(isAnalysis)
    {
        return;
    }
    if (self.dictData.count>0) {
        isAnalysis=YES;
        [self parseData:self.dictData[0] success:successBlock];
    }
}
-(void)parseData:(NSData*)data success:(void(^)(GPBMessage*message))successBlock{
        __weak NSDataTool*weakSelf=self;
        dispatch_async(serialQueue, ^{
            [weakSelf parseSocketReceiveData:data result:^(NSData *result, int messageId ,int headerId) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(successBlock)
                        successBlock([self sendMessageToServer:result messageId:messageId]);
                });
                
                
            } finish:^(void) {
                [weakSelf.dictData removeObjectAtIndex:0];
                if (weakSelf.dictData.count>0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self parseData:nil success:successBlock];
                    });
                }else{
                    isAnalysis=NO;
                }
            }];
        });
    
}
-(void)parseSocketReceiveData:(NSData*)data result:(void (^)(NSData*result ,int messageId,int hearderId))resultBlock finish:(void(^)())finishBlockMessage{
    
    if (_halfData.length>0) {
        [_halfData appendData:data];
        data=[_halfData copy];
        _halfData =[[NSMutableData alloc]init];
    }else{
        data=[data copy];
    }
    
    if (data.length<20) {
        [_halfData appendData:data];
        if (finishBlockMessage) {
            finishBlockMessage();
        }
        return;
    }
    Byte *testByte = (Byte*)[data bytes];
    
    int length=(int) ((testByte[4] & 0xFF<<24)
                      | ((testByte[5] & 0xFF)<<16)
                      | ((testByte[6] & 0xFF)<<8)
                      | ((testByte[7] & 0xFF)));
    
    int messageId=(int) ((testByte[8] & 0xFF<<24)
                         | ((testByte[9] & 0xFF)<<16)
                         | ((testByte[10] & 0xFF)<<8)
                         | ((testByte[11] & 0xFF)));
    int headerId=(int)((testByte[12] & 0xFF<<24)
                       | ((testByte[13] & 0xFF)<<16)
                       | ((testByte[14] & 0xFF)<<8)
                       | ((testByte[15] & 0xFF)));
    if(length==data.length){
        if (resultBlock) {
            resultBlock([data subdataWithRange:NSMakeRange(20, length-20)],messageId,headerId);
        }
        if (finishBlockMessage) {
            finishBlockMessage();
        }
    }else if(length<data.length){
        if (resultBlock) {
            resultBlock([data subdataWithRange:NSMakeRange(20, length-20)],messageId,headerId);
        }
        [self parseSocketReceiveData:[data subdataWithRange:NSMakeRange(length, data.length-length)] result:resultBlock finish:            finishBlockMessage];
    }else{
        
        [_halfData appendData:data];
        if (finishBlockMessage) {
            finishBlockMessage();
        }
    }
}

@end
