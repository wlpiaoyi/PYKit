//
//  PYDisplayImageView.h
//  PYKit
//
//  Created by wlpiaoyi on 2017/9/4.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYUtile.h"
@interface PYDisplayImageView : UIView
//默认的imageView是PYAsyImageView
kPNSNA UIImageView * imageView;
kPNA NSUInteger maxMultiple;
-(void) synchronizedImageSize;
@end
