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

static NSString * PYWebViewPrompt = @"qqpiaoyi_prompt";

@interface PYWebView()<WKUIDelegate,WKNavigationDelegate>
@property (nonatomic, strong) WKWebView * webView;
@property (nonatomic, strong) NSMutableDictionary<NSString* , NSDictionary *> * interfacesDict;
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
}

-(nullable id ) loadRequest:(nonnull NSURLRequest *)request{
    return [_webView loadRequest:request];
}
-(nullable id) loadHTMLString:(nonnull NSString *)HTMLString{
    return [self loadHTMLString:HTMLString baseURL:[NSURL URLWithString:[[NSBundle mainBundle] resourcePath]]];
}
-(nullable id) loadHTMLString:(nonnull NSString *)HTMLString baseURL:(nullable NSURL *)baseURL{
    return [_webView loadHTMLString:HTMLString baseURL:baseURL];
}
- (nullable id)loadFileURL:(nonnull NSURL *)URL{
    return [self loadFileURL:URL allowingReadAccessToURL:URL];
}
- (nullable id)loadFileURL:(nonnull NSURL *)URL allowingReadAccessToURL:(NSURL *)readAccessURL{
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

#pragma WKNavigationDelegate ==>
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
}
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation{

}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
}
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
    
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
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
