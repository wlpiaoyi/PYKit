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

kPNSNA NSMutableArray * datas;
kPNSNA UIView * viewTail;
kPNCNA BOOL (^blockOnDel) (id delData);

-(void) addData:(id) data animations:(BOOL) animations;


@end

NS_ASSUME_NONNULL_END
