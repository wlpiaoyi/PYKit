//
//  PYAudioRecord.m
//  PYKit
//
//  Created by wlpiaoyi on 2017/7/6.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import "PYAudioRecord.h"
#import <AVFoundation/AVFoundation.h>
#import "PYUtile.h"

#ifdef pylameforparsemp3
#include "lame.h"
#endif


#ifdef pylameforparsemp3
typedef struct _py_audio_PCMtoMP3_params {
    float samplerate;
    unsigned short quality;
    unsigned short channels;
} py_audio_PCMtoMP3_params;
void py_audio_PCMtoMP3( const char *audioPath,
                       const char *mp3Path,
                       py_audio_PCMtoMP3_params params);
#endif

static PYAudioRecord * xPYAudioRecord;
@interface PYAudioRecord()<AVAudioRecorderDelegate>{
@private
#ifdef pylameforparsemp3
    py_audio_PCMtoMP3_params _params;
    bool _isMp3Record;
    NSURL * _tempPath;
#endif
}
@property (nonatomic, strong, nonnull) AVAudioSession *session;
@property (nonatomic, strong, nonnull) AVAudioRecorder * recorder;
@property (nonatomic, strong, nullable) NSURL * path;

@end

@implementation PYAudioRecord
+(nonnull instancetype) getSingleInstance{
    @synchronized (self) {
        if(xPYAudioRecord == nil){
            xPYAudioRecord = [self new];
        }
    }
    return xPYAudioRecord;
}
-(instancetype) init{
    if(self = [super init]){
        _status = PYAudioRecordPrepare;
        _session =[AVAudioSession sharedInstance];
    }
    return self;
}

-(BOOL) start:(nonnull NSURL *) path settings:(nullable NSDictionary<NSString *, id> *)settings {
    if(_status == PYAudioRecordIng) return false;
    _status = PYAudioRecordPrepare;
    NSError *error;
    [_session setActive:YES error:&error];
    if (error) {
        NSLog(@"Alert setActive true session: %@",[error description]);
    }

    self.path = path;
    NSMutableDictionary * mutableSettings = [NSMutableDictionary new];
    if(settings){
        [mutableSettings setDictionary:settings];
    }
    if(!mutableSettings[AVSampleRateKey]){
        //采样率  8000/11025/22050/44100/96000（影响音频的质量）
        mutableSettings[AVSampleRateKey] = [NSNumber numberWithFloat:22050];
    }
    if(!mutableSettings[AVFormatIDKey]){
        // 音频格式
        mutableSettings[AVFormatIDKey] = [NSNumber numberWithInt:kAudioFormatLinearPCM];
    }
    if(!mutableSettings[AVLinearPCMBitDepthKey]){
        //采样位数  8、16、24、32 默认为16
        mutableSettings[AVLinearPCMBitDepthKey] = [NSNumber numberWithInt:16];
    }
    if(!mutableSettings[AVNumberOfChannelsKey]){
        // 音频通道数 1 或 2
        mutableSettings[AVNumberOfChannelsKey] = [NSNumber numberWithInt:2];
    }
    if(!mutableSettings[AVEncoderAudioQualityKey]){
        //录音质量
        mutableSettings[AVEncoderAudioQualityKey] = [NSNumber numberWithInt:AVAudioQualityMedium];
    }
#ifdef pylameforparsemp3
    _isMp3Record = false;
    if(((NSNumber *)mutableSettings[AVFormatIDKey]).intValue == kAudioFormatMPEGLayer3){
        mutableSettings[AVFormatIDKey] = [NSNumber numberWithInt:kAudioFormatLinearPCM];
        _isMp3Record = true;
        _params.samplerate = ((NSNumber *)mutableSettings[AVSampleRateKey]).floatValue;
        _params.quality = ((NSNumber *)mutableSettings[AVEncoderAudioQualityKey]).shortValue;
        _params.channels = ((NSNumber *)mutableSettings[AVNumberOfChannelsKey]).shortValue;
        _tempPath = self.path;
        self.path = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/tempPCM",NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject]];
    }
#endif
    
    self.recorder = [[AVAudioRecorder alloc] initWithURL:self.path settings:mutableSettings error:&error];
    if (error) {
        NSLog(@"Error creating recorder: %@",[error description]);
        return false;
    }
    
    if (self.recorder) {
        self.recorder.delegate = self;
        self.recorder.meteringEnabled = YES;
        [self.recorder prepareToRecord];
        [self.recorder record];
        if(![self.recorder isRecording]){
            return false;
        }
    }else{
        NSLog(@"音频格式和文件存储格式不匹配,无法初始化Recorder");
        return false;
    }
    _status = PYAudioRecordIng;
    return true;
}
-(BOOL) cancel{
    if(_status == PYAudioRecordCancel) return false;
    _status = PYAudioRecordPrepare;
    if([self stop]){
        NSFileManager *manager = [NSFileManager defaultManager];
        if ([manager fileExistsAtPath:self.path.relativePath]){
            NSError *error;
            [manager removeItemAtPath:self.path.relativePath error:&error];
            if (error) {
                NSLog(@"Error remove tempPath: %@",[error description]);
            }
        }
    }else{
        return false;
    }
    _status = PYAudioRecordCancel;
    return true;
}
-(nonnull NSURL *) stop{
    [_session setActive:false error:nil];
    if(_status == PYAudioRecordEnd) return nil;
    _status = PYAudioRecordPrepare;
    if ([self.recorder isRecording]) {
        [self.recorder stop];
    }else{
        return false;
    }
    
#ifdef pylameforparsemp3
    if(_isMp3Record){
        [[NSFileManager defaultManager] removeItemAtPath:_tempPath.relativePath error:nil];
        py_audio_PCMtoMP3([self.path.relativePath UTF8String], [_tempPath.relativePath UTF8String], _params);
        self.path = _tempPath;
    }
#endif
    NSURL * result = self.path;
    self.path = nil;
    _status = PYAudioRecordEnd;
    return result;
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError * __nullable)error{
}
@end

#ifdef pylameforparsemp3
void py_audio_PCMtoMP3( const char *audioPath,
                       const char *mp3Path,
                       py_audio_PCMtoMP3_params params) {
    
    @try {
        int read, write;
        
        FILE *pcm = fopen(audioPath, "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen(mp3Path, "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        params.samplerate = params.samplerate <= 0 ? 22050.0 : params.samplerate;
        params.quality = params.quality == 0 ? 0x40 : params.quality;
        params.channels = params.channels == 0 ? 2 : params.channels;
        lame_set_in_samplerate(lame, params.samplerate);
        lame_set_quality(lame, params.quality);
        lame_set_num_channels(lame, params.channels);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = (typeof(read))fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        kPrintExceptionln("%s", [exception description].UTF8String);
    }
    @finally {
        kPrintLogln("MP3生成成功: %s", mp3Path);
    }
    
}
#endif
