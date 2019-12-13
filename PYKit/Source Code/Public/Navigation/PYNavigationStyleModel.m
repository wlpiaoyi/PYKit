//
//  PYNavigationStyleModel.m
//  PYKit
//
//  Created by wlpiaoyi on 2019/12/10.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import "PYNavigationStyleModel.h"

@implementation PYNavigationStyleModel

-(instancetype) initForLight{
    if (self = [super init]) {
        [self initLightParams];
    }
    return self;
}

-(instancetype) initForDark{
    if (self = [super init]) {
        [self initDarkParams];
    }
    return self;
}

-(instancetype) initForDefault{
    if (self = [super init]) {
        [self initDefaultParams];
    }
    return self;
}

-(void) initDarkParams{
    self.shadowOffset = CGSizeZero;
    self.barMetrics =  UIBarMetricsDefault;
    self.statusBarStyle = UIStatusBarStyleLightContent;
    self.lineButtomImage = [UIImage new];
    self.shadowBlurRadius = 0;
    self.shadowColor = [UIColor clearColor];
    self.titleColor = [UIColor whiteColor];
    self.titleFont = [UIFont systemFontOfSize:20];
    self.itemColor = [UIColor whiteColor];
    self.itemFont = [UIFont systemFontOfSize:14];
    self.itemState = UIControlStateNormal;
    self.tintColor = [UIColor whiteColor];
    self.backgroundImage = [UIImage imageWithColor:[UIColor clearColor]];
    
}

-(void) initLightParams{
    self.shadowOffset = CGSizeZero;
    self.barMetrics =  UIBarMetricsDefault;
    if (@available(iOS 13.0, *)) {
        self.statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        self.statusBarStyle = UIStatusBarStyleDefault;
    }
    self.lineButtomImage = [UIImage new];
    self.shadowBlurRadius = 0;
    self.shadowColor = [UIColor clearColor];
    self.titleColor = [UIColor darkTextColor];
    self.titleFont = [UIFont systemFontOfSize:20];
    self.itemColor = [UIColor whiteColor];
    self.itemFont = [UIFont systemFontOfSize:14];
    self.itemState = UIControlStateNormal;
    self.tintColor = [UIColor darkTextColor];
    self.backgroundImage = [UIImage imageWithColor:[UIColor clearColor]];
}

-(void) initDefaultParams{
    if (@available(iOS 13.0, *)) {
        if([PYUtile getCurrenWindow].overrideUserInterfaceStyle == UIUserInterfaceStyleLight){
            [self initLightParams];
        }else{
            [self initDefaultParams];
        }
    }else{
        [self initLightParams];
    }
}

/**
 设置导航栏样式
 */
+(void) setNavigationBarStyle:(nonnull UINavigationBar *) navigationBar barStyle:(nonnull PYNavigationStyleModel *) barStyle{

    NSMutableDictionary *titleTextAttributes = [NSMutableDictionary dictionaryWithDictionary:[navigationBar titleTextAttributes]];
    NSShadow *shadow = titleTextAttributes[NSShadowAttributeName];
    if (!shadow) {
        shadow = [[NSShadow alloc] init];
    }
    if (barStyle.shadowOffset.width != CGSizeZero.width && barStyle.shadowOffset.height != CGSizeZero.height) {
        shadow.shadowOffset = barStyle.shadowOffset;
    }
    if (barStyle.shadowBlurRadius != CGFLOAT_MIN) {
        shadow.shadowBlurRadius = barStyle.shadowBlurRadius;
    }
    if (barStyle.shadowColor) {
        shadow.shadowColor = barStyle.shadowColor;
    }
    titleTextAttributes[NSShadowAttributeName] = shadow;
    
    if (barStyle.titleColor) {
        titleTextAttributes[NSForegroundColorAttributeName] = barStyle.titleColor;
    }
    if (barStyle.titleFont) {
        titleTextAttributes[NSFontAttributeName] = barStyle.titleFont;
    }
    
    [navigationBar setTitleTextAttributes:titleTextAttributes];
    
    if (barStyle.tintColor) {
        [navigationBar setTintColor:barStyle.tintColor];
    }
    if (barStyle.backgroundColor) {
        [navigationBar setBackgroundColor:barStyle.backgroundColor];
    }else if (barStyle.backgroundImage) {
        [navigationBar setBackgroundImage:barStyle.backgroundImage forBarMetrics:barStyle.barMetrics];
    }
    
    if(barStyle.lineButtomImage)navigationBar.shadowImage = barStyle.lineButtomImage;
}

/**
设置导航栏按钮样式
 */
+(void) setNavigationItemStyle:(nonnull UINavigationItem *) navigationItem barStyle:(nonnull PYNavigationStyleModel *) barStyle{
    if(navigationItem.leftBarButtonItems){
        for (UIBarButtonItem * barButtonItem in navigationItem.leftBarButtonItems) {
            [self setBarButtonItemStyle:barButtonItem barStyle:barStyle];
        }
    }else if(navigationItem.backBarButtonItem){
        [self setBarButtonItemStyle:navigationItem.backBarButtonItem barStyle:barStyle];
    }
    
    if(navigationItem.rightBarButtonItems){
        for (UIBarButtonItem * barButtonItem in navigationItem.rightBarButtonItems) {
            [self setBarButtonItemStyle:barButtonItem barStyle:barStyle];
        }
    }
}

/**
 设置导航栏按钮样式
 */
+(void) setBarButtonItemStyle:(nonnull UIBarButtonItem *) barButtonItem barStyle:(nonnull PYNavigationStyleModel *) barStyle{
    NSMutableDictionary *titleTextAttributes = [NSMutableDictionary dictionaryWithDictionary:[barButtonItem titleTextAttributesForState:barStyle.itemState]];

    NSShadow *shadow = titleTextAttributes[NSShadowAttributeName];
    if (!shadow) {
        shadow = [[NSShadow alloc] init];
    }
    if (barStyle.shadowOffset.width != CGSizeZero.width && barStyle.shadowOffset.height != CGSizeZero.height) {
        shadow.shadowOffset = barStyle.shadowOffset;
    }
    if (barStyle.shadowBlurRadius != CGFLOAT_MIN) {
        shadow.shadowBlurRadius = barStyle.shadowBlurRadius;
    }
    if (barStyle.shadowColor) {
        shadow.shadowColor = barStyle.shadowColor;
    }
    titleTextAttributes[NSShadowAttributeName] = shadow;
    if (barStyle.itemColor) {
        titleTextAttributes[NSForegroundColorAttributeName] = barStyle.itemColor;
    }
    if (barStyle.itemFont) {
        titleTextAttributes[NSFontAttributeName] = barStyle.itemFont;
    }
    
    [barButtonItem setTitleTextAttributes:titleTextAttributes forState:barStyle.itemState];
    
}

@end
