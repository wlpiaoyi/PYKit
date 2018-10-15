//
//  UIView+Toast.h
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/9.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(Toast)
-(void) toastShow:(CGFloat) time;
-(void) toastShow:(CGFloat) time message:(nullable NSString *) message;
-(void) toastShow:(CGFloat) time attributeMessage:(nullable NSAttributedString *) attributeMessage;
@end


@interface UIView(Topbar)
-(void) topbarShow:(CGFloat) time;
-(void) topbarShow:(CGFloat) time message:(nullable NSString *) message;
-(void) topbarShow:(CGFloat) time attributeMessage:(nullable NSAttributedString *) attributeMessage;
@end
