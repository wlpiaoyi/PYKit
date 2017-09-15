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
//==>加载web

- (nullable WKNavigation *)loadRequest:(NSURLRequest *)request;
- (nullable WKNavigation *)loadFileURL:(NSURL *)URL allowingReadAccessToURL:(NSURL *)readAccessURL;
- (nullable WKNavigation *)loadHTMLString:(NSString *)string baseURL:(nullable NSURL *)baseURL;
///<=加载web
-(void) addJavascriptInterface:(nonnull NSObject *) interface name:(nullable NSString *) name;
-(void) removeJavascriptInterfaceWithName:(nullable NSString *) name;
@end
