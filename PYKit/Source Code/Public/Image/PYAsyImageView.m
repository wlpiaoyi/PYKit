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

NSString * PY_ASY_DICT_DEFAULT_KEY;
NSDictionary<NSString*, UIImage *> * PY_ASY_NODATA_IMG_DICT;
NSDictionary<NSString*, UIImage *> * PY_ASY_LOADING_IMG_DICT;

CFStringRef PY_ASYIMG_PERCENT_FIELD = CFSTR(":/?#[]@!$&’()*+,;=");

static NSString * PYAsyImageViewDataCaches;

@interface PYAsyImageView(){
    NSTimeInterval static_pre_time_interval;
}
kPNSNN UIActivityIndicatorView * activityIndicator;
kPNSNN UIView * activityView;
kPNSNN UILabel * activityLabel;
kPNSNN PYNetDownload * dnw;
kPNSNA NSString * cachesPath;
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
        PY_ASY_DICT_DEFAULT_KEY = @"default";
    });
}
-(void) imageDownloadIng:(PYNetDownload * _Nonnull) target  currentBytes:(int64_t) currentBytes totalBytes:(int64_t) totalBytes{
    [self.lock lock];
    if(self.blockProgress){
        self.blockProgress((double)currentBytes/(double)totalBytes, self);
    }
    if(self.hasPercentage){
        if([NSDate timeIntervalSinceReferenceDate] - static_pre_time_interval > 0.2){
            self.currentBytes = currentBytes;
            self.totalBytes = totalBytes;
            [self.graphicsThumb executDisplay:nil];
            if(self.currentBytes < 1024 * 1024)
                self.activityLabel.text = kFORMAT(@"%.2fKB", (double)self.currentBytes / (double)1024);
            else
                self.activityLabel.text = kFORMAT(@"%.2fMB", (double)self.currentBytes / (double)(1024 * 1024));
            static_pre_time_interval = [NSDate timeIntervalSinceReferenceDate];
        }
    }
    [self.lock unlock];
}
-(void) imageDownloadComplete:(PYNetwork * _Nonnull) target data:(id  _Nullable) data response:(NSURLResponse * _Nullable) response{
    [self.lock lock];
    @try{
        [self.activityIndicator stopAnimating];
        self.activityView.hidden = YES;
        self.image = self.imageNoData;
        self.cachesPath = nil;
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
        NSString * imagePath = [PYAsyImageView getCachePathWithUrl:self.imgUrl];
        if(![NSString isEnabled:imagePath]){
            NSLog(@"create image path erro!!");
            return;
        }
        NSError * erro;
        if([[NSFileManager defaultManager] fileExistsAtPath:imagePath isDirectory:nil]) [[NSFileManager defaultManager] removeItemAtPath:imagePath error:&erro];
        if(erro) NSLog(@"[erro code:%ld] [erro domain;%@] [erro description:%@] imagePath:%@", (long)((NSError*)erro).code, ((NSError*)data).domain, ((NSError*)erro).description, imagePath);
        
        erro = nil;
        [[NSFileManager defaultManager] moveItemAtPath:data toPath:imagePath error:&erro];
        if(erro) NSLog(@"%@ image errocode:%ld, errodomain:%@",NSStringFromClass([PYAsyImageView class]), (long)[erro code], [erro domain]);
        self.cachesPath = imagePath;
        if(self.blockDisplay) self.blockDisplay(true,false, self);
    }@finally{
        [self.lock unlock];
    }
}

kINITPARAMS{
    self.lock = [NSLock new];
    self.strokeColor = [UIColor colorWithHexNumber:0x66884466];
    self.fillColor = [UIColor colorWithHexNumber:0x88888833];
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
    [self.activityView py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
        make.centerX.centerY.py_constant(0);
        make.width.height.py_constant(30);
    }];
    self.activityLabel = [UILabel new];
    self.activityLabel.backgroundColor = [UIColor clearColor];
    self.activityLabel.numberOfLines = 2;
    self.activityLabel.font = [UIFont systemFontOfSize:12];
    self.activityLabel.textColor = [UIColor darkGrayColor];
    [self.activityView addSubview: self.activityLabel];
    [self.activityLabel py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
        make.centerX.py_constant(0);
        make.centerY.py_constant(20);
        make.height.py_constant(15);
    }];
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.activityView addSubview:self.activityIndicator];
    [self.activityIndicator py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
        make.centerX.centerY.py_constant(0);
        make.width.height.py_constant(30);
    }];
    self.showType = self.showType;
}

