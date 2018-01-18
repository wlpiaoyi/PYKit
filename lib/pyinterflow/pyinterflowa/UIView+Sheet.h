//
//  UIView+Sheet.h
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/6.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pyutilea.h"
#import "PYParams.h"

@interface UIView(Sheet)
kPNRNN UIView * sheetShowView;
-(void) sheetShow;
-(void) sheetShowWithTitle:(nullable NSString *) title
            buttonConfirme:(nullable NSString *) confirme
            buttonCancel:(nullable NSString *) canel
            blockOpt:(void (^ _Nullable)(UIView * _Nullable view, NSUInteger index)) blcokOpt;
-(void) sheetShowWithTitle:(nullable NSString *) title
            buttonConfirme:(nullable NSString *) confirme
            buttonCancel:(nullable NSString *) canel
            itemStrings:(nullable NSArray<NSString *> *) itemStrings
            blockOpt:(void (^ _Nullable)(UIView * _Nullable view, NSUInteger index)) blcokOpt
            blockSelected:(void (^ _Nullable)(UIView * _Nullable view, NSUInteger index)) blcokSelected;
-(void) sheetShowWithAttributeTitle:(nullable NSAttributedString *) attributeTitle
        buttonNormalAttributeConfirme:(nullable NSAttributedString *) normalConfirme
        buttonNormalAttributeCancel:(nullable NSAttributedString *) normalCanel
        buttonHighlightedAttributeConfirme:(nullable NSAttributedString *) highlightedconfirme
        buttonHighlightedAttributeCancel:(nullable NSAttributedString *) highlightedCanel
        itemAttributes:(nullable NSArray<NSAttributedString *> *) itemAttributes
        blockOpt:(void (^ _Nullable)(UIView * _Nullable view, NSUInteger index)) blcokOpt
        blockSelected:(void (^ _Nullable)(UIView * _Nullable view, NSUInteger index)) blcokSelected;
-(void) sheetHidden;
@end
