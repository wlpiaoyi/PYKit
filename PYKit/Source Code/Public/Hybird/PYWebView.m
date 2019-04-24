//
//  PYWebView.m
//  PYFrameWork
//
//  Created by wlpiaoyi on 16/9/5.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "PYWebView.h"
#import "PYHybirdUtile.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <objc/runtime.h>
#import <WebKit/WebKit.h>
#import "pyutilea.h"
#import "pyinterflowa.h"
#import "PYWebViewDelegate.h"

@interface PYScheduleView:UIView
kPNA CGFloat schedule;
kPNSNA void (^block) (void);
kPNSNN UIColor * pColor;
kPNSNN UIColor * bColor;
kSOULDLAYOUTP
@end
@implementation PYScheduleView{
    UIView * _pView;
    UIView * _bView;
    UIView * _psView;
    UIView * _bsView;
    NSLayoutConstraint * _lcph;
}
-(instancetype) init{
    self = [super init];
    _pView = [UIView new];
    _bView = [UIView new];
    _psView = [UIView new];
    _bsView = [UIView new];
    [_pView addSubview:_psView];
    [_bView addSubview:_bsView];
    self.pColor = [UIColor orangeColor];
    self.bColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    self.backgroundColor = [UIColor clearColor];
    _pView.backgroundColor = [UIColor clearColor];
    _bView.backgroundColor = [UIColor clearColor];
    [self addSubview:_bView];
    [_bView addSubview:_pView];
    [PYViewAutolayoutCenter persistConstraint:_bView relationmargins:UIEdgeInsetsMake(3, 3, 3, 3) relationToItems:PYEdgeInsetsItemNull()];
    [PYViewAutolayoutCenter persistConstraint:_pView relationmargins:UIEdgeInsetsMake(0, 0, 0, DisableConstrainsValueMAX) relationToItems:PYEdgeInsetsItemNull()];
    _lcph = [PYViewAutolayoutCenter persistConstraint:_pView size:CGSizeMake(0, DisableConstrainsValueMAX)].allValues.firstObject;
    [PYViewAutolayoutCenter persistConstraint:_psView relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:PYEdgeInsetsItemNull()];
    [PYViewAutolayoutCenter persistConstraint:_bsView relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:PYEdgeInsetsItemNull()];
    return self;
}

-(void) forBlock{
    if(self.block) _block();
}

-(void) setSchedule:(CGFloat)schedule{
    _schedule = MIN(MAX(0, schedule), 1);
    _lcph.constant = _bView.frameWidth * _schedule;
}

-(void) setPColor:(UIColor *)pColor{
    _pColor = pColor;
    _psView.backgroundColor = _pColor;
    [_pView setShadowColor:_pColor.CGColor shadowRadius:2];
}
-(void) setBColor:(UIColor *)bColor{
    _bColor = bColor;
    _bsView.backgroundColor = _bColor;
    self.backgroundColor = nil;
    [_bView setShadowColor:_bColor.CGColor shadowRadius:2];
}

-(void) setBackgroundColor:(UIColor *)backgroundColor{
    [super setBackgroundColor:[UIColor clearColor]];
}
kSOULDLAYOUTMSTART
self.schedule = self.schedule;
[_bsView setCornerRadiusAndBorder:self.frameHeight/2 -3 borderWidth:0 borderColor:[UIColor clearColor]];
[_psView setCornerRadiusAndBorder:self.frameHeight/2 - 3 borderWidth:0 borderColor:[UIColor clearColor]];
kSOULDLAYOUTMEND
@end

@interface PYWebView()

kPNSNA id <WKNavigationDelegate> navigationDelegatet;
kPNSNA id <WKUIDelegate> UIDelegatet;

kPNANA id <WKNavigationDelegate> navigationDelegatec;
kPNANA id <WKUIDelegate> UIDelegatec;
kPNSNN NSMutableDictionary<NSString* , NSDictionary *> * interfacesDict;
kPNSNN PYScheduleView * progressView;
kPNSNN WKNavigation * navigation;
kPNSNA NSTimer * timer;
@end

@implementation PYWebView{
@private
    WKUserScript * _baseScript;
}

kINITPARAMS{
    _interfacesDict = [NSMutableDictionary new];
    WKWebViewConfiguration * configuration = self.configuration;
    if(configuration.preferences == nil){
        // Webview的偏好设置
        configuration.preferences = [[WKPreferences alloc] init];
        configuration.preferences.minimumFontSize = 10;
        configuration.preferences.javaScriptEnabled = true;
    }
    
    // 通过js与webview内容交互配置
    if(configuration.userContentController == nil){
        configuration.userContentController = [[WKUserContentController alloc] init];
    }
    
    // 默认是不能通过JS自动打开窗口的，必须通过用户交互才能打开
//    configuration.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    
    _progressView = [PYScheduleView new];
    [self addSubview:_progressView];
    [PYViewAutolayoutCenter persistConstraint:_progressView size:CGSizeMake(DisableConstrainsValueMAX, 20)];
    [PYViewAutolayoutCenter persistConstraint:_progressView relationmargins:UIEdgeInsetsMake(0, 0 , DisableConstrainsValueMAX, 0) relationToItems:PYEdgeInsetsItemNull()];
    _progressView.hidden = YES;
    
    self.UIDelegatet = [PYWebViewUIDelegate new];
    self.navigationDelegatet = [PYWebViewNavigationDelegate new];
    self.UIDelegate = self.UIDelegatet;
    self.navigationDelegate = self.navigationDelegatet;
}

