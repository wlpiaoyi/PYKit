//
//  PYUserLocationView.m
//  PYMap
//
//  Created by wlpiaoyi on 2018/7/26.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import "PYUserLocationView.h"
#import "pyutilea.h"

@implementation PYUserLocationView{
@private UIImageView * directionImage;
@private UIView * displayView;
    
}

-(instancetype) init{
    
    if(self = [super init]){
        
        self.bounds = CGRectMake(0, 0 ,20, (10 + 9) * 2);
        displayView = [UIView new];
        displayView.backgroundColor = [UIColor clearColor];
        [self addSubview:displayView];
        [PYViewAutolayoutCenter persistConstraint:displayView relationmargins:UIEdgeInsetsZero relationToItems:PYEdgeInsetsItemNull()];
        directionImage = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"PYKit.bundle/images/user_location_direction.png"]];
        [directionImage setContentMode:UIViewContentModeScaleToFill];
        
        [displayView addSubview:directionImage];
        [directionImage setAutotLayotDict:@{@"x":@(0), @"w":@(10), @"h":@(9), @"y":@(-15)}];
    }
    
    return self;
    
}
-(void) setMagneticHeading:(CLLocationDirection)magneticHeading{
    _magneticHeading = magneticHeading;
    displayView.transform = CGAffineTransformMakeRotation(self.magneticHeading *M_PI / 180.0);
}

@end
