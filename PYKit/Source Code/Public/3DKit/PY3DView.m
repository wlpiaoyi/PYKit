//
//  PY3DView.m
//  PYKit
//
//  Created by wlpiaoyi on 2017/11/20.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import "PY3DView.h"

@implementation PY3DView

-(void) syn3DTranslate{
    if(_viewContainer == nil){
        @synchronized(self){
            if(_viewContainer == nil){
                _viewContainer = [UIView new];
                _viewContainer.backgroundColor = [UIColor whiteColor];
                [_viewContainer setCornerRadiusAndBorder:1 borderWidth:1 borderColor:[UIColor redColor]];
                [self addSubview:_viewContainer];
                [PYViewAutolayoutCenter persistConstraint:_viewContainer relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:PYEdgeInsetsItemNull()];
            }
        }
    }
}

-(void) angleWithDegreex:(CGFloat) degreex degreey:(CGFloat) degreey degreez:(CGFloat) degreez{
    [PY3DParams checkWithDegreex:&degreex degreey:&degreey degreez:&degreez];
    CGFloat angelx = parseDegreesToRadians(degreex);
    CGFloat angely = parseDegreesToRadians(degreey);
    CGFloat angelz = parseDegreesToRadians(degreez);
    PY3DTransform otx = {0,1,0};
    PY3DTransform oty = {1,0,0};
    PY3DTransform otz = {0,0,1};
    
    CATransform3D trans = CATransform3DIdentity;
    trans.m34 = -1.0f / 400.0f;
    trans = CATransform3DTranslate(trans, 0, 0, -_size.d/2);
    trans = CATransform3DRotate(trans, angelx, otx.x, otx.y , otx.z);
    trans = CATransform3DRotate(trans, angely, oty.x, oty.y , oty.z);
    trans = CATransform3DRotate(trans, angelz, otz.x, otz.y, otz.z);
    _viewContainer.layer.sublayerTransform = trans;
}

@end
