//
//  PYAsyGifView.m
//  PYKit
//
//  Created by wlpiaoyi on 2021/1/13.
//  Copyright © 2021 wlpiaoyi. All rights reserved.
//

#import "PYAsyGifView.h"
#import "PYAsyImageView.h"
#import <ImageIO/ImageIO.h>
#import "PYNetDownload.h"


NSMutableDictionary * PY_ASYGIF_DICT_DOWNLOADS;
CFStringRef PY_ASYGIF_PERCENT_FIELD = CFSTR(":/?#[]@!$&’()*+,;=");



@interface PYAsyGifView()

kPNSNN PYNetDownload * download;
kPNSNN NSLock * lock;
kPNSNA NSString * cachesPath;
kPNSNA NSString * cacheTag;

@end

@implementation PYAsyGifView{
    //gif的字典属性，定义了gif的一些特殊内容，这里虽然设置了，但是没啥特殊设置，一般情况下可以设置为NULL
    NSDictionary * gifProperties;
    size_t index;
    size_t count;
    CGImageSourceRef gifRef;
    NSTimer *timer;
    NSString * _imageUrl;
    UIImageView * _placeHolderImage;
    UIImage * _loadingImage;
    UIView * _gifCtxView;
}

+(void) initialize{
   static dispatch_once_t onceToken; dispatch_once(&onceToken,^{
        [PYUtile class];
        PY_ASYGIF_DICT_DOWNLOADS = @{}.mutableCopy;
        [PYAsyImageView checkCachesPath];
    });
}

kINITPARAMSForType(PYAsyGifView){
        self.lock = [NSLock new];
        self.interval = 0.05;
        _placeHolderImage = [UIImageView new];
        _placeHolderImage.backgroundColor = [UIColor clearColor];
        _placeHolderImage.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_placeHolderImage];
        [_placeHolderImage py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
            make.top.left.bottom.right.py_constant(0);
        }];
        UIView * view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        [self addSubview:view];
        [view py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
            make.top.left.bottom.right.py_constant(0);
        }];
        _gifCtxView = view;
        [self setLoadingImage:_loadingImage];
}


-(PYNetDownload *) download{
    if(_download) return _download;
    if(![NSString isEnabled:_cacheTag]) return nil;
    PYNetDownload * dnw = [PY_ASYGIF_DICT_DOWNLOADS objectForKey:_cacheTag];
    NSString * cacheTag = _cacheTag;
    if(_download.state != PYNetworkStateResume){
    }
    if(dnw == nil){
        dnw = [PYNetDownload new];
        dnw.url = _imageUrl;
        [dnw setBlockReceiveChallenge:^BOOL(id  _Nullable data, PYNetwork * _Nonnull target) {
            return true;
        }];
        [dnw setBlockComplete:^(id  _Nullable data, NSURLResponse * _Nullable response, PYNetwork * _Nonnull target) {
            NSMutableDictionary * dict = @{}.mutableCopy;
            if(data) dict[@0] = data;
            if(response) dict[@1] = response;
            if(target) dict[@2] = target;
            kNOTIF_POST(cacheTag, dict);
        }];
        void * pointer = (__bridge void *)(self);
        [dnw setBlockCancel:^(id  _Nullable data, NSURLResponse * _Nullable response, PYNetDownload * _Nonnull target) {
            [PYAsyGifView removeSelfFromDownload:cacheTag download:_download pointer:pointer];
        }];
    }
    _download = dnw;
    [self addSelfFromDownload];
    return _download;
}

-(void) addSelfFromDownload{
    if(![NSString isEnabled:_cacheTag]) return;
    if(_download == nil) return;
    NSMutableArray * objs = _download.userInfo;
    if(objs == nil){
        objs = @[].mutableCopy;
        _download.userInfo = objs;
    }
    PY_ASYGIF_DICT_DOWNLOADS[_cacheTag] = _download;
    void * pointer = (__bridge void *)(self);
    NSInteger i = pointer;
    if([objs containsObject:@(i)]) return;
    [objs addObject:@(i)];
}


