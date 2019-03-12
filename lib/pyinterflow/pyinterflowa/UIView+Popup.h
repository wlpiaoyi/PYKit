//
//  UIView+Popup.h
//  PYInterchange
//
//  Created by wlpiaoyi on 16/1/21.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYInterflowParams.h"

extern CGFloat PYPopupAnimationTime;
//typedef NS_ENUM(NSInteger, PYPopupEnum) {
//    PYPopupCenter = 0,
//    PYPopupLeftIn = 1,
//    PYPopupRightIn = 2,
//    PYPopupTopIn = 3,
//    PYPopupBottomIn = 4
//};
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
//显示靠近边缘的参照
@property (nonatomic) PYEdgeInsetsItem popupEdgeInsetItems;

@property (nonatomic,copy, nullable) void (^popupBlockStart)(UIView * _Nullable view);
@property (nonatomic,copy, nullable) void (^popupBlockEnd)(UIView * _Nullable view);
//=====================显示和隐藏自定义动画=========================>
@property (nonatomic,copy, nullable) BlockPopupAnimation blockShowAnimation;
@property (nonatomic,copy, nullable) BlockPopupAnimation blockHiddenAnimation;
///<=====================显示和隐藏自定义动画=========================


//popupBlockTap == nil  点击空白区域隐藏
@property (nonatomic,copy, nullable) void (^popupBlockTap)(UIView * _Nullable view);

//是否显示毛玻璃效果
@property (nonatomic, assign) BOOL popupHasEffect;
//窗口视图
@property (nonatomic, strong, nonnull) UIView * popupBaseView;
//父级视图
@property (nonatomic, readonly, nullable) UIView * popupContentView;

/**
 显示视图
 */
-(BOOL) popupShow;
/**
 显示视图
 @params hasContentView 是否拥有父级视图
 */
-(BOOL) popupShowForHasContentView:(BOOL) hasContentView;
/**
 隐藏视图
 */
-(BOOL) popupHidden;

-(void) resetTransform;
-(void) resetAutoLayout;

@end
