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
kPNCNA NSArray<NSDictionary<NSString *, NSLayoutConstraint *> *> * lcButtons;
@end

@implementation PYSelectorBarView
kINITPARAMSForType(PYSelectorBarView){
    _contentView = [UIView new];
    _contentView.backgroundColor = [UIColor clearColor];
    [self addContentView:_contentView];
    [PYViewAutolayoutCenter persistConstraint:_contentView relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:PYEdgeInsetsItemNull()];
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
        UIImageView * selectorTag = [UIImageView new];
        selectorTag.backgroundColor = [UIColor orangeColor];
        selectorTag.contentMode = UIViewContentModeScaleAspectFit;
        [selectorTag setCornerRadiusAndBorder:2 borderWidth:1 borderColor:[UIColor clearColor]];
        self.selectorTag = selectorTag;
    }
}
-(void) setButtons:(NSArray *)buttons{
    if(self.lcButtons){
        for (NSDictionary * lcDict in self.lcButtons) {
            for (NSLayoutConstraint * lc in lcDict.allKeys) {
                [_contentView removeConstraint:lc];
            }
        }
        self.lcButtons = nil;
    }
    _buttons = buttons;
    for (UIButton * button in _buttons) {
        if(![button isKindOfClass:[UIButton class]]){
            @throw [NSException exceptionWithName:@"erro type" reason:@"buttons containts erro type" userInfo:nil];
        }
        [button removeFromSuperview];
        [button removeTarget:self action:@selector(onclickSelect:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(onclickSelect:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:button];
    }
    self.lcButtons = [PYViewAutolayoutCenter persistConstraintHorizontal:_buttons relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:PYEdgeInsetsItemNull() offset:0];
    self.selectorTag = _selectorTag;
}
-(void) addContentView:(UIView *) contentView{
    [self addSubview:contentView];
}
-(void) onclickSelect:(UIButton *) button{
    unsigned int index = (unsigned int)[self.buttons indexOfObject:button];
    if(index == self.selectIndex) return;
    if(self.delegate && ![self.delegate selectorBarView:self selecteItemIndex:index]){
        return;
    }else if(!self.delegate && self.blockSelecteItem && !_blockSelecteItem(index)){
        return;
    }
    [self setSelectIndex:index animation:YES];
}
-(void) setSelectorTag:(UIImageView *)selectorTag{
    if (_selectorTag) {
        [_selectorTag removeFromSuperview];
    }
    _selectorTag = selectorTag;
    if(!_selectorTag) return;
    [self.contentView addSubview:_selectorTag];
    self.selectIndex = _selectIndex;
}

-(void) setSelectIndex:(NSUInteger)selectIndex animation:(BOOL) animation{
    _selectIndex = selectIndex;
    if(self.buttons.count == 0) return;
    if(_blockSelectedOpt){
        _blockSelectedOpt(selectIndex);
    }
    if(self.selectorTag){
        kAssign(self);
        void (^block)() = ^() {
            kStrong(self);
            CGFloat width = self.contentView.frame.size.width / self.buttons.count;
            CGFloat height;
            if(_selectorTagHeight < 0){
                height = self.contentView.frame.size.height;
                [self.selectorTag.superview sendSubviewToBack:self.selectorTag];
            }else{
                height = MIN(MAX(0, _selectorTagHeight), self.contentView.frame.size.height);
                [self.selectorTag.superview bringSubviewToFront:self.selectorTag];
            }
            CGRect rect = CGRectMake(width * self.selectIndex
                                     ,  self.contentView.frame.size.height - height
                                     , width, height);
            self.selectorTag.frame = rect;
        };
        
        if(animation){
            [UIView animateWithDuration:0.25f animations:^{
                kStrong(self);
                self.userInteractionEnabled = NO;
                block();
            } completion:^(BOOL finished) {
                kStrong(self);
                self.userInteractionEnabled = YES;
            }];
        }else{
            self.userInteractionEnabled = YES;
            block();
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
