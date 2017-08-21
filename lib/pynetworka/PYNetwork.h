//
//  PYNetwork.h
//  PYNetwork
//
//  Created by wlpiaoyi on 2017/4/14.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import "pyutilea.h"
#ifndef pyutilea
#import <UIKit/UIKit.h>
#import <Utile/EXTScope.h>
#import <Utile/PYUtile.h>
#import <Utile/NSString+Expand.h>
#import <Utile/NSData+Expand.h>
#import <Utile/NSDictionary+Expand.h>
#import <Utile/PYReachabilityListener.h>
#import <Utile/PYViewAutolayoutCenter.h>
#define PYPNSNA @property (nonatomic, strong, nullable)
#define PYPNSNN @property (nonatomic, strong, nonnull)
#define PYPNRNN @property (nonatomic, readonly, nonnull)
#define PYPNCNA @property (nonatomic, copy, nullable)
#define PYPNA @property (nonatomic, assign)
#define PYINITPARAMS -(instancetype) initWithFrame:(CGRect)frame{if(self = [super initWithFrame:frame]){[self initParams];}return self;} -(instancetype) initWithCoder:(NSCoder *)aDecoder{ if(self = [super initWithCoder:aDecoder]){ [self initParams];}return self;}

#define PYSOULDLAYOUTP @property (nonatomic) CGSize __layoutSubviews_UseSize;
#define PYSOULDLAYOUTM -(BOOL) __layoutSubviews_Size_Compare{ if(CGSizeEqualToSize(self.__layoutSubviews_UseSize, self.bounds.size)){return false;}self.__layoutSubviews_UseSize = self.bounds.size;return true;}
#define PYSOULDLAYOUTE [self __layoutSubviews_Size_Compare]
#endif


static NSString * _Nonnull  PYNetworkCache;
static NSTimeInterval   PYNetworkOutTime;


//==>传输方法
extern const NSString * _Nonnull PYNET_HTTP_GET;
extern const NSString * _Nonnull PYNET_HTTP_POST;
extern const NSString * _Nonnull PYNET_HTTP_PUT ;
extern const NSString * _Nonnull PYNET_HTTP_DELETE;
///<==

@interface PYNetwork : NSObject
@property (nonatomic) NSTimeInterval outTime;
PYPNSNA id userInfo;
PYPNSNN NSURLSession * session;


PYPNSNN NSString * url;
PYPNSNN NSString * method;
PYPNSNA NSDictionary<NSString *, id> * params;
PYPNSNA NSDictionary<NSString *, NSString *> * heads;
PYPNSNN NSURLSessionTask * sessionTask;

PYPNCNA void (^blockSendProgress) (PYNetwork * _Nonnull target, int64_t currentBytes, int64_t totalBytes);
PYPNCNA BOOL (^blockReceiveChallenge)(id _Nullable data, PYNetwork * _Nonnull target) ;
PYPNCNA void (^blockComplete)(id _Nullable data, PYNetwork * _Nonnull target);

PYPNSNA NSString * certificationName;
PYPNSNA NSString * certificationPassword;
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
