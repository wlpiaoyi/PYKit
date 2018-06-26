//
//  PYSliderSingleView.m
//  PYKit
//
//  Created by wlpiaoyi on 2018/5/17.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import "PYSliderSingleView.h"

@interface PYSliderSingleView ()

kPNSNN UIImageView * imageLine;
kPNSNN PYMoveView * moveView;
kPNSNN UIImageView * moveImage;

kPNSNA NSLayoutConstraint * lcmT;
kPNA CGFloat  constantT;

kSOULDLAYOUTPForType(PYSliderSingleView);
@end

@implementation PYSliderSingleView

kINITPARAMSForType(PYSliderSingleView){
    self.imageLine = [UIImageView new];
    self.imageLine.image = [UIImage imageWithColor:[UIColor lightGrayColor]];
    self.moveView = [PYMoveView new];
    self.moveView.backgroundColor = [UIColor clearColor];
    [self.moveView setShadowColor:[UIColor grayColor].CGColor shadowRadius:2];
    self.moveImage = [UIImageView new];
    self.moveImage.image = [UIImage imageNamed:@"PYKit.bundle/py_slider_drag.png"];
    self.moveImage.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.imageLine];
    [self addSubview:self.moveView];
    [self.moveView addSubview:self.moveImage];
    
    [self.imageLine setAutotLayotDict:@{@"top":@(PY_SLIDER_POINTER_DIAMETER/2), @"bottom":@(PY_SLIDER_POINTER_DIAMETER/2), @"w":@(PY_SLIDER_LINE_THICKNESS), @"x":@(0)}];
    self.lcmT = [self.moveView setAutotLayotDict:@{@"w":@(PY_SLIDER_POINTER_DIAMETER), @"h":@(PY_SLIDER_POINTER_DIAMETER), @"top":@(0), @"x":@(0)}][@"margin"][@"superTop"];
    [self.moveImage setAutotLayotDict:@{@"top":@(0), @"left":@(0), @"right":@(0), @"bottom":@(0)}];
    [self.imageLine setCornerRadiusAndBorder:PY_SLIDER_LINE_THICKNESS/2 borderWidth:0 borderColor:[UIColor clearColor]];
    self.moveView.isMoveable = false;
    
    kAssign(self);
    [self.moveView setBlockTouchBegin:^(CGPoint transformPoint, UIView * _Nonnull touchView) {
        kStrong(self);
        self.constantT = self.lcmT.constant;
    }];
    [self.moveView setBlockTouchMoved:^(CGPoint transformPoint, UIView * _Nonnull touchView) {
        kStrong(self);
        self.lcmT.constant = MAX(0, MIN(self.imageLine.frameHeight, self.constantT + transformPoint.y));
        if(![self synValueFromlc]){
            [self synLcFromValue];
        }
    }];
    
    
    self.minValue = 20;
    self.maxValue = 120;
    self.currentValue = 70;
    
}

-(void) setCurrentValue:(CGFloat)currentValue{
    _currentValue = MAX(self.minValue, MIN(self.maxValue, currentValue));
    [self synLcFromValue];
}

-(BOOL) synValueFromlc{
    _currentValue = self.lcmT.constant / self.imageLine.frameHeight * (self.maxValue - self.minValue)  + self.minValue;
    if(self.blockTouchSlider){
        return self.blockTouchSlider(self);
    }
    return YES;
}
-(void)synLcFromValue{
    self.lcmT.constant = (_currentValue - self.minValue) / (self.maxValue - self.minValue) * self.imageLine.frameHeight;
}

kSOULDLAYOUTMSTARTForType(PYSliderSingleView)
[self synLcFromValue];
kSOULDLAYOUTMEND

@end
