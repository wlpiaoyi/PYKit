//
//  UIView+Dialog.h
//  PYInterchange
//
//  Created by wlpiaoyi on 16/1/21.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYParams.h"

/**
 对话框
 */
@interface UIView(Dialog)
@property (nonatomic, retain, nullable) id dialogUserInfo;

-(void) dialogShowWithTitle:(nullable NSString *) title message:(nullable NSString *) message block:(nullable BlockDialogOpt) block buttonNames:(nonnull NSArray<NSString*>*)buttonNames;
-(void) dialogShowWithAttributeTitle:(nullable NSAttributedString *) attributeTitle attributeMessage:(nullable NSAttributedString *) attributeMessage block:(nullable BlockDialogOpt) block buttonNormalNames:(nonnull NSArray<NSAttributedString*>*)buttonNormalNames buttonHightLightNames:(nonnull NSArray<NSAttributedString*>*)buttonHightLightNames;

-(void) dialogShowWithTitle:(nullable NSString *) title block:(nullable BlockDialogOpt) block buttonNames:(nonnull NSArray<NSString*>*)buttonNames;
-(void) dialogShowWithAttributeTitle:(nullable NSAttributedString *) attributeTitle block:(nullable BlockDialogOpt) block buttonNormalNames:(nonnull NSArray<NSAttributedString*>*)buttonNormalNames buttonHightLightNames:(nonnull NSArray<NSAttributedString*>*)buttonHightLightNames;

-(void) dialogHidden;

@end
