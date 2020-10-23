//
//  PYNavigationStyleModel.h
//  PYKit
//
//  Created by wlpiaoyi on 2019/12/10.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "pyutilea.h"

@protocol PYNavigationSetterTag <NSObject>

@optional

/**
 自定义itemFont
 */
-(nonnull UIFont *) pyNavigationItemFont:(nonnull UIBarButtonItem *) barItem;
/**
 自定义itemNormalColor
 */
-(nonnull UIColor *) pyNavigationItemNormalColor:(nonnull UIBarButtonItem *) barItem;
/**
 自定义itemHighlightColor
 */
-(nonnull UIColor *) pyNavigationItemHighlightColor:(nonnull UIBarButtonItem *) barItem;
/**
 自定义tintColor作用于ItemBar图片
 */
-(nonnull UIColor *) pyNavigationItemTintColor:(nonnull UIBarButtonItem *) barItem;

/**
 自定义PopItemBar图片
 */
-(nullable UIImage *) pyNavigatonPopItemImage;

/**
 自定义DismissItemBar图片
 */
-(nullable UIImage *) pyNavigatonDismissItemImage;

/**
 点击退出按钮之前的确认
 @return YES:允许退出 NO:反之
 */
//==========================================================>
-(BOOL) beforeOnclikPop:(nonnull UIViewController *) vc;
-(BOOL) beforeOnclickDismiss:(nonnull UIViewController *) vc;
///<==========================================================

@end


@interface PYNavigationStyleModel : NSObject

kPNSNA id userInfo;

kPNSNA UIImage * popItemimage;
kPNSNA UIImage * dismissItemimage;

kPNSNA UIColor * titleColor;
kPNSNA UIFont * titleFont;

kPNSNA UIColor * itemNormalColor;
kPNSNA UIColor * itemHighlightColor;
kPNSNA UIFont * itemFont;

kPNSNA UIColor * tintColor;
kPNSNA UIColor * backgroundColor;
kPNSNA UIImage * backgroundImage;
kPNSNA UIImage * lineButtomImage;

kPNA UIBarMetrics barMetrics;

kPNA UIStatusBarStyle statusBarStyle;
kPRA BOOL needsUpdateStatusBarStyle;

kPNCNA BOOL (^blockSetNavigationBarStyle)(PYNavigationStyleModel * _Nonnull styleModel, UIViewController * _Nonnull target);
kPNCNA UIView * _Nullable (^blockCreateNavigationBarBackgrand) (UIViewController * _Nonnull vc);

-(nonnull instancetype) initForLight;

-(nonnull instancetype) initForDark;

-(nonnull instancetype) initForDefault;

/**
 设置导航栏样式
 */
+(void) setNavigationBarStyle:(nonnull UINavigationBar *) navigationBar barStyle:(nonnull PYNavigationStyleModel *) barStyle;
/**
设置导航栏按钮样式
 */
 +(void) setNavigationItemStyle:(nonnull UINavigationItem *) navigationItem barStyle:(nonnull PYNavigationStyleModel *) barStyle;
 +(void) setNavigationItemStyle:(nonnull UINavigationItem *) navigationItem barStyle:(nonnull PYNavigationStyleModel *) barStyle target:(nullable UIViewController *) target;
/**
 设置导航栏按钮样式
 */
+(void) setBarButtonItemStyle:(nonnull UIBarButtonItem *) barButtonItem barStyle:(nonnull PYNavigationStyleModel *) barStyle;
+(void) setBarButtonItemStyle:(nonnull UIBarButtonItem *) barButtonItem barStyle:(nonnull PYNavigationStyleModel *) barStyle target:(nullable UIViewController *) target;


@end
