//
//  PYSelectorScrollView.m
//  PYKit
//
//  Created by wlpiaoyi on 2017/10/17.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import "PYSelectorScrollView.h"
#import "PYGraphicsDraw.h"
#import "PYGraphicsThumb.h"
#import "PYViewAutolayoutCenter.h"
#import "UIColor+Expand.h"

int kSelectorbarviewtag = 1860005;

@interface PYSelectorScrollView()<UIScrollViewDelegate>{
@private
    UIScrollView * _scrollView;
    UIView * _ssv_contentView;
    PYGraphicsThumb * _graphicsThumb;
}
kSOULDLAYOUTPForType(PYSelectorScrollView)
@end

@implementation PYSelectorScrollView
kINITPARAMSForType(PYSelectorScrollView){
    self.gradualChangeColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:.2];
    _contentWidth = 600;
    kAssign(self)
    _graphicsThumb = [PYGraphicsThumb graphicsThumbWithView:self block:^(CGContextRef  _Nonnull ctx, id  _Nullable userInfo) {
        kStrong(self);
        if(!self.isScorllSelected) return;
        [PYGraphicsDraw drawLinearGradientWithContext:ctx  colorValues : (CGFloat[]){
            _gradualChangeColor.red,_gradualChangeColor.green,_gradualChangeColor.blue,_gradualChangeColor.alpha,
            1.0f, 1.0f, 1.0f, 0.98f}
                                              alphas : (CGFloat[]){
                                                  0.99f,
                                                  0.01f}
                                              length : 2 startPoint:CGPointMake(0, 0) endPoint:CGPointMake(_scrollView.contentInset.left, 0)];
        CGFloat width = _ssv_contentView.frame.size.width / self.buttons.count;
        [PYGraphicsDraw drawLinearGradientWithContext:ctx  colorValues : (CGFloat[]){
            _gradualChangeColor.red,_gradualChangeColor.green,_gradualChangeColor.blue,_gradualChangeColor.alpha,
            1.0f, 1.0f, 1.0f, 0.98f}
                                              alphas : (CGFloat[]){
                                                  0.01f,
                                                  0.99f}
                                              length : 2 startPoint:CGPointMake(_scrollView.contentInset.left + width, 0) endPoint:CGPointMake(_scrollView.frame.size.width, 0)];
    }];
    _scrollView.backgroundColor = [UIColor clearColor];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [self addSubview:_scrollView];
    [PYViewAutolayoutCenter persistConstraint:_scrollView relationmargins:UIEdgeInsetsZero relationToItems:PYEdgeInsetsItemNull()];
    _ssv_contentView.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_ssv_contentView];
    [self setBlockSelectedOpt:^(NSUInteger index) {
        kStrong(self);
        self.contentWidth = self.contentWidth;
    }];
    self.isScorllSelected = false;
}
-(void) setIsScorllSelected:(bool)isScorllSelected{
    _isScorllSelected = isScorllSelected;
    UIEdgeInsets   contentInset;
    if(_isScorllSelected){
        contentInset = UIEdgeInsetsMake(0, self.frame.size.width/2 - (_contentWidth/self.buttons.count)/2, 0, self.frame.size.width/2 - (_contentWidth/self.buttons.count)/2);
        _scrollView.delegate = self;
        _scrollView.decelerationRate = 0.8;
        self.selectorTag.hidden = YES;
    }else{
        _scrollView.decelerationRate = 1;
        contentInset = UIEdgeInsetsZero;
        _scrollView.delegate = nil;
        self.selectorTag.hidden = NO;
    }
    _scrollView.contentInset = contentInset;
    self.contentWidth = self.contentWidth;
}

-(void) addContentView:(UIView *) contentView{
    _scrollView = [UIScrollView new];
    _ssv_contentView = [UIView new];
    [_ssv_contentView addSubview:contentView];
    
}

-(void) setContentWidth:(CGFloat)contentWidth{
    _contentWidth = contentWidth;
    _ssv_contentView.frame = CGRectMake(0, 0, MAX(contentWidth, self.frame.size.width), self.frame.size.height);
    _scrollView.contentSize = _ssv_contentView.frame.size;
    kAssign(self);
    void (^block)() = ^() {
        kStrong(self);
        CGFloat width = _ssv_contentView.frame.size.width / self.buttons.count;
        CGFloat height = MIN(MAX(0, self.selectorTagHeight), _ssv_contentView.frame.size.height);
        CGRect rect = CGRectMake(width * self.selectIndex
                                 ,  _ssv_contentView.frame.size.height - height
                                 , width, height);
        self.selectorTag.frame = rect;
        CGPoint contentOffset = _scrollView.contentOffset;
        if(self.isScorllSelected){
            contentOffset = CGPointMake(width * self.selectIndex - _scrollView.contentInset.left, 0);
        }else if(_contentWidth > 0){
            if(contentOffset.x  > width * self.selectIndex){
                contentOffset.x  =  width * self.selectIndex;
            }else if(contentOffset.x + _scrollView.frame.size.width < width * self.selectIndex + width){
                contentOffset.x =  width * self.selectIndex + width - _scrollView.frame.size.width;
            }
        }
        _scrollView.contentOffset = contentOffset;
    };
    [UIView animateWithDuration:0.25f animations:^{
        kStrong(self);
        self.userInteractionEnabled = NO;
        block();
    } completion:^(BOOL finished) {
        kStrong(self);
        self.userInteractionEnabled = YES;
    }];
}
-(void) setGradualChangeColor:(UIColor *)gradualChangeColor{
    _gradualChangeColor = gradualChangeColor;
    if(_graphicsThumb)[_graphicsThumb executDisplay:nil];
}

kSOULDLAYOUTMSTARTForType(PYSelectorScrollView)
self.isScorllSelected = self.isScorllSelected;
self.contentWidth = _contentWidth;
[_graphicsThumb executDisplay:nil];
kSOULDLAYOUTMEND

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;{
    if(!decelerate){
        [self scrollViewDidEndDecelerating:scrollView];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGPoint contentOffset = _scrollView.contentOffset;
    CGFloat offsetx = contentOffset.x + _scrollView.contentInset.left;
    CGFloat width = _ssv_contentView.frame.size.width / self.buttons.count;
    NSUInteger x = offsetx / width;
    if(((long)offsetx) % ((long)width) > width/2){
        x += 1;
    }
    self.selectIndex = x;
    if(self.blockSelecteItem){
        self.blockSelecteItem(x);
    }
    
}

@end
