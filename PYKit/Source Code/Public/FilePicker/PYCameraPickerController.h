//
//  PYCameraPickerController.h
//  PYKit
//
//  Created by wlpiaoyi on 2020/7/22.
//  Copyright © 2020 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pyutilea.h"
NS_ASSUME_NONNULL_BEGIN

@interface PYCameraPickerController : UIViewController

kPNA CGSize imageSize;
kPNCNA BOOL (^blockCamera) (UIImage * image);

@end

NS_ASSUME_NONNULL_END
