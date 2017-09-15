//
//  PYDisplayImageTools.m
//  PYKit
//
//  Created by wlpiaoyi on 2017/9/5.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import "PYDisplayImageTools.h"

CGPoint PY_CGPointSubtract(CGPoint p1, CGPoint p2){
    return CGPointMake(p1.x - p2.x, p1.y - p2.y);
}
CGPoint PY_CGPointAdd(CGPoint p1, CGPoint p2){
    return CGPointMake(p1.x + p2.x, p1.y + p2.y);
}

@implementation PYDisplayImageTools

+(void) initialize{
    [self pyTest];
}
/**
 获取中间点
 */
+(CGPoint) getCenterPointWithTouchFirst:(nonnull UITouch *) touchFist
                            touchSecond:(nonnull UITouch *) touchSecond
                            tagView:(nonnull UIView *) tagView{
    
    CGPoint p1 = CGPointZero,p2 = CGPointZero,p3 = CGPointZero;
    p1 = [touchFist locationInView:tagView];
    p2 = [touchSecond locationInView:tagView];
    p3 = PY_CGPointSubtract(p1, p2);
    
    return PY_CGPointAdd(CGPointMake(p3.x/2, p3.y/2), p2);
}
/**
 获取图片在试图中的最适大小
 */
+(CGRect) getFitImgRectWithDisplaySize:(CGSize) displaySize imgSize:(CGSize) imgSize{
    CGRect fitrect = CGRectZero;
    if(imgSize.width <= 0 || imgSize.height <= 0){
        fitrect.size = CGSizeZero;
        fitrect.origin = CGPointMake(displaySize.width/2, displaySize.height/2);
    }else if(imgSize.width/imgSize.height > displaySize.width/displaySize.height){
        fitrect.size.width = displaySize.width;
        fitrect.size.height = displaySize.width * imgSize.height/imgSize.width;
        fitrect.origin.x = 0;
        fitrect.origin.y = (displaySize.height - fitrect.size.height)/2;
    }else{
        fitrect.size.height = displaySize.height;
        fitrect.size.width = displaySize.height * imgSize.width/imgSize.height;
        fitrect.origin.x = (displaySize.width - fitrect.size.width)/2;
        fitrect.origin.y = 0;
    }
    return fitrect;
}
/**
 检查位置和大小偏移量预防超出指定范围
 */
+(void) checkDisplayRect:(nonnull CGRect *) displayRectp fitRect:(CGRect) fitRect maxMultiple:(NSUInteger) maxMultiple{
    
    CGFloat dWidth = MIN(fitRect.size.width * (maxMultiple + 1), (*displayRectp).size.width);
    CGFloat dHeight = MIN(fitRect.size.height * (maxMultiple + 1), (*displayRectp).size.height);
    dWidth = MAX(fitRect.size.width, dWidth);
    dHeight = MAX(fitRect.size.height, dHeight);
    
    if(dWidth != (*displayRectp).size.width){
        if(dHeight == (*displayRectp).size.height){
            dWidth = dHeight * fitRect.size.width / fitRect.size.height;
        }
    }else if(dHeight != (*displayRectp).size.height){
        if(dWidth == (*displayRectp).size.width){
            dHeight = dWidth * fitRect.size.height / fitRect.size.width;
        }
    }
    CGPoint nailPoint = CGPointMake(fitRect.size.width/2, fitRect.size.height/2);
    CGPoint rNailPoint = [PYDisplayImageTools getRatioPointWithTagPoint:nailPoint displayRect:(*displayRectp)];
    (*displayRectp).size.width = dWidth;
    (*displayRectp).size.height = dHeight;
    (*displayRectp).origin.x = nailPoint.x - rNailPoint.x * (*displayRectp).size.width;
    (*displayRectp).origin.y = nailPoint.y - rNailPoint.y* (*displayRectp).size.height;
    
    CGFloat offx = fitRect.size.width + ABS(fitRect.origin.x) *2;
    CGFloat offy = fitRect.size.height + ABS(fitRect.origin.y) *2;
    CGFloat minOriginX = 0.0, maxOriginX = 0.0, minOriginY = 0.0, maxOriginY = 0.0;
    if((*displayRectp).size.width < offx){
        minOriginX = (offx - (*displayRectp).size.width)/2;
        maxOriginX = minOriginX;
    }else{
        minOriginX = fitRect.size.width + fitRect.origin.x * 2 - dWidth;
        maxOriginX = 0;
    }
    if((*displayRectp).size.height < offy){
        minOriginY = (offy - (*displayRectp).size.height)/2;
        maxOriginY = minOriginY;
    }else{
        minOriginY = fitRect.size.height + fitRect.origin.y * 2 - dHeight;
        maxOriginY = 0;
    }
    
    (*displayRectp).origin.x = MIN(maxOriginX , (*displayRectp).origin.x);
    (*displayRectp).origin.x = MAX(minOriginX , (*displayRectp).origin.x);
    (*displayRectp).origin.y = MIN(maxOriginY , (*displayRectp).origin.y);
    (*displayRectp).origin.y = MAX(minOriginY , (*displayRectp).origin.y);
    
}
/**
 根据图片的最适位置，定点，移动点的变化计算出下一个展示的 位置和大小
 */
