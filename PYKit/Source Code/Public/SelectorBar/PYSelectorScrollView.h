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

//content 宽度
kPNA CGFloat contentWidth;

//覆盖层渐变颜色
kPNSNN UIColor * gradualChangeColor;
//
kPNA bool isScorllSelected;
/**
 仅当 isScorllSelected == YES 有效
 */
-(void) setContentWidth:(CGFloat)contentWidth animation:(BOOL) animation;
@end
