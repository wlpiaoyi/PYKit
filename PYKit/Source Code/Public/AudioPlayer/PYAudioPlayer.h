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
@property (nonatomic, strong,readonly) AVAudioPlayer *player;
//播放文件的index
@property (nonatomic) NSUInteger indexPlay;
//播放文件列表
@property (nonatomic, copy) NSMutableArray *arrayAudiosURL;
//当前文件信息
@property (nonatomic, strong, readonly) NSDictionary *audioInfo;

@property (nonatomic, readonly) PYAudioPlayerStatus playerStatus;
@end

