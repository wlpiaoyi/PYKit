//
//  PYNavigationControll.h
//  PYKit
//
//  Created by wlpiaoyi on 2019/12/10.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "pyutilea.h"
#import "PYNavigationStyleModel.h"

@protocol PYNavigationSetterTag <NSObject>
@optional
-(BOOL) beforePop:(nonnull UIViewController *) vc;
-(BOOL) beforeDismiss:(nonnull UIViewController *) vc;
@end

NS_ASSUME_NONNULL_BEGIN

@interface PYNavigationControll : NSObject
/*
 设置全局导航栏样式
 */
+(void) setNavigationWithBarStyle:(nonnull PYNavigationStyleModel *) barStyle;

@end

NS_ASSUME_NONNULL_END