+(void) analyzeDisplayRect:(nonnull CGRect *) displayRectp fitRect:(CGRect) fitRect nailOrigin:(CGPoint) nailOrigin preTouchPoint:(CGPoint) preTouchPoint curTouchPoint:(CGPoint) curTouchPoint;{
    if((*displayRectp).size.width < fitRect.size.width/3 || (*displayRectp).size.height < fitRect.size.height/3) return;
    //==>
    //ratioNailOrigin 定点相对 displaySize 的比例
    //ratioTouchPoint 触控点相对 displaySize 的比例
    CGPoint ratioNailOrigin = [PYDisplayImageTools getRatioPointWithTagPoint:nailOrigin displayRect:(*displayRectp)];
    CGPoint ratioTouchPoint = [PYDisplayImageTools getRatioPointWithTagPoint:preTouchPoint displayRect:(*displayRectp)];
    ///<==
    
    //curtpc 矫正后的触控位置
    [self checkCurTouchPoint:&curTouchPoint nailOrigin:nailOrigin preTouchPoint:preTouchPoint];
    
    CGRect nextDispalyRect = [self getNextDisplayRectWithRatioNailOrigin:ratioNailOrigin ratioTouchPoint:ratioTouchPoint nailOrigin:nailOrigin touchPoint:curTouchPoint fitSize:fitRect.size];
    if(!CGRectEqualToRect(nextDispalyRect, CGRectZero)){
        (*displayRectp) = nextDispalyRect;
    }
    
}
+(CGRect) getNextDisplayRectWithRatioNailOrigin:(CGPoint) ratioNailOrigin
                                     ratioTouchPoint:(CGPoint) ratioTouchPoint
                                     nailOrigin:(CGPoint) nailOrigin
                                     touchPoint:(CGPoint) touchPoint
                                     fitSize:(CGSize) fitSize{
    CGRect nextDisplayRect = CGRectZero;
    if((ratioNailOrigin.x - ratioTouchPoint.x) != 0 && (ratioNailOrigin.y - ratioTouchPoint.y) != 0){
        nextDisplayRect.size.width = (nailOrigin.x - touchPoint.x) / (ratioNailOrigin.x - ratioTouchPoint.x);
        nextDisplayRect.origin.x = nailOrigin.x - ratioNailOrigin.x * nextDisplayRect.size.width;
        nextDisplayRect.size.height = (nailOrigin.y - touchPoint.y) / (ratioNailOrigin.y - ratioTouchPoint.y);
        nextDisplayRect.origin.y = nailOrigin.y - ratioNailOrigin.y * nextDisplayRect.size.height;
    }
    return nextDisplayRect;
}

+(CGPoint) getTagPointWithRatioPoint:(CGPoint) ratioPoint displayRect:(CGRect) displayRect{
    CGPoint tagPoint = CGPointZero;
    tagPoint.x = ratioPoint.x * displayRect.size.width + displayRect.origin.x;
    tagPoint.y = ratioPoint.y * displayRect.size.height + displayRect.origin.y;
    return tagPoint;
}

+(CGPoint) getRatioPointWithTagPoint:(CGPoint) tagPoint displayRect:(CGRect) displayRect{
    CGPoint ratioPoint = CGPointZero;
    ratioPoint.x = (tagPoint.x - displayRect.origin.x) / displayRect.size.width;
    ratioPoint.y = (tagPoint.y - displayRect.origin.y) / displayRect.size.height;
    return ratioPoint;
}

+(void) checkCurTouchPoint:(nonnull CGPoint *) curTouchPointp nailOrigin:(CGPoint) nailOrigin preTouchPoint:(CGPoint) preTouchPoint{
    
    if(CGPointEqualToPoint((*curTouchPointp), preTouchPoint)) return;
    
    CGFloat preOffx =  preTouchPoint.x - nailOrigin.x;
    CGFloat preOffy =  preTouchPoint.y - nailOrigin.y;
    CGFloat curOffx =  (*curTouchPointp).x - nailOrigin.x;
    CGFloat curOffy =  (*curTouchPointp).y - nailOrigin.y;
    if(ABS(curOffx - preOffx) >= ABS(curOffy - preOffy)){
        CGFloat pv = (curOffx - preOffx) / preOffx;
        (*curTouchPointp).y = preTouchPoint.y + preOffy * pv;
    }else{
        CGFloat pv = (curOffy - preOffy) / preOffy;
        (*curTouchPointp).x = preTouchPoint.x + preOffx * pv;
    }
    
}

+(void) pyTest{
    
    CGRect fitRect = CGRectMake(0, 1, 7, 4);
    CGRect displayRect = CGRectMake(-3, -2, 11, 9);
    CGPoint tagPoint = CGPointMake(3.5, 2);
    CGPoint natioPoint = CGPointMake(3, 3);
    CGPoint ratioTagPoint = [self getRatioPointWithTagPoint:tagPoint displayRect:displayRect];
    CGPoint ratioNatioPoint = [self getRatioPointWithTagPoint:natioPoint displayRect:displayRect];
    CGPoint nextTagPoint = CGPointMake(4, 2);
    [self checkCurTouchPoint:&nextTagPoint nailOrigin:natioPoint preTouchPoint:tagPoint];
    CGRect nextDispalyRect = [self getNextDisplayRectWithRatioNailOrigin:ratioNatioPoint ratioTouchPoint:ratioTagPoint nailOrigin:natioPoint touchPoint:nextTagPoint fitSize:fitRect.size];
    ratioTagPoint = [self getRatioPointWithTagPoint:nextTagPoint displayRect:nextDispalyRect];
    ratioNatioPoint = [self getRatioPointWithTagPoint:natioPoint displayRect:nextDispalyRect];
    

}

@end
