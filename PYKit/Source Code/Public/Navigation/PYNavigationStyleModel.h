//
//  PYNavigationStyleModel.h
//  PYKit
//
//  Created by wlpiaoyi on 2019/12/10.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "pyutilea.h"

@interface PYNavigationStyleModel : NSObject

kPNSNA UIImage * popItemimage;
kPNSNA UIImage * dismissItemimage;

kPNA CGSize textShadowOffset;      // offset in user space of the shadow from the original drawing
kPNA CGFloat textShadowBlurRadius; // blur radius of the shadow in default user space units
kPNSNA UIColor * textShadowColor;     // color used for the shadow (default is black with an alpha value of 1/3)

kPNSNA UIColor * titleColor;
kPNSNA UIFont * titleFont;

kPNSNA UIColor * itemColor;
kPNSNA UIFont * itemFont;
kPNA UIControlState itemState;

kPNSNA UIColor * tintColor;
kPNSNA UIColor * backgroundColor;
kPNSNA UIImage * backgroundImage;
kPNSNA UIImage * lineButtomImage;

kPNA UIBarMetrics barMetrics;

kPNA UIStatusBarStyle statusBarStyle;

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
/**
 设置导航栏按钮样式
 */
+(void) setBarButtonItemStyle:(nonnull UIBarButtonItem *) barButtonItem barStyle:(nonnull PYNavigationStyleModel *) barStyle;


@end
