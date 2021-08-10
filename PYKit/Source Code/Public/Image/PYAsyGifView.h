//
//  PYAsyGifView.h
//  PYKit
//
//  Created by wlpiaoyi on 2021/1/13.
//  Copyright © 2021 wlpiaoyi. All rights reserved.
//

#import "pyutilea.h"

NS_ASSUME_NONNULL_BEGIN

@interface PYAsyGifView : UIView

kPNAR BOOL isAnimating;
kPNA CGFloat interval;

kPNCNA void(^blockPlayStart)(void);
kPNCNA void(^blockPlayEnd)(void);

-(void) setLoadingImage:(nullable UIImage *) image;
-(void) setLocatonPath:(nonnull NSString *) path;
-(void) setImgUrl:(nonnull NSString *) url;

-(CGImageRef) imageRefWithIndex:(NSInteger) index;
 
-(void)start;
-(void)stop;
 


@end

NS_ASSUME_NONNULL_END
