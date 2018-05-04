//
//  PYMoveView.h
//  PYInterflow
//
//  Created by wlpiaoyi on 2018/3/31.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pyutilea.h"
#import "PYParams.h"

@interface PYMoveView : UIView
kPNCNA BlockTouchView blockTouchBegin;
kPNCNA BlockTouchView blockTouchMoved;
kPNCNA BlockTouchView blockTouchEnded;
kPNCNA BlockTouchView blockTouchCancelled;
@end
