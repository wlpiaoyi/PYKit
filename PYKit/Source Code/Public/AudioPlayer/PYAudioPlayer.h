//
//  PYAudioPlayer.h
//  UtileScourceCode
//
//  Created by wlpiaoyi on 15/12/22.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import "PYAudio.h"


//默认声音大小
extern float DEFAULT_VOLUME;
//默认循环次数
extern unsigned int DEFAULT_NUMBEROFLOOPS;
//默认进度
extern float DEFAULT_PROGRESS;
SINGLETON_SYNTHESIZE_FOR_hCLASS(PYAudioPlayer, NSObject, <PYAudioPlayer>)

kPNAR PYAudioPlayerStatus playerStatus;
kPNRNA AVAudioPlayer * player;
kPNANA id<PYAudioRemote> delegate;
kPNRNA NSDictionary * audioInfo;

/**
 准备播放
 */
- (nullable NSDictionary *) prepareWithUrl:(nonnull NSString *) url;

@end

