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
//    self.textShadowOffset = CGSizeZero;
//    self.textShadowBlurRadius = 0;
//    self.textShadowColor = [UIColor clearColor];
    self.barMetrics =  UIBarMetricsDefault;
    self.statusBarStyle = UIStatusBarStyleDefault;
    self.lineButtomImage = [UIImage imageWithColor:[UIColor lightGrayColor]];
    self.titleFont = [UIFont systemFontOfSize:20];
    self.itemFont = [UIFont systemFontOfSize:14];
    self.itemNormalColor = self.titleColor = self.tintColor = [UIColor whiteColor];
    self.backgroundImage = [UIImage imageWithColor:[UIColor clearColor]];
    _needsUpdateStatusBarStyle = YES;
    
}

-(void) initLightParams{
//    self.textShadowOffset = CGSizeZero;
//    self.textShadowBlurRadius = 0;
//    self.textShadowColor = [UIColor clearColor];
    self.barMetrics =  UIBarMetricsDefault;
    self.statusBarStyle = UIStatusBarStyleDefault;
    self.lineButtomImage = [UIImage imageWithColor:[UIColor lightGrayColor]];
    self.titleFont = [UIFont systemFontOfSize:20];
    self.itemFont = [UIFont systemFontOfSize:14];
    self.itemNormalColor = self.titleColor = self.tintColor = [UIColor blackColor];
    self.backgroundImage = [UIImage imageWithColor:[UIColor clearColor]];
    _needsUpdateStatusBarStyle = YES;
}

