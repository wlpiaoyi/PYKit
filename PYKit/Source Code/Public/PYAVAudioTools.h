//
//  PYAVAudioTools.h
//  PYKit
//
//  Created by wlpiaoyi on 2017/4/25.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class PYAudioPlayer;

@interface PYAVAudioTools : NSObject
/**
 后台运行
 */
+(void) backgourndPlay:(BOOL) flag;
/**
 远程控制
 */
+ (void) remoteControlReceivedWithEvent:(nonnull UIEvent *) receivedEvent player:(nonnull PYAudioPlayer *) player;
/**
 设置锁屏状态，显示的歌曲信息
 */
+(void)configNowPlayingInfoCenter:(nonnull NSDictionary *) audioDic player:(nonnull AVAudioPlayer *) player;
/**
 歌曲信息
 */
+(nonnull NSDictionary *) getAudioInfoByUrl:(nonnull NSURL *) url;
/**
 hook远程控制
 */
+(void) hookremoteControlReceivedWithPlayer:(nonnull PYAudioPlayer *) player;
/**
 hook耳机插拔监听
 */
+(void) hookoutputDeviceChangedWithPlayer:(nonnull PYAudioPlayer *) player;


@end
