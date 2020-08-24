//
//  AppDelegate.m
//  PYKit
//
//  Created by wlpiaoyi on 2017/4/19.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import "AppDelegate.h"
#import "PYCalendarLocation.h"
#import "PYCalendarParam.h"
#import "PYSelectorBarView.h"
#import "PYDisplayImageTools.h"
#import "PYAudioPlayer.h"
#import "pykita.h"
@interface UIViewController(HookInitM)

@end
@implementation UIViewController(HookInitM)


- (instancetype)exchangeInitWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil{
    typeof(self) obj = [self exchangeInitWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    obj.modalPresentationStyle = UIModalPresentationFullScreen;
    return obj;
}
- (nullable instancetype)exchangeInitWithCoder:(NSCoder *)coder{
    typeof(self) obj = [self exchangeInitWithCoder:coder];
    obj.modalPresentationStyle = UIModalPresentationFullScreen;
    return obj;
}

+(void) hookInitM{
    [self hookInstanceMethodName:@"initWithCoder:"];
    [self hookInstanceMethodName:@"initWithNibName:bundle:"];
}

@end
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    PYNavigationStyleModel * styleModel = [[PYNavigationStyleModel alloc] initForDefault];
    styleModel.dismissItemimage = [UIImage imageNamed:@"WechatIMG272"];
        styleModel.blockSetNavigationBarStyle = ^BOOL(PYNavigationStyleModel * _Nonnull styleModel, UIViewController * _Nonnull target) {
    //        if([target conformsToProtocol:@protocol(ZFNavigationSetterBlueTag)]){
    //            styleModel.backgroundImage = normalImage;
    //            styleModel.tintColor = styleModel.titleColor = [UIColor darkTextColor];
    //        }else{
                styleModel.tintColor = styleModel.titleColor = [UIColor darkTextColor];
    //        }
            return YES;
        };
    [PYNavigationControll setNavigationWithBarStyle:styleModel];
    [PYKeyboardControll setControllType:PYKeyboardControllTag];
    [PYCalendarParam loadCalendarData];
    [PYDisplayImageTools class];
    [UIViewController hookInitM];
    [[PYAudioPlayer sharedPYAudioPlayer] prepareWithUrl:@"https://pp.ting55.com/201908221229/7cef186d6d8ee5404870ec022e67bc53/2015/08/1787/28.mp3"];
    [[PYAudioPlayer sharedPYAudioPlayer] play];
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
