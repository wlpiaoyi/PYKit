//
//  UIView+Remove.h
//  PYInterchange
//
//  Created by wlpiaoyi on 16/1/21.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYParams.h"

@interface UIView(Remove)
/**
 是否可以移动
 */
@property (nonatomic) BOOL moveable;

//==>移动回调
@property (nonatomic, copy) BlockTouchView blockTouchBegin;
@property (nonatomic, copy) BlockTouchView blockTouchMove;
@property (nonatomic, copy) BlockTouchView blockTouchEnd;
///<
-(void) removeParams;
@end
