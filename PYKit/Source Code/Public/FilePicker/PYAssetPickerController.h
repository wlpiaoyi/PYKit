//
//  PYAssetPickerController.h
//  PYKit
//
//  Created by wlpiaoyi on 2020/7/21.
//  Copyright © 2020 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "pyutilea.h"

NS_ASSUME_NONNULL_BEGIN

@interface PYAssetPickerController : UIViewController

kPNA PHAssetCollectionSubtype subtype;

kPNA NSUInteger maxSelected;
kPNCNA void (^blockSelected) (NSArray<PHAsset *> * selectedAssets);
kPNCNA void (^blockSelectedHasICloud) (NSArray<PHAsset *> * selectedAssets, BOOL hasiCloud, void (^ _Nonnull blockDesmiss)(void));

+(instancetype) instanceVideos;
+(instancetype) instanceAny;

@end

NS_ASSUME_NONNULL_END
