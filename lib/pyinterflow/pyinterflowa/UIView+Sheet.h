//
//  UIView+Sheet.h
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/6.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pyutilea.h"
#import "PYInterflowParams.h"

@interface UIView(Sheet)
kPNRNN UIView * sheetShowView;
kPNCNA NSArray<NSNumber *> * sheetIndexs;
kPNA BOOL sheetIsHiddenOnClick;
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
            blockSelected:(void (^ _Nullable)(UIView * _Nullable view,  NSUInteger index)) blcokSelected;
-(void) sheetShowWithTitle:(nullable NSString *) title
            buttonConfirme:(nullable NSString *) confirme
            buttonCancel:(nullable NSString *) canel
            itemStrings:(nullable NSArray<NSString *> *) itemStrings
            blockOpts:(void (^ _Nullable)(UIView * _Nullable view, NSUInteger index)) blcokOpts
            blockSelecteds:(BOOL (^ _Nullable)(UIView * _Nullable view)) blockSelecteds;
-(void) sheetHidden;
@end
