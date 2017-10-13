//
//  PYSelectorBarView.h
//  PYKit
//
//  Created by wlpiaoyi on 2017/8/18.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYUtile.h"

@interface PYSelectorBarView : UIView
kPNSNN NSArray * buttons;
kPNSNN UIImageView * selectorTag;
kPNA BOOL isBackground;
kPNA CGFloat selectorTagHeight;
kPNA NSUInteger selectIndex;
kPNA CGFloat contentWidth;
kPNCNA BOOL (^blockSelecteItem)(int index);
-(void) setSelectIndex:(NSUInteger)selectIndex animation:(BOOL) animation;
@end
