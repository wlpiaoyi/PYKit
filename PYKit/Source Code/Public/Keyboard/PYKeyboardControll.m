//
//  PYKeyboardControll.m
//  PYKit
//
//  Created by wlpiaoyi on 2019/12/4.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import "PYKeyboardControll.h"
#import "pyutilea.h"
#import "__PY_UIResponderHookKeyboardImpl.h"

@implementation PYKeyboardControll

static __PY_UIResponderHookKeyboardImpl * xUIResponderHookKeyboardImpl;
static PYKeyboardControllEnum xPYKeyboardControllEnum = PYKeyboardControllTag;
+(void) initialize{
    static dispatch_once_t onceToken; dispatch_once(&onceToken, ^{
        [UIViewController hookMethodView];
        xUIResponderHookKeyboardImpl = [__PY_UIResponderHookKeyboardImpl new];
        [[UIViewController delegateBaseHook] addObject:xUIResponderHookKeyboardImpl];
        [UIViewController addDelegateView:xUIResponderHookKeyboardImpl];
    });
}

+(void) setControllType:(PYKeyboardControllEnum) controllType{
    xPYKeyboardControllEnum = controllType;
}
+(BOOL) showKeyboaardOption:(nonnull UIViewController *) vc{
    switch (xPYKeyboardControllEnum) {
        case PYKeyboardControllTag:{
            return [vc conformsToProtocol:@protocol(PYKeyboardOptionTag)];
        }
        case PYKeyboardControllAll:{
            return ![vc conformsToProtocol:@protocol(PYKeyboardOptionTag)];
        }
        default:
            return false;
    }
}

@end
