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
@property (nonatomic, readonly) BOOL popupisAnimation;
//是否显示了
@property (nonatomic, readonly) BOOL popupIsShow;
//显示靠近中心的偏移量
@property (nonatomic) CGPoint popupCenterPoint;
//显示靠近边缘的偏移量
@property (nonatomic) UIEdgeInsets popupEdgeInsets;
@property (nonatomic,copy, nullable) void (^popupBlockStart)(UIView * _Nullable view);
@property (nonatomic,copy, nullable) void (^popupBlockEnd)(UIView * _Nullable view);
//=====================显示和隐藏自定义动画=========================>
@property (nonatomic,copy, nullable) BlockPopupAnimation blockShowAnimation;
@property (nonatomic,copy, nullable) BlockPopupAnimation blockHiddenAnimation;
///<=====================显示和隐藏自定义动画=========================

@property (nonatomic, strong, nonnull) UIView * popupBaseView;
@property (nonatomic, readonly, nullable) UIView * popupContentView;

-(void) popupShow;
-(void) popupShowForHasContentView:(BOOL) hasContentView;
-(void) popupHidden;

-(void) resetTransform;
-(void) resetAutoLayout;

@end
