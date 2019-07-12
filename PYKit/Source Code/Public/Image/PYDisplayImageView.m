//
//  PYDisplayImageView.m
//  PYKit
//
//  Created by wlpiaoyi on 2017/9/4.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import "PYDisplayImageView.h"
#import "PYDisplayImageTools.h"

@interface PYDisplayImageView(){
@private
    CGSize _imgSize;
    CGRect _imgFitRect;
    CGPoint _preTouchPoint;
    CGPoint _movePoint;
    NSUInteger _touchIndex;
}
kPNA PYDisplayImageTouchEnum touchState;
kPNSNA UITouch * touchFirst;
kPNSNA UITouch * touchSecond;
kPNSNA UITouch * preTouch;

kPNSNN UIView * viewImgContext;
kSOULDLAYOUTPForType(PYDisplayImageView)
@end

@implementation PYDisplayImageView

kINITPARAMS{
    self.maxMultiple = 6;
    _movePoint = CGPointZero;
    _preTouchPoint = CGPointZero;
    _imgSize = CGSizeZero;
    _imgFitRect = CGRectZero;
    _touchIndex = 0;
    [self initTouchData];
    _viewImgContext = [UIView new];
    _viewImgContext.backgroundColor = [UIColor clearColor];
    [self addSubview:_viewImgContext];
    [PYViewAutolayoutCenter persistConstraint:_viewImgContext relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:PYEdgeInsetsItemNull()];
    
    _imageView = [PYAsyImageView new];
    _imageView.contentMode = UIViewContentModeScaleToFill;
    _imageView.frame = CGRectZero;
    ((PYAsyImageView *)_imageView).hasPercentage = YES;
    [self.viewImgContext addSubview:_imageView];
    
    self.multipleTouchEnabled = YES;
    _viewImgContext.multipleTouchEnabled = YES;
    kAssign(self);
    [((PYAsyImageView *)self.imageView) setBlockDisplay:^(bool isSuccess, bool isCahes, PYAsyImageView * _Nonnull imageView) {
        kStrong(self);
        [self synchronizedImageSize];
    }];
}

-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    _touchIndex += touches.count;
    _movePoint = [touches.anyObject locationInView: self];
    if(_touchState != PYDisplayImageTouchUnkown){
        _touchState = PYDisplayImageTouchChange;
    }
}

-(void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    //感觉手机触控反应比较迟钝，导致touchesCount不能及时响应，这里由此产生的point变化异常的bug处理一下
    if (touches.count != _touchIndex) {
        _preTouch = nil;
        _preTouchPoint = CGPointZero;
        return;
    }
    //==>
    bool hasChange = false;
    //判断是移动还是缩放移动
    if(_touchState != PYDisplayImageTouchOne && _touchIndex == 1 ){
        hasChange = true;
        _touchState = PYDisplayImageTouchOne;
        self.touchFirst = touches.anyObject;
    }else if(_touchState != PYDisplayImageTouchMultiple && _touchIndex >= 2){
        hasChange = true;
        _touchState = PYDisplayImageTouchMultiple;
        if(self.touchFirst == nil || ![touches containsObject:self.touchFirst]){
            if(self.touchSecond && [touches containsObject:self.touchSecond]){
                self.touchFirst = self.touchSecond;
                self.touchSecond = nil;
            }else{
                self.touchFirst = touches.anyObject;
            }
        }
        if(!self.touchSecond || ![touches containsObject:self.touchSecond]){
            self.touchSecond = nil;
            for (UITouch * touch in touches) {
                if(touch != self.touchFirst){
                    self.touchSecond = touch;
                    break;
                }
            }
        }
    }
    ///<==

    switch (_touchState) {
            //移动图片处理
        case PYDisplayImageTouchOne:{
            CGPoint movePoint = [self.touchFirst locationInView: self];
            if(hasChange){
                _movePoint = movePoint;
            }else{
                self.movePoint = movePoint;
            }
        }
            break;
        
            //缩放移动图片处理
        case PYDisplayImageTouchMultiple:{
            //==>
            //计算并设置movePoint
            CGPoint movePoint;
            if(self.touchFirst && !self.touchSecond){
                movePoint = [self.touchFirst locationInView: self];
            }else if(self.touchFirst && self.touchSecond){
                movePoint = [PYDisplayImageTools getCenterPointWithTouchFirst:self.touchFirst touchSecond:self.touchSecond tagView:self];
            }else{
                movePoint = CGPointZero;
            }
            //如果没有movePoint等于 0 就不设置
            if(CGPointEqualToPoint(movePoint, CGPointZero)){
                return;
            }
            CGPoint offPoint = PY_CGPointSubtract(movePoint, _movePoint);
            //如果触控手指没有变化将设置否则仅赋值
            if(hasChange){
                _movePoint = movePoint;
            }else{
                self.movePoint = movePoint;
            }
            ///<==
            if(self.touchFirst && self.touchSecond){
                UITouch * touch;
                CGPoint point;
                [self.class getTouchPoint:&point touch:&touch touchFirst:self.touchFirst touchSecond:self.touchSecond tagView:self];
                if(touch && _preTouch && !CGPointEqualToPoint(_preTouchPoint, CGPointZero)){
                    CGRect displayRect = self.imageView.frame;
                    CGPoint touchPoint = PY_CGPointAdd(offPoint, _preTouchPoint);
                    [PYDisplayImageTools analyzeDisplayRect:&displayRect fitRect:_imgFitRect nailOrigin:_movePoint preTouchPoint:touchPoint curTouchPoint:point];
                    self.imageView.frame = displayRect;
                }
                _preTouch = touch;
                _preTouchPoint = point;
            }
        }
            break;
        default:
            break;
    }
    
}

