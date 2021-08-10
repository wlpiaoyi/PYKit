//
//  PYAsyImageView+Delegate.h
//  PYKit
//
//  Created by wlpiaoyi on 2021/4/20.
//  Copyright © 2021 wlpiaoyi. All rights reserved.
//

#import "PYAsyImageView.h"
#import "PYNetDownload.h"

NS_ASSUME_NONNULL_BEGIN

@interface PYAsyImageView(Delegate)

-(void) imageDownloadIng:(PYNetDownload * _Nonnull) target  currentBytes:(int64_t) currentBytes totalBytes:(int64_t) totalBytes;
-(void) imageDownloadComplete:(PYNetwork * _Nonnull) target data:(id  _Nullable) data response:(NSURLResponse * _Nullable) response;
@end

NS_ASSUME_NONNULL_END
