//
//  PYWebView.m
//  PYFrameWork
//
//  Created by wlpiaoyi on 16/9/5.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "PYWebView.h"
#import "PYWebView+PYSchedule.h"

@interface PYWebView()

kPNSNA id <WKNavigationDelegate> navigationDelegatet;
kPNSNA id <WKUIDelegate> UIDelegatet;

kPNANA id <WKNavigationDelegate> navigationDelegatec;
kPNANA id <WKUIDelegate> UIDelegatec;

kPNSNN NSMutableDictionary<NSString* , NSDictionary *> * interfacesDict;
kPNSNN WKNavigation * navigation;

kPNSNN PYScheduleView * progressView;
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
    
    [self initSchedule];
    
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