+(void) getTouchPoint:(nonnull CGPoint *) touchPointp
                touch:(UITouch * _Nullable __autoreleasing * _Nullable) touchp
           touchFirst:(nonnull UITouch *) touchFist
          touchSecond:(nonnull UITouch *) touchSecond
              tagView:(nonnull UIView *) tagView{
    
    CGPoint p1 = CGPointZero,p2 = CGPointZero,p3 = CGPointZero;
    p1 = [touchFist locationInView:tagView];
    p2 = [touchSecond locationInView:tagView];
    p3 = [PYDisplayImageTools getCenterPointWithTouchFirst:touchFist touchSecond:touchSecond tagView:tagView];
    
    CGPoint op1 = PY_CGPointSubtract(p3, p1);
    CGPoint op2 = PY_CGPointSubtract(p3, p2);
    CGFloat v1 = sqrt(pow(op1.x, 2) + pow(op1.y, 2));
    CGFloat v2 = sqrt(pow(op2.x, 2) + pow(op2.y, 2));
    
    if(ABS(v1) > 5 && v1 >= v2){
        (*touchPointp) = p1;
        (*touchp) = touchFist;
    }else if(ABS(v2) < 5 && v2 >= v1){
        (*touchPointp) = p2;
        (*touchp) = touchSecond;
    }else{
        (*touchPointp) = CGPointZero;
        *(touchp) = nil;
    }
    
}

-(void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    _touchState = PYDisplayImageTouchChange;
    _touchIndex -= touches.count;
    if(_touchIndex > 0) return;
    kAssign(self);
    [UIView animateWithDuration:0.15 animations:^{
        kStrong(self);
        CGRect displayRect = self.imageView.frame;
        [PYDisplayImageTools checkDisplayRect:&displayRect fitRect:self->_imgFitRect maxMultiple:self.maxMultiple];
        self.imageView.frame = displayRect;
    }];
    [self initTouchData];
}
-(void) touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    _touchState = PYDisplayImageTouchChange;
    _touchIndex -= touches.count;
    if(_touchIndex > 0) return;
    kAssign(self);
    [UIView animateWithDuration:0.15 animations:^{
        kStrong(self);
        CGRect displayRect = self.imageView.frame;
        [PYDisplayImageTools checkDisplayRect:&displayRect fitRect:self->_imgFitRect maxMultiple:self.maxMultiple];
        self.imageView.frame = displayRect;
    }];
    [self initTouchData];
}
-(void) initTouchData{
    _touchState = PYDisplayImageTouchUnkown;
    _touchIndex = 0;
    _preTouch = nil;
    _preTouchPoint = CGPointZero;
    _movePoint = CGPointZero;
}

-(void) setMaxMultiple:(NSUInteger)maxMultiple{
    _maxMultiple = MIN(10, MAX(0, maxMultiple));
}
-(void) setMovePoint:(CGPoint)movePoint{
    CGPoint offPoint = PY_CGPointSubtract(movePoint, _movePoint);
    self.imageView.frameOrigin = PY_CGPointAdd(self.imageView.frameOrigin, offPoint);
    _movePoint = movePoint;
}

-(void) synchronizedImageSize{
    @synchronized (_imageView) {
        if(!_imageView || !_imageView.image){
            _imgSize = CGSizeZero;
            _imageView.frame = self.bounds;
        }else{
            _imgSize = self.imageView.image.size;
            _imgFitRect = [PYDisplayImageTools getFitImgRectWithDisplaySize:self.frameSize imgSize:_imgSize];
            _imageView.frame = _imgFitRect;
        }
    }
}
kSOULDLAYOUTMSTARTForType(PYDisplayImageView)
[self synchronizedImageSize];
kSOULDLAYOUTMEND
-(void) dealloc{
    NSLog(@"");
}
@end

