//
//  __UIViewcontrollerNavigationImpl.m
//  PYKit
//
//  Created by wlpiaoyi on 2019/12/10.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import "__PY__UIViewcontrollerNavigationImpl.h"
#import "PYNavigationControll.h"

@interface PYNavigationStyleModel (__Expand__)
-(void) setNeedsUpdateStatusBarStyle:(BOOL)needsUpdateStatusBarStyle;
@end

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
    if([self respondsToSelector:@selector(beforeOnclikPop:)] && [((id<PYNavigationSetterTag>) self) beforeOnclikPop:self] == NO){
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

void __py_navigation_dismissvc(UIViewController * self, SEL _cmd){
    if([self respondsToSelector:@selector(beforeOnclickDismiss:)] && [((id<PYNavigationSetterTag>) self) beforeOnclickDismiss:self] == NO){
        return;
    }
    [(self.navigationController ? : self) dismissViewControllerAnimated:YES completion:^{}];
}

@implementation __PY__UIViewcontrollerNavigationImpl

-(void) afterExcuteViewWillAppearWithTarget:(nonnull UIViewController *) target{
    if(![target conformsToProtocol:@protocol(PYNavigationSetterTag)]) return;
    if(self.navigationStyle.blockSetNavigationBarStyle && !self.navigationStyle.blockSetNavigationBarStyle(self.navigationStyle, target)) return;
    [self excuteSetterBackItem:target];
    [self excuteSetterBarStyle:target];
    if(self.navigationStyle.needsUpdateStatusBarStyle){
        [target setNeedsStatusBarAppearanceUpdate];
        [self.navigationStyle setNeedsUpdateStatusBarStyle:NO];
    }
}

-(void) afterExcuteViewDidAppearWithTarget:(nonnull UIViewController *) target{
    if(![target conformsToProtocol:@protocol(PYNavigationSetterTag)]) return;
    if(self.navigationStyle.blockSetNavigationBarStyle && !self.navigationStyle.blockSetNavigationBarStyle(self.navigationStyle, target)) return;
    [self excuteSetterBackItem:target];
    [self excuteSetterBarStyle:target];
    if(self.navigationStyle.needsUpdateStatusBarStyle){
        [target setNeedsStatusBarAppearanceUpdate];
        [self.navigationStyle setNeedsUpdateStatusBarStyle:NO];
    }
}

-(void) afterExcuteViewWillLayoutSubviewsWithTarget:(nonnull UIViewController *) target{
    UIView * navigationBarView = [target.view viewWithTag:187335021];
    if(navigationBarView){
        [navigationBarView.superview bringSubviewToFront:navigationBarView];
    }
}

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

    UIStatusBarStyle statusBarStyle = self.navigationStyle ? self.navigationStyle.statusBarStyle : style;
    return statusBarStyle;
}

-(void)  excuteSetterBackItem:(nonnull UIViewController *) target{
    if(!target.navigationController) return;
    PYBackButtonItem * backButtonItem;
    for (UIBarButtonItem * buttonItem in target.navigationItem.leftBarButtonItems) {
        if([buttonItem isKindOfClass:[PYBackButtonItem class]]){
            backButtonItem = buttonItem;
            break;
        }
    }
    if(target.navigationController.childViewControllers
       && target.navigationController.childViewControllers.count > 1) {
        SEL popSel = sel_getUid("__py_navigatioin_popvc");
        if(![target respondsToSelector:popSel]){
            class_addMethod([target class], popSel, (IMP)__py_navigatioin_popvc, "v@:");
        };
        PYNavigationBackItemStyleModel * popStyle = self.navigationStyle.popStyle;
        if([((id<PYNavigationSetterTag>)target) respondsToSelector:@selector(pyNavigatonPopStyle:)]){
            popStyle = [((id<PYNavigationSetterTag>)target) pyNavigatonPopStyle:popStyle] ? : popStyle;
        }
        if(!popStyle) return;
        if(!backButtonItem){
            UIButton * backButton = [popStyle createButton];
            backButtonItem = [[PYBackButtonItem alloc] initWithCustomView:backButton];
        }else{
            if(backButtonItem.customView && [backButtonItem.customView isKindOfClass:[UIButton class]]){
                UIButton * backButton = backButtonItem.customView;
                [popStyle setStyleWithButton:backButton];
                [backButton addTarget:target action:popSel forControlEvents:UIControlEventTouchUpInside];
            }
            backButtonItem = nil;
        }
        target.navigationController.interactivePopGestureRecognizer.delegate = [__PYGestureRecognizerDelegate shareDelegate];
    }else if(target.navigationController.presentingViewController
             && target.navigationController.viewControllers.count == 1
             && target.navigationController.viewControllers.firstObject == target){
        SEL dismessSel = sel_getUid("__py_navigation_dismissvc");
        if(![target respondsToSelector:dismessSel]){
            class_addMethod([target class], dismessSel, (IMP)__py_navigation_dismissvc, "v@:");
        }
        PYNavigationBackItemStyleModel * dismissStyle = self.navigationStyle.dismissStyle;
        if([((id<PYNavigationSetterTag>)target) respondsToSelector:@selector(pyNavigatonDismissStyle:)]){
            dismissStyle = [((id<PYNavigationSetterTag>)target) pyNavigatonDismissStyle:dismissStyle] ? : dismissStyle;
        }
        if(!dismissStyle) return;
        if(!backButtonItem){
            UIButton * backButton  = [dismissStyle createButton];
            backButtonItem = [[PYBackButtonItem alloc] initWithCustomView:backButton];
        }else{
            if(backButtonItem.customView && [backButtonItem.customView isKindOfClass:[UIButton class]]){
                UIButton * backButton = backButtonItem.customView;
                [dismissStyle setStyleWithButton:backButton];
                [backButton addTarget:target action:dismessSel forControlEvents:UIControlEventTouchUpInside];
            }
            backButtonItem = nil;
        }
    }
    if(backButtonItem){
        if(target.navigationItem.leftBarButtonItem == nil) target.navigationItem.leftBarButtonItem = backButtonItem;
        else{
            NSMutableArray * leftBarButtonItems = [target.navigationItem.leftBarButtonItems mutableCopy];
            [leftBarButtonItems insertObject:backButtonItem atIndex:0];
            target.navigationItem.leftBarButtonItems = leftBarButtonItems;
        }
    }
}
-(void) excuteSetterBarStyle:(nonnull UIViewController *) target{
    if(!target.navigationController) return;
    if(self.navigationStyle == nil) return;
    if(![target conformsToProtocol:@protocol(PYNavigationSetterTag)]) return;
    if([target isKindOfClass:[UINavigationController class]]) return;
    if(target.navigationController == nil) return;
    [PYNavigationStyleModel setNavigationBarStyle:target.navigationController.navigationBar barStyle:self.navigationStyle.barStyle target:target];
    [PYNavigationStyleModel setNavigationItemStyle:target.navigationItem itemStyle:self.navigationStyle.itemStyle target:target];
    if([target.view viewWithTag:187335021] == nil && self.navigationStyle.blockCreateNavigationBarBackgrand){
        UIView * navigationBarView = self.navigationStyle.blockCreateNavigationBarBackgrand(target);
        navigationBarView.tag = 187335021;
        if(navigationBarView){
            [target.view addSubview:navigationBarView];
            UIView * lineTag = [UIView new];
            lineTag.backgroundColor = [UIColor clearColor];
            [target.view addSubview:lineTag];
            [lineTag py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
                make.left.bottom.right.py_constant(0);
                make.height.py_constant(.5);
            }];
        }
    }
    
}


@end
