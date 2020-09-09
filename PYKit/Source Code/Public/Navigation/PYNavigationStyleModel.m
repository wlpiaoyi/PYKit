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
    self.statusBarStyle = UIStatusBarStyleDefault;
    self.lineButtomImage = [UIImage imageWithColor:[UIColor lightGrayColor]];
    self.textShadowBlurRadius = 0;
    self.textShadowColor = [UIColor clearColor];
    self.titleFont = [UIFont systemFontOfSize:20];
    [UIColor whiteColor];
    self.itemFont = [UIFont systemFontOfSize:14];
    self.itemState = UIControlStateNormal;
    self.itemColor = self.titleColor = self.tintColor = [UIColor whiteColor];
    self.backgroundImage = [UIImage imageWithColor:[UIColor clearColor]];
    _needsUpdateStatusBarStyle = YES;
    
}

-(void) initLightParams{
    self.textShadowOffset = CGSizeZero;
    self.barMetrics =  UIBarMetricsDefault;
    self.statusBarStyle = UIStatusBarStyleDefault;
    self.lineButtomImage = [UIImage imageWithColor:[UIColor lightGrayColor]];
    self.textShadowBlurRadius = 0;
    self.textShadowColor = [UIColor clearColor];
    self.titleFont = [UIFont systemFontOfSize:20];
    self.itemFont = [UIFont systemFontOfSize:14];
    self.itemState = UIControlStateNormal;
    self.itemColor = self.titleColor = self.tintColor = [UIColor blackColor];
    self.backgroundImage = [UIImage imageWithColor:[UIColor clearColor]];
    _needsUpdateStatusBarStyle = YES;
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
    [self setNavigationItemStyle:navigationItem barStyle:barStyle target:nil];
}

+(void) setNavigationItemStyle:(nonnull UINavigationItem *) navigationItem barStyle:(nonnull PYNavigationStyleModel *) barStyle target:(nullable UIViewController *) target{
    if(navigationItem.leftBarButtonItems){
        for (UIBarButtonItem * barButtonItem in navigationItem.leftBarButtonItems) {
            [self setBarButtonItemStyle:barButtonItem barStyle:barStyle target:target];
        }
    }else if(navigationItem.backBarButtonItem){
        [self setBarButtonItemStyle:navigationItem.backBarButtonItem barStyle:barStyle target:target];
    }
    if(navigationItem.rightBarButtonItems){
        for (UIBarButtonItem * barButtonItem in navigationItem.rightBarButtonItems) {
            [self setBarButtonItemStyle:barButtonItem barStyle:barStyle target:target];
        }
    }
    
}

/**
 设置导航栏按钮样式
 */
+(void) setBarButtonItemStyle:(nonnull UIBarButtonItem *) barButtonItem barStyle:(nonnull PYNavigationStyleModel *) barStyle{
    [self setBarButtonItemStyle:barButtonItem barStyle:barStyle target:nil];
}

/**
 设置导航栏按钮样式
 */
+(void) setBarButtonItemStyle:(nonnull UIBarButtonItem *) barButtonItem barStyle:(nonnull PYNavigationStyleModel *) barStyle target:(UIViewController *) target{
    if(barButtonItem.customView && [barButtonItem.customView isKindOfClass:[UIButton class]]){
        if(((UIButton *)barButtonItem.customView).buttonType == UIButtonTypeCustom) return;
        if(barStyle.itemFont) ((UIButton *)barButtonItem.customView).titleLabel.font = barStyle.itemFont;
        if(barStyle.itemColor){
            [((UIButton *)barButtonItem.customView) setTitleColor:barStyle.itemColor forState:UIControlStateNormal];
            [((UIButton *)barButtonItem.customView) setTitleColor:[UIColor colorWithRed:barStyle.itemColor.red green:barStyle.itemColor.green blue:barStyle.itemColor.blue alpha:barStyle.itemColor.alpha * .5] forState:UIControlStateHighlighted];
            [UIButton buttonWithType:UIButtonTypeSystem];
            [((UIButton *)barButtonItem.customView) setTintColor:barStyle.itemColor];
        }
    }else{
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
    
}

-(void) setStatusBarStyle:(UIStatusBarStyle)statusBarStyle{
    if(_statusBarStyle != statusBarStyle){
        _needsUpdateStatusBarStyle = YES;
    }
    _statusBarStyle = statusBarStyle;
}

-(void) setNeedsUpdateStatusBarStyle:(BOOL)needsUpdateStatusBarStyle{
    _needsUpdateStatusBarStyle = needsUpdateStatusBarStyle;
}

@end
