//
//  PYAudioTools.h
//  PYAudioPlayer
//
//  Created by wlpiaoyi on 15/12/22.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//


#import "PYAudio.h"

@interface PYAudioTools : NSObject
/**
 后台运行
 */
+(void) backgourndPlay:(BOOL) flag;
/**
 远程控制
 */
+ (void) remoteControlReceivedWithEvent:(UIEvent * _Nonnull) receivedEvent player:(id<PYAudioPlayer> _Nonnull) player;
/**
 设置锁屏状态，显示的歌曲信息
 */
+(void)configNowPlayingInfoCenter:(NSDictionary * _Nonnull) audioDic player:(AVAudioPlayer * _Nonnull) player;
/**
 歌曲信息
 */
+(NSDictionary * _Nonnull) getAudioInfoByUrl:(NSURL * _Nonnull) url;
/**
 hook远程控制
 */
+(void) hookremoteControlReceivedWithPlayer:(id<PYAudioPlayer> _Nonnull) player;
/**
 hook耳机插拔监听
 */
+(void) hookoutputDeviceChangedWithPlayer:(id<PYAudioPlayer> _Nonnull) player;

@end
