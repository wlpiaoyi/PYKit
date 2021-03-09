//
//  PYItemTapView.h
//  PYKit
//
//  Created by wlpiaoyi on 2020/12/1.
//  Copyright © 2020 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pyutilea.h"

NS_ASSUME_NONNULL_BEGIN

@interface PYLongpressMoveItemView : UIView

kPNA BOOL isShowDelCtx;
kPNA CGSize itemSize;
kPNA NSInteger maxCount;
kPNA BOOL hasAnimation;

kPNSNA NSMutableArray * datas;
kPNSNA UIView * viewTail;
kPNCNA id (^blockCheckData) (id data);
kPNCNA BOOL (^blockBeforeEdit) (PYLongpressMoveItemView * itemView);
kPNCNA void (^blockAfterEdit) (PYLongpressMoveItemView * itemView);
kPNCNA BOOL (^blockBeforeDel) (id delData);
kPNCNA void (^blockAfterDel) (id delData);
kPNCNA BOOL (^blockBeforeMove) (id target, id toMove);
kPNCNA void (^blockAfterMove) (id target, id toMove);

-(void) addData:(id) data animations:(BOOL) animations;


@end

NS_ASSUME_NONNULL_END
