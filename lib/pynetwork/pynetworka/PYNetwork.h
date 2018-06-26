//
//  PYNetwork.h
//  PYNetwork
//
//  Created by wlpiaoyi on 2017/4/14.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import "pyutilea.h"
typedef enum _PYNetworkState {
    PYNetworkStateUnkwon = 0,
    PYNetworkStateResume,
    PYNetworkStateSuspend,
    PYNetworkStateCancel,
    PYNetworkStateInterrupt
} PYNetworkState;

static NSString * _Nonnull  PYNetworkCache;
static NSString * _Nonnull  PYNetWorkDatePattern;
static NSTimeInterval   PYNetworkOutTime;


//==>传输方法
extern NSString * _Nonnull PYNET_HTTP_GET;
extern NSString * _Nonnull PYNET_HTTP_POST;
extern NSString * _Nonnull PYNET_HTTP_PUT ;
extern NSString * _Nonnull PYNET_HTTP_DELETE;
///<==

@class PYNetwork;
@interface PYNetworkDelegate:NSObject<NSURLSessionDelegate>
kPNSNA PYNetwork * network;
@end

@interface PYNetwork : NSObject

kPNA NSTimeInterval outTime;
kPNAR PYNetworkState state;
kPNSNA id userInfo;

kPNRNN NSURLSession * session;
kPNSNA NSURLSessionTask * sessionTask;

//=========================================>
kPNSNN NSString * url;//请求地址
kPNSNN NSString * method;//请求类型，GET、POST、PUT、DELETE
kPNSNA NSDictionary<NSString *, id> * params;//全method参数key必须是支付类型value全类型支持
kPNSNA NSArray<NSString *> * keySorts;//参数排序 如果为空则不排序, 否则仅当前key-value有效
kPNSNA NSDictionary<NSString *, NSString *> * heads;//头文件
///<=========================================

kPNCNA void (^blockSendProgress) (PYNetwork * _Nonnull target, int64_t currentBytes, int64_t totalBytes);
kPNCNA BOOL (^blockReceiveChallenge)(id _Nullable data, PYNetwork * _Nonnull target) ;
kPNCNA void (^blockComplete)(id _Nullable data, NSURLResponse * _Nullable response, PYNetwork * _Nonnull target);

/**
 ssl证书账号密码
 */
//=========================================>
kPNSNA NSString * certificationName;
kPNSNA NSString * certificationPassword;
///<=========================================


//=========================================>
/**
 开始、恢复请求
 */
-(BOOL) resume;
/**
 暂停请求
 */
-(BOOL) suspend;
/**
 取消请求
 */
-(BOOL) cancel;
/**
 强制中断请求
 不可短点恢复
 */
-(void) interrupt;
///<=========================================

-(nullable NSURLSession*) createSession;
-(nullable NSURLSessionTask *) createSessionTask;

+(nonnull NSURLRequest *) createRequestWithUrlString:(nonnull NSString*) urlString
                                            httpMethod:(nullable NSString*) httpMethod
                                            heads:(nullable NSDictionary<NSString *, NSString *> *) heads
                                            params:(nullable NSData *) params
                                            outTime:(CGFloat) outTime;
+(nonnull NSData *) parseDictionaryToHttpBody:(NSDictionary<NSString*, id> *) params
                                            keySorts:(nullable NSArray<NSString *> *) keySorts
                                            contentType:(NSString *) contentType;
@end
