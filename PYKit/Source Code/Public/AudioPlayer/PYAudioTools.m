//
//  PYAudioTools.m
//  PYAudioPlayer
//
//  Created by wlpiaoyi on 15/12/22.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import "PYAudioTools.h"
#import "pyutilea.h"
#import <MediaPlayer/MediaPlayer.h>
#import <objc/runtime.h>


NSMapTable<NSString *, id> *PYAudioMapTable;

@interface PYAudioTools()

@end

void _hook_remoteControlReceivedWithEvent_(id target, SEL action, UIEvent * receivedEvent) {
    id<PYAudioPlayer> player = [PYAudioMapTable objectForKey:@"player"];
    if (!player) {
        return;
    }
    [PYAudioTools remoteControlReceivedWithEvent:receivedEvent player:player];
    
    if ([((NSObject*)target) respondsToSelector:sel_getUid("_hookremoteControlReceivedWithEvent:")]) {
        [PYInvoke invoke:target action:sel_getUid("_hookremoteControlReceivedWithEvent:") returnValue:nil params:&receivedEvent, nil];
    }
}

void _hook_outputDeviceChanged_(id target, SEL action, NSNotification * aNotification){
    NSNumber *routeNum = aNotification.userInfo[AVAudioSessionRouteChangeReasonKey];
    id<PYAudioPlayer> player = [PYAudioMapTable objectForKey:@"player"];
    if (routeNum && routeNum.intValue == 1) {
        [player play];
    }else if(routeNum && routeNum.intValue == 2){
        [player pause];
    }
}


@implementation PYAudioTools
+(void) initialize{
    PYAudioMapTable = [NSMapTable weakToStrongObjectsMapTable];
}
+(void) backgourndPlay:(BOOL) flag{
    //==>可以后台播放
    /*在info.plist里面添加
     <key>Required background modes</key>
     <array>
     <string>App plays audio</string>
     </array>
     即可。*/
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:NO error:nil];
    ///<==
    
    //注册远程控制
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];

}

+ (void) remoteControlReceivedWithEvent:(UIEvent *) receivedEvent player:(id<PYAudioPlayer>) player{
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        
        switch (receivedEvent.subtype) {
                
            case UIEventSubtypeRemoteControlPlay:{
                [player play];
            }
                break;
                
            case UIEventSubtypeRemoteControlPause:{
                [player pause];
            }
                break;
                
            case UIEventSubtypeRemoteControlNextTrack:{
                if(![player next]){
                    player.indexPlay = 0;
                }
            }
                break;
                
            case UIEventSubtypeRemoteControlPreviousTrack:{
                if(![player previous]){
                    player.indexPlay = [player.arrayAudiosURL count] - 1;
                }
            }
                break;
            case UIEventSubtypeRemoteControlTogglePlayPause:{
                switch (player.playerStatus) {
                    case PYAudioPlayerStatusPlay:{
                        [player pause];
                    }
                        break;
                        
                    default:{
                        [player play];
                    }
                        break;
                }
            }
                
            default:
                break;
        }
    }
}


/**
 设置锁屏状态，显示的歌曲信息
 */
+(void)configNowPlayingInfoCenter:(NSDictionary*) audioDic player:(AVAudioPlayer*) player{
    
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        NSString *title = [audioDic objectForKey:MPMediaItemPropertyTitle];
        NSString *artist = [audioDic objectForKey:MPMediaItemPropertyArtist];
        NSString *album = [audioDic objectForKey:MPMediaItemPropertyAlbumTitle];
        UIImage *image = [audioDic objectForKey:MPMediaItemPropertyArtwork];
        if (![NSString isEnabled:title]) {
            title = [player.url.absoluteString componentsSeparatedByString:@"/"].lastObject;
        }
        if (![NSString isEnabled:artist]) {
            artist = @"no artist";
        }
        if (![NSString isEnabled:album]) {
            album = [audioDic objectForKey:@"album"];
        }
        if (![NSString isEnabled:album]) {
            album = @"no album";
        }
        if (!image) {
            CGRect rect = CGRectMake(0.0f, 0.0f, 600.0f, 600.0f);
            UIGraphicsBeginImageContext(rect.size);
            CGContextRef context = UIGraphicsGetCurrentContext();
            
            CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0.8 green:1 blue:0.9 alpha:0.9] CGColor]);
            CGContextFillRect(context, rect);
            UIFont *f = [UIFont systemFontOfSize:rect.size.width/10];
            NSString *msg = @"NO IMAGE";
            CGSize s = CGSizeMake(998, 999);
            s = [PYUtile getBoundSizeWithTxt:msg font:f size:s];
            s.width = 999;
            s = [PYUtile getBoundSizeWithTxt:msg font:f size:s];
            rect.origin = CGPointMake((rect.size.width-s.width)/2, (rect.size.height-s.height)/2);
            [PYGraphicsDraw drawTextWithContext:nil attribute:[[NSMutableAttributedString alloc] initWithString:msg attributes:@{(NSString*)kCTForegroundColorAttributeName:[UIColor blueColor], (NSString*)kCTFontAttributeName:f}] rect:rect y:rect.size.height scaleFlag:YES];
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        //歌曲名称
        [dict setObject:[title stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:MPMediaItemPropertyTitle];
        
        //演唱者
        [dict setObject:artist forKey:MPMediaItemPropertyArtist];
        
        //专辑名
        [dict setObject:album forKey:MPMediaItemPropertyAlbumTitle];
        
        //专辑缩略图
        MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:image];
        [dict setObject:artwork forKey:MPMediaItemPropertyArtwork];
        
        //音乐剩余时长
        [dict setObject:[NSNumber numberWithDouble:player.duration] forKey:MPMediaItemPropertyPlaybackDuration];
        //音乐当前播放时间 在计时器中修改
        [dict setObject:[NSNumber numberWithDouble:player.currentTime] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
        
        //设置锁屏状态下屏幕显示播放音乐信息
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
    }
}

