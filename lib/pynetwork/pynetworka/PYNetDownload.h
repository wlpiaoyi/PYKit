//
//  PYNetDownload.h
//  UtileScourceCode
//
//  Created by wlpiaoyi on 15/11/27.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import "PYNetwork.h"

@interface PYNetDownload : PYNetwork

kPNRNN NSString * identifier;
/**
 短点继续下载
 */
-(BOOL) resumeWithData:(nonnull NSData *) data;
/**
 请求反馈
 */
//==>
/**
 下载进程
 */
-(instancetype _Nonnull) setBlockDownloadProgress:(void (^_Nullable) (PYNetDownload * _Nonnull target,int64_t currentBytes, int64_t totalBytes)) blockProgress;
/**
 下载请求恢复取消
 */
-(instancetype _Nonnull) setBlockCancel:(void (^_Nullable)(id _Nullable data, NSURLResponse * _Nullable response, PYNetDownload * _Nonnull target)) blockCancel;
///<==

@end
