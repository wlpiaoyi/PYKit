//
//  PYImageDownloadTools.h
//  PYKit
//
//  Created by wlpiaoyi on 2021/5/6.
//  Copyright © 2021 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PYNetDownload.h"

@protocol PYImageDownloadToolsDelegate <NSObject>

@optional
-(void) progressWithTagert:(nonnull PYNetDownload *) target currentBytes:(int64_t) currentBytes totalBytes:(int64_t) totalBytes;
-(void) completeWithTagert:(nonnull PYNetDownload *) target data:(nullable id) data response:(nullable NSURLResponse *) response;
-(void) cancelWithTagert:(nonnull PYNetDownload *) target data:(nullable id) data response:(nullable NSURLResponse *) response;

@end

NS_ASSUME_NONNULL_BEGIN

@interface PYImageDownloadTools : NSObject

kPNRNA PYNetDownload * download;
kPNRNA NSString * key;

+(void) removeDownloadToolsWithKey:(nonnull NSString *) key delegate:(nullable id<PYImageDownloadToolsDelegate>) delegate;
+(instancetype) shareDownloadToolsWithKey:(nonnull NSString *) key delegate:(nullable id<PYImageDownloadToolsDelegate>) delgate;


@end

NS_ASSUME_NONNULL_END
