//
//  UIResponderHookKeyboardImpl.m
//  PYKit
//
//  Created by wlpiaoyi on 2019/12/4.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import "__PY_UIResponderHookKeyboardImpl.h"
#import "PYKeyboardOptionView.h"
#import "PYKeyboardControll.h"

@implementation __PY_UIResponderHookKeyboardImpl

-(void) afterExcuteViewWillAppearWithTarget:(UIViewController *)target{
    if(![PYKeyboardControll showKeyboaardOption:target]) return;
    if([PYKeyboardOptionView getWithTargetView:target]){
        PYKeyboardOptionView * keybordHead = [PYKeyboardOptionView sharedWithTargetView:target];
        if(keybordHead.hasShowKeyboard)
            keybordHead.frameY = boundsHeight() - keybordHead.keyBoardFrame.size.height - keybordHead.frameHeight;
    }
}

-(void) afterExcuteViewDidAppearWithTarget:(nonnull UIViewController *) target{
    if(![PYKeyboardControll showKeyboaardOption:target]) return;
    if([PYKeyboardOptionView getWithTargetView:target] == nil){
        PYKeyboardOptionView * keybordHead = [PYKeyboardOptionView sharedWithTargetView:target];
        keybordHead.frameOrigin = CGPointMake(0, boundsHeight());
        keybordHead.frameWidth = boundsWidth();
        UIView * topView = [PYUtile getTopView:target.view];
        [topView addSubview:keybordHead];
    }
    [PYKeyboardOptionView setHiddenForTargetView:target];
    UIViewController * vc = target;
    PYKeyboardOptionView * keybordHead = [PYKeyboardOptionView sharedWithTargetView:target];
    keybordHead.canChangeFocus = ![target respondsToSelector:@selector(canChangeFocus)] || [((id<PYKeyboardOptionTag>)target) canChangeFocus];
    if(keybordHead.tapGestureRecognizer){
        [vc.view removeGestureRecognizer:keybordHead.tapGestureRecognizer];
        keybordHead.tapGestureRecognizer = nil;
    };
    if(keybordHead.hasShowKeyboard)
        keybordHead.frameY = boundsHeight() - keybordHead.keyBoardFrame.size.height - keybordHead.frameHeight;
    if(![target respondsToSelector:@selector(canTouchHidden)] || [((id<PYKeyboardOptionTag>)target) canTouchHidden]){
        keybordHead.tapGestureRecognizer = [vc.view py_addTarget:self action:@selector(hiddenKeyboard)];
    }
}

-(void) beforeExcuteDeallocWithTarget:(nonnull NSObject *) target{
    if(![target isKindOfClass:[UIViewController class]]) return;
    if(![PYKeyboardControll showKeyboaardOption:(UIViewController *)target]) return;
    PYKeyboardOptionView * keybordHead = [PYKeyboardOptionView getWithTargetView:((UIViewController *)target)];
    [keybordHead removeFromSuperview];
    if(keybordHead)[PYKeyboardNotification removeKeyboardNotificationWithResponder:keybordHead];
}

-(void) hiddenKeyboard{
    [PYKeyboardNotification hiddenKeyboard];
}

@end
