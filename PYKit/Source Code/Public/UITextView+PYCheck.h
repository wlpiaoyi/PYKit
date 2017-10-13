//
//  UITextView+PYCheck.h
//  PYKit
//
//  Created by wlpiaoyi on 2017/7/15.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYUtile.h"

@interface UITextView(PYCheck)

kPNCNA void (^py_blockInputEndMatch) (NSString * _Nonnull identify, BOOL * _Nonnull checkResult);
-(void) py_clearTextViewCheck;
-(void) py_checkInteger;
-(void) py_checkIntegerForMax:(kInt64) max min:(kInt64) min;
-(void) py_checkFloat;
-(void) py_checkFloatForMax:(CGFloat) max min:(CGFloat) min precision:(int) precision;
-(void) py_checkMobliePhone;
-(void) py_checkEmail;
-(void) py_checkIDCard;
-(void) py_checkMatchWithIdentify:(nonnull NSString *) identify inputing:(nonnull id) inputing inputEnd:(nonnull NSString *) inputEnd;

@end
