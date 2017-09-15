//
//  PYDisplayImageTools.h
//  PYKit
//
//  Created by wlpiaoyi on 2017/9/5.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYUtile.h"

typedef enum _PYDisplayImageTouchEnum {
    PYDisplayImageTouchUnkown = 0b0,
    PYDisplayImageTouchChange = 0b1,
    PYDisplayImageTouchOne = 0b10,
    PYDisplayImageTouchMultiple = 0b11
} PYDisplayImageTouchEnum;

CGPoint PY_CGPointSubtract(CGPoint p1, CGPoint p2);
CGPoint PY_CGPointAdd(CGPoint p1, CGPoint p2);

@interface PYDisplayImageTools : NSObject

/**
 获取中间点
 */
+(CGPoint) getCenterPointWithTouchFirst:(nonnull UITouch *) touchFist
                            touchSecond:(nonnull UITouch *) touchSecond
                                tagView:(nonnull UIView *) tagView;
/**
 获取图片在试图中的最适大小
 */
+(CGRect) getFitImgRectWithDisplaySize:(CGSize) displaySize imgSize:(CGSize) imgSize;
/**
 检查位置和大小偏移量预防超出指定范围
 */
+(void) checkDisplayRect:(nonnull CGRect *) displayRectp fitRect:(CGRect) fitRect maxMultiple:(NSUInteger) maxMultiple;
/**
 根据图片的最适位置，定点，移动点的变化计算出下一个展示的 位置和大小
 */
+(void) analyzeDisplayRect:(nonnull CGRect *) displayRectp fitRect:(CGRect) fitRect nailOrigin:(CGPoint) nailOrigin preTouchPoint:(CGPoint) preTouchPoint curTouchPoint:(CGPoint) curTouchPoint;
@end
