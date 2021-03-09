//
//  PYAsyGifView.m
//  PYKit
//
//  Created by wlpiaoyi on 2021/1/13.
//  Copyright © 2021 wlpiaoyi. All rights reserved.
//

#import "PYAsyGifView.h"
#import <ImageIO/ImageIO.h>

@implementation PYAsyGifView{
    //gif的字典属性，定义了gif的一些特殊内容，这里虽然设置了，但是没啥特殊设置，一般情况下可以设置为NULL
    NSDictionary * gifProperties;
    size_t index;
    size_t count;
    CGImageSourceRef gifRef;
    NSTimer *timer;

}

-(instancetype) init{
    if(self = [super init]){
        self.interval = 0.05;
    }
    return self;
}

-(void) setLocatonPath:(nonnull NSString *) path{
    //设置gif的属性来获取gif的图片信息
    gifProperties = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:@0 forKey:(NSString *)kCGImagePropertyGIFLoopCount]
                                                forKey:(NSString *)kCGImagePropertyGIFDictionary];
    //这个是拿到图片的信息
    gifRef = CGImageSourceCreateWithURL((CFURLRef)[NSURL fileURLWithPath:path], (CFDictionaryRef)gifProperties);
    //这个拿到的是图片的张数，一张gif其实内部是有好几张图片组合在一起的，如果是普通图片的话，拿到的数就等于1
    count = CGImageSourceGetCount(gifRef);
//    UIImage *image = [UIImage imageWithContentsOfFile:path];
//    self.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    _isAnimating = NO;
}

-(CGImageRef) imageRefWithIndex:(NSInteger) index{
    NSAssert(gifProperties, @"Gif is not load!");
    return CGImageSourceCreateImageAtIndex(gifRef, index % count, (CFDictionaryRef)gifProperties);
}

-(void)start{
    index = 0;
    //开始动画，启动一个定时器，每隔一段时间调用一次方法，切换图片
    if (timer == nil) {
        timer = [NSTimer scheduledTimerWithTimeInterval:self.interval target:self selector:@selector(play) userInfo:nil repeats:YES];
    }
    [timer fire];
    _isAnimating = YES;
}

-(void)play{
    if(index == 0 && self.blockPlayStart){
        self.blockPlayStart();
    }
    index = index % count;
    //方法的内容是根据上面拿到的imageSource来获取gif内部的第几张图片，拿到后在进行layer重新填充
    CGImageRef currentRef = [self imageRefWithIndex:index];
    self.layer.contents = (id)CFBridgingRelease(currentRef);
    index ++;
    if(index >= count && self.blockPlayEnd){
        self.blockPlayEnd();
    }
}

-(void)stop{
    //停止定时器
    _isAnimating = NO;
    [timer invalidate];
    timer = nil;
}

@end
