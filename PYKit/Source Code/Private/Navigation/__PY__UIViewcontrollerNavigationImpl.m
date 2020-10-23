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
    if(self.barStyle.blockSetNavigationBarStyle && !self.barStyle.blockSetNavigationBarStyle(self.barStyle, target)) return;
    [self excuteSetterBackItem:target];
    [self excuteSetterBarStyle:target];
    if(self.barStyle.needsUpdateStatusBarStyle){
        [target setNeedsStatusBarAppearanceUpdate];
        [self.barStyle setNeedsUpdateStatusBarStyle:NO];
    }
}

-(void) afterExcuteViewDidAppearWithTarget:(nonnull UIViewController *) target{
    if(![target conformsToProtocol:@protocol(PYNavigationSetterTag)]) return;
    if(self.barStyle.blockSetNavigationBarStyle && !self.barStyle.blockSetNavigationBarStyle(self.barStyle, target)) return;
    [self excuteSetterBackItem:target];
    [self excuteSetterBarStyle:target];
    if(self.barStyle.needsUpdateStatusBarStyle){
        [target setNeedsStatusBarAppearanceUpdate];
        [self.barStyle setNeedsUpdateStatusBarStyle:NO];
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

    UIStatusBarStyle statusBarStyle = self.barStyle ? self.barStyle.statusBarStyle : style;
    return statusBarStyle;
}

-(void)  excuteSetterBackItem:(nonnull UIViewController *) target{
    if(!target.navigationController) return;
    if(target.navigationItem.leftBarButtonItem) return;
    UIImage * popItemimage = self.barStyle.popItemimage;
    UIImage * dismissItemimage = self.barStyle.dismissItemimage;
    if([((id<PYNavigationSetterTag>)target) respondsToSelector:@selector(pyNavigatonPopItemImage)]){
        popItemimage = [((id<PYNavigationSetterTag>)target) pyNavigatonPopItemImage] ? : popItemimage;
    }
    if([((id<PYNavigationSetterTag>)target) respondsToSelector:@selector(pyNavigatonDismissItemImage)]){
        dismissItemimage = [((id<PYNavigationSetterTag>)target) pyNavigatonDismissItemImage] ? : dismissItemimage;
    }
    if(popItemimage && target.navigationController.childViewControllers
       && target.navigationController.childViewControllers.count > 1) {
        SEL popSel = sel_getUid("__py_navigatioin_popvc");
        if(![target respondsToSelector:popSel]){
            class_addMethod([target class], popSel, (IMP)__py_navigatioin_popvc, "v@:");
        };
        UIBarButtonItem * bbi = [[UIBarButtonItem alloc] initWithImage:popItemimage  style:UIBarButtonItemStylePlain target:target action:popSel];
        target.navigationItem.leftBarButtonItem = bbi;
        target.navigationController.interactivePopGestureRecognizer.delegate = [__PYGestureRecognizerDelegate shareDelegate];
        [PYNavigationStyleModel setBarButtonItemStyle:bbi barStyle:self.barStyle target:target];
    }else if(dismissItemimage && target.navigationController.presentingViewController
             && target.navigationController.viewControllers.count == 1
             && target.navigationController.viewControllers.firstObject == target){
        SEL dismessSel = sel_getUid("__py_navigation_dismissvc");
        if(![target respondsToSelector:dismessSel]){
            class_addMethod([target class], dismessSel, (IMP)__py_navigation_dismissvc, "v@:");
        }
        UIBarButtonItem * bbi = [[UIBarButtonItem alloc] initWithImage:dismissItemimage  style:UIBarButtonItemStylePlain target:target action:dismessSel];
        target.navigationItem.leftBarButtonItem = bbi;
        [PYNavigationStyleModel setBarButtonItemStyle:bbi barStyle:self.barStyle target:target];
    }
}
-(void) excuteSetterBarStyle:(nonnull UIViewController *) target{
    if(!target.navigationController) return;
    if(self.barStyle == nil) return;
    if(![target conformsToProtocol:@protocol(PYNavigationSetterTag)]) return;
    if([target isKindOfClass:[UINavigationController class]]) return;
    if(target.navigationController == nil) return;
    [PYNavigationStyleModel setNavigationBarStyle:target.navigationController.navigationBar barStyle:self.barStyle];
    [PYNavigationStyleModel setNavigationItemStyle:target.navigationItem barStyle:self.barStyle target:target];
    if([target.view viewWithTag:187335021] == nil && self.barStyle.blockCreateNavigationBarBackgrand){
        UIView * navigationBarView = self.barStyle.blockCreateNavigationBarBackgrand(target);
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
