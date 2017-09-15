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

@interface PYSelectorBarView()
PYSOULDLAYOUTP
PYPNCNA NSArray<NSDictionary<NSString *, NSLayoutConstraint *> *> * lcButtons;
PYPNCNA NSDictionary<NSString *, NSLayoutConstraint *> * lcSelectorLine;
@end

@implementation PYSelectorBarView
PYINITPARAMS{
    NSMutableArray * mButtons = [NSMutableArray new];
    for(UIButton * button in self.subviews){
        if([button isKindOfClass:[UIButton class]]){
            [mButtons addObject:button];
        }
    }
    self.buttons = mButtons;
    if(self.selectorLine == nil){
        UIImageView * selectorLine = [UIImageView new];
        selectorLine.image = [UIImage imageWithColor:[UIColor orangeColor]];
        CGRect r = selectorLine.frame;
        r.size.height = 3;
        selectorLine.frame = r;
        self.selectorLine = selectorLine;
    }
    if(!self.selectorColor)[self bringSubviewToFront:self.selectorLine];
    else [self sendSubviewToBack:self.selectorLine];
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
    BOOL flag = false;
    for (UIButton * button in _buttons) {
        if(![button isKindOfClass:[UIButton class]]){
            @throw [NSException exceptionWithName:@"erro type" reason:@"buttons containts erro type" userInfo:nil];
        }
        [button removeTarget:self action:@selector(onclickSelect:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(onclickSelect:) forControlEvents:UIControlEventTouchUpInside];
        if(button.superview != self) [self addSubview:button];
        else flag = true;
    }
    if(!flag) self.lcButtons = [PYViewAutolayoutCenter persistConstraintHorizontal:_buttons relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:PYEdgeInsetsItemNull() offset:0];
    self.selectorLine = self.selectorLine;
}
-(void) onclickSelect:(UIButton *) button{
    unsigned int index = (unsigned int)[self.buttons indexOfObject:button];
    if(index == self.selectIndex) return;
    self.selectIndex = index;
    if(self.blockSelecteItem && !_blockSelecteItem(index)){
        return;
    }
}
-(void) setSelectorLine:(UIImageView *)selectorLine{
    if(_selectorLine){
        [self removeConstraints:self.lcSelectorLine.allValues];
        [_selectorLine removeConstraints:self.lcSelectorLine.allValues];
        [_selectorLine removeFromSuperview];
    }
    _selectorLine = selectorLine;
    if(!_selectorLine) return;
    [self addSubview:_selectorLine];
    [self bringSubviewToFront:_selectorLine];
    self.lcSelectorLine = nil;
    [self refreshImageView];
    
}
-(void) setSelectorColor:(UIColor *)selectorColor{
    _selectorColor = selectorColor;
    if(_selectorLine){
        [self removeConstraints:self.lcSelectorLine.allValues];
        [_selectorLine removeConstraints:self.lcSelectorLine.allValues];
        [_selectorLine removeFromSuperview];
    }
    if(!_selectorColor) return;
    _selectorLine = [UIImageView new];
    _selectorLine.image = [UIImage imageWithColor:_selectorColor];
    [self addSubview:_selectorLine];
    [self sendSubviewToBack:_selectorLine];
    self.lcSelectorLine = nil;
    [self refreshImageView];
    
}
-(void) setSelectIndex:(unsigned int)selectIndex{
    
    _selectIndex = selectIndex;
    if(!self.lcSelectorLine || !self.lcSelectorLine[@"superLeft"]) return;
    
    if(!self.selectorColor)[self bringSubviewToFront:self.selectorLine];
    else [self sendSubviewToBack:self.selectorLine];
    
    @unsafeify(self);
    [UIView animateWithDuration:0.25f animations:^{
        @strongify(self);
        NSLayoutConstraint * lc = self.lcSelectorLine[@"superLeft"];
        lc.constant = self.frame.size.width / self.buttons.count * self.selectIndex;
        CGRect r = self.selectorLine.frame;
        r.origin.x = lc.constant;
        self.selectorLine.frame = r;
        self.userInteractionEnabled = NO;
    } completion:^(BOOL finished) {
        @strongify(self);
        self.userInteractionEnabled = YES;
    }];
    
    int index = 0;
    for (UIButton * button in self.buttons) {
        [button setSelected:index == _selectIndex];
        index++;
    }
    
}
-(void) refreshImageView{
    if(!_selectorLine || _selectorLine.superview !=self) return;
    if(!self.lcSelectorLine){
        if(self.buttons.count == 0 || self.frame.size.width == 0) return;
        CGFloat w = self.frame.size.width/self.buttons.count;
        if(w <= 0) return;
        if(self.selectorColor){
            NSMutableDictionary * mDict = [NSMutableDictionary dictionaryWithDictionary:[PYViewAutolayoutCenter persistConstraint:self.selectorLine size:CGSizeMake(w, DisableConstrainsValueMAX)]];
            NSDictionary * tDict = [PYViewAutolayoutCenter persistConstraint:self.selectorLine relationmargins:UIEdgeInsetsMake(0, 0, 0, DisableConstrainsValueMAX) relationToItems:PYEdgeInsetsItemNull()];
            for (NSString * key in tDict) {
                [mDict setValue:tDict[key] forKey:key];
            }
            self.lcSelectorLine = mDict;
        }else{
            NSMutableDictionary * mDict = [NSMutableDictionary dictionaryWithDictionary:[PYViewAutolayoutCenter persistConstraint:self.selectorLine size:CGSizeMake(w, _selectorLine.frame.size.height)]];
            NSDictionary * tDict = [PYViewAutolayoutCenter persistConstraint:self.selectorLine relationmargins:UIEdgeInsetsMake(DisableConstrainsValueMAX, 0, 0, DisableConstrainsValueMAX) relationToItems:PYEdgeInsetsItemNull()];
            for (NSString * key in tDict) {
                [mDict setValue:tDict[key] forKey:key];
            }
            self.lcSelectorLine = mDict;
        }
    }else{
        CGFloat w = self.frame.size.width/self.buttons.count;
        NSLayoutConstraint * lc = self.lcSelectorLine[@"selfWith"];
        lc.constant = w;
        lc = self.lcSelectorLine[@"selfHeight"];
        lc.constant = _selectorLine.frame.size.height;
    }
    self.selectIndex = self.selectIndex;
}
PYSOULDLAYOUTMSTART
    [self refreshImageView];
PYSOULDLAYOUTMEND

@end
