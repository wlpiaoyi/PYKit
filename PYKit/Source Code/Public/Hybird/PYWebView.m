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
@interface PYScheduleView:UIView
PYPNA CGFloat schedule;
PYPNSNN UIColor * pColor;
PYPNSNN UIColor * bColor;
PYSOULDLAYOUTP
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
PYSOULDLAYOUTMSTART
self.schedule = self.schedule;
[_bsView setCornerRadiusAndBorder:self.frameHeight/2 -3 borderWidth:0 borderColor:[UIColor clearColor]];
[_psView setCornerRadiusAndBorder:self.frameHeight/2 - 3 borderWidth:0 borderColor:[UIColor clearColor]];
PYSOULDLAYOUTMEND
@end

static NSString * PYWebViewPrompt = @"qqpiaoyi_prompt";

@interface PYWebView()<WKUIDelegate,WKNavigationDelegate>
@property (nonatomic, strong) WKWebView * webView;
@property (nonatomic, strong) NSMutableDictionary<NSString* , NSDictionary *> * interfacesDict;
PYPNSNN PYScheduleView * progressView;
PYPNSNN WKNavigation * navigation;
PYPNSNA NSTimer * timer;
@end

@implementation PYWebView

-(instancetype) init{
    if (self = [super init]) {
        [self initParams];
    }
    return self;
}
-(instancetype) initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self initParams];
    }
    return self;
}
-(void) initParams{
    _interfacesDict = [NSMutableDictionary new];
    WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc] init];
    // Webview的偏好设置
    configuration.preferences = [[WKPreferences alloc] init];
    configuration.preferences.minimumFontSize = 10;
    configuration.preferences.javaScriptEnabled = true;
    // 默认是不能通过JS自动打开窗口的，必须通过用户交互才能打开
    configuration.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    // 通过js与webview内容交互配置
    configuration.userContentController = [[WKUserContentController alloc] init];
    NSString * javaScript = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@/hybird.js",[[NSBundle mainBundle] resourcePath]] encoding:NSUTF8StringEncoding error:nil];
    WKUserScript * userScript = [[WKUserScript alloc] initWithSource:javaScript  injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:false];
    [configuration.userContentController addUserScript:userScript];
    _webView = [[WKWebView alloc] initWithFrame:self.bounds configuration:configuration];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    [self addSubview:_webView];
    [PYViewAutolayoutCenter persistConstraint:_webView relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:PYEdgeInsetsItemNull()];
    _progressView = [PYScheduleView new];
    [self addSubview:_progressView];
    [PYViewAutolayoutCenter persistConstraint:_progressView size:CGSizeMake(DisableConstrainsValueMAX, 20)];
    [PYViewAutolayoutCenter persistConstraint:_progressView relationmargins:UIEdgeInsetsMake(0, 0 , DisableConstrainsValueMAX, 0) relationToItems:PYEdgeInsetsItemNull()];
    _progressView.hidden = YES;
}
-(nullable id ) loadRequest:(nonnull NSURLRequest *)request{
    _progressView.hidden = NO;
    return [_webView loadRequest:request];
}
-(nullable id) loadHTMLString:(nonnull NSString *)HTMLString{
    return [self loadHTMLString:HTMLString baseURL:[NSURL URLWithString:[[NSBundle mainBundle] resourcePath]]];
}
-(nullable id) loadHTMLString:(nonnull NSString *)HTMLString baseURL:(nullable NSURL *)baseURL{
    _progressView.hidden = YES;
    return [_webView loadHTMLString:HTMLString baseURL:baseURL];
}
- (nullable id)loadFileURL:(nonnull NSURL *)URL{
    return [self loadFileURL:URL allowingReadAccessToURL:URL];
}
- (nullable id)loadFileURL:(nonnull NSURL *)URL allowingReadAccessToURL:(NSURL *)readAccessURL{
    _progressView.hidden = YES;
    if(![[NSFileManager defaultManager] fileExistsAtPath:URL.absoluteString]){
        return nil;
    }
    if (IOS9_OR_LATER) {
        return  [_webView loadFileURL:URL allowingReadAccessToURL:readAccessURL];
    }else{
        NSString * html = [NSString stringWithContentsOfFile:URL.absoluteString encoding:NSUTF8StringEncoding error:nil];
        return [self loadHTMLString:html baseURL:readAccessURL];
    }
}

-(void) addJavascriptInterface:(nonnull NSObject *) interface name:(nullable NSString *) name{
    @synchronized (self.interfacesDict) {
        
        [self removeJavascriptInterfaceWithName:name];
        WKUserScript * userScript = [[WKUserScript alloc] initWithSource:[PYHybirdUtile parseInstanceToJsObject:interface name:name] injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:false];
        [_webView.configuration.userContentController addUserScript:userScript];
        NSNumber * interfacePointer = @(((NSInteger)((__bridge void *)(interface))));
        [self.interfacesDict setObject:@{@"interfacePointer": interfacePointer, @"userScript":userScript} forKey:name];
        
    }
}
-(void) removeJavascriptInterfaceWithName:(nullable NSString *) name{
    @synchronized (self.interfacesDict) {
        [self.interfacesDict removeObjectForKey:name];
    }
}
-(void) showProgress:(CGFloat) progeress{
    _progressView.schedule = progeress;
    _progressView.hidden = NO;
    if(self.timer) [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:30 repeats:NO block:^(NSTimer * _Nonnull timer) {
        [self hiddenProgress];
    }];
}
-(void) hiddenProgress{
    if(self.timer) [self.timer invalidate];
    self.timer = nil;
    _progressView.schedule = 1;
    [UIView animateWithDuration:0.25 animations:^{
        _progressView.alpha = 0;
    } completion:^(BOOL finished) {
        _progressView.hidden = YES;
        _progressView.alpha = 1;
    }];
}

#pragma WKNavigationDelegate ==>
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    self.navigation = navigation;
    [self showProgress:0.3];
}
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    self.navigation = navigation;
    _progressView.schedule = 0.6;
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    if(self.navigation == navigation) [self hiddenProgress];
}
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
    _progressView.schedule = 0.8;
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    if(self.navigation == navigation) [self hiddenProgress];
}
#pragma WKNavigationDelegate <==

#pragma WKUIDelegate ==>
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIView * view = [UIView new];
    [view dialogShowWithTitle:webView.title.length ? webView.title : @"提示" message:message block:^(UIView * _Nonnull view, NSUInteger index) {
        [view dialogHidden];
        completionHandler();
    } buttonNames:@[@"确定"]];
}
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    UIView * view = [UIView new];
    [view dialogShowWithTitle:webView.title message:message block:^(UIView * _Nonnull view, NSUInteger index) {
        [view dialogHidden];
        completionHandler(index != 0);
    } buttonNames:@[@"确定",@"取消"]];
}
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    if ([prompt isEqual:PYWebViewPrompt]) {
        NSDictionary * jsDict = [[defaultText dataUsingEncoding:NSUTF8StringEncoding] toDictionary];
        NSDictionary * interfaceDict = self.interfacesDict[jsDict[@"instanceName"]];
        NSDictionary * resultDict = [PYHybirdUtile invokeInstanceFromJs:jsDict interfaceDict:interfaceDict];
        completionHandler([[resultDict toData] toString]);
    }else{
        completionHandler(@"success");
    }
}
#pragma WKUIDelegate <==


@end
