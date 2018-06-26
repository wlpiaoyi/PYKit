//
//  PYSliderSingleView.h
//  PYKit
//
//  Created by wlpiaoyi on 2018/5/17.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import "PYSliderParams.h"

@interface PYSliderSingleView : UIView

kPNA CGFloat minValue;
kPNA CGFloat maxValue;
kPNA CGFloat currentValue;
kPNCNA BOOL (^blockTouchSlider) (PYSliderSingleView * _Nonnull slider);

@end
