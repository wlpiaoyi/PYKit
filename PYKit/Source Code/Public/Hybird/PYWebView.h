//
//  PYWebView.h
//  PYFrameWork
//
//  Created by wlpiaoyi on 16/9/5.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface PYWebView : WKWebView
@property BOOL isShowProgress;
//==>加载web
- (nullable WKNavigation *)loadRequest:(nonnull NSURLRequest *)request;
- (nullable WKNavigation *)loadFileURL:(nonnull NSURL *)URL allowingReadAccessToURL:(nullable NSURL *)readAccessURL;
- (nullable WKNavigation *)loadHTMLString:(nonnull NSString *)string baseURL:(nullable NSURL *)baseURL;
///<=加载web
-(void) addJavascriptInterface:(nonnull NSObject *) interface name:(nullable NSString *) name;
-(void) removeJavascriptInterfaceWithName:(nullable NSString *) name;
-(void) reloadInjectJS;
@end