+(NSDictionary*) getAudioInfoByUrl:(NSURL*) url{
    NSMutableDictionary *audioInfo = [NSMutableDictionary new];
    AudioFileID fileID = nil;
    OSStatus err = noErr;
    AudioFileOpenURL((__bridge CFURLRef) url, kAudioFileReadPermission, 0, &fileID);
    if( err != noErr ) {
        NSLog( @"AudioFileOpenURL failed" );
    }
    UInt32 id3DataSize = 0;
    err = AudioFileGetPropertyInfo( fileID, kAudioFilePropertyID3Tag, &id3DataSize, NULL );
    
    if( err != noErr ) {
        NSLog( @"AudioFileGetPropertyInfo failed for ID3 tag" );
    }
    UInt32 piDataSize = sizeof( audioInfo );
    err = AudioFileGetProperty( fileID, kAudioFilePropertyInfoDictionary, &piDataSize, &audioInfo );
    if( err != noErr ) {
        NSLog( @"AudioFileGetProperty failed for property info dictionary" );
        return @{};
    }
    CFDataRef albumPic= nil;
    UInt32 picDataSize = sizeof(picDataSize);
    err = AudioFileGetProperty(fileID, kAudioFilePropertyAlbumArtwork, &picDataSize, &albumPic);
    if( err != noErr ) {
        NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:err userInfo:nil];
        NSLog(@"Error: %@", [error description]);
    }else{
        [audioInfo setObject:[UIImage imageWithData:(__bridge NSData *)(albumPic)] forKey:MPMediaItemPropertyArtwork];
    }
    AVURLAsset *mp3Asset = [AVURLAsset URLAssetWithURL:url options:nil];
    for (NSString *format in [mp3Asset availableMetadataFormats]) {
        for (AVMetadataItem *metadataItem in [mp3Asset metadataForFormat:format]) {
            //artwork这个key对应的value里面存的就是封面缩略图，其它key可以取出其它摘要信息，例如title - 标题
            if ([metadataItem.commonKey isEqualToString:MPMediaItemPropertyTitle] && metadataItem.value) { //歌曲名称
                NSString *title  = (NSString*)metadataItem.value;
                if ([NSString isEnabled:title]) {
                    [audioInfo setObject:title forKey:MPMediaItemPropertyTitle];
                }
            }else if ([metadataItem.commonKey isEqualToString:MPMediaItemPropertyArtist] && metadataItem.value) {//演唱者
                NSString *artist  = (NSString*)metadataItem.value;
                if ([NSString isEnabled:artist]) {
                    [audioInfo setObject:artist forKey:MPMediaItemPropertyArtist];
                }
            }else if ([metadataItem.commonKey isEqualToString:MPMediaItemPropertyAlbumTitle] && metadataItem.value) {//专辑名
                NSString *albumName  = (NSString*)metadataItem.value;
                if ([NSString isEnabled:albumName]) {
                    [audioInfo setObject:albumName forKey:MPMediaItemPropertyAlbumTitle];
                }
            }else if ([metadataItem.commonKey isEqualToString:MPMediaItemPropertyArtwork] && metadataItem.value) {//图片
                NSData *data = (NSData*)metadataItem.value;
                [audioInfo setObject:[UIImage imageWithData:data] forKey:MPMediaItemPropertyArtwork];
            }
        }
    }
    return audioInfo;
}
/**
 hook远程控制
 */
+(void) hookremoteControlReceivedWithPlayer:(id<PYAudioPlayer> _Nonnull) player{
    
    [PYAudioMapTable setObject:player forKey:@"player"];
    
    id<UIApplicationDelegate> delegate = [UIApplication sharedApplication].delegate;
    IMP impPrevious = class_replaceMethod([delegate class], @selector(remoteControlReceivedWithEvent:), (IMP)_hook_remoteControlReceivedWithEvent_, "v@:@");
    if (impPrevious) {
        class_replaceMethod([delegate class], sel_getUid("_hookremoteControlReceivedWithEvent:"), (IMP)impPrevious, "v@:@");
    }
    
}
/**
 hook耳机插拔监听
 */
+(void) hookoutputDeviceChangedWithPlayer:(id<PYAudioPlayer> _Nonnull) player{
    [PYAudioMapTable setObject:player forKey:@"player"];
    SEL action  =sel_getUid("outputDeviceChanged:");
    [[NSNotificationCenter defaultCenter] removeObserver:player name:AVAudioSessionRouteChangeNotification object:[AVAudioSession sharedInstance]];
    [[NSNotificationCenter defaultCenter] addObserver:player
                                             selector:action
                                                 name:AVAudioSessionRouteChangeNotification
                                               object:[AVAudioSession sharedInstance]];
    class_replaceMethod([player class], action, (IMP)_hook_outputDeviceChanged_, "v@:@");
}
@end
