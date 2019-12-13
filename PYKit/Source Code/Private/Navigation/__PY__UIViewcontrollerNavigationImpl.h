//
//  __UIViewcontrollerNavigationImpl.h
//  PYKit
//
//  Created by wlpiaoyi on 2019/12/10.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "pyutilea.h"
#import "PYNavigationStyleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface __PY__UIViewcontrollerNavigationImpl : NSObject<UIViewcontrollerHookViewDelegate>

kPNSNA UIImage * imagePop;
kPNSNA UIImage * imageDismiss;

kPNSNA PYNavigationStyleModel * barStyle;

kPNCNA BOOL (^blockBeforeBarStyle) (UIViewController * _Nonnull vc, NSObject *_Nullable* _Nullable userInfo);
kPNCNA BOOL (^blockAfterBarStyle) (UIViewController * _Nonnull vc, NSObject * _Nullable userInfo);

@end

NS_ASSUME_NONNULL_END