-(void) setLoadingImage:(nullable UIImage *) image{
    _loadingImage = image;
    _placeHolderImage.image = image;
    _placeHolderImage.hidden = image ? NO : YES;
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

-(void) notifyImageDownloadComplete:(NSNotification *) notify{
    id object = notify.object;
    id  _Nullable data = object[@0];
    NSURLResponse * response = object[@1];
    PYNetwork * target = object[@2];
    void * pointer = (__bridge void *)(self);
    [PYAsyGifView removeSelfFromDownload:self.cacheTag download:_download pointer:pointer];
    [self imageDownloadComplete:target data:data response:response];
}

-(void) imageDownloadComplete:(PYNetwork * _Nonnull) target data:(id  _Nullable) data response:(NSURLResponse * _Nullable) response{
    [self.lock lock];
    @try{
        self.cachesPath = nil;
        if(data  != nil && [data isKindOfClass:[NSError class]]){
            NSLog(@"[erro code:%ld] [erro domain;%@] [erro description:%@]", (long)((NSError*)data).code, ((NSError*)data).domain, ((NSError*)data).description);
            return;
        }
        if(data == nil || ![data isKindOfClass:[NSString class]]){
            return;
        }
        BOOL isDirectory = false;
        BOOL abc = NO;
        if(![[NSFileManager defaultManager] fileExistsAtPath:data isDirectory:&isDirectory] || isDirectory){
            abc = YES;
        }
        NSString * imagePath = [PYAsyImageView getCachePathWithUrl:_imageUrl];
        if(![NSString isEnabled:imagePath]){
            NSLog(@"create image path erro!!");
            return;
        }
        if(!abc){
            NSError * erro;
            if([[NSFileManager defaultManager] fileExistsAtPath:imagePath isDirectory:nil]) [[NSFileManager defaultManager] removeItemAtPath:imagePath error:&erro];
            if(erro) NSLog(@"[erro code:%ld] [erro domain;%@] [erro description:%@] imagePath:%@", (long)((NSError*)erro).code, ((NSError*)data).domain, ((NSError*)erro).description, imagePath);
            
            erro = nil;
            [[NSFileManager defaultManager] moveItemAtPath:data toPath:imagePath error:&erro];
            if(erro) NSLog(@"%@ image errocode:%ld, errodomain:%@",NSStringFromClass([PYAsyImageView class]), (long)[erro code], [erro domain]);
        }
        self.cachesPath = imagePath;
        [self setLocatonPath:self.cachesPath];
        [self start];
    }@finally{
        [self.lock unlock];
    }
}

-(void) setImgUrl:(NSString *)url{
    _imageUrl = url;
    NSString * cachesPath = [PYAsyImageView getCachePathWithUrl:url];
    self.cachesPath = cachesPath;
    self.cacheTag = [PYUtile MD5ForLower32Bate:url];
//    PYNetDownload * download = PY_ASYGIF_VIEW_DOWNLOADS[cachesPath];
//    if(download)
    if([[NSFileManager defaultManager] fileExistsAtPath:cachesPath]){
        [self setLocatonPath:cachesPath];
        [self start];
    }else{
        if(_download){
            [_download setBlockCancel:nil];
            [_download setBlockReceiveChallenge:nil];
            [_download setBlockSendProgress:nil];
            [_download setBlockDownloadProgress:nil];
        }
        _download = nil;
        
        kNOTIF_REMV(self, self.cacheTag);
        kNOTIF_ADD(self, self.cacheTag, notifyImageDownloadComplete:);
        if(self.download.state == PYNetworkStateUnkwon || self.download.state == PYNetworkStateCancel || self.download.state == PYNetworkStateInterrupt){
            [self.download resume];
        }
    }
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
    _gifCtxView.layer.contents = (id)CFBridgingRelease(currentRef);
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


-(void) dealloc{
    [self.lock lock];
    kNOTIF_REMV(self, self.cacheTag);
    [self.class removeSelfFromDownload:self.cacheTag download:_download pointer:(__bridge void *)(self)];
    [_download setBlockCancel:nil];
    [_download setBlockReceiveChallenge:nil];
    [_download setBlockSendProgress:nil];
    [_download setBlockDownloadProgress:nil];
    [_download stop];
    [_lock unlock];
}


+(void) removeSelfFromDownload:(nonnull NSString *) cacheTag download:(PYNetDownload *) download pointer:(void *) pointer{
    if(![NSString isEnabled:cacheTag]) return;
    if(download == nil) return;
    NSMutableArray * objs = download.userInfo;
    NSInteger i = pointer;
    [objs removeObject:@(i)];
    if(!objs || objs.count == 0){
        [PY_ASYGIF_DICT_DOWNLOADS removeObjectForKey:cacheTag];
    }
}

@end
