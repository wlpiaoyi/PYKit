//
//  PYDisplayImageView.m
//  PYNetwork
//
//  Created by wlpiaoyi on 2017/4/18.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import "PYDisplayImageView.h"

@interface PYDisplayImageView()
PYPNSNN PYAsyImageView * imageView;

PYPNA bool isTouchMove;
PYPNA NSUInteger countMusulTouch;
PYPNA CGFloat suffiTouchValue;
PYPNA NSTimeInterval touchBeginTime;
PYPNA NSTimeInterval touchEndTime;
PYPNA CGPoint preTouchPoint;
PYPNA CGRect preImageViewRect;

PYPNA CGRect imgFrame;
PYSOULDLAYOUTP
@end

@implementation PYDisplayImageView
PYINITPARAMS
-(void) initParams{
    self.imageView = [PYAsyImageView new];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.touchEndTime = self.touchBeginTime = 0;
    [self addSubview:self.imageView];
    self.multipleTouchEnabled = true;
}
-(void) setImgUrl:(NSString *)imgUrl{
    _imgUrl = imgUrl;
    self.imageView.imgUrl = imgUrl;
}
-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    self.isTouchMove = false;
    self.suffiTouchValue = 0;
    UITouch *touch = touches.anyObject;
    self.preTouchPoint = [touch locationInView: self];
    self.touchBeginTime = [NSDate timeIntervalSinceReferenceDate];
    self.countMusulTouch = 0;
    self.preImageViewRect = self.imageView.frame;
}

-(void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    
    if(self.isTouchMove == false){
        UITouch *touch = touches.anyObject;
        CGPoint point = [touch locationInView: self];
        self.isTouchMove = !CGPointEqualToPoint(point, self.preTouchPoint);
    }
    
    if(self.countMusulTouch < 1 && [touches count] == 1){
        self.countMusulTouch = 1;
    }else if(self.countMusulTouch < 2 && [touches count] == 2){
        self.countMusulTouch = 2;
    }else if([touches count] > 2){
        self.countMusulTouch = [touches count];
    }
    
    if(self.countMusulTouch == 1 && [touches count] == 1){
        if((self.touchBeginTime > 0 && [NSDate timeIntervalSinceReferenceDate] - self.touchBeginTime < 0.1f)) {
            return;
        }else{
            self.touchBeginTime = 0;
        }
        UITouch *touch = touches.anyObject;
        CGPoint point = [touch locationInView: self];
        self.imageView.frameX -= self.preTouchPoint.x - point.x;
        self.imageView.frameY -= self.preTouchPoint.y - point.y;
        self.preTouchPoint = point;
    }else if(self.countMusulTouch == 2 && [touches count] == 2){
        CGFloat suffv = -99999;
        NSArray<UITouch *> *touchas = [touches allObjects];
        CGPoint point1 = [touchas.firstObject locationInView: self];
        CGPoint point2 = [touchas.lastObject locationInView: self];
        CGFloat suffx = ABS(point1.x - point2.x), suffy = ABS(point1.y - point2.y);
        if(ABS(suffx) > ABS(suffy)){
            suffv = suffx;
        }else{
            suffv = suffy;
        }
        if(self.suffiTouchValue != 0 ){
            CGRect r = self.imageView.frame;
            r.size.width = self.preImageViewRect.size.width +  suffv - self.suffiTouchValue;
            r.size.height = r.size.width * self.frameHeight/self.frameWidth;
            r.origin.x = (self.preImageViewRect.size.width - self.imageView.frameWidth)/2.0f;
            r.origin.y =  (self.frameHeight * (self.preImageViewRect.size.width / self.frameWidth) - self.imageView.frameHeight)/2.0f;
            r.origin.x += self.preImageViewRect.origin.x;
            r.origin.y += self.preImageViewRect.origin.y;
            self.imageView.frame = r;
        }else{
            self.suffiTouchValue = suffv;
        }
    }
}

