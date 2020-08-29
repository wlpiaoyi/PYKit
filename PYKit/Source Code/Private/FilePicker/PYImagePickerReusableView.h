//
//  PYImagePickerReusableView.h
//  PYKit
//
//  Created by wlpiaoyi on 2020/7/21.
//  Copyright © 2020 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYUtile.h"

NS_ASSUME_NONNULL_BEGIN

@interface PYImagePickerReusableView : UICollectionReusableView

kPNSNA NSString * name;
kPNA NSInteger section;
kPNA BOOL isExpand;
kPNCNA BOOL (^blockExpand)(PYImagePickerReusableView * view);

@end

NS_ASSUME_NONNULL_END
