//
//  PYAsyImageView+Data.m
//  PYKit
//
//  Created by wlpiaoyi on 2021/4/20.
//  Copyright © 2021 wlpiaoyi. All rights reserved.
//

#import "PYAsyImageView+Data.h"

@interface PYAsyImageView(){
    NSTimeInterval static_pre_time_interval;
}

kPNSNN PYNetDownload * download;
kPNSNA PYGraphicsThumb * graphicsThumb;

kPNSNN UIActivityIndicatorView * activityIndicator;
kPNSNN UIView * activityView;
kPNSNN UILabel * activityLabel;

kPNSNN NSLock * lock;
kPNSNA NSString * cachesPath;
kPNA int64_t currentBytes;
kPNA int64_t totalBytes;

kPNSNN UIColor * strokeColor;
kPNSNN UIColor * fillColor;

@end



@implementation PYAsyImageView(Data)



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
