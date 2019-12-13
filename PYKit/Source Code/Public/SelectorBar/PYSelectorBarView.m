//
//  PYSelectorBarView.m
//  PYKit
//
//  Created by wlpiaoyi on 2017/8/18.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import "PYSelectorBarView.h"
#import "PYViewAutolayoutCenter.h"
#import "UIImage+PYExpand.h"
#import "UIView+PYExpand.h"
@interface PYSelectorBarView(){
}
kSOULDLAYOUTPForType(PYSelectorBarView)
kPNSNA NSMutableArray<  NSLayoutConstraint *> * lcButtons;
kPNSNA NSMutableArray<  NSLayoutConstraint *> * lcDisplays;
@end

@implementation PYSelectorBarView
kINITPARAMSForType(PYSelectorBarView){
    _lcDisplays = [NSMutableArray new];
    _lcButtons = [NSMutableArray new];
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
    if(mButtons.count > 0){
        [mButtons sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            UIButton * b1 = obj1;
            UIButton * b2 = obj2;
            if(b1.frameX < b2.frameX){
                return NSOrderedAscending;
            }else if(b1.frameX > b2.frameX){
                return NSOrderedDescending;
            }else{
                return NSOrderedSame;
            }
        }];
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
        for (NSLayoutConstraint * lc in self.lcButtons) {
            [self.class __LC_REMOVE_FROM_VIEW:lc];
        }
        [self.lcButtons removeAllObjects];;
    }
    if(_buttons && _buttons.count){
        for (UIButton * button in _buttons) {
            [button removeFromSuperview];
        }
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
        NSDictionary<NSString *, NSLayoutConstraint *> * lcd = [PYViewAutolayoutCenter persistConstraint:_buttons.firstObject relationmargins:UIEdgeInsetsZero relationToItems:PYEdgeInsetsItemNull()];
        [self.lcButtons addObjectsFromArray:lcd.allValues];
    }else{
        NSArray<NSDictionary<NSString *, NSLayoutConstraint *> *> * lcds = [PYViewAutolayoutCenter persistConstraintHorizontal:_buttons relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:PYEdgeInsetsItemNull() offset:0];
        for (NSDictionary<NSString *, NSLayoutConstraint *> * lcd in lcds) {
            [self.lcButtons addObjectsFromArray:lcd.allValues];
        }
    }
    self.selectorTag = _selectorTag;
    self.selectIndex = 0;
    self.displayTags = _displayTags;
}

-(void) setDisplayTags:(NSArray<UIView *> *)displayTags{
    if(_displayTags && _displayTags.count){
        for (UIView * view in _displayTags) {
            [view removeFromSuperview];
        }
    }
    if(_lcDisplays && _lcDisplays.count){
        for (NSLayoutConstraint * lc in _lcDisplays) {
            [self.class __LC_REMOVE_FROM_VIEW:lc];
        }
        [_lcDisplays removeAllObjects];
    }
    
    _displayTags = displayTags;
    if(_displayTags.count != _buttons.count) return;
    
    for (NSUInteger i = 1; i < _displayTags.count; i++) {
        UIView * view = self.displayTags[i-1];
        [_contentView addSubview:view];
        UIButton * button = _buttons[i];
        NSDictionary<NSString *, NSDictionary<NSString *, NSLayoutConstraint *> *> * lcds = [view setAutotLayotDict:@{@"top":@0, @"right":@0,@"w":@(view.frameWidth), @"h":@(view.frameHeight),@"rightPoint":button}];
        for (NSDictionary<NSString *, NSLayoutConstraint *> * lcd in lcds.allValues) {
            [_lcDisplays addObjectsFromArray:lcd.allValues];
        }
    }
    UIView * view = self.displayTags.lastObject;
    [_contentView addSubview:view];
    NSDictionary<NSString *, NSDictionary<NSString *, NSLayoutConstraint *> *> * lcds = [view setAutotLayotDict:@{@"top":@0, @"right":@0,@"w":@(view.frameWidth), @"h":@(view.frameHeight)}];
    for (NSDictionary<NSString *, NSLayoutConstraint *> * lcd in lcds.allValues) {
        [_lcDisplays addObjectsFromArray:lcd.allValues];
    }
    
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
    
    if(_blockSelectedOpt){
        _blockSelectedOpt(_selectIndex);
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



+(void) __LC_REMOVE_FROM_VIEW:(nonnull NSLayoutConstraint *) lc{
    UIView * view = lc.firstItem;
    if(view){
        [view removeConstraint:lc];
        [view.superview removeConstraint:lc];
    }
    view = lc.secondItem;
    if(view){
        [view removeConstraint:lc];
        [view.superview removeConstraint:lc];
    }
}
@end