-(void) initDefaultParams{
    if (@available(iOS 13.0, *)) {
//        self.textShadowOffset = CGSizeZero;
//        self.textShadowBlurRadius = 0;
//        self.textShadowColor = [UIColor clearColor];
        self.barMetrics =  UIBarMetricsDefault;
        self.statusBarStyle = UIStatusBarStyleDefault;
        self.lineButtomImage = [UIImage imageWithColor:[UIColor lightGrayColor]];
        self.titleFont = [UIFont systemFontOfSize:20];
        self.itemFont = [UIFont systemFontOfSize:14];
        self.itemNormalColor = self.titleColor = self.tintColor = [UIColor labelColor];
        self.backgroundImage = [UIImage imageWithColor:[UIColor clearColor]];
        _needsUpdateStatusBarStyle = YES;
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
    if (!shadow)  shadow = [[NSShadow alloc] init];
    titleTextAttributes[NSShadowAttributeName] = shadow;
    
    if (barStyle.titleColor) titleTextAttributes[NSForegroundColorAttributeName] = barStyle.titleColor;
    if (barStyle.titleFont) titleTextAttributes[NSFontAttributeName] = barStyle.titleFont;
    
    [navigationBar setTitleTextAttributes:titleTextAttributes];
    
    if (barStyle.tintColor)  [navigationBar setTintColor:barStyle.tintColor];
    else [navigationBar setTintColor:nil];
    
    if(barStyle.backgroundImage){
        [navigationBar setBackgroundColor:[UIColor clearColor]];
        [navigationBar setBackgroundImage:barStyle.backgroundImage forBarMetrics:barStyle.barMetrics];
    }else if(barStyle.backgroundColor) navigationBar.backgroundColor = barStyle.backgroundColor;
    
    if(barStyle.lineButtomImage) navigationBar.shadowImage = barStyle.lineButtomImage;
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

    UIColor * tintColor = barStyle.tintColor;
    UIFont * itemFont = barStyle.itemFont;
    UIColor * itemNormalColor = barStyle.itemNormalColor;
    UIColor * itemHighlightColor = barStyle.itemHighlightColor;
    
    if([((id<PYNavigationSetterTag>)target) respondsToSelector:@selector(pyNavigationItemTintColor:)]){
        tintColor = [((id<PYNavigationSetterTag>)target) pyNavigationItemTintColor:barButtonItem];
    }
    if([((id<PYNavigationSetterTag>)target) respondsToSelector:@selector(pyNavigationItemFont:)]){
        itemFont = [((id<PYNavigationSetterTag>)target) pyNavigationItemFont:barButtonItem];
    }
    if([((id<PYNavigationSetterTag>)target) respondsToSelector:@selector(pyNavigationItemNormalColor:)]){
        itemNormalColor = [((id<PYNavigationSetterTag>)target) pyNavigationItemNormalColor:barButtonItem];
    }
    if([((id<PYNavigationSetterTag>)target) respondsToSelector:@selector(pyNavigationItemHighlightColor:)]){
        itemHighlightColor = [((id<PYNavigationSetterTag>)target) pyNavigationItemHighlightColor:barButtonItem];
    }
    
    
    if(barButtonItem.customView){
        
        if(![barButtonItem.customView isKindOfClass:[UIButton class]]) return;
        UIButton * button = barButtonItem.customView;
        if(button.buttonType != UIButtonTypeSystem) return;
        
        if(tintColor) [button setTintColor:tintColor];
        if(itemFont) button.titleLabel.font = itemFont;
        if(itemNormalColor) [button setTitleColor:itemNormalColor forState:UIControlStateNormal];
        if(itemHighlightColor) [button setTitleColor:itemHighlightColor forState:UIControlStateHighlighted];
        else if(itemNormalColor) [button setTitleColor:itemNormalColor forState:UIControlStateHighlighted];
        if([button imageForState:UIControlStateNormal] && ![button imageForState:UIControlStateHighlighted])
        [button setImage:[button imageForState:UIControlStateNormal] forState:UIControlStateHighlighted];
        
        return;
    }
    
    if(barButtonItem.customView == nil){
        UIButton * button;
        if(barButtonItem.image){
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:barButtonItem.image forState:UIControlStateNormal];
            [button setImage:barButtonItem.image forState:UIControlStateHighlighted];
            barButtonItem.image = nil;
        }else if([NSString isEnabled:barButtonItem.title]){
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:barButtonItem.title forState:UIControlStateNormal];
            if(itemNormalColor) [button setTitleColor:itemNormalColor forState:UIControlStateNormal];
            if(itemHighlightColor) [button setTitleColor:itemHighlightColor forState:UIControlStateHighlighted];
            else if(itemNormalColor) [button setTitleColor:itemNormalColor forState:UIControlStateHighlighted];
            button.titleLabel.font = itemFont;
            barButtonItem.title = nil;
        }
        [button addTarget:barButtonItem.target action:barButtonItem.action forControlEvents:UIControlEventTouchUpInside];
        [barButtonItem setCustomView:button];
        
//        NSMutableDictionary * textNormalAttributes = [barButtonItem titleTextAttributesForState:UIControlStateNormal].mutableCopy;
//        NSMutableDictionary * textHighlightedAttributes = [barButtonItem titleTextAttributesForState:UIControlStateHighlighted].mutableCopy;
//        NSShadow * shadowNormal =  textNormalAttributes[NSShadowAttributeName];
//        NSShadow * shadowHighlighted =  textNormalAttributes[NSShadowAttributeName];
//
//        if(!shadowNormal) shadowNormal = [[NSShadow alloc] init];
//        if(!shadowHighlighted) shadowHighlighted = [[NSShadow alloc] init];
//
//        if(barStyle.textShadowOffset.width != CGSizeZero.width && barStyle.textShadowOffset.height != CGSizeZero.height) {
//            shadowNormal.shadowOffset = barStyle.textShadowOffset;
//            shadowHighlighted.shadowOffset = barStyle.textShadowOffset;
//        }
//        if(barStyle.textShadowBlurRadius != CGFLOAT_MIN) {
//            shadowNormal.shadowBlurRadius = barStyle.textShadowBlurRadius;
//            shadowHighlighted.shadowBlurRadius = barStyle.textShadowBlurRadius;
//        }
//        if(barStyle.textShadowColor) {
//            shadowNormal.shadowColor = barStyle.textShadowColor;
//            shadowHighlighted.shadowColor = barStyle.textShadowColor;
//        }
//        textNormalAttributes[NSShadowAttributeName] = shadowNormal;
//        textHighlightedAttributes[NSShadowAttributeName] = shadowHighlighted;
//
//        if(barStyle.itemNormalColor)  textNormalAttributes[NSForegroundColorAttributeName] = barStyle.itemNormalColor;
//        if(barStyle.itemHighlightColor) textHighlightedAttributes[NSForegroundColorAttributeName] = barStyle.itemHighlightColor;
//        else if(barStyle.itemNormalColor) textHighlightedAttributes[NSForegroundColorAttributeName] = barStyle.itemNormalColor;
//
//        if (barStyle.itemFont) {
//            textNormalAttributes[NSFontAttributeName] = barStyle.itemFont;
//            textHighlightedAttributes[NSFontAttributeName] = barStyle.itemFont;
//        }
//        [barButtonItem setTitleTextAttributes:textNormalAttributes forState:UIControlStateNormal];
//        [barButtonItem setTitleTextAttributes:textHighlightedAttributes forState:UIControlStateHighlighted];
//        [barButtonItem setTintColor:tintColor];
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