-(void) reloadInjectJS{
    @synchronized (self.configuration.userContentController.userScripts) {
        if(_baseScript){
            NSArray * allScript = [self.configuration.userContentController userScripts];
            if(allScript && allScript.count){
                [self.configuration.userContentController removeAllUserScripts];
                NSMutableArray * mds = [NSMutableArray new];
                [mds addObjectsFromArray:allScript];
                [mds removeObject:_baseScript];
                for (WKUserScript * userScript in mds) {
                    [self.configuration.userContentController addUserScript:userScript];
                }
            }
        }
        NSString * javaScript = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@/py_webview_hybird.js",[[NSBundle mainBundle] resourcePath]] encoding:NSUTF8StringEncoding error:nil];
        _baseScript = [[WKUserScript alloc] initWithSource:javaScript  injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:false];
        [self.configuration.userContentController addUserScript:_baseScript];
    }
}

- (nullable WKNavigation *)loadRequest:(NSURLRequest *)request{
    [self showProgress:0];
    return [super loadRequest:request];
}
- (nullable WKNavigation *)loadFileURL:(NSURL *)URL allowingReadAccessToURL:(NSURL *)readAccessURL{
    [self showProgress:0];
    if(IOS9_OR_LATER){
        return [super loadFileURL:URL allowingReadAccessToURL:readAccessURL];
    }else if([[NSFileManager defaultManager] fileExistsAtPath:URL.absoluteString]){
        NSString * html = [NSString stringWithContentsOfFile:URL.absoluteString encoding:NSUTF8StringEncoding error:nil];
        return [self loadHTMLString:html baseURL:readAccessURL];
    }
    return nil;
}
- (nullable WKNavigation *)loadHTMLString:(NSString *)string baseURL:(nullable NSURL *)baseURL{
    [self showProgress:0];
    return [super loadHTMLString:string baseURL:baseURL];
}
- (nullable WKNavigation *)loadData:(nonnull NSData *)data MIMEType:(NSString *)MIMEType characterEncodingName:(NSString *)characterEncodingName baseURL:(nonnull NSURL *)baseURL{
    [self showProgress:0];
    if(IOS9_OR_LATER){
        return [super loadData:data MIMEType:MIMEType characterEncodingName:characterEncodingName baseURL:baseURL];
    }
    return nil;
}

-(void) addJavascriptInterface:(nonnull NSObject *) interface name:(nullable NSString *) name{
    @synchronized (self.interfacesDict) {
        
        [self removeJavascriptInterfaceWithName:name];
        NSString * injectJS = [PYHybirdUtile parseInstanceToJsObject:interface name:name];
        WKUserScript * userScript = [[WKUserScript alloc] initWithSource:injectJS injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:false];
        [self.configuration.userContentController addUserScript:userScript];
        NSNumber * interfacePointer = @(((NSInteger)((__bridge void *)(interface))));
        [self.interfacesDict setObject:@{@"interfacePointer": interfacePointer, @"userScript":userScript} forKey:name];
        printf("injectJS:\n%s",injectJS.UTF8String);
    }
}
-(void) removeJavascriptInterfaceWithName:(nullable NSString *) name{
    @synchronized (self.interfacesDict) {
        [self.interfacesDict removeObjectForKey:name];
    }
}
-(void) showProgress:(CGFloat) progeress{
    if(!_isShowProgress) return;
    _progressView.schedule = progeress;
    _progressView.hidden = NO;
    _progressView.alpha = 1;
#pragma NSTimer导致的处理内存溢出
    kAssign(self);
    _progressView.block = ^{
        kStrong(self);
        [self scheduledTimerEnd];
    };
    if(self.timer) [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:300 target:_progressView selector:@selector(forBlock) userInfo:nil repeats:NO];
}
-(void) scheduledTimerEnd{
    NSError * erro = [NSError errorWithDomain:NSNetServicesErrorDomain code:1860504 userInfo:@{@"describle":@"Gateway Timeout"}];
    [self.navigationDelegatec webView:self didFailProvisionalNavigation:self.navigation withError:erro];
}
-(void) hiddenProgress{
    if(!_isShowProgress) return;
    if(self.timer) [self.timer invalidate];
    self.timer = nil;
    _progressView.schedule = 1;
    [UIView animateWithDuration:0.25 animations:^{
        _progressView.alpha = 0;
    } completion:^(BOOL finished) {
        if(_progressView.alpha != 1){
            _progressView.hidden = YES;
            _progressView.alpha = 1;
            
        }
    }];
}
-(void) setUIDelegate:(id<WKUIDelegate>)UIDelegate{
    if([UIDelegate isKindOfClass:[PYWebViewUIDelegate class]]){
        [super setUIDelegate:UIDelegate];
    }else{
        self.UIDelegatec = UIDelegate;
    }
}
-(void) setNavigationDelegate:(id<WKNavigationDelegate>)navigationDelegate{
    
    if(navigationDelegate && [navigationDelegate isKindOfClass:[PYWebViewNavigationDelegate class]]){
        [super setNavigationDelegate:navigationDelegate];
    }else{
        self.navigationDelegatec = navigationDelegate;
    }
}

-(void) clearConfigure{
    _navigationDelegatec = nil;
    _UIDelegatec = nil;
    [super setNavigationDelegate:nil];
    [super setUIDelegate:nil];
}
-(void) dealloc{
    [self stopLoading];
    [self clearConfigure];
    if(self.timer) [self.timer invalidate];
}



@end
