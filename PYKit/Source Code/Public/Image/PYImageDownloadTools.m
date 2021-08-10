//
//  PYImageDownloadTools.m
//  PYKit
//
//  Created by wlpiaoyi on 2021/5/6.
//  Copyright © 2021 wlpiaoyi. All rights reserved.
//

#import "PYImageDownloadTools.h"

NSMutableDictionary * PY_ASY_IMAGE_DICT_DOWNLOADS;

@interface PYImageDownloadTools()

kPNSNA NSMutableArray<id<PYImageDownloadToolsDelegate>> * delegates;

@end

@implementation PYImageDownloadTools

+(void) load{
    PY_ASY_IMAGE_DICT_DOWNLOADS = @{}.mutableCopy;
}

+(instancetype) getDownloadWithKey:(nonnull NSString *) key{
    PYImageDownloadTools * download = PY_ASY_IMAGE_DICT_DOWNLOADS[key];
    return download;
}

+(void) removeDownloadWithKey:(nonnull NSString *) key{
    [PY_ASY_IMAGE_DICT_DOWNLOADS removeObjectForKey:key];
}

+(void) removeDownloadToolsWithKey:(nonnull NSString *) key delegate:(nullable id<PYImageDownloadToolsDelegate>) delegate{
    PYImageDownloadTools * downloadTools = [PYImageDownloadTools getDownloadWithKey:key];
    if(downloadTools == nil) return;
    [downloadTools removeDownloadToolsWithDelegate:delegate];
    return;
}

+(instancetype) shareDownloadToolsWithKey:(nonnull NSString *) key delegate:(nullable id<PYImageDownloadToolsDelegate>) delegate{
    PYImageDownloadTools * downloadTools = [PYImageDownloadTools getDownloadWithKey:key];
    if(downloadTools.delegates == nil){
        downloadTools.delegates = [NSMutableArray new];
    }
    if(delegate && ![downloadTools.delegates containsObject:delegate]){
        [downloadTools.delegates addObject:delegate];
    }
    PYNetDownload * dnw = downloadTools.download;
    NSMutableArray<id<PYImageDownloadToolsDelegate>> * delegates = downloadTools.delegates;
    if(downloadTools == nil){
        downloadTools = [PYImageDownloadTools new];
        PY_ASY_IMAGE_DICT_DOWNLOADS[key] = downloadTools;
    }
    
    if(dnw.state == PYNetworkStateCancel || dnw.state == PYNetworkStateInterrupt || dnw.state == PYNetworkStateCompleted){
        [downloadTools clearBlock];
        dnw = nil;
    }
    
    if(dnw == nil){
        dnw = [PYNetDownload new];
        downloadTools->_download = dnw;
    }
    
    downloadTools->_key = key;
    [dnw setBlockReceiveChallenge:^BOOL(id  _Nullable data, PYNetwork * _Nonnull target) {
        return true;
    }];
    
    [dnw setBlockDownloadProgress:^(PYNetDownload * _Nonnull target, int64_t currentBytes, int64_t totalBytes) {
        for (id<PYImageDownloadToolsDelegate> delegate in delegates) {
            if([delegate respondsToSelector:@selector(progressWithTagert:currentBytes:totalBytes:)]){
                [delegate progressWithTagert:target currentBytes:currentBytes totalBytes:totalBytes];
            }
        }
    }];
    [dnw setBlockComplete:^(id  _Nullable data, NSURLResponse * _Nullable response, PYNetwork * _Nonnull target) {
        for (id<PYImageDownloadToolsDelegate> delegate in delegates) {
            if([delegate respondsToSelector:@selector(completeWithTagert:data:response:)]){
                [delegate completeWithTagert:target data:data response:response];
            }
        }
    }];
    [dnw setBlockCancel:^(id  _Nullable data, NSURLResponse * _Nullable response, PYNetDownload * _Nonnull target) {
        for (id<PYImageDownloadToolsDelegate> delegate in delegates) {
            if([delegate respondsToSelector:@selector(cancelWithTagert:data:response:)]){
                [delegate cancelWithTagert:target data:data response:response];
            }
        }
    }];
    return downloadTools;
}

-(void) removeDownloadToolsWithDelegate:(nullable id<PYImageDownloadToolsDelegate>) delegate{
    NSMutableArray<id<PYImageDownloadToolsDelegate>> * delegates = self.delegates;
    [delegates removeObject:delegate];
    return;
}


-(void) clearBlock{
    PYNetDownload * dnw = self.download;
    [dnw setBlockCancel:nil];
    [dnw setBlockReceiveChallenge:nil];
    [dnw setBlockSendProgress:nil];
    [dnw setBlockDownloadProgress:nil];
}




@end
