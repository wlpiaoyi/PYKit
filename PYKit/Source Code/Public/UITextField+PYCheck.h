//
//  UITextField+PYCheck.h
//  PYKit
//
//  Created by wlpiaoyi on 2017/6/27.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import "PYUtile.h"

@interface UITextField(PYCheck)
kPNCNA void (^blockInputEndMatch) (NSString * _Nonnull identify, BOOL * _Nonnull checkResult);
-(void) pyClearTextFieldCheck;
-(void) pyCheckInteger;
-(void) pyCheckIntegerForMax:(kInt64) max min:(kInt64) min;
-(void) pyCheckFloat;
-(void) pyCheckFloatForMax:(CGFloat) max min:(CGFloat) min precision:(int) precision;
-(void) pyCheckMobliePhone;
-(void) pyCheckEmail;
-(void) pyCheckIDCard;
-(void) pyCheckMatchWithIdentify:(nonnull NSString *) identify inputing:(nonnull id) inputing inputEnd:(nonnull NSString *) inputEnd;
@end
