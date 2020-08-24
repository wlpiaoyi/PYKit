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
    self.textShadowOffset = CGSizeZero;
    self.barMetrics =  UIBarMetricsDefault;
    self.statusBarStyle = UIStatusBarStyleLightContent;
    self.lineButtomImage = [UIImage imageWithColor:[UIColor lightGrayColor]];
    self.textShadowBlurRadius = 0;
    self.textShadowColor = [UIColor clearColor];
    self.titleFont = [UIFont systemFontOfSize:20];
    [UIColor whiteColor];
    self.itemFont = [UIFont systemFontOfSize:14];
    self.itemState = UIControlStateNormal;
    self.itemColor = self.titleColor = self.tintColor = [UIColor whiteColor];
    self.backgroundImage = [UIImage imageWithColor:[UIColor clearColor]];
    
}

-(void) initLightParams{
    self.textShadowOffset = CGSizeZero;
    self.barMetrics =  UIBarMetricsDefault;
    if (@available(iOS 13.0, *)) {
        self.statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        self.statusBarStyle = UIStatusBarStyleDefault;
    }
    self.lineButtomImage = [UIImage imageWithColor:[UIColor lightGrayColor]];
    self.textShadowBlurRadius = 0;
    self.textShadowColor = [UIColor clearColor];
    self.titleFont = [UIFont systemFontOfSize:20];
    self.itemFont = [UIFont systemFontOfSize:14];
    self.itemState = UIControlStateNormal;
    self.itemColor = self.titleColor = self.tintColor = [UIColor blackColor];
    self.backgroundImage = [UIImage imageWithColor:[UIColor clearColor]];
}

-(void) initDefaultParams{
    if (@available(iOS 13.0, *)) {
        if(UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark){
            [self initDarkParams];
        }else{
            [self initLightParams];
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
    if (barStyle.textShadowOffset.width != CGSizeZero.width && barStyle.textShadowOffset.height != CGSizeZero.height) {
        shadow.shadowOffset = barStyle.textShadowOffset;
    }
    if (barStyle.textShadowBlurRadius != CGFLOAT_MIN) {
        shadow.shadowBlurRadius = barStyle.textShadowBlurRadius;
    }
    if (barStyle.textShadowColor) {
        shadow.shadowColor = barStyle.textShadowColor;
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
    if(barStyle.backgroundImage){
        [navigationBar setBackgroundColor:[UIColor clearColor]];
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
    if (barStyle.textShadowOffset.width != CGSizeZero.width && barStyle.textShadowOffset.height != CGSizeZero.height) {
        shadow.shadowOffset = barStyle.textShadowOffset;
    }
    if (barStyle.textShadowBlurRadius != CGFLOAT_MIN) {
        shadow.shadowBlurRadius = barStyle.textShadowBlurRadius;
    }
    if (barStyle.textShadowColor) {
        shadow.shadowColor = barStyle.textShadowColor;
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
