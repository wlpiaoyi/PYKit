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
    PYNavigationItemStyleModel * itemStyle = [PYNavigationItemStyleModel new];
    PYNavigationBackItemStyleModel * popStyle = [PYNavigationBackItemStyleModel new];
    PYNavigationBackItemStyleModel * dismissStyle = [PYNavigationBackItemStyleModel new];
    PYNavigationBarStyleModel * barStyle =[PYNavigationBarStyleModel new];
    itemStyle.font = popStyle.font = dismissStyle.font = [UIFont systemFontOfSize:14];
    barStyle.titleColor = itemStyle.normalColor = popStyle.normalColor = dismissStyle.normalColor = [UIColor whiteColor];
    barStyle.barMetrics =  UIBarMetricsDefault;
    barStyle.lineButtomImage = [UIImage imageWithColor:[UIColor lightGrayColor]];
    barStyle.titleFont = [UIFont systemFontOfSize:20];
    barStyle.backgroundImage = [UIImage imageWithColor:[UIColor clearColor]];
    self.itemStyle = itemStyle;
    self.popStyle = popStyle;
    self.dismissStyle = dismissStyle;
    self.barStyle = barStyle;
    self.statusBarStyle = UIStatusBarStyleDefault;
    _needsUpdateStatusBarStyle = YES;
    
}

-(void) initLightParams{
    PYNavigationItemStyleModel * itemStyle = [PYNavigationItemStyleModel new];
    PYNavigationBackItemStyleModel * popStyle = [PYNavigationBackItemStyleModel new];
    PYNavigationBackItemStyleModel * dismissStyle = [PYNavigationBackItemStyleModel new];
    PYNavigationBarStyleModel * barStyle =[PYNavigationBarStyleModel new];
    itemStyle.font = popStyle.font = dismissStyle.font = [UIFont systemFontOfSize:14];
    barStyle.titleColor = itemStyle.normalColor = popStyle.normalColor = dismissStyle.normalColor = [UIColor blackColor];
    barStyle.barMetrics =  UIBarMetricsDefault;
    barStyle.lineButtomImage = [UIImage imageWithColor:[UIColor lightGrayColor]];
    barStyle.titleFont = [UIFont systemFontOfSize:20];
    barStyle.backgroundImage = [UIImage imageWithColor:[UIColor clearColor]];
    self.itemStyle = itemStyle;
    self.popStyle = popStyle;
    self.dismissStyle = dismissStyle;
    self.barStyle = barStyle;
    self.statusBarStyle = UIStatusBarStyleDefault;
    _needsUpdateStatusBarStyle = YES;
}

-(void) initDefaultParams{
    if (@available(iOS 13.0, *)) {
        PYNavigationItemStyleModel * itemStyle = [PYNavigationItemStyleModel new];
        PYNavigationBackItemStyleModel * popStyle = [PYNavigationBackItemStyleModel new];
        PYNavigationBackItemStyleModel * dismissStyle = [PYNavigationBackItemStyleModel new];
        PYNavigationBarStyleModel * barStyle =[PYNavigationBarStyleModel new];
        itemStyle.font = popStyle.font = dismissStyle.font = [UIFont systemFontOfSize:14];
        barStyle.titleColor = itemStyle.normalColor = popStyle.normalColor = dismissStyle.normalColor = [UIColor labelColor];
        barStyle.barMetrics =  UIBarMetricsDefault;
        barStyle.lineButtomImage = [UIImage imageWithColor:[UIColor lightGrayColor]];
        barStyle.titleFont = [UIFont systemFontOfSize:20];
        barStyle.backgroundImage = [UIImage imageWithColor:[UIColor clearColor]];
        self.itemStyle = itemStyle;
        self.popStyle = popStyle;
        self.dismissStyle = dismissStyle;
        self.barStyle = barStyle;
        self.statusBarStyle = UIStatusBarStyleDefault;
        _needsUpdateStatusBarStyle = YES;
    }else{
        [self initLightParams];
    }
}

/**
 设置导航栏样式
 */
+(void) setNavigationBarStyle:(nonnull UINavigationBar *) navigationBar barStyle:(nonnull PYNavigationBarStyleModel *) barStyle target:(nullable UIViewController *) target{
    
    if([((id<PYNavigationSetterTag>)target) respondsToSelector:@selector(pyNavigationBarStyle:)]){
        barStyle = [((id<PYNavigationSetterTag>)target) pyNavigationBarStyle:barStyle];
    }
    [barStyle setStyleWithNavigaitonBar:navigationBar];
}