-(void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    NSTimeInterval touchEndTime = [NSDate timeIntervalSinceReferenceDate];
    if(self.isTouchMove){
        @unsafeify(self);
        [UIView animateWithDuration:0.2 animations:^{
            @strongify(self);
            CGRect imgFrame = self.imgFrame;
            if(imgFrame.size.width < self.frameWidth && imgFrame.size.height < self.frameWidth){
                self.imageView.frame = self.bounds;
                imgFrame = self.imgFrame;
            }else{
                CGRect r = self.imgFrame;
                CGFloat bv = 3;
                if(r.size.width/r.size.height > self.imageView.frameWidth/self.imageView.frameHeight){
                    if(r.size.width / bv > self.frameWidth){
                        CGFloat w = r.size.width;
                        CGFloat h = r.size.height;
                        r.size.width = self.frameWidth * bv;
                        r.size.height = r.size.height * r.size.width / w;
                        r.origin.x += (w - r.size.width)/2;
                        r.origin.y += (h - r.size.height)/2;
                    }else{
                        if(r.origin.x > 0){
                            r.origin.x = 0;
                        }else if(r.origin.x < self.frameWidth - r.size.width){
                            r.origin.x = self.frameWidth - r.size.width;
                        }
                        if(r.size.height < self.frameHeight){
                            r.origin.y = (self.frameHeight - r.size.height)/2;
                        }else if(r.origin.y > 0){
                            r.origin.y = 0;
                        }else if(r.origin.y < self.frameHeight - r.size.height){
                            r.origin.y = self.frameHeight - r.size.height;
                        }
                    }
                }else{
                    if(r.size.height / bv > self.frameHeight){
                        CGFloat w = r.size.width;
                        CGFloat h = r.size.height;
                        r.size.height = self.frameHeight * bv;
                        r.size.width = r.size.width * r.size.height / h;
                        r.origin.x += (w - r.size.width)/2;
                        r.origin.y += (h - r.size.height)/2;
                    }else{
                        if(r.origin.y > 0){
                            r.origin.y = 0;
                        }else if(r.origin.y < self.frameHeight - r.size.height){
                            r.origin.y = self.frameHeight - r.size.height;
                        }
                        if(r.size.width < self.frameWidth){
                            r.origin.x = (self.frameWidth - r.size.width)/2;
                        }else if(r.origin.x > 0){
                            r.origin.x = 0;
                        }else if(r.origin.x < self.frameWidth - r.size.width){
                            r.origin.x = self.frameWidth - r.size.width;
                        }
                    }
                }
                self.imgFrame = r;
            }
        }];
    }else{
        if(self.touchEndTime > 0 && touchEndTime- self.touchEndTime < 0.4f && touchEndTime-self.touchBeginTime<0.2f){
            @unsafeify(self);
            [UIView animateWithDuration:0.2f animations:^{
                @strongify(self);
                [self showDefualt];
            }];
        }
    }
    self.touchEndTime = touchEndTime;
}
-(void) showDefualt{
    CGRect imgFrame = self.imgFrame;
    self.imageView.frame = self.bounds;
    imgFrame = self.imgFrame;
    self.imgFrame = imgFrame;
}
-(CGRect) imgFrame{
    if(self.imageView.image == nil) return CGRectZero;
    CGSize s = self.imageView.image.size;
    if(s.width/s.height > self.imageView.frameWidth/self.imageView.frameHeight){
        CGFloat w = s.width;
        s.width = self.imageView.frameWidth;
        s.height = s.height * self.imageView.frameWidth/w;
    }else{
        CGFloat h = s.height;
        s.height = self.imageView.frameHeight;
        s.width = s.width * self.imageView.frameHeight/h;
    }
    CGPoint p = CGPointMake((self.imageView.frameWidth - s.width)/2.0f, (self.imageView.frameHeight - s.height)/2.0f);
    p.x += self.imageView.frameX;
    p.y += self.imageView.frameY;
    return CGRectMake(p.x, p.y, s.width, s.height);
}
-(void) setImgFrame:(CGRect)imgFrame{
    CGPoint pv = imgFrame.origin;
    if(imgFrame.size.width/imgFrame.size.height > self.imageView.frameWidth/self.imageView.frameHeight){
        CGFloat w = self.imageView.frameWidth;
        self.imageView.frameWidth = imgFrame.size.width;
        self.imageView.frameHeight = self.imageView.frameHeight * imgFrame.size.width / w;
        pv.y -= (self.imageView.frameHeight - imgFrame.size.height)/2;
    }else{
        CGFloat h = self.imageView.frameHeight;
        self.imageView.frameHeight = imgFrame.size.height;
        self.imageView.frameWidth = self.imageView.frameWidth * imgFrame.size.height / h;
        pv.x -= (self.imageView.frameWidth - imgFrame.size.width)/2;
    }
    self.imageView.frameOrigin = pv;
}
PYSOULDLAYOUTM
-(void) layoutSubviews{
    [super layoutSubviews];
    if(PYSOULDLAYOUTE){
        [self showDefualt];
    }
}

@end
