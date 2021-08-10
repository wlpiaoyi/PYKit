//
//  PYAsyImageView.h
//  PYNetwork
//
//  Created by wlpiaoyi on 2017/4/10.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYNetwork.h"


extern NSDictionary<NSString*, UIImage *> * _Nullable PY_ASY_NODATA_IMG_DICT;
extern NSDictionary<NSString*, UIImage *> * _Nullable PY_ASY_LOADING_IMG_DICT;
extern void (^PY_ASY_BLOCK_OPTION) (UIImageView * _Nonnull imageView);

@interface PYAsyImageView : UIImageView

kPNSNA UIImage * imageNoData;
kPNSNA UIImage * imageLoading;

kPNA BOOL hasPercentage;

kPNSNN NSString * imgUrl;
kPNSNA NSString * showType;

kPCNRA NSString * dictDefaultKey;

@property (nonatomic, copy, nullable) void (^blockDisplay)(bool isSuccess, bool isCahes, PYAsyImageView * _Nonnull imageView);
@property (nonatomic, copy, nullable) void (^blockProgress)(double progress, PYAsyImageView * _Nonnull imageView);

+(nullable NSString *) getCachePathWithUrl:(nonnull NSString *) url;
+(bool) clearCache:(nonnull NSString *) imgUrl;
+(bool) clearCaches;
+(void) checkCachesPath;

@end
