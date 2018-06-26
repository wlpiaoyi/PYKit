//
//  PY3DOrthogonView.h
//  PYKit
//
//  Created by wlpiaoyi on 2017/11/20.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PY3DView.h"

@interface PY3DOrthogonView : PY3DView
kPNSNA UIView * viewFront;
kPNSNA UIView * viewBehind;
kPNSNA UIView * viewLeft;
kPNSNA UIView * viewRight;
kPNSNA UIView * viewUp;
kPNSNA UIView * viewDown;
kPNA BOOL touchHorizontal;
kPNA BOOL touchVertica;
@end
