//
//  PY3DOrthogonView.m
//  PYKit
//
//  Created by wlpiaoyi on 2017/11/20.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import "PY3DOrthogonView.h"

@implementation PY3DOrthogonView{
@private
    CGPoint pointTB;
    CGPoint pointAdd;
}
-(void) syn3DTranslate{
    [super syn3DTranslate];
    pointTB = pointAdd = CGPointMake(0, 0);
    CATransform3D trans = CATransform3DIdentity;
    if(_viewFront){
        UIView * viewTemp = _viewFront;
        [viewTemp removeFromSuperview];
        [_viewContainer addSubview:viewTemp];
        [PYViewAutolayoutCenter persistConstraint:viewTemp size:CGSizeMake(self.size.w, self.size.h)];
        [PYViewAutolayoutCenter persistConstraint:viewTemp centerPointer:CGPointMake(0, 0)];
        CATransform3D transTemp = CATransform3DTranslate(trans, 0, 0, self.size.d/2);
        transTemp = CATransform3DRotate(transTemp, 0 , 0 , 1 , 0);
        viewTemp.layer.transform = transTemp;
    }
    if(_viewBehind){
        UIView * viewTemp = _viewBehind;
        [viewTemp removeFromSuperview];
        [_viewContainer addSubview:viewTemp];
        [PYViewAutolayoutCenter persistConstraint:viewTemp size:CGSizeMake(self.size.w, self.size.h)];
        [PYViewAutolayoutCenter persistConstraint:viewTemp centerPointer:CGPointMake(0, 0)];
        CATransform3D transTemp = CATransform3DTranslate(trans, 0, 0, -self.size.d/2);
        transTemp = CATransform3DRotate(transTemp, M_PI , 0 , 1 , 0);
        viewTemp.layer.transform = transTemp;
    }
    if(_viewLeft){
        UIView * viewTemp = _viewLeft;
        [viewTemp removeFromSuperview];
        [_viewContainer addSubview:viewTemp];
        [PYViewAutolayoutCenter persistConstraint:viewTemp size:CGSizeMake(self.size.d, self.size.h)];
        [PYViewAutolayoutCenter persistConstraint:viewTemp centerPointer:CGPointMake(0, 0)];
        CATransform3D transTemp = CATransform3DTranslate(trans, -self.size.w/2, 0, 0);
        transTemp = CATransform3DRotate(transTemp, -M_PI_2 , 0 , 1 , 0);
        viewTemp.layer.transform = transTemp;
    }
    if(_viewRight){
        UIView * viewTemp = _viewRight;
        [viewTemp removeFromSuperview];
        [_viewContainer addSubview:viewTemp];
        [PYViewAutolayoutCenter persistConstraint:viewTemp size:CGSizeMake(self.size.d, self.size.h)];
        [PYViewAutolayoutCenter persistConstraint:viewTemp centerPointer:CGPointMake(0, 0)];
        CATransform3D transTemp = CATransform3DTranslate(trans, self.size.w/2, 0, 0);
        transTemp = CATransform3DRotate(transTemp, M_PI_2 , 0 , 1 , 0);
        viewTemp.layer.transform = transTemp;
    }
    if(_viewUp){
        UIView * viewTemp = _viewUp;
        [viewTemp removeFromSuperview];
        [_viewContainer addSubview:viewTemp];
        [PYViewAutolayoutCenter persistConstraint:viewTemp size:CGSizeMake(self.size.w, self.size.d)];
        [PYViewAutolayoutCenter persistConstraint:viewTemp centerPointer:CGPointMake(0, 0)];
        CATransform3D transTemp = CATransform3DTranslate(trans, 0, -self.size.h/2, 0);
        transTemp = CATransform3DRotate(transTemp, M_PI_2 , 1 , 0 , 0);
        viewTemp.layer.transform = transTemp;
    }
    if(_viewDown){
        UIView * viewTemp = _viewDown;
        [viewTemp removeFromSuperview];
        [_viewContainer addSubview:viewTemp];
        [PYViewAutolayoutCenter persistConstraint:viewTemp size:CGSizeMake(self.size.w, self.size.d)];
        [PYViewAutolayoutCenter persistConstraint:viewTemp centerPointer:CGPointMake(0, 0)];
        CATransform3D transTemp = CATransform3DTranslate(trans, 0, self.size.h/2, 0);
        transTemp = CATransform3DRotate(transTemp, -M_PI_2 , -1 , 0 , 0);
        viewTemp.layer.transform = transTemp;
    }
    
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [_viewContainer addGestureRecognizer:pan];
    trans = CATransform3DIdentity;
    trans = CATransform3DTranslate(trans, 0, 0, -self.size.d/2);
    _viewContainer.layer.sublayerTransform = trans;
}
-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    pointAdd.x += pointTB.x;
    pointAdd.y += pointTB.y;
    if(pointAdd.x > 360){
        pointAdd.x = ((NSInteger)pointAdd.x) % 360;
    }
    if(pointAdd.x < 0){
        pointAdd.x = (((NSInteger)pointAdd.x) % -360) + 360;
    }
    if(pointAdd.y > 360){
        pointAdd.y = ((NSInteger)pointAdd.y) % 360;
    }
    if(pointAdd.y < 0){
        pointAdd.y = (((NSInteger)pointAdd.y) % - 360) + 360;
    }
}

-(void) handlePan:(UIPanGestureRecognizer *) sender{
    CGPoint p = [sender translationInView:_viewContainer];
    pointTB = p;
    p.x += pointAdd.x;
    p.y += pointAdd.y;
    CGFloat dx = p.x;
    CGFloat dy = p.y;
    CGFloat dz = 0;
    [PY3DParams checkWithDegreex:&dx degreey:&dy degreez:&dz];
    [self angleWithDegreex:dx degreey:dy degreez:dz];
}


@end