/**
设置导航栏按钮样式
 */
+(void) setNavigationItemStyle:(nonnull UINavigationItem *) navigationItem itemStyle:(nonnull PYNavigationItemStyleModel *) itemStyle target:(nullable UIViewController *) target{
    if(navigationItem.leftBarButtonItems){
        for (UIBarButtonItem * barButtonItem in navigationItem.leftBarButtonItems) {
            if([barButtonItem isKindOfClass:[PYBackButtonItem class]]) continue;
            [self setBarButtonItemStyle:barButtonItem itemStyle:itemStyle target:target];
        }
    }
    if(navigationItem.rightBarButtonItems){
        for (UIBarButtonItem * barButtonItem in navigationItem.rightBarButtonItems) {
            if([barButtonItem isKindOfClass:[PYBackButtonItem class]]) continue;
            [self setBarButtonItemStyle:barButtonItem itemStyle:itemStyle target:target];
        }
    }
}

/**
 设置导航栏按钮样式
 */
+(void) setBarButtonItemStyle:(nonnull UIBarButtonItem *) barButtonItem itemStyle:(nonnull PYNavigationItemStyleModel *) itemStyle target:(UIViewController *) target{
    
    if([((id<PYNavigationSetterTag>)target) respondsToSelector:@selector(pyNavigationItemStyle:)]){
        itemStyle = [((id<PYNavigationSetterTag>)target) pyNavigationItemStyle:itemStyle];
    }
    
    if(barButtonItem.customView){
        if(![barButtonItem.customView isKindOfClass:[UIButton class]]) return;
        UIButton * button = barButtonItem.customView;
        [itemStyle setStyleWithButton:button];
        return;
    }
    
    
    if(barButtonItem.image == nil && [NSString isEnabled:barButtonItem.title]){
        [itemStyle setStyleWithButtonItem:barButtonItem];
    }
    
//    if(barButtonItem.image == nil && [NSString isEnabled:barButtonItem.title]){
//        [itemStyle setStyleWithButtonItem:barButtonItem];
//    UIButton * button;
//    if(barButtonItem.image){
//        if(!button) button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button setImage:barButtonItem.image forState:UIControlStateNormal];
//        [button setImage:barButtonItem.image forState:UIControlStateHighlighted];
//        [button addTarget:barButtonItem.target action:barButtonItem.action forControlEvents:UIControlEventTouchUpInside];
//        barButtonItem.image = nil;
//        barButtonItem.title = nil;
//    }else
//         button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [itemStyle setStyleWithButton:button];
//        [button setTitle:barButtonItem.title forState:UIControlStateNormal];
//        barButtonItem.image = nil;
//        barButtonItem.title = nil;
//    }
//    if(button){
//        [button addTarget:barButtonItem.target action:barButtonItem.action forControlEvents:UIControlEventTouchUpInside];
//        [barButtonItem setCustomView:button];
//        return;
//    }
    
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


@implementation PYNavigationItemStyleModel

-(void) setStyleWithButtonItem:(UIBarButtonItem *) buttonItem{
    NSMutableDictionary * textNormalAttributes = [buttonItem titleTextAttributesForState:UIControlStateNormal].mutableCopy ? : [NSMutableDictionary new];
    NSMutableDictionary * textHighlightedAttributes = [buttonItem titleTextAttributesForState:UIControlStateHighlighted].mutableCopy ? : [NSMutableDictionary new];
    
//    NSShadow * shadowNormal =  textNormalAttributes[NSShadowAttributeName];
//    NSShadow * shadowHighlighted =  textNormalAttributes[NSShadowAttributeName];
//    if(!shadowNormal) shadowNormal = [[NSShadow alloc] init];
//    if(!shadowHighlighted) shadowHighlighted = [[NSShadow alloc] init];
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
//    textNormalAttributes[NSShadowAttributeName] = shadowNormal;
//    textHighlightedAttributes[NSShadowAttributeName] = shadowHighlighted;
    if(self.normalColor)  textNormalAttributes[NSForegroundColorAttributeName] = self.normalColor;
    if(self.highlightedColor) textHighlightedAttributes[NSForegroundColorAttributeName] = self.highlightedColor;

    if (self.font) {
        textNormalAttributes[NSFontAttributeName] = self.font;
        textHighlightedAttributes[NSFontAttributeName] = self.font;
    }

    [buttonItem setTitleTextAttributes:textNormalAttributes forState:UIControlStateNormal];
    [buttonItem setTitleTextAttributes:textHighlightedAttributes forState:UIControlStateHighlighted];
    [buttonItem setTintColor:self.tintColor];
}

-(nonnull UIButton *) createButton{
    UIButton * button = [UIButton buttonWithType:self.tintColor ? UIButtonTypeSystem : UIButtonTypeCustom];
    [self setStyleWithButton:button];
    return button;
}

-(void) setStyleWithButton:(nonnull UIButton *) button{
    if(button.buttonType != UIButtonTypeSystem) return;
    [button setTintColor:self.tintColor ? : self.normalColor];
    button.titleLabel.font = self.font;
}

-(instancetype) copy{
    typeof(self) copyObj = [self.class new];
    copyObj.font = self.font;
    copyObj.tintColor = self.tintColor;
    copyObj.normalColor = self.normalColor;
    copyObj.highlightedColor = self.highlightedColor;
    return copyObj;
}

@end

@implementation PYNavigationBackItemStyleModel

-(void) setStyleWithButton:(nonnull UIButton *) button{
    [super setStyleWithButton:button];
    if(self.normalImage){
        [button setImage:self.normalImage forState:UIControlStateNormal];
    }
    if(self.highlightedImage){
        [button setImage:self.highlightedImage forState:UIControlStateHighlighted];
    }
    if([NSString isEnabled:self.title]){
        [button setTitle:self.title forState:UIControlStateNormal];
    }
}
-(void) setStyleWithButtonItem:(UIBarButtonItem *) buttonItem{
    if(self.normalImage){
        [buttonItem setImage:self.normalImage];
    }
    if([NSString isEnabled:self.title]){
        [buttonItem setTitle:self.title];
    }
}

-(instancetype) copy{
    typeof(self) copyObj = [self.class new];
    copyObj.title = self.title;
    copyObj.font = self.font;
    copyObj.tintColor = self.tintColor;
    copyObj.normalColor = self.normalColor;
    copyObj.highlightedColor = self.highlightedColor;
    copyObj.normalImage = self.normalImage;
    copyObj.highlightedImage = self.highlightedImage;
    return copyObj;
}

@end


@implementation PYNavigationBarStyleModel

-(void) setStyleWithNavigaitonBar:(nonnull UINavigationBar *) navigationBar{
    NSMutableDictionary *titleTextAttributes = [NSMutableDictionary dictionaryWithDictionary:[navigationBar titleTextAttributes]];
    NSShadow *shadow = titleTextAttributes[NSShadowAttributeName];
    if (!shadow)  shadow = [[NSShadow alloc] init];
    titleTextAttributes[NSShadowAttributeName] = shadow;
    
    if (self.titleColor) titleTextAttributes[NSForegroundColorAttributeName] = self.titleColor;
    if (self.titleFont) titleTextAttributes[NSFontAttributeName] = self.titleFont;
    
    [navigationBar setTitleTextAttributes:titleTextAttributes];
    
    if (self.tintColor)  [navigationBar setTintColor:self.tintColor];
    else [navigationBar setTintColor:nil];
    
    if(self.backgroundImage){
        [navigationBar setBackgroundColor:[UIColor clearColor]];
        [navigationBar setBackgroundImage:self.backgroundImage forBarMetrics:self.barMetrics];
    }else if(self.backgroundColor) navigationBar.backgroundColor = self.backgroundColor;
    
    if(self.lineButtomImage) navigationBar.shadowImage = self.lineButtomImage;
}


-(instancetype) copy{
    typeof(self) copyObj = [self.class new];
    copyObj.titleColor = self.titleColor;
    copyObj.titleFont = self.titleFont;
    copyObj.tintColor = self.tintColor;
    copyObj.backgroundColor = self.backgroundColor;
    copyObj.backgroundImage = self.backgroundImage;
    copyObj.lineButtomImage = self.lineButtomImage;
    copyObj.barMetrics = self.barMetrics;
    return copyObj;
}

@end

@implementation PYBackButtonItem @end
