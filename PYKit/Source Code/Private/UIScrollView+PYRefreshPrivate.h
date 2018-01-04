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
kPNSNN PYRefreshView * headerView;
kPNSNN PYRefreshView * footerView;
kPNCNA void (^blockRefreshHeader)(UIScrollView * _Nonnull scrollView);
kPNCNA void (^blockRefreshFooter)( UIScrollView * _Nonnull scrollView);
@end

@interface UIScrollView(PYRefreshPrivate)
kPNSNN PYRefreshView * py_headerView;
kPNSNN PYRefreshView * py_footerView;
-(nonnull PYRefreshParam *) py_RefreshParam;
@end
