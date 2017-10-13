//
//  PYSelectorBarView.m
//  PYKit
//
//  Created by wlpiaoyi on 2017/8/18.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import "PYSelectorBarView.h"
#import "PYViewAutolayoutCenter.h"
#import "UIImage+Expand.h"
#import "EXTScope.h"

@interface PYSelectorBarView(){
@private
    UIScrollView * _scrollView;
    UIView * _contentView;
}
kSOULDLAYOUTP
kPNCNA NSArray<NSDictionary<NSString *, NSLayoutConstraint *> *> * lcButtons;
@end

@implementation PYSelectorBarView
kINITPARAMS{
    _contentWidth = 0;
    _scrollView = [UIScrollView new];
    _scrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:_scrollView];
    [PYViewAutolayoutCenter persistConstraint:_scrollView relationmargins:UIEdgeInsetsZero relationToItems:PYEdgeInsetsItemNull()];
    
    _contentView = [UIView new];
    _contentView.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_contentView];
    
    NSMutableArray * mButtons = [NSMutableArray new];
    for(UIButton * button in self.subviews){
        if([button isKindOfClass:[UIButton class]]){
            [mButtons addObject:button];
            [button removeTarget:self action:@selector(onclickSelect:) forControlEvents:UIControlEventTouchUpInside];
            [button addTarget:self action:@selector(onclickSelect:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    _buttons = mButtons;
    _selectIndex = 0;
    _selectorTagHeight = 3;
    if(self.selectorTag == nil){
        UIImageView * selectorTag = [UIImageView new];
        selectorTag.backgroundColor = [UIColor orangeColor];
        selectorTag.contentMode = UIViewContentModeScaleAspectFit;
        self.selectorTag = selectorTag;
    }
}
-(void) setButtons:(NSArray *)buttons{
    if(self.lcButtons){
        for (NSDictionary * lcDict in self.lcButtons) {
            for (NSLayoutConstraint * lc in lcDict.allKeys) {
                [self removeConstraint:lc];
            }
        }
        self.lcButtons = nil;
    }
    _buttons = buttons;
    for (UIButton * button in _buttons) {
        if(![button isKindOfClass:[UIButton class]]){
            @throw [NSException exceptionWithName:@"erro type" reason:@"buttons containts erro type" userInfo:nil];
        }
        [button removeTarget:self action:@selector(onclickSelect:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(onclickSelect:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:button];
    }
    self.lcButtons = [PYViewAutolayoutCenter persistConstraintHorizontal:_buttons relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:PYEdgeInsetsItemNull() offset:0];
    self.selectorTag = _selectorTag;
}
-(void) onclickSelect:(UIButton *) button{
    unsigned int index = (unsigned int)[self.buttons indexOfObject:button];
    if(index == self.selectIndex) return;
    if(self.blockSelecteItem && !_blockSelecteItem(index)){
        return;
    }
    [self setSelectIndex:index animation:YES];
}
-(void) setSelectorTag:(UIImageView *)selectorTag{
    _selectorTag = selectorTag;
    if(!_selectorTag) return;
    if(self.lcButtons == nil || self.lcButtons.count == 0){
        [self addSubview:_selectorTag];
        [self bringSubviewToFront:_selectorTag];
        _scrollView.hidden = YES;
    }else{
        [_contentView addSubview:_selectorTag];
        [_contentView bringSubviewToFront:_selectorTag];
        _scrollView.hidden = NO;
    }
    self.selectIndex = _selectIndex;
}

-(void) setSelectIndex:(NSUInteger)selectIndex animation:(BOOL) animation{
    _selectIndex = selectIndex;
    if(self.buttons.count == 0) return;
    @unsafeify(self);
    void (^block)() = ^() {
        @strongify(self);
        CGFloat width = _contentView.frame.size.width / self.buttons.count;
        CGFloat height = MIN(MAX(0, _selectorTagHeight), _contentView.frame.size.height);
        CGRect rect = CGRectMake(width * self.selectIndex
                                 ,  _contentView.frame.size.height - height
                                 , width, height);
        self.selectorTag.frame = rect;
        if(_contentWidth > 0){
            CGPoint contentOffset = _scrollView.contentOffset;
            if(contentOffset.x  > width * _selectIndex){
                contentOffset.x  =  width * _selectIndex;
            }else if(contentOffset.x + _scrollView.frame.size.width < width * _selectIndex + width){
                contentOffset.x =  width * _selectIndex + width - _scrollView.frame.size.width;
            }
            _scrollView.contentOffset = contentOffset;
        }else{
            _scrollView.contentOffset = CGPointMake(0, 0);
        }
    };
    if(animation){
        [UIView animateWithDuration:0.25f animations:^{
            @strongify(self);
            self.userInteractionEnabled = NO;
            block();
        } completion:^(BOOL finished) {
            @strongify(self);
            self.userInteractionEnabled = YES;
        }];
    }else{
        self.userInteractionEnabled = YES;
        block();
    }
    
    int index = 0;
    for (UIButton * button in self.buttons) {
        [button setSelected:index == _selectIndex];
        index++;
    }
}
-(void) setSelectIndex:(NSUInteger)selectIndex{
    [self setSelectIndex:selectIndex animation:NO];
}
-(void) setContentWidth:(CGFloat)contentWidth{
    _contentWidth = contentWidth;
    _contentView.frame = CGRectMake(0, 0, MAX(_contentWidth, _scrollView.frame.size.width), _scrollView.frame.size.height);
    _scrollView.contentSize = _contentView.frame.size;
    self.selectIndex = _selectIndex;
}
kSOULDLAYOUTMSTART
self.contentWidth = _contentWidth;
kSOULDLAYOUTMEND

@end
