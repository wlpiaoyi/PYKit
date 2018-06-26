//
//  PY3DParams.m
//  PYKit
//
//  Created by wlpiaoyi on 2017/11/20.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import "PY3DParams.h"

@implementation PY3DParams

+(void) checkWithDegreex:(CGFloat *) degreexp degreey:(CGFloat *) degreeyp degreez:(CGFloat *) degreezp{
    CGFloat degreex = *degreexp;
    CGFloat degreey = *degreeyp;
    CGFloat degreez = *degreezp;
    if(degreex > 360){
        degreex = ((NSInteger)degreex) % 360;
    }
    if(degreex < 0){
        degreex = (((NSInteger)degreex) % -360) + 360;
    }
    if(degreey > 360){
        degreey = ((NSInteger)degreey) % 360;
    }
    if(degreey < 0){
        degreey = (((NSInteger)degreey) % - 360) + 360;
    }
    if(degreez > 360){
        degreez = ((NSInteger)degreez) % 360;
    }
    if(degreez < 0){
        degreez = (((NSInteger)degreez) % - 360) + 360;
    }
    *degreexp = degreex;
    *degreeyp = degreey;
    *degreezp = degreez;
}

@end
