//
//  __UIViewcontrollerNavigationImpl.m
//  PYKit
//
//  Created by wlpiaoyi on 2019/12/10.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import "__PY__UIViewcontrollerNavigationImpl.h"
#import "PYNavigationControll.h"

@interface __PYGestureRecognizerDelegate : NSObject <UIGestureRecognizerDelegate>
+(nullable instancetype) shareDelegate;
@end

@implementation __PYGestureRecognizerDelegate
+(nullable instancetype) shareDelegate{
    static __PYGestureRecognizerDelegate * xGrd;
    static dispatch_once_t onceToken; dispatch_once(&onceToken, ^{
        xGrd = [__PYGestureRecognizerDelegate new];
    });
    return xGrd;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}

@end

void __py_navigatioin_popvc(UIViewController * self, SEL _cmd){
    [self.navigationController popViewControllerAnimated:YES];
}

void __py_navigation_dismissvc(UIViewController * self, SEL _cmd){
    [(self.navigationController ? : self) dismissViewControllerAnimated:YES completion:^{}];
}

@implementation __PY__UIViewcontrollerNavigationImpl

-(void) afterExcuteViewWillAppearWithTarget:(nonnull UIViewController *) target{
    if(![target conformsToProtocol:@protocol(PYNavigationSetterTag)]) return;
    [self excuteSetterBackItem:target];
    [self excuteSetterBarStyle:target];
}
//-(void) afterExcuteViewDidAppearWithTarget:(nonnull UIViewController *) target{
//    if(![target conformsToProtocol:@protocol(PYNavigationSetterTag)]) return;
//    [self excuteSetterBackItem:target];
//    [self excuteSetterBarStyle:target];
//}

-(UIStatusBarStyle) afterExcutePreferredStatusBarStyleWithTarget:(nonnull UIViewController *) target style:(UIStatusBarStyle)style{
    if([target isKindOfClass:[UINavigationController class]] &&
       ((UINavigationController*)(target)).viewControllers &&
       ((UINavigationController*)(target)).viewControllers.count){
        return [((UINavigationController*)(target)).viewControllers.lastObject preferredStatusBarStyle];
    }
    if([target isKindOfClass:[UITabBarController class]] &&
       ((UITabBarController *) target).selectedViewController){
        return [((UITabBarController *) target).selectedViewController preferredStatusBarStyle];
    }
    if(![target conformsToProtocol:@protocol(PYNavigationSetterTag)]) return style;
    if(target.childViewControllers.count ){
        return [target.childViewControllers.lastObject preferredStatusBarStyle];
    }

    UIStatusBarStyle statusBarStyle = self.barStyle ? self.barStyle.statusBarStyle : style;
    return statusBarStyle;
}

-(void) excuteSetterBackItem:(nonnull UIViewController *) target{
    if(!target.navigationController) return;
    if(target.navigationItem.leftBarButtonItem) return;
    if(self.imagePop && target.navigationController.childViewControllers
       && target.navigationController.childViewControllers.count > 1) {
        SEL popSel = sel_getUid("__py_navigatioin_popvc");
        if(![target respondsToSelector:popSel]){
            class_addMethod([target class], popSel, (IMP)__py_navigatioin_popvc, "v@:");
        }
        UIBarButtonItem * bbi = [[UIBarButtonItem alloc] initWithImage:self.imagePop  style:UIBarButtonItemStylePlain target:target action:popSel];
        target.navigationItem.leftBarButtonItem = bbi;
        target.navigationController.interactivePopGestureRecognizer.delegate = [__PYGestureRecognizerDelegate shareDelegate];
    }else if(self.imageDismiss && target.navigationController.presentingViewController
             && target.navigationController.childViewControllers.count == 1
             && target.navigationController.childViewControllers.firstObject == target){
        SEL dismessSel = sel_getUid("__py_navigation_dismissvc");
        if(![target respondsToSelector:dismessSel]){
            class_addMethod([target class], dismessSel, (IMP)__py_navigation_dismissvc, "v@:");
        }
        UIBarButtonItem * bbi = [[UIBarButtonItem alloc] initWithImage:self.imageDismiss  style:UIBarButtonItemStylePlain target:target action:dismessSel];
        target.navigationItem.leftBarButtonItem = bbi;
    }
}
-(void) excuteSetterBarStyle:(nonnull UIViewController *) target{
    if(!target.navigationController) return;
    if(self.barStyle == nil) return;
    
    NSObject * userInfo = nil;
    BOOL flag = true;
    if(_blockBeforeBarStyle) flag = _blockBeforeBarStyle(target, &userInfo);
    if(!flag) return;
    
    if(![target conformsToProtocol:@protocol(PYNavigationSetterTag)]) return;
    if([target isKindOfClass:[UINavigationController class]]) return;
    if(target.navigationController == nil) return;
    [PYNavigationStyleModel setNavigationBarStyle:target.navigationController.navigationBar barStyle:self.barStyle];
    [PYNavigationStyleModel setNavigationItemStyle:target.navigationItem barStyle:self.barStyle];
    if(_blockAfterBarStyle) _blockAfterBarStyle(target, userInfo);
}


@end
