//
//  PYAsyImageView+Delegate.m
//  PYKit
//
//  Created by wlpiaoyi on 2021/4/20.
//  Copyright © 2021 wlpiaoyi. All rights reserved.
//

#import "PYAsyImageView+Delegate.h"

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
kPNA int64_t currentBytes;
kPNA int64_t totalBytes;

kPNSNN UIColor * strokeColor;
kPNSNN UIColor * fillColor;

@end

@implementation PYAsyImageView(Delegate)


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
        BOOL abc = NO;
        if(![[NSFileManager defaultManager] fileExistsAtPath:data isDirectory:&isDirectory] || isDirectory){
            abc = YES;
        }
        NSString * imagePath = [PYAsyImageView getCachePathWithUrl:self.imgUrl];
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
        if(self.blockDisplay) self.blockDisplay(true,false, self);
    }@finally{
        [self.lock unlock];
    }
}

@end
