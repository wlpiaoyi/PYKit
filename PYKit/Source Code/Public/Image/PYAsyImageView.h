//
//  PYAsyImageView.h
//  PYNetwork
//
//  Created by wlpiaoyi on 2017/4/10.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYNetwork.h"

extern UIImage * PY_ASY_DEFAULT_IMG;
extern UIImage * PY_ASY_NODATA_IMG;

extern NSDictionary<NSString*, UIImage *> * PY_ASY_DEFAULT_IMG_DICT;
extern NSDictionary<NSString*, UIImage *> * PY_ASY_NODATA_IMG_DICT;

@interface PYAsyImageView : UIImageView
kPNSNA UIImage * defaultImg;
kPNSNA UIImage * noDataImg;
kPNA BOOL hasPercentage;
kPNSNN NSString * imgUrl;
kPNRNA NSString * cacheTag;
kPNSNA NSString * showType;
@property (nonatomic, copy, nullable) void (^blockDisplay)(bool isSuccess, bool isCahes, PYAsyImageView * _Nonnull imageView);
@property (nonatomic, copy, nullable) void (^blockProgress)(double progress, PYAsyImageView * _Nonnull imageView);
-(void) setImgUrl:(nonnull NSString *) imgUrl cacheTag:(nullable NSString *) cacheTag;
+(nullable UIImage *) getCacheImageWithUrl:(nonnull NSString *) url;
+(bool) clearCache:(nonnull NSString *) imgUrl;
+(bool) clearCaches;
@end
