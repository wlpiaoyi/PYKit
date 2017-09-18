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
PYPNSNN NSArray * buttons;
PYPNSNN UIImageView * selectorTag;
PYPNA BOOL isBackground;
PYPNA CGFloat selectorTagHeight;
PYPNA NSUInteger selectIndex;
PYPNA CGFloat contentWidth;
PYPNCNA BOOL (^blockSelecteItem)(int index);
-(void) setSelectIndex:(NSUInteger)selectIndex animation:(BOOL) animation;
@end