-(void) setShowType:(NSString *)showType{
    _showType = showType;
    if(PY_ASY_NODATA_IMG_DICT && self.showType){
        self.imageNoData = PY_ASY_NODATA_IMG_DICT[self.showType];
    }
    if(self.imageNoData == nil) self.imageNoData = PY_ASY_NODATA_IMG_DICT[PYAsyImageView.dictDefaultKey];
    if(PY_ASY_LOADING_IMG_DICT && self.showType){
        self.imageLoading = PY_ASY_LOADING_IMG_DICT[self.showType];
    }
    if(self.imageLoading == nil) self.imageLoading = PY_ASY_LOADING_IMG_DICT[PYAsyImageView.dictDefaultKey];
    if(self.imageLoading == nil) self.imageLoading = self.imageNoData;
}


-(void) setCachesPath:(NSString *)cachesUrl{
    _cachesPath = cachesUrl;
    if(_cachesPath != nil){
//        NSLog(self.cachesPath);
        NSData * data = [NSData dataWithContentsOfFile:self.cachesPath];
        UIImage * image  = [[UIImage alloc] initWithData:data];
        if(image && image.size.width > 0 && image.size.height > 0){
            self.image = image;
        }else{
            [[NSFileManager defaultManager] removeItemAtPath:_cachesPath error:nil];
            self.image = self.imageNoData;
        }
    }else self.image = self.imageNoData;
}

-(PYNetDownload *) createDnw{
    PYNetDownload * dnw = [PYNetDownload new];
    [dnw setBlockReceiveChallenge:^BOOL(id  _Nullable data, PYNetwork * _Nonnull target) {
        return true;
    }];
    kAssign(self);
    [dnw setBlockDownloadProgress:^(PYNetDownload * _Nonnull target, int64_t currentBytes, int64_t totalBytes) {
        kStrong(self);
        [self imageDownloadIng:target currentBytes:currentBytes totalBytes:totalBytes];
    }];
    [dnw setBlockComplete:^(id  _Nullable data, NSURLResponse * _Nullable response, PYNetwork * _Nonnull target) {
        kStrong(self);
        [self imageDownloadComplete:target data:data response:response];
    }];
    [dnw setBlockCancel:^(id  _Nullable data, NSURLResponse * _Nullable response, PYNetDownload * _Nonnull target) {
        kStrong(self);
        [self.lock lock];
        [self.activityIndicator stopAnimating];
        if(self.image == nil || self.image == self.imageLoading) self.image = self.imageNoData;
        self.activityView.hidden = YES;
        if(self.blockDisplay){
            self.blockDisplay(false,false, self);
        }
        [self.lock unlock];
    }];
    return dnw;
}

+(NSString *) getCachePathWithUrl:(nonnull NSString *) url{
    if(![NSString isEnabled:url]) return nil;
    NSString * cacheTag = [PYUtile MD5ForLower32Bate:url];
    NSMutableString * imagePath = [NSMutableString new];
    [imagePath appendString:PYAsyImageViewDataCaches];
    [imagePath appendFormat:@"/%@",cacheTag];
    return imagePath;
}

-(void) setImgUrl:(NSString *)imgUrl{
    _imgUrl = [imgUrl pyEncodeToPercentEscapeString:@"!*'();@&=+$,%#[]"];
    self.showType = self.showType;
    self.image = self.imageNoData;
    if(_imgUrl == nil || _imgUrl.length == 0) return;
    if(self.dnw) [self.dnw stop];
    else self.dnw = [self createDnw];
    self.image = self.imageLoading;
    NSString * imagePath = [PYAsyImageView getCachePathWithUrl:_imgUrl];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:imagePath isDirectory:nil]){
        self.cachesPath = imagePath;
        if(self.blockDisplay) _blockDisplay(true,true, self);
        return;
    }
    
    static_pre_time_interval = 0;
    self.dnw.url = _imgUrl;
    [self.dnw resume];
    [self.activityIndicator startAnimating];
    self.activityView.hidden = NO;
}

+(nonnull NSString *) dictDefaultKey{
    return PY_ASY_DICT_DEFAULT_KEY;
}

+(bool) clearCache:(nonnull NSString *) imageUrl{
    NSString * imagePath = [PYAsyImageView getCachePathWithUrl:imageUrl];
    if(![NSString isEnabled:imagePath]) return false;
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
    [self.dnw stop];
    [self.activityIndicator stopAnimating];
    self.activityView.hidden = YES;
    [self.lock unlock];
}

@end
