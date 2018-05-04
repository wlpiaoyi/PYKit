//
//  PYAsyImageView.m
//  PYNetwork
//
//  Created by wlpiaoyi on 2017/4/10.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import "PYAsyImageView.h"
#import "PYNetDownload.h"

static NSString * PYAsyImageViewDataCaches;

@interface PYAsyImageView()
kPNSNN UIActivityIndicatorView * aiv;
kPNSNN PYNetDownload * dnw;
kPNSNA NSString * cachesUrl;
kPNSNN NSLock * lock;
@end

@implementation PYAsyImageView

+(void) initialize{
    [PYUtile class];
    [PYAsyImageView checkCachesPath];
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
    [self.dnw setBlockReceiveChallenge:^BOOL(id  _Nullable data, PYNetwork * _Nonnull target) {
        return true;
    }];
    __unsafe_unretained typeof(self) uself = self;
    [self.dnw setBlockDownloadProgress:^(PYNetDownload * _Nonnull target, int64_t currentBytes, int64_t totalBytes) {
        [uself.lock lock];
        if(uself.blockProgress){
            uself.blockProgress((double)currentBytes/(double)totalBytes, uself);
        }
        [uself.lock unlock];
    }];
    [self.dnw setBlockComplete:^(id  _Nullable data, NSURLResponse * _Nullable response, PYNetwork * _Nonnull target) {
        [uself.lock lock];
        @try{
            [uself.aiv stopAnimating];
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
        [uself.aiv stopAnimating];
        if(uself.blockDisplay){
            uself.blockDisplay(false,false, uself);
        }
        [uself.lock unlock];
    }];
    self.aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:self.aiv];
    [PYViewAutolayoutCenter persistConstraint:self.aiv size:CGSizeMake(50, 50)];
    [PYViewAutolayoutCenter persistConstraint:self.aiv centerPointer:CGPointMake(0, 0)];
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
    if([self.dnw.url isEqual:self.imgUrl]){
        return;
    }
    [self.dnw cancel];
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
    [self.aiv startAnimating];
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
    PYAsyImageViewDataCaches = [NSString stringWithFormat:@"%@/imageCaches", documentDir];
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
    [self.aiv stopAnimating];
    [self.lock unlock];
}

@end
