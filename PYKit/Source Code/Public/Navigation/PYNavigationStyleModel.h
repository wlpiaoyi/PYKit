//
//  PYNavigationStyleModel.h
//  PYKit
//
//  Created by wlpiaoyi on 2019/12/10.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "pyutilea.h"


@class PYNavigationItemStyleModel, PYNavigationBackItemStyleModel, PYNavigationBarStyleModel;

@interface PYNavigationStyleModel : NSObject

kPNSNA id userInfo;

kPNSNA PYNavigationBarStyleModel * barStyle;
kPNSNA PYNavigationItemStyleModel * itemStyle;
kPNSNA PYNavigationBackItemStyleModel * popStyle;
kPNSNA PYNavigationBackItemStyleModel * dismissStyle;

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
+(void) setNavigationBarStyle:(nonnull UINavigationBar *) navigationBar barStyle:(nonnull PYNavigationBarStyleModel *) barStyle target:(nullable UIViewController *) target;

/**
设置导航栏按钮样式
 */
 +(void) setNavigationItemStyle:(nonnull UINavigationItem *) navigationItem itemStyle:(nonnull PYNavigationItemStyleModel *) itemStyle target:(nullable UIViewController *) target;

/**
 设置导航栏按钮样式
 */
 +(void) setBarButtonItemStyle:(nonnull UIBarButtonItem *) barButtonItem itemStyle:(nonnull PYNavigationItemStyleModel *) itemStyle target:(nullable UIViewController *) target;


@end

@protocol PYNavigationSetterTag <NSObject>

@optional

/**
 自定义barStyle
 */
-(nonnull PYNavigationBarStyleModel *) pyNavigationBarStyle:(nonnull PYNavigationBarStyleModel *) barStyle;

/**
 自定义itemStyle
 */
-(nonnull PYNavigationItemStyleModel *) pyNavigationItemStyle:(nonnull PYNavigationItemStyleModel *) itemStyle;

/**
 自定义PopItemBar
 @return 返回nil表示不需要返回按钮
 */
 -(nullable PYNavigationBackItemStyleModel *) pyNavigatonPopStyle:(nonnull PYNavigationBackItemStyleModel *) popStyle;

/**
 自定义DismissStyle
 @return 返回nil表示不需要返回按钮
 */
 -(nullable PYNavigationBackItemStyleModel *) pyNavigatonDismissStyle:(nonnull PYNavigationBackItemStyleModel *) dismissStyle;

/**
 点击退出按钮之前的确认
 @return YES:允许退出 NO:反之
 */
//==========================================================>
-(BOOL) beforeOnclikPop:(nonnull UIViewController *) vc;
-(BOOL) beforeOnclickDismiss:(nonnull UIViewController *) vc;
///<==========================================================

@end

/**
 导航栏样式
 */
@interface PYNavigationBarStyleModel : NSObject

kPNSNA UIColor * titleColor;
kPNSNA UIFont * titleFont;
kPNSNA UIColor * tintColor;
kPNSNA UIColor * backgroundColor;
kPNSNA UIImage * backgroundImage;
kPNSNA UIImage * lineButtomImage;

kPNA UIBarMetrics barMetrics;

-(void) setStyleWithNavigaitonBar:(nonnull UINavigationBar *) navigationBar;

@end

/**
 按钮样式
 */
@interface PYNavigationItemStyleModel : NSObject

kPNSNA UIFont * font;
kPNSNA UIColor * tintColor;
kPNSNA UIColor * normalColor;
kPNSNA UIColor * highlightedColor;

-(nonnull UIButton *) createButton;
-(void) setStyleWithButton:(nonnull UIButton *) button;
-(void) setStyleWithButtonItem:(nonnull UIBarButtonItem *) buttonItem;

@end
/**
 退出按钮样式
 */
@interface PYNavigationBackItemStyleModel : PYNavigationItemStyleModel

kPNSNA NSString * title;
kPNSNA UIImage * normalImage;
kPNSNA UIImage * highlightedImage;

@end

@interface PYBackButtonItem : UIBarButtonItem @end
