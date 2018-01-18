//
//  UIScrollView+PYRefreshPrivate.h
//  PYKit
//
//  Created by wlpiaoyi on 2018/1/4.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import "pyutilea.h"
#import <objc/runtime.h>
#import "PYRefreshView.h"

@interface PYRefreshParam : NSObject
kPNSNN NSConditionLock * headerLock;
kPNSNN NSConditionLock * footerLock;
//kPNSNN dispatch_queue_t queueHeader;
//kPNSNN dispatch_group_t groupHeader;
//kPNSNN dispatch_queue_t queueFooter;
//kPNSNN dispatch_group_t groupFooter;
kPNSNN id  delegate;
kPNSNN PYRefreshView * headerView;
kPNSNN PYRefreshView * footerView;
kPNCNA void (^blockRefreshHeader)(UIScrollView * _Nonnull scrollView);
kPNCNA void (^blockRefreshFooter)( UIScrollView * _Nonnull scrollView);
@end

@interface PYRefreshScrollViewDelegate: NSObject<UIScrollViewDelegate>
@end

@interface UIScrollView(PYRefreshPrivate)
kPNSNN PYRefreshView * py_headerView;
kPNSNN PYRefreshView * py_footerView;
-(void) py_refresh_HeaderInsetOffset:(BOOL) flag;
-(void) py_refresh_FooterInsetOffset:(BOOL) flag;
-(nonnull PYRefreshParam *) py_RefreshParam;
@end
