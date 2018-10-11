//
//  PYDisplayImageView.h
//  PYKit
//
//  Created by wlpiaoyi on 2017/9/4.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYAsyImageView.h"
@interface PYDisplayImageView : UIView
kPNRNN PYAsyImageView * imageView;
kPNA NSUInteger maxMultiple;
-(void) synchronizedImageSize;
@end
