//
//  PYAudio.h
//  PYAudioPlayer
//
//  Created by wlpiaoyi on 15/12/22.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "PYUtile.h"
/**
 播放状态
 */
typedef enum{
    PYAudioPlayerStatusUnkown,
    PYAudioPlayerStatusPrepare,
    PYAudioPlayerStatusPlay,
    PYAudioPlayerStatusPause,
    PYAudioPlayerStatusStop
} PYAudioPlayerStatus;

@protocol PYAudioRemote;

@protocol PYAudioPlayer <NSObject>

@required

kPNAR PYAudioPlayerStatus playerStatus;
kPNRNA AVAudioPlayer * player;
kPNANA id<PYAudioRemote> delegate;

/**
 从指定的位置播放
 @progress 0-1
 */
- (BOOL) skip:(CGFloat) progress;
/**
 播放
 */
- (BOOL) play;
/**
 暂停
 */
- (BOOL) pause;
/**
 停止
 */
- (BOOL) stop;
@end

@protocol PYAudioRemote <NSObject>
/**
 播放
 */
@optional - (BOOL) play:(nonnull id<PYAudioPlayer>) player;
/**
 暂停
 */
@optional - (BOOL) pause:(nonnull id<PYAudioPlayer>) player;
/**
 上一个
 */
@required - (BOOL) previous:(nonnull id<PYAudioPlayer>) player;
/**
 下一个
 */
@required - (BOOL) next:(nonnull id<PYAudioPlayer>) player;

@end
