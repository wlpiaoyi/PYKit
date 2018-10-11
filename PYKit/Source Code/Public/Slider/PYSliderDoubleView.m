//
//  PYSliderDoubleView.m
//  PYKit
//
//  Created by wlpiaoyi on 2018/5/8.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import "PYSliderDoubleView.h"

@interface PYSliderDoubleView()
kPNSNN UIImageView * imageLine01;
kPNSNN UIImageView * imageLine02;
kPNSNN PYMoveView * moveView01;
kPNSNN PYMoveView * moveView02;
kPNSNN UIImageView * moveImage01;
kPNSNN UIImageView * moveImage02;

kPNSNA NSLayoutConstraint * lcMv01L;
kPNSNA NSLayoutConstraint * lcMv02L;
kPNSNA NSLayoutConstraint * lcIL02L;
kPNSNA NSLayoutConstraint * lcIL02R;

kPNA CGFloat constantMv01;
kPNA CGFloat constantMv02;
kSOULDLAYOUTPForType(PYSliderDoubleView);
@end

@implementation PYSliderDoubleView

kINITPARAMSForType(PYSliderDoubleView){
    self.offsetValue = 10;
    self.imageLine01 = [UIImageView new];
    self.imageLine01.image = [UIImage imageWithColor:[UIColor lightGrayColor]];
    self.imageLine01.backgroundColor = [UIColor clearColor];
    self.imageLine02 = [UIImageView new];
    self.imageLine02.backgroundColor = [UIColor clearColor];
    self.imageLine02.image = [UIImage imageWithColor:[UIColor orangeColor]];
    [self.imageLine01 setCornerRadiusAndBorder:PY_SLIDER_LINE_THICKNESS/2 borderWidth:0 borderColor:[UIColor clearColor]];
    self.moveView01 = [PYMoveView new];
    self.moveView01.backgroundColor = [UIColor clearColor];
    [self.moveView01 setShadowColor:[UIColor grayColor].CGColor shadowRadius:2];
    self.moveView02 = [PYMoveView new];
    self.moveView02.backgroundColor = [UIColor clearColor];
    [self.moveView02 setShadowColor:[UIColor grayColor].CGColor shadowRadius:2];
    
    self.moveImage01 = [UIImageView new];
    self.moveImage01.image = [UIImage imageNamed:@"PYKit.bundle/images/py_slider_drag.png"];
    self.moveImage01.backgroundColor = [UIColor clearColor];
    self.moveImage02 = [UIImageView new];
    self.moveImage02.backgroundColor = [UIColor clearColor];
    self.moveImage02.image = [UIImage imageNamed:@"PYKit.bundle/images/py_slider_drag.png"];
    
    [self addSubview:self.imageLine01];
    [self addSubview:self.imageLine02];
    [self addSubview:self.moveView01];
    [self addSubview:self.moveView02];
    [self.moveView01 addSubview:self.moveImage01];
    [self.moveView02 addSubview:self.moveImage02];
    self.moveView01.isMoveable = self.moveView02.isMoveable = false;
    [self.moveImage01 setAutotLayotDict:@{@"top":@(0), @"left":@(0), @"bottom":@(0), @"right":@(0)}];
    [self.moveImage02 setAutotLayotDict:@{@"top":@(0), @"left":@(0), @"bottom":@(0), @"right":@(0)}];
    [self.imageLine01 setAutotLayotDict:@{@"y":@(0),@"h":@(PY_SLIDER_LINE_THICKNESS),@"left":@(PY_SLIDER_POINTER_DIAMETER/2),@"right":@(PY_SLIDER_POINTER_DIAMETER/2)}];
    NSDictionary * lcDicts = [self.moveView01 setAutotLayotDict:@{@"y":@(0), @"w":@(PY_SLIDER_POINTER_DIAMETER), @"h":@(PY_SLIDER_POINTER_DIAMETER), @"left":@(0)}];
    self.lcMv01L = lcDicts[@"margin"][@"superLeft"];
    lcDicts = [self.moveView02 setAutotLayotDict:@{@"y":@(0), @"w":@(PY_SLIDER_POINTER_DIAMETER), @"h":@(PY_SLIDER_POINTER_DIAMETER), @"left":@(0)}];
    self.lcMv02L = lcDicts[@"margin"][@"superLeft"];
    lcDicts =[self.imageLine02 setAutotLayotDict:@{@"y":@(0), @"h":@(PY_SLIDER_LINE_THICKNESS), @"left":@(-PY_SLIDER_POINTER_DIAMETER/2), @"leftPoint":self.moveView01, @"right":@(-PY_SLIDER_POINTER_DIAMETER/2), @"rightPoint":self.moveView02}];
    self.lcIL02L = lcDicts[@"margin"][@"superLeft"];
    self.lcIL02R = lcDicts[@"margin"][@"superRight"];
    self.constantMv01 = self.constantMv02 = 0;
    kAssign(self);
    [self.moveView01 setBlockTouchBegin:^(CGPoint transformPoint, UIView * _Nonnull touchView) {
        kStrong(self);
        [self.moveView01.superview bringSubviewToFront:self.moveView01];
    }];
    [self.moveView01 setBlockTouchMoved:^(CGPoint transformPoint, UIView * _Nonnull touchView) {
        kStrong(self);
        self.lcMv01L.constant = MAX(0, MIN(self.imageLine01.frameWidth - [self getOffsetWith], self.constantMv01 + transformPoint.x));
        if(self.lcMv01L.constant + [self getOffsetWith] > self.lcMv02L.constant){
            self.lcMv02L.constant = self.lcMv01L.constant + [self getOffsetWith];
            self.constantMv02 = self.lcMv02L.constant;
        }
        if(![self synValueFromlc]){
            [self synLcFromValue];
        }
    }];
    [self.moveView01 setBlockTouchEnded:^(CGPoint transformPoint, UIView * _Nonnull touchView) {
        kStrong(self);
        self.constantMv01 = self.lcMv01L.constant;
        [self synValueFromlc];
    }];
    [self.moveView01 setBlockTouchCancelled:^(CGPoint transformPoint, UIView * _Nonnull touchView) {
        kStrong(self);
        self.constantMv01 = self.lcMv01L.constant;
        [self synValueFromlc];
    }];
    
    [self.moveView02 setBlockTouchBegin:^(CGPoint transformPoint, UIView * _Nonnull touchView) {
        kStrong(self);
        [self.moveView02.superview bringSubviewToFront:self.moveView02];
    }];
    [self.moveView02 setBlockTouchMoved:^(CGPoint transformPoint, UIView * _Nonnull touchView) {
        kStrong(self);
        self.lcMv02L.constant = MAX([self getOffsetWith], MIN([self getMaxLineWith] + PY_SLIDER_POINTER_DIAMETER, self.constantMv02 + transformPoint.x)) ;
        if(self.lcMv01L.constant  > self.lcMv02L.constant - [self getOffsetWith]){
            self.lcMv01L.constant = self.lcMv02L.constant - [self getOffsetWith];
            self.constantMv01 = self.lcMv01L.constant;
        }
        if(![self synValueFromlc]){
            [self synLcFromValue];
        }
    }];
    [self.moveView02 setBlockTouchEnded:^(CGPoint transformPoint, UIView * _Nonnull touchView) {
        kStrong(self);
        self.constantMv02 = self.lcMv02L.constant;
        [self synValueFromlc];
    }];
    [self.moveView02 setBlockTouchCancelled:^(CGPoint transformPoint, UIView * _Nonnull touchView) {
        kStrong(self);
        self.constantMv02 = self.lcMv02L.constant;
        [self synValueFromlc];
    }];
    self.minValue = 0;
    self.maxValue = 100;
    self.startValue = 0;
    self.endValue = 100;
}
-(CGFloat) getMaxLineWith{
    return self.imageLine01.frameWidth - PY_SLIDER_POINTER_DIAMETER;
}
-(CGFloat) getOffsetWith{
    return PY_SLIDER_POINTER_DIAMETER + self.offsetValue / self.maxValue * [self getMaxLineWith];
}
-(void) setStartValue:(CGFloat)startValue{
    if(self.endValue < startValue){
        self.endValue = startValue;
    }
    _startValue = MAX(self.minValue, MIN(self.endValue, startValue));
    [self synLcFromValue];
}
-(void) setEndValue:(CGFloat)endValue{
    if(self.startValue > endValue){
        self.endValue = endValue;
    }
    _endValue = MAX(self.startValue, MIN(self.maxValue, endValue));
    [self synLcFromValue];
}

-(BOOL) synValueFromlc{
    _startValue = self.lcMv01L.constant / (self.imageLine01.frameWidth - PY_SLIDER_POINTER_DIAMETER) * (self.maxValue - self.minValue) + self.minValue;
    _endValue = (self.lcMv02L.constant - PY_SLIDER_POINTER_DIAMETER) / (self.imageLine01.frameWidth - PY_SLIDER_POINTER_DIAMETER)* (self.maxValue - self.minValue) + self.minValue;
    if(self.blockTouchSlider){
        return self.blockTouchSlider(self);
    }
    return YES;
}
-(void)synLcFromValue{
    self.constantMv01 = self.lcMv01L.constant = (self.startValue - self.minValue) / (self.maxValue-self.minValue) * [self getMaxLineWith];
    self.constantMv02 = self.lcMv02L.constant = (self.endValue - self.minValue) / (self.maxValue-self.minValue) * [self getMaxLineWith] + PY_SLIDER_POINTER_DIAMETER;
}
kSOULDLAYOUTMSTARTForType(PYSliderDoubleView)
[self synLcFromValue];
kSOULDLAYOUTMEND


@end
