//
//  PYNetwork.h
//  PYNetwork
//
//  Created by wlpiaoyi on 2017/4/14.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import "pyutilea.h"
//#ifndef pyutilea
//#import <UIKit/UIKit.h>
//#import <Utile/EXTScope.h>
//#import <Utile/PYUtile.h>
//#import <Utile/NSString+Expand.h>
//#import <Utile/NSData+Expand.h>
//#import <Utile/NSDictionary+Expand.h>
//#import <Utile/PYReachabilityListener.h>
//#import <Utile/PYViewAutolayoutCenter.h>
//#define kPNSNA @property (nonatomic, strong, nullable)
//#define kPNSNN @property (nonatomic, strong, nonnull)
//#define kPNRNN @property (nonatomic, readonly, nonnull)
//#define kPNCNA @property (nonatomic, copy, nullable)
//#define kPNA @property (nonatomic, assign)
//#define kINITPARAMS -(instancetype) initWithFrame:(CGRect)frame{if(self = [super initWithFrame:frame]){[self initParams];}return self;} -(instancetype) initWithCoder:(NSCoder *)aDecoder{ if(self = [super initWithCoder:aDecoder]){ [self initParams];}return self;}
//#define kSOULDLAYOUTP @property (nonatomic) CGSize __layoutSubviews_UseSize;
//#define PYSOULDLAYOUTM -(BOOL) __layoutSubviews_Size_Compare{ if(CGSizeEqualToSize(self.__layoutSubviews_UseSize, self.bounds.size)){return false;}self.__layoutSubviews_UseSize = self.bounds.size;return true;}
//#define PYSOULDLAYOUTE [self __layoutSubviews_Size_Compare]
//#endif


static NSString * _Nonnull  PYNetworkCache;
static NSTimeInterval   PYNetworkOutTime;


//==>传输方法
extern NSString * _Nonnull PYNET_HTTP_GET;
extern NSString * _Nonnull PYNET_HTTP_POST;
extern NSString * _Nonnull PYNET_HTTP_PUT ;
extern NSString * _Nonnull PYNET_HTTP_DELETE;
///<==

@interface PYNetwork : NSObject
@property (nonatomic) NSTimeInterval outTime;
kPNSNA id userInfo;
kPNSNN NSURLSession * session;


kPNSNN NSString * url;
kPNSNN NSString * method;
kPNSNA NSDictionary<NSString *, id> * params;
kPNSNA NSDictionary<NSString *, NSString *> * heads;
kPNSNA NSURLSessionTask * sessionTask;

kPNCNA void (^blockSendProgress) (PYNetwork * _Nonnull target, int64_t currentBytes, int64_t totalBytes);
kPNCNA BOOL (^blockReceiveChallenge)(id _Nullable data, PYNetwork * _Nonnull target) ;
kPNCNA void (^blockComplete)(id _Nullable data, PYNetwork * _Nonnull target);

kPNSNA NSString * certificationName;
kPNSNA NSString * certificationPassword;
-(BOOL) resume;
-(BOOL) suspend;
-(BOOL) cancel;

+(nonnull NSURLRequest *) createRequestWithUrlString:(nonnull NSString*) urlString
                                          httpMethod:(nullable NSString*) httpMethod
                                               heads:(nullable NSDictionary<NSString *, NSString *> *) heads
                                              params:(nullable NSData *) params;
+(nonnull NSData *) parseDictionaryToHttpBody:(nullable NSDictionary<NSString*, id> *) params
                                  contentType:(nonnull NSString *) contentType;
@end
