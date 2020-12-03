//
//  PYLongpressMoveItemCell.h
//  PYKit
//
//  Created by wlpiaoyi on 2020/12/1.
//  Copyright © 2020 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pyutilea.h"

NS_ASSUME_NONNULL_BEGIN

@interface PYLongpressMoveItemCell : UICollectionViewCell

kPNSNA NSString * imgUrl;
kPNSNA UIImage * imgData;

kPNCNA void (^blockDel) (PYLongpressMoveItemCell * cell);

kPNA BOOL isDelCtx;
kPNA BOOL isOnTap;

-(UIImage *) snapImage;

@end

NS_ASSUME_NONNULL_END
