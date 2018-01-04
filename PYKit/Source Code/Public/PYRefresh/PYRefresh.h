//
//  PYRefresh.h
//  PYKit
//
//  Created by wlpiaoyi on 2018/1/2.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pyutilea.h"

@interface UIScrollView(pyrefresh)
kPNCNA void (^py_blockRefreshHeader)(UIScrollView * _Nonnull scrollView);
kPNCNA void (^py_blockRefreshFooter)(UIScrollView * _Nonnull scrollView);
-(void) py_beginRefreshHeader;
-(void) py_beginRefreshFooter;
-(void) py_endRefreshHeader;
-(void) py_endRefreshFooter;
@end
