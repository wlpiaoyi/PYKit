//
//  UIView+Popup.h
//  PYInterchange
//
//  Created by wlpiaoyi on 16/1/21.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYParams.h"

extern CGFloat PYPopupAnimationTime;
typedef NS_ENUM(NSInteger, PYPopupEnum) {
    PYPopupCenter = 0,
    PYPopupLeftIn = 1,
    PYPopupRightIn = 2,
    PYPopupTopIn = 3,
    PYPopupBottomIn = 4
};
/**
 弹出框
 */
@interface UIView(Popup)
//是否正在进行动画
@property (nonatomic, readonly) BOOL isAnimationing;
//是否显示了
@property (nonatomic, readonly) BOOL isShow;
//显示靠近中心的偏移量
@property (nonatomic) CGPoint centerPoint;
//显示靠近边缘的偏移量
@property (nonatomic) UIEdgeInsets borderEdgeInsets;
@property (nonatomic,copy, nullable) void (^blockStart)(UIView * _Nullable view);
@property (nonatomic,copy, nullable) void (^blockEnd)(UIView * _Nullable view);
//动画类型
//@property (nonatomic) PYPopupEnum popupType;
//=====================显示和隐藏自定义动画=========================>
@property (nonatomic,copy, nullable) BlockPopupAnimation blockShowAnimation;
@property (nonatomic,copy, nullable) BlockPopupAnimation blockHiddenAnimation;
///<=====================显示和隐藏自定义动画=========================

//基础层
@property (nonatomic, assign, nonnull) UIView * baseView;

-(void) popupShow;
-(void) popupHidden;

-(void) resetBoundPoint;

@end
