//
//  PYAsyImageView.m
//  PYNetwork
//
//  Created by wlpiaoyi on 2017/4/10.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import "PYAsyImageView.h"
#import "pyutilea.h"
#import "PYNetDownload.h"

static NSString * PYAsyImageViewDataCaches;

@interface PYAsyImageView()
kPNSNN UIActivityIndicatorView * activityIndicator;
kPNSNN UIView * activityView;
kPNSNN UILabel * activityLabel;
kPNSNN PYNetDownload * dnw;
kPNSNA NSString * cachesUrl;
kPNSNN NSLock * lock;
kPNSNA PYGraphicsThumb * graphicsThumb;
kPNA int64_t currentBytes;
kPNA int64_t totalBytes;
kPNSNN UIColor * strokeColor;
kPNSNN UIColor * fillColor;
@end

@implementation PYAsyImageView

+(void) initialize{
   static dispatch_once_t onceToken; dispatch_once(&onceToken,^{
        [PYUtile class];
        [PYAsyImageView checkCachesPath];
    });
}

+(NSString *) parseImageUrlToImagePath:(NSString *) imageUrl{
    if(imageUrl.length < 7) return nil;
    NSRange range = [imageUrl rangeOfString:@"http://"];
    BOOL hasHead = false;
    if(range.length > 0 && range.location == 0){
        imageUrl = [imageUrl stringByReplacingCharactersInRange:range withString:@""];
        hasHead = true;
    }else{
        range = [imageUrl rangeOfString:@"https://"];
        if(range.length > 0 && range.location == 0){
            imageUrl = [imageUrl stringByReplacingCharactersInRange:range withString:@""];
            hasHead = true;
        }
    }
    if(!hasHead) return nil;
    range = [imageUrl rangeOfString:@"/"];
    if(range.length > 0){
        range.length = range.location + 1;
        range.location = 0;
        imageUrl = [imageUrl stringByReplacingCharactersInRange:range withString:@""];
    }
    imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@"/" withString:@""];
    imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@"?" withString:@""];
    
    NSMutableString * imagePath = [NSMutableString new];
    [imagePath appendString:PYAsyImageViewDataCaches];
    NSMutableString * imageName = [NSMutableString new];
    [imageName appendString:@"PYDATA["];
    [imageName appendString:imageUrl];
    [imageName appendString:@"]"];
    [imagePath appendFormat:@"/%@",imageName];
    
    return imagePath;
}

