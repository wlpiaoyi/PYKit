//
//  PYSliderDoubleView.h
//  PYKit
//
//  Created by wlpiaoyi on 2018/5/8.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import "PYSliderParams.h"

@interface PYSliderDoubleView : UIView
kPNA CGFloat minValue;
kPNA CGFloat maxValue;
kPNA CGFloat startValue;
kPNA CGFloat endValue;
kPNA CGFloat offsetValue;
kPNCNA BOOL (^blockTouchSlider) (PYSliderDoubleView * _Nonnull slider);
@end
