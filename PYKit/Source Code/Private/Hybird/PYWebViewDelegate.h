//
//  PYWebViewDelegate.h
//  PYKit
//
//  Created by wlpiaoyi on 2019/2/28.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

extern NSString * PYWebViewPrompt;

@interface PYWebViewUIDelegate : NSObject<WKUIDelegate>

@end

@interface PYWebViewNavigationDelegate : NSObject<WKNavigationDelegate>

@end

