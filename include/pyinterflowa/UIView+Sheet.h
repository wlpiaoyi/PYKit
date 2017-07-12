//
//  UIView+Sheet.h
//  PYInterflow
//
//  Created by wlpiaoyi on 2016/12/6.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYParams.h"

@interface UIView(Sheet)
-(void) sheetShow;
-(void) sheetShowWithTitle:(nullable NSString *) title
            buttonConfirme:(nullable NSString *) confirme
              buttonCancel:(nullable NSString *) canel
                     block:(void (^ _Nullable)(UIView * _Nullable view, int index)) blcok;
-(void) sheetShowWithAttributeTitle:(nullable NSAttributedString *) attributeTitle
      buttonNormalAttributeConfirme:(nullable NSAttributedString *) normalConfirme
        buttonNormalAttributeCancel:(nullable NSAttributedString *) normalCanel
 buttonHighlightedAttributeConfirme:(nullable NSAttributedString *) highlightedconfirme
   buttonHighlightedAttributeCancel:(nullable NSAttributedString *) highlightedCanel
                              block:(void (^ _Nullable)(UIView * _Nullable view, int index)) blcok;
-(void) sheetHidden;
@end
