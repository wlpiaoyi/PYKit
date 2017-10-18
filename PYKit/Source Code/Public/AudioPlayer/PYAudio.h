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
    PYAudioPlayerStatusPrepare,
    PYAudioPlayerStatusPlay,
    PYAudioPlayerStatusPause,
    PYAudioPlayerStatusStop
} PYAudioPlayerStatus;

@protocol PYAudioPlayer <NSObject>

@property (nonatomic, strong,readonly) AVAudioPlayer * _Nonnull player;
//播放文件的index
@property (nonatomic) NSUInteger indexPlay;
//播放文件列表
@property (nonatomic, copy) NSMutableArray * _Nonnull arrayAudiosURL;
//当前文件信息
@property (nonatomic, strong, readonly) NSDictionary * _Nullable audioInfo;

@property (nonatomic, readonly) PYAudioPlayerStatus playerStatus;
/**
 添加音频播放文件URL
 */
- (void) addAudioUrl:(NSURL * _Nonnull) url;
/**
 添加音频播放文件名称
 */
- (void) addAudioName:(NSString * _Nonnull) name ofType:(NSString * _Nonnull) ofType;
/**
 开始播放
 */
- (BOOL) play;
/**
 从指定的位置播放
 @progress 0-1
 */
- (BOOL) playProgress:(CGFloat) progress;
/**
 暂停
 */
- (BOOL) pause;
/**
 停止
 */
- (BOOL) stop;
/**
 下一个
 */
- (BOOL) next;
/**
 上一个
 */
- (BOOL) previous;
@end
