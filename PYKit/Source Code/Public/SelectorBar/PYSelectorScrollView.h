//
//  PYSelectorScrollView.h
//  PYKit
//
//  Created by wlpiaoyi on 2017/10/17.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYSelectorBarView.h"

extern int kSelectorbarviewtag;

@interface PYSelectorScrollView : PYSelectorBarView
kPNA CGFloat contentWidth;
/**
 覆盖层渐变颜色
 */
kPNSNN UIColor * gradualChangeColor;
kPNA bool isScorllSelected;
@end