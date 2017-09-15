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
PYPNSNA UIImageView * imageView;
PYPNA NSUInteger maxMultiple;
-(void) synchronizedImageSize;
@end
