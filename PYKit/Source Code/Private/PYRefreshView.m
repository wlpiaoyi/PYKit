//
//  PYRefreshView.m
//  PYKit
//
//  Created by wlpiaoyi on 2018/1/2.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import "PYRefreshView.h"

CGFloat PYRefreshViewHeight = 80;
NSString * PYRefreshDownBeginText = @"下拉刷新";
NSString * PYRefreshDownDoText = @"松手刷新";
NSString * PYRefreshDownDoingText = @"请稍后...";
NSString * PYRefreshDownEndText = @"刷新完成";
NSString * PYRefreshUpBeginText = @"上拉刷新";
NSString * PYRefreshUpDoText = @"松手刷新";
NSString * PYRefreshUpDoingText = @"请稍后...";
NSString * PYRefreshUpEndText = @"刷新完成";


@interface PYRefreshView()
kSOULDLAYOUTPForType(PYRefreshView)
@end

@implementation PYRefreshView{
@private
    UIView * _contextView;
    UIImageView * _imageViewArrow;
    UIActivityIndicatorView * _activityIndicator;
    UILabel * _labelMessage;
    NSLayoutConstraint * _lcw;
    NSLayoutConstraint * _lc1;
    BOOL _isUp;
}
kINITPARAMSForType(PYRefreshView){
    _state = kPYRefreshNoThing;
    _contextView = [UIView new];
    _contextView.backgroundColor = [UIColor clearColor];
    [_contextView setShadowColor:[UIColor orangeColor].CGColor shadowRadius:2];
    [self addSubview:_contextView];
    _lcw = [PYViewAutolayoutCenter persistConstraint:_contextView size:CGSizeMake(70, DisableConstrainsValueMAX)].allValues.firstObject;
    [PYViewAutolayoutCenter persistConstraint:_contextView relationmargins:UIEdgeInsetsMake(0, DisableConstrainsValueMAX, 0, DisableConstrainsValueMAX) relationToItems:PYEdgeInsetsItemNull()];
    [PYViewAutolayoutCenter persistConstraint:_contextView centerPointer:CGPointMake(0, DisableConstrainsValueMAX)];
    
    _imageViewArrow = [UIImageView new];
    _imageViewArrow.backgroundColor = [UIColor clearColor];
    _imageViewArrow.contentMode = UIViewContentModeScaleAspectFit;
    [_contextView addSubview:_imageViewArrow];
    _lc1 = [PYViewAutolayoutCenter persistConstraint:_imageViewArrow size:CGSizeMake(60, DisableConstrainsValueMAX)].allValues.firstObject;
    [PYViewAutolayoutCenter persistConstraint:_imageViewArrow relationmargins:UIEdgeInsetsMake(0, 0, 0, DisableConstrainsValueMAX) relationToItems:PYEdgeInsetsItemNull()];
    
    _activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicator.color = [UIColor lightGrayColor];
    [_contextView addSubview:_activityIndicator];
    [PYViewAutolayoutCenter persistConstraint:_activityIndicator size:CGSizeMake(60, DisableConstrainsValueMAX)];
    [PYViewAutolayoutCenter persistConstraint:_activityIndicator relationmargins:UIEdgeInsetsMake(0, 0, 0, DisableConstrainsValueMAX) relationToItems:PYEdgeInsetsItemNull()];
    
    _labelMessage = [UILabel new];
    _labelMessage.backgroundColor = [UIColor clearColor];
    _labelMessage.textColor = [UIColor lightGrayColor];
    _labelMessage.font = [UIFont systemFontOfSize:12];
    [_contextView addSubview:_labelMessage];
    PYEdgeInsetsItem insets = PYEdgeInsetsItemNull();
    insets.left = (__bridge void * _Nullable)(_imageViewArrow);
    [PYViewAutolayoutCenter persistConstraint:_labelMessage relationmargins:UIEdgeInsetsMake(0,0,0,0) relationToItems:insets];
}
-(void) setScheduleHeight:(CGFloat)scheduleHeight{
    _scheduleHeight = MIN(PYRefreshViewHeight, MAX(10, scheduleHeight));
    self.frameHeight = _scheduleHeight;
    self.alpha = _scheduleHeight / PYRefreshViewHeight;
}
-(void) setState:(kPYRefreshState)state{
    if(self.hidden == YES || _state == state) return;
    _state = state;
    [self synIsUp];
    NSString * message = nil;
    _imageViewArrow.hidden = NO;
    _activityIndicator.hidden = YES;
    [_activityIndicator stopAnimating];
    switch (_state) {
        case kPYRefreshBegin:{
            message = _type == kPYRefreshHeader ? PYRefreshDownBeginText : PYRefreshUpBeginText;
        }
            break;
        case kPYRefreshDo:{
            message = _type == kPYRefreshHeader ? PYRefreshDownDoText : PYRefreshUpDoText;
        }
            break;
        case kPYRefreshDoing:{
            message = _type == kPYRefreshHeader ? PYRefreshDownDoingText : PYRefreshUpDoingText;
            _imageViewArrow.hidden = YES;
            _activityIndicator.hidden = NO;
            [_activityIndicator startAnimating];
        }
            break;
        case kPYRefreshEnd:{
            message = _type == kPYRefreshHeader ? PYRefreshDownEndText : PYRefreshUpEndText;
        }
            break;
        default:
            break;
    }
    _labelMessage.text = message;
    [_labelMessage automorphismWidth];
    [UIView animateWithDuration:0.2 animations:^{
        _lcw.constant = _labelMessage.frameWidth + 1 + _lc1.constant;
    }];
}
-(void) synIsUp{
    _isUp = (_type == kPYRefreshHeader && _state == kPYRefreshEnd) || (_type == kPYRefreshFooter && _state != kPYRefreshEnd) ;
    if(!_isUp){
        _imageViewArrow.image = [UIImage imageNamed:@"PYKit.bundle/arrow_buttom.png"];
    }else{
        _imageViewArrow.image = [UIImage imageNamed:@"PYKit.bundle/arrow_top.png"];
    }
}
-(void) setType:(kPYRefreshType)type{
    _type = type;
    [self synIsUp];
}
kSOULDLAYOUTMSTARTForType(PYRefreshView)
    
kSOULDLAYOUTMEND

@end
