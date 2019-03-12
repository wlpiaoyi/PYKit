//
//  PYNetNormal.h
//  PYNetwork
// 允许http网络访问  App Transport Security Settings - Allow Arbitrary Loads - YES
//  Created by wlpiaoyi on 2017/4/10.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSUInteger PYRequestType;
NS_ENUM(PYRequestType) {
    PYRequestGet = 0,
    PYRequestPost = 1,
    PYRequestPut = 2,
    PYRequestDelete = 3,
    };


@interface PYNetNormal : NSObject

//http请求反馈
@property (nonatomic, strong, nullable) id userInfo;
@property (nonatomic, strong, nonnull) NSString * url;
@property (nonatomic) NSStringEncoding encoding;
@property (nonatomic) CGFloat outTime;
@property (nonatomic, copy, nullable) void (^blockComplete)(NSInteger status, id _Nullable data, PYNetNormal * _Nonnull target);
@property (nonatomic, copy, nullable) BOOL (^blockAuthenticationChallenge)(NSURLAuthenticationChallenge * _Nullable challenge, PYNetNormal * _Nonnull target);
/**
 添加头信息
 @params headRequest : 头信息
 */
-(void) setHeadRequest:(NSDictionary<NSString * , NSString * > * _Nonnull) headRequest;
/**
 开始请求数据
 @params type : 请求类型
 @params params 参数
 @params blockComplete : 回调
 */
-(nullable NSURLConnection *) requestWithType:(PYRequestType) type params:(nullable NSDictionary<NSString *, NSObject *> *) params blockComplete:(nullable void (^)(NSInteger status, id _Nullable data, PYNetNormal * _Nonnull target)) blockComplete;
-(NSURLConnection * _Nullable) requestGetWithParams:(NSDictionary<NSString *, NSObject *> * _Nullable) params;
-(NSURLConnection * _Nullable) requestPostWithParams:(NSDictionary<NSString *, NSObject *> * _Nullable) params;
-(NSURLConnection * _Nullable) requestPutWithParams:(NSDictionary<NSString *, NSObject *> * _Nullable) params;
-(NSURLConnection * _Nullable) requestDeleteWithParams:(NSDictionary<NSString *, NSObject *> * _Nullable) params;
/**
 取消请求
 */
-(BOOL) cancel;
@end
