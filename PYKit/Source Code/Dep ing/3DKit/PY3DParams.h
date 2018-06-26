//
//  PY3DParams.h
//  PYKit
//
//  Created by wlpiaoyi on 2017/11/20.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "pyutilea.h"

typedef struct PY3DTransform {
    CGFloat x;
    CGFloat y;
    CGFloat z;
} PY3DTransform;
typedef struct PY3DSize {
    CGFloat w;
    CGFloat h;
    CGFloat d;
} PY3DSize;
kUTILE_STATIC_INLINE PY3DSize PY3DSizeMake(CGFloat w,
                                           CGFloat h,
                                           CGFloat d) {
    PY3DSize insets = {w, h, d};
    return insets;
}

@interface PY3DParams : NSObject
+(void) checkWithDegreex:(CGFloat *) degreexp degreey:(CGFloat *) degreeyp degreez:(CGFloat *) degreezp;
@end
