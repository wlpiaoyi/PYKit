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
#import "PYAsyImageView+Delegate.h"


NSMutableDictionary * PY_ASY_DICT_DOWNLOADS;
CFStringRef PY_ASYIMG_PERCENT_FIELD = CFSTR(":/?#[]@!$&’()*+,;=");

NSString * PY_ASY_DICT_DEFAULT_KEY;
NSDictionary<NSString*, UIImage *> * PY_ASY_NODATA_IMG_DICT;
NSDictionary<NSString*, UIImage *> * PY_ASY_LOADING_IMG_DICT;
void (^PY_ASY_BLOCK_OPTION) (UIImageView * _Nonnull imageView);


static NSString * PYAsyImageViewDataCaches;


@interface PYAsyImageView(){
    NSTimeInterval static_pre_time_interval;
}


kPNSNN PYNetDownload * download;
kPNSNA PYGraphicsThumb * graphicsThumb;

kPNSNN UIActivityIndicatorView * activityIndicator;
kPNSNN UIView * activityView;
kPNSNN UILabel * activityLabel;

kPNSNN NSLock * lock;
kPNSNA NSString * cachesPath;
kPNSNA NSString * cacheTag;
kPNA int64_t currentBytes;
kPNA int64_t totalBytes;

kPNSNN UIColor * strokeColor;
kPNSNN UIColor * fillColor;
@end

@implementation PYAsyImageView

