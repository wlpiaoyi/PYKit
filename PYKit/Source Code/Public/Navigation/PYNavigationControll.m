//
//  PYNavigationControll.m
//  PYKit
//
//  Created by wlpiaoyi on 2019/12/10.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import "PYNavigationControll.h"
#import "__PY__UIViewcontrollerNavigationImpl.h"
static __PY__UIViewcontrollerNavigationImpl * xUIViewcontrollerNavigationImpl;
@implementation PYNavigationControll
+(void) initialize{
    static dispatch_once_t onceToken; dispatch_once(&onceToken, ^{
        [UIViewController hookMethodView];
        xUIViewcontrollerNavigationImpl = [__PY__UIViewcontrollerNavigationImpl new];
        [UIViewController addDelegateView:xUIViewcontrollerNavigationImpl];
    });
}

+(void) setBackItemWithPopImage:(nonnull UIImage *) popImage dismissImage:(nonnull UIImage *) dismissImage{
    xUIViewcontrollerNavigationImpl.imagePop = popImage;
    xUIViewcontrollerNavigationImpl.imageDismiss = dismissImage;
}

/*
 设置全局导航栏样式
 */
+(void) setNavigationWithBarStyle:(nonnull PYNavigationStyleModel *) barStyle{
    xUIViewcontrollerNavigationImpl.barStyle = barStyle;
}

@end
