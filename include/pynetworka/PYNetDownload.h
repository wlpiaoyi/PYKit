//
//  PYNetDownload.h
//  UtileScourceCode
//
//  Created by wlpiaoyi on 15/11/27.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import "PYNetwork.h"

@interface PYNetDownload : PYNetwork

PYPNRNN NSString * identifier;
-(BOOL) resumeWithData:(nonnull NSData *) data;
/**
 请求反馈
 */
//==>
-(instancetype _Nonnull) setBlockDownloadProgress:(void (^_Nullable) (PYNetDownload * _Nonnull target,int64_t currentBytes, int64_t totalBytes)) blockProgress;
//下载请求恢复数取消
-(instancetype _Nonnull) setBlockCancel:(void (^_Nullable)(id _Nullable data, PYNetDownload * _Nonnull target)) blockCancel;
///<==

@end
