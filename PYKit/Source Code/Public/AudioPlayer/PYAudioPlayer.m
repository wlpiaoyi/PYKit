//
//  PYAudioPlayer.m
//  UtileScourceCode
//
//  Created by wlpiaoyi on 15/12/22.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import "PYAudioPlayer.h"
#import "PYAudioTools.h"
#import "pyutilea.h"
#import <MediaPlayer/MediaPlayer.h>
#import <CoreText/CoreText.h>


//默认声音大小
float DEFAULT_VOLUME = 0.4f;
//默认循环次数
unsigned int DEFAULT_NUMBEROFLOOPS = 0;
//默认进度
float DEFAULT_PROGRESS = -1;

@interface PYAudioPlayer()<AVAudioPlayerDelegate>{
}
@end
SINGLETON_SYNTHESIZE_FOR_mCLASS(PYAudioPlayer){
    
}
-(id) init{
    if (self=[super init]) {
        _arrayAudiosURL = [NSMutableArray new];
        _playerStatus = PYAudioPlayerStatusPrepare;
        [PYAudioTools backgourndPlay:YES];
        [self initShareParamsPYAudioPlayer];
    }
    return self;
}
-(void) addAudioUrl:(NSURL*) url{
    [self.arrayAudiosURL addObject:url];
}
-(void) addAudioName:(NSString*) name ofType:(NSString*) ofType{
    NSString *stringPath = [[NSBundle mainBundle] pathForResource:name ofType:ofType];
    NSURL *url = [NSURL fileURLWithPath:stringPath];
    [self addAudioUrl:url];
}
-(BOOL) play{
    @synchronized(self) {
        if (self.playerStatus == PYAudioPlayerStatusPlay) {
            return false;
        }
        if (![self __playProgress:DEFAULT_PROGRESS]) {
            return false;
        }
        _playerStatus = PYAudioPlayerStatusPlay;
    }
    return true;
}
-(BOOL) playProgress:(CGFloat) progress{
    @synchronized(self) {
        return [self __playProgress:progress];
    }
}
-(BOOL) pause{
    @synchronized(self) {
        if (!self.player) {
            return false;
        }
        [self.player pause];
        _playerStatus = PYAudioPlayerStatusPause;
    }
    return true;
}
-(BOOL) stop{
    @synchronized(self) {
        if (!self.player) {
            return false;
        }
        [self.player stop];
        _player = nil;
        _playerStatus = PYAudioPlayerStatusStop;
    }
    return true;
}
-(BOOL) next{
    _indexPlay ++;
    if (_indexPlay >= [self.arrayAudiosURL count]) {
        _indexPlay --;
        return false;
    }
    [self stop];
    return [self play];
}
-(BOOL) previous{
    if (!_indexPlay) {
        return false;
    }
    _indexPlay --;
    [self stop];
    return [self play];
}
-(void) setIndexPlay:(NSUInteger)indexPlay{
    _indexPlay = MIN([self.arrayAudiosURL count], indexPlay);
    [self stop];
    [self play];
}

#pragma start delegate AVAudioPlayerDelegate ==>
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer*)player successfully:(BOOL)flag{
    if (!flag) {
        return;
    }
    [self next];
}
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer*)player error:(NSError *)error{
    //解码错误执行的动作
    _player = nil;
}
- (void)audioPlayerBeginInteruption:(AVAudioPlayer*)player{
    //处理中断的代码
    _player = nil;
}
- (void)audioPlayerEndInteruption:(AVAudioPlayer*)player{
    //处理中断结束的代码
    _player = nil;
}
#pragma end delegate AVAudioPlayerDelegate <==

-(BOOL) __playProgress:(CGFloat) progress{
    if (!self.player) {
        _indexPlay = MIN(_indexPlay, (unsigned int)([_arrayAudiosURL count]-1));
        _indexPlay = MAX(_indexPlay, 0);
        NSURL *url = [_arrayAudiosURL objectAtIndex:_indexPlay];
        if (url) {
            _audioInfo = [PYAudioTools getAudioInfoByUrl:url];
            _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
            _player.volume = DEFAULT_VOLUME; //0.0-1.0之间
            _player.numberOfLoops = DEFAULT_NUMBEROFLOOPS;//循环播放次数
        }
    }
    if (!_player) {
        return false;
    }
    NSTimeInterval duration = _player.duration*(_player.numberOfLoops+1);//获取采样的持续时间
    if (progress>=0.0f) {
        progress = MIN(progress, 1);
        progress = MAX(progress, 0);
        _player.currentTime = duration*progress;//播放位置
    }
    _player.delegate = self;
    [_player prepareToPlay];
    
    if (!self.player.isPlaying) {
        [self.player play];
        [PYAudioTools configNowPlayingInfoCenter:self.audioInfo player:self.player];
    }
    return true;
}
-(void) dealloc{
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
