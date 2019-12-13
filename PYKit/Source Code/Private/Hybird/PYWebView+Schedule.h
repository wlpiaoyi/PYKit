//
//  PYWebView+Schedule.h
//  PYKit
//
//  Created by wlpiaoyi on 2019/12/7.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import "PYWebView.h"
#import "PYHybirdUtile.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <objc/runtime.h>
#import <WebKit/WebKit.h>
#import "pyutilea.h"
#import "pyinterflowa.h"
#import "PYWebViewDelegate.h"


NS_ASSUME_NONNULL_BEGIN

@interface PYScheduleView:UIView
kPNA CGFloat schedule;
kPNSNA void (^block) (void);
kPNSNN UIColor * pColor;
kPNSNN UIColor * bColor;
kSOULDLAYOUTP
@end

@interface PYWebView(Schedule)
kPNA BOOL isShowProgress;
-(void) initSchedule;
-(void) showProgress:(CGFloat) progeress;
-(void) scheduledTimerEnd;
-(void) hiddenProgress;
@end

NS_ASSUME_NONNULL_END
