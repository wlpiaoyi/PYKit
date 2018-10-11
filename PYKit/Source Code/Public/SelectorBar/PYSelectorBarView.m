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
#import "UIView+Expand.h"
@interface PYSelectorBarView(){
}
kSOULDLAYOUTPForType(PYSelectorBarView)
kPNSNA NSArray<NSDictionary<NSString *, NSLayoutConstraint *> *> * lcButtons;
kPNSNA NSDictionary<NSString *, NSLayoutConstraint *> * lcButton;
@end

@implementation PYSelectorBarView
kINITPARAMSForType(PYSelectorBarView){
    _contentView = [UIView new];
    _contentView.backgroundColor = [UIColor clearColor];
    [self addContentView:_contentView];
    PYEdgeInsetsItem eii = PYEdgeInsetsItemNull();
    eii.topActive = eii.leftActive = eii.rightActive = eii.bottomActive = YES;
    [PYViewAutolayoutCenter persistConstraint:_contentView relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:eii];
    NSMutableArray * mButtons = [NSMutableArray new];
    for(UIButton * button in self.subviews){
        if([button isKindOfClass:[UIButton class]]){
            [mButtons addObject:button];
        }
    }
    self.buttons = mButtons;
    _selectIndex = 0;
    _selectorTagHeight = 3;
    if(self.selectorTag == nil){
        UIView * selectorTag = [UIView new];
        selectorTag.backgroundColor = [UIColor orangeColor];
        selectorTag.contentMode = UIViewContentModeScaleAspectFit;
        [selectorTag setCornerRadiusAndBorder:2 borderWidth:1 borderColor:[UIColor clearColor]];
        self.selectorTag = selectorTag;
    }
}
-(void) setButtons:(NSArray *)buttons{
    if(self.lcButtons){
        for (NSDictionary * lcDict in self.lcButtons) {
            for (NSLayoutConstraint * lc in lcDict.allValues) {
                [_contentView removeConstraint:lc];
            }
        }
        self.lcButtons = nil;
    }
    if(self.lcButton){
        for (NSLayoutConstraint * lc in self.lcButton.allValues) {
            [_contentView removeConstraint:lc];
        }
        self.lcButton = nil;
    }
    _buttons = buttons;
    if(_buttons == nil || buttons.count == 0) return;
    for (UIButton * button in _buttons) {
        if(![button isKindOfClass:[UIButton class]]){
            @throw [NSException exceptionWithName:@"erro type" reason:@"buttons containts erro type" userInfo:nil];
        }
        [button removeFromSuperview];
        [button removeTarget:self action:@selector(onclickSelect:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(onclickSelect:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:button];
    }
    if(_buttons.count == 1){
        self.lcButton = [PYViewAutolayoutCenter persistConstraint:_buttons.firstObject relationmargins:UIEdgeInsetsZero relationToItems:PYEdgeInsetsItemNull()];
    }else{
        self.lcButtons = [PYViewAutolayoutCenter persistConstraintHorizontal:_buttons relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:PYEdgeInsetsItemNull() offset:0];
    }
    self.selectorTag = _selectorTag;
    self.selectIndex = 0;
}
-(void) addContentView:(UIView *) contentView{
    [self addSubview:contentView];
}
-(void) onclickSelect:(UIButton *) button{
    unsigned int index = (unsigned int)[self.buttons indexOfObject:button];
    if(index == self.selectIndex) return;
    NSUInteger orgIndex = _selectIndex;
    _selectIndex = index;
    @try{
        if(self.delegate
           && [self.delegate respondsToSelector:@selector(selectorBarView:selectedItemIndex:)]
           && ![self.delegate selectorBarView:self selectedItemIndex:index]){
            return;
        }else if(!self.delegate && self.blockSelecteItem && !_blockSelecteItem(index)){
            return;
        }
    }@finally{
        _selectIndex = orgIndex;
    }
    [self setSelectIndex:index animation:YES];
}
-(void) setSelectorTag:(UIView *)selectorTag{
    if (_selectorTag) {
        [_selectorTag removeFromSuperview];
    }
    _selectorTag = selectorTag;
    if(!_selectorTag) return;
    [self.contentView addSubview:_selectorTag];
    self.selectIndex = _selectIndex;
}

-(void) setSelectIndex:(NSUInteger)selectIndex animation:(BOOL) animation{
    if(self.buttons.count == 0) return;
    CGFloat width = self.contentView.frame.size.width / self.buttons.count;
    CGFloat offsetW = (self.selectorTagWidth > 0 && self.selectorTagWidth < width) ? (width - self.selectorTagWidth)/2 : 0;
    offsetW = offsetW > 0 ? offsetW : 0;
    CGFloat orgSelectIndex = _selectIndex;
    _selectIndex = MAX(0, MIN(self.buttons.count - 1, selectIndex));
    if(_blockSelectedOpt){
        _blockSelectedOpt(selectIndex);
    }
    if(self.selectorTag){
        kAssign(self);
        void (^blockStart)() = ^() {
            kStrong(self);
            CGFloat height;
            if(_selectorTagHeight < 0){
                height = self.contentView.frame.size.height;
                [self.selectorTag.superview sendSubviewToBack:self.selectorTag];
            }else{
                height = MIN(MAX(0, _selectorTagHeight), self.contentView.frame.size.height);
                [self.selectorTag.superview bringSubviewToFront:self.selectorTag];
            }
            CGRect rect = CGRectMake(width * ((self.selectIndex - orgSelectIndex) > 0 ? orgSelectIndex : self.selectIndex) + offsetW
                                     ,  self.contentView.frame.size.height - height
                                     , width + width * ABS(self.selectIndex - orgSelectIndex) - offsetW * 2, height);
            self.selectorTag.frame = rect;
        };
        void (^blockEnd)() = ^() {
            kStrong(self);
            CGFloat width = self.contentView.frame.size.width / self.buttons.count;
            CGFloat height;
            if(_selectorTagHeight < 0){
                height = self.contentView.frame.size.height;
                [self.selectorTag.superview sendSubviewToBack:self.selectorTag];
            }else{
                height = MIN(MAX(0, self.selectorTagHeight), self.contentView.frame.size.height);
                [self.selectorTag.superview bringSubviewToFront:self.selectorTag];
            }
            CGRect rect = CGRectMake(width * self.selectIndex + offsetW
                                     ,  self.contentView.frame.size.height - height
                                     , width - offsetW * 2, height);
            self.selectorTag.frame = rect;
        };
        
        if(animation){
            [UIView animateWithDuration:.125f animations:^{
                self.userInteractionEnabled = NO;
                blockStart();
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.125f animations:^{
                    blockEnd();
                } completion:^(BOOL finished) {
                    self.userInteractionEnabled = YES;
                }];
            }];
        }else{
            self.userInteractionEnabled = YES;
            blockEnd();
        }
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
kSOULDLAYOUTMSTARTForType(PYSelectorBarView)
self.selectIndex = _selectIndex;
kSOULDLAYOUTMEND
-(void) dealloc{
    
}
@end
