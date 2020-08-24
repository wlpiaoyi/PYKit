//
//  PYImagePickerCell.h
//  PYKit
//
//  Created by wlpiaoyi on 2020/7/21.
//  Copyright © 2020 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "PYUtile.h"
NS_ASSUME_NONNULL_BEGIN

@interface PYImagePickerCell : UICollectionViewCell

kPNSNA UIImage * imageData;
kPNA BOOL isSelectedData;
kPNSNA PHAsset * asset;
kPNA BOOL isLoading;

@end

NS_ASSUME_NONNULL_END