+(void) initialize{
   static dispatch_once_t onceToken; dispatch_once(&onceToken,^{
        [PYUtile class];
       PY_ASY_DICT_DOWNLOADS = @{}.mutableCopy;
        [PYAsyImageView checkCachesPath];
        PY_ASY_DICT_DEFAULT_KEY = @"default";
    });
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

-(void) notifyImageDownloadComplete:(NSNotification *) notify{
    id object = notify.object;
    id  _Nullable data = object[@0];
    NSURLResponse * response = object[@1];
    PYNetwork * target = object[@2];
    void * pointer = (__bridge void *)(self);
    [PYAsyImageView removeSelfFromDownload:self.cacheTag download:_download pointer:pointer];
    [self imageDownloadComplete:target data:data response:response];
}

-(void) setCachesPath:(NSString *)cachesUrl{
    _cachesPath = cachesUrl;
    if(_cachesPath != nil){
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

//-(id) getObjValue:(NSDictionary *) objs index:(NSInteger) index{
//    return objs[@(index)];
//}

-(PYNetDownload *) download{
    if(_download) return _download;
    if(![NSString isEnabled:_cacheTag]) return nil;
    PYNetDownload * dnw = [PY_ASY_DICT_DOWNLOADS objectForKey:_cacheTag];
    NSString * cacheTag = _cacheTag;
    if(_download.state != PYNetworkStateResume){
    }
    if(dnw == nil){
        dnw = [PYNetDownload new];
        dnw.url = _imgUrl;
        PYNetDownload * download = dnw;
        [dnw setBlockReceiveChallenge:^BOOL(id  _Nullable data, PYNetwork * _Nonnull target) {
            return true;
        }];
        kAssign(self);
        [dnw setBlockDownloadProgress:^(PYNetDownload * _Nonnull target, int64_t currentBytes, int64_t totalBytes) {
            kStrong(self);
            [self imageDownloadIng:target currentBytes:currentBytes totalBytes:totalBytes];
        }];
        [dnw setBlockComplete:^(id  _Nullable data, NSURLResponse * _Nullable response, PYNetwork * _Nonnull target) {
            NSMutableDictionary * dict = @{}.mutableCopy;
            if(data) dict[@0] = data;
            if(response) dict[@1] = response;
            if(target) dict[@2] = target;
            kNOTIF_POST(cacheTag, dict);
//            NSArray<NSNumber *> * objs = [target.userInfo mutableCopy];
//            @synchronized (objs) {
//                for (NSNumber * pointer in objs) {
//                    void * p = pointer.integerValue;
//                    PYAsyImageView * aiv = (__bridge PYAsyImageView *)(p);
//                    [aiv notifyImageDownloadComplete:dict];
//                }
//            }
        }];
        void * pointer = (__bridge void *)(self);
        [dnw setBlockCancel:^(id  _Nullable data, NSURLResponse * _Nullable response, PYNetDownload * _Nonnull target) {
            kStrong(self);
            [PYAsyImageView removeSelfFromDownload:cacheTag download:_download pointer:pointer];
            [self.lock lock];
            [self.activityIndicator stopAnimating];
            if(self.image == nil || self.image == self.imageLoading || self.image.size.width == 0) self.image = self.imageNoData;
            self.activityView.hidden = YES;
            if(self.blockDisplay){
                self.blockDisplay(false,false, self);
            }
            [self.lock unlock];
        }];
    }
    _download = dnw;
    [self addSelfFromDownload];
    return _download;
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
    _imgUrl = imgUrl;
    if([NSString isEnabled:_imgUrl]){
        if(PY_ASY_BLOCK_OPTION){
            PY_ASY_BLOCK_OPTION(self);
            return;
        }
        if([_imgUrl isEqual:[_imgUrl pyDecodeFromPercentEscapeString]]){
            _imgUrl = [_imgUrl pyEncodeToPercentEscapeString:@"!*'();@+$,%#[]`_-"];
        }
        self.cacheTag = [PYUtile MD5ForLower32Bate:self.imgUrl];
        kNOTIF_REMV(self, self.cacheTag);
        kNOTIF_ADD(self, self.cacheTag, notifyImageDownloadComplete:);
    }else{
        _imgUrl = nil;
        self.cacheTag = nil;
    }
    self.showType = self.showType;
    self.image = self.imageNoData;
    if(_imgUrl == nil || _imgUrl.length == 0) return;
    self.image = self.imageLoading;
    NSString * imagePath = [PYAsyImageView getCachePathWithUrl:_imgUrl];
    if([[NSFileManager defaultManager] fileExistsAtPath:imagePath isDirectory:nil]){
        self.cachesPath = imagePath;
        if(self.blockDisplay) _blockDisplay(true,true, self);
        return;
    }
    if(_download){
        [_download setBlockCancel:nil];
        [_download setBlockReceiveChallenge:nil];
        [_download setBlockSendProgress:nil];
        [_download setBlockDownloadProgress:nil];
    }
    _download = nil;
    if(self.download.state == PYNetworkStateUnkwon || self.download.state == PYNetworkStateCancel || self.download.state == PYNetworkStateInterrupt) [self.download resume];
    static_pre_time_interval = 0;
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

-(void) addSelfFromDownload{
    if(![NSString isEnabled:_cacheTag]) return;
    if(_download == nil) return;
    NSMutableArray * objs = _download.userInfo;
    if(objs == nil){
        objs = @[].mutableCopy;
        _download.userInfo = objs;
    }
    PY_ASY_DICT_DOWNLOADS[_cacheTag] = _download;
    void * pointer = (__bridge void *)(self);
    NSInteger i = pointer;
    if([objs containsObject:@(i)]) return;
    [objs addObject:@(i)];
}

+(void) removeSelfFromDownload:(nonnull NSString *) cacheTag download:(PYNetDownload *) download pointer:(void *) pointer{
    if(![NSString isEnabled:cacheTag]) return;
    if(download == nil) return;
    NSMutableArray * objs = download.userInfo;
    NSInteger i = pointer;
    [objs removeObject:@(i)];
    if(!objs || objs.count == 0){
        [PY_ASY_DICT_DOWNLOADS removeObjectForKey:cacheTag];
    }
}

-(void) dealloc{
    [self.lock lock];
    kNOTIF_REMV(self, self.cacheTag);
    [self.class removeSelfFromDownload:self.cacheTag download:_download pointer:(__bridge void *)(self)];
    [_download setBlockCancel:nil];
//    [_download setBlockComplete:nil];
    [_download setBlockReceiveChallenge:nil];
    [_download setBlockSendProgress:nil];
    [_download setBlockDownloadProgress:nil];
    [_download stop];
    [_activityIndicator stopAnimating];
    _activityView.hidden = YES;
    [_lock unlock];
}

@end
