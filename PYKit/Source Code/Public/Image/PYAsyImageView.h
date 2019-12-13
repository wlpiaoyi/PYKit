//
//  PYAsyImageView.h
//  PYNetwork
//
//  Created by wlpiaoyi on 2017/4/10.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYNetwork.h"
@interface PYAsyImageView : UIImageView
kPNA BOOL hasPercentage;
kPNSNN NSString * cacheTag;
kPNSNN NSString * imgUrl;
@property (nonatomic, copy, nullable) void (^blockDisplay)(bool isSuccess, bool isCahes, PYAsyImageView * _Nonnull imageView);
@property (nonatomic, copy, nullable) void (^blockProgress)(double progress, PYAsyImageView * _Nonnull imageView);
+(bool) clearCache:(nonnull NSString *) imgUrl;
+(bool) clearCaches;
@end
