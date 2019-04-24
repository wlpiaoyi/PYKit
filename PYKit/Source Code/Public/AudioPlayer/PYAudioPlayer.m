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
float DEFAULT_VOLUME = -1.0f;
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
        [PYAudioTools backgourndPlay:YES];
        [self initShareParamsPYAudioPlayer];
        _playerStatus = PYAudioPlayerStatusUnkown;
    }
    return self;
}

/**
 准备播放
 */
- (nullable NSDictionary *) prepareWithUrl:(nonnull NSString *) url{
    _audioUrl = nil;
    @synchronized(self) {
        [self stop];
        _audioUrl = [NSURL URLWithString:url];
        if(_audioUrl == nil) return nil;
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:_audioUrl error:nil];
        if(DEFAULT_VOLUME >= 0)_player.volume = DEFAULT_VOLUME; //0.0-1.0之间
        _player.numberOfLoops = DEFAULT_NUMBEROFLOOPS;//循环播放次数
        
        if(_player)_audioInfo = [PYAudioTools getAudioInfoByUrl:_audioUrl];
        else return nil;
        
        if (![self skip:DEFAULT_PROGRESS]) return nil;
        _playerStatus = PYAudioPlayerStatusPrepare;

        _player.delegate = self;
    
    }
    return _audioInfo ? : @{};
}
-(BOOL) play{
    @synchronized(self) {
        if (!self.player)  return false;
        if (self.player.isPlaying) return false;
        if(_playerStatus == PYAudioPlayerStatusPrepare){
            if(![_player prepareToPlay]) return false;
            [PYAudioTools configNowPlayingInfoCenter:_audioInfo player:self.player];
        }
        if([self.player play]){
            _playerStatus = PYAudioPlayerStatusPlay;
            return true;
        }
    }
    return false;
}

-(BOOL) pause{
    @synchronized(self) {
        if (!self.player) return false;
        if(!self.player.isPlaying)return false;
        
        [self.player pause];
        _playerStatus = PYAudioPlayerStatusPause;
    }
    return false;
}
-(BOOL) stop{
    @try{
        if (!self.player) return false;
        [self.player stop];
        return true;
    }
    @finally{
        _playerStatus = PYAudioPlayerStatusStop;
    }
}

#pragma start delegate AVAudioPlayerDelegate ==>
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer*)player successfully:(BOOL)flag{
    [self stop];
}
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer*)player error:(NSError *)error{
    //解码错误执行的动作
    [self audioPlayerDidFinishPlaying:player successfully:NO];
}
- (void)audioPlayerBeginInteruption:(AVAudioPlayer*)player{
    //处理中断的代码
    [self audioPlayerDidFinishPlaying:player successfully:NO];
}
- (void)audioPlayerEndInteruption:(AVAudioPlayer*)player{
    //处理中断结束的代码
    [self audioPlayerDidFinishPlaying:player successfully:NO];
}
#pragma end delegate AVAudioPlayerDelegate <==

-(BOOL) skip:(CGFloat) progress{
    if (!_player) return false;
    NSTimeInterval duration = _player.duration*(_player.numberOfLoops+1);//获取采样的持续时间
    if (progress >= 0.0f) {
        progress = MIN(progress, 1);
        progress = MAX(progress, 0);
        _player.currentTime = duration*progress;//播放位置
    }

    return true;
}
-(void) dealloc{
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
