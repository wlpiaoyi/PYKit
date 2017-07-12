//
//  PYAudioRecord.h
//  PYKit
//
//  Created by wlpiaoyi on 2017/7/6.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

typedef enum {
    PYAudioRecordPrepare = 1,
    PYAudioRecordIng = PYAudioRecordPrepare << 1,
    PYAudioRecordEnd = PYAudioRecordIng << 2,
    PYAudioRecordCancel = 1 << 3,
} PYAudioRecordEnum;

extern CGFloat PYAudioRecordTime;

@interface PYAudioRecord : NSObject
 @property (nonatomic, assign, readonly) PYAudioRecordEnum status;
+(nonnull instancetype) getSingleInstance;
-(BOOL) start:(nonnull NSURL *) path settings:(nullable NSDictionary<NSString *, id> *)settings;
-(BOOL) cancel;
-(nonnull NSURL *) stop;
@end
