//
//  PYNetUpload.h
//  PYNetwork
//
//  Created by wlpiaoyi on 2017/4/14.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import "PYNetwork.h"

@interface PYNetUpload : PYNetwork
/**
 分段压缩上传
 */
-(BOOL) resumeWithData:(nonnull NSData *) data fileName:(nonnull NSString *) fileName contentType:(nonnull NSString *)contentType;
/**
 直接上传
 */
-(BOOL) resumeWithPath:(nonnull NSString *) path;

@end