kINITPARAMS{
    self.lock = [NSLock new];
    self.dnw = [PYNetDownload new];
    self.strokeColor = [UIColor colorWithRGBHex:0x66884466];
    self.fillColor = [UIColor colorWithRGBHex:0x88888833];
    [self.dnw setBlockReceiveChallenge:^BOOL(id  _Nullable data, PYNetwork * _Nonnull target) {
        return true;
    }];
    __unsafe_unretained typeof(self) uself = self;
    static NSTimeInterval static_pre_time_interval = 0;
    [self.dnw setBlockDownloadProgress:^(PYNetDownload * _Nonnull target, int64_t currentBytes, int64_t totalBytes) {
        [uself.lock lock];
        if(uself.blockProgress){
            uself.blockProgress((double)currentBytes/(double)totalBytes, uself);
        }
        if(uself.hasPercentage){
            if([NSDate timeIntervalSinceReferenceDate] - static_pre_time_interval > 0.2){
                uself.currentBytes = currentBytes;
                uself.totalBytes = totalBytes;
                [uself.graphicsThumb executDisplay:nil];
                if(self.currentBytes < 1024 * 1024)
                    uself.activityLabel.text = kFORMAT(@"%.2fKB", (double)self.currentBytes / (double)1024);
                else
                    uself.activityLabel.text = kFORMAT(@"%.2fMB", (double)self.currentBytes / (double)(1024 * 1024));
                static_pre_time_interval = [NSDate timeIntervalSinceReferenceDate];
            }
        }
        [uself.lock unlock];
    }];
    [self.dnw setBlockComplete:^(id  _Nullable data, NSURLResponse * _Nullable response, PYNetwork * _Nonnull target) {
        [uself.lock lock];
        @try{
            [uself.activityIndicator stopAnimating];
            uself.activityView.hidden = YES;
            uself.cachesUrl = nil;
            if(data  != nil && [data isKindOfClass:[NSError class]]){
                NSLog(@"[erro code:%ld] [erro domain;%@] [erro description:%@]", (long)((NSError*)data).code, ((NSError*)data).domain, ((NSError*)data).description);
                return;
            }
            if(data == nil || ![data isKindOfClass:[NSString class]]){
                return;
            }
            BOOL isDirectory = false;
            if(![[NSFileManager defaultManager] fileExistsAtPath:data isDirectory:&isDirectory] || isDirectory){
                return;
            }
            NSString * imagePath = [PYAsyImageView parseImageUrlToImagePath:uself.imgUrl];
            imagePath = imagePath ? imagePath : uself.imgUrl;
            NSError * erro;
            if([[NSFileManager defaultManager] fileExistsAtPath:imagePath isDirectory:nil]) [[NSFileManager defaultManager] removeItemAtPath:imagePath error:&erro];
            erro = nil;
            [[NSFileManager defaultManager] moveItemAtPath:data toPath:imagePath error:&erro];
            if(erro == nil){
                uself.cachesUrl = imagePath;
                if(uself.blockDisplay){
                    uself.blockDisplay(true,false, uself);
                }
            }else{
                NSLog(@"%@ image errocode:%ld, errodomain:%@",NSStringFromClass([PYAsyImageView class]), (long)[erro code], [erro domain]);
            }
        }@finally{
            [uself.lock unlock];
        }
    }];
    [self.dnw setBlockCancel:^(id  _Nullable data, NSURLResponse * _Nullable response, PYNetDownload * _Nonnull target) {
        [uself.lock lock];
        [uself.activityIndicator stopAnimating];
        uself.activityView.hidden = YES;
        if(uself.blockDisplay){
            uself.blockDisplay(false,false, uself);
        }
        [uself.lock unlock];
    }];
    self.activityView = [UIView new];
    self.activityView.backgroundColor = [UIColor clearColor];
    kAssign(self);
    self.graphicsThumb = [PYGraphicsThumb graphicsThumbWithView:self.activityView block:^(CGContextRef  _Nonnull ctx, id  _Nullable userInfo) {
        kStrong(self);
        if(self.totalBytes > 0 && self.totalBytes >= self.currentBytes){
            CGFloat pValue = (double)self.currentBytes / (double)self.totalBytes;
            [PYGraphicsDraw drawCircleWithContext:ctx pointCenter:CGPointMake(self.activityView.frameWidth/2, self.activityView.frameHeight/2) radius:MIN(self.activityView.frameWidth/2, self.activityView.frameHeight/2)/2 strokeColor:self.strokeColor.CGColor fillColor:[UIColor clearColor].CGColor strokeWidth:MIN(self.activityView.frameWidth/2, self.activityView.frameHeight/2) startDegree:0 endDegree:360 * pValue];
            [PYGraphicsDraw drawCircleWithContext:ctx pointCenter:CGPointMake(self.activityView.frameWidth/2, self.activityView.frameHeight/2) radius:MIN(self.activityView.frameWidth/2, self.activityView.frameHeight/2)/2 strokeColor:self.fillColor.CGColor fillColor:[UIColor clearColor].CGColor strokeWidth:MIN(self.activityView.frameWidth/2, self.activityView.frameHeight/2) startDegree:360 * pValue endDegree:360];
        }
    }];
    [self addSubview:self.activityView];
    [self.activityView setAutotLayotDict:@{@"x":@(0), @"y":@(0), @"w":@(30), @"h":@(30)}];
    self.activityLabel = [UILabel new];
    self.activityLabel.backgroundColor = [UIColor clearColor];
    self.activityLabel.numberOfLines = 2;
    self.activityLabel.font = [UIFont systemFontOfSize:12];
    self.activityLabel.textColor = [UIColor darkGrayColor];
    [self.activityView addSubview: self.activityLabel];
    [self.activityLabel setAutotLayotDict:@{@"x":@(0), @"y":@(20), @"h":@(15)}];
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.activityView addSubview:self.activityIndicator];
    [PYViewAutolayoutCenter persistConstraint:self.activityIndicator size:CGSizeMake(30, 30)];
    [PYViewAutolayoutCenter persistConstraint:self.activityIndicator centerPointer:CGPointMake(0, 0)];
}
-(void) setCachesUrl:(NSString *)cachesUrl{
    _cachesUrl = cachesUrl;
    if(_cachesUrl != nil){
        self.image = [[UIImage alloc] initWithContentsOfFile:self.cachesUrl];
    }else{
        self.image = nil;
    }
}
-(void) setImgUrl:(NSString *)imgUrl{
    _imgUrl = imgUrl;
    [self.dnw interrupt];
    NSString * imagePath = [PYAsyImageView parseImageUrlToImagePath:self.imgUrl];
    if(imagePath == nil){
        kPrintExceptionln("setImageUrl:%s","imagepath is null or is not 'http' or 'https'");
        return;
    }
    
    if([[NSFileManager defaultManager] fileExistsAtPath:imagePath isDirectory:nil]){
        self.cachesUrl = imagePath;
        if(self.blockDisplay){
            _blockDisplay(true,true, self);
        }
        return;
    }
    
    self.dnw.url = imgUrl;
    [self.dnw resume];
    [self.activityIndicator startAnimating];
    self.activityView.hidden = NO;
}

+(bool) clearCache:(nonnull NSString *) imgUrl{
    NSString * imagePath = [PYAsyImageView parseImageUrlToImagePath:imgUrl];
    if(imagePath == nil) return false;
    NSError * erro;
    [[NSFileManager defaultManager] removeItemAtPath:imagePath error:&erro];
    if(erro) return false;
    return true;
}

+(bool) clearCaches{
    NSError * erro;
    [[NSFileManager defaultManager] removeItemAtPath:PYAsyImageViewDataCaches error:&erro];
    [PYAsyImageView checkCachesPath];
    if(erro) return false;
    return true;
}

+(void) checkCachesPath{
    PYAsyImageViewDataCaches = [NSString stringWithFormat:@"%@/imageCaches", cachesDir];
    BOOL isDirectory = false;
    BOOL hasPath = [[NSFileManager defaultManager] fileExistsAtPath:PYAsyImageViewDataCaches isDirectory:&isDirectory];
    if(!hasPath || (hasPath && !isDirectory)){
        NSError * error;
        [[NSFileManager defaultManager] createDirectoryAtPath:PYAsyImageViewDataCaches withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSAssert(NO, @"%@",error);
        }
    }
}

-(void) dealloc{
    [self.lock lock];
    [self.dnw setBlockCancel:nil];
    [self.dnw setBlockComplete:nil];
    [self.dnw setBlockReceiveChallenge:nil];
    [self.dnw setBlockComplete:nil];
    [self.dnw setBlockSendProgress:nil];
    [self.dnw setBlockDownloadProgress:nil];
    [self.dnw cancel];
    [self.activityIndicator stopAnimating];
    self.activityView.hidden = YES;
    [self.lock unlock];
}

@end
