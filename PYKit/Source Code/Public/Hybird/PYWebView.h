//
//  PYWebView.h
//  PYFrameWork
//
//  Created by wlpiaoyi on 16/9/5.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PYWebView : UIView
//==>加载web
-(nullable id ) loadRequest:(nonnull NSURLRequest *)request;
-(nullable id) loadHTMLString:(nonnull NSString *)HTMLString baseURL:(nullable NSURL *)baseURL;
-(nullable id) loadHTMLString:(nonnull NSString *)HTMLString;
-(nullable id) loadFileURL:(nonnull NSURL *)URL;
-(nullable id) loadFileURL:(nonnull NSURL *)URL allowingReadAccessToURL:(nullable NSURL *)readAccessURL;
///<=加载web
-(void) addJavascriptInterface:(nonnull NSObject *) interface name:(nullable NSString *) name;
-(void) removeJavascriptInterfaceWithName:(nullable NSString *) name;
@end
