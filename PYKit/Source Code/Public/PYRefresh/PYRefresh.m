//
//  PYRefresh.m
//  PYKit
//
//  Created by wlpiaoyi on 2018/1/2.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import "PYRefresh.h"
#import "UIScrollView+PYRefreshPrivate.h"

@implementation UIScrollView(pyrefresh)
-(void (^) (UIScrollView * _Nonnull scrollView)) py_blockRefreshHeader{
    return [self py_RefreshParam].blockRefreshHeader;
}
-(void) setPy_blockRefreshHeader:(void (^)(UIScrollView *))py_blockRefreshHeader{
    [self py_RefreshParam].blockRefreshHeader = py_blockRefreshHeader;
}
-(void (^) ( UIScrollView * _Nonnull scrollView)) py_blockRefreshFooter{
    return [self py_RefreshParam].blockRefreshFooter;
}
-(void) setPy_blockRefreshFooter:(void (^)(UIScrollView *))py_blockRefreshFooter{
    [self py_RefreshParam].blockRefreshFooter = py_blockRefreshFooter;
}
-(void) py_beginRefreshHeader{
    if(self.py_blockRefreshHeader == nil) return;
    if(self.py_headerView.state != kPYRefreshEnd && self.py_headerView.state != kPYRefreshNoThing && self.py_headerView.state != kPYRefreshDoing){
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block CGPoint contentOffset = CGPointMake(0, 999999999 - 1);
        dispatch_async(dispatch_get_main_queue(), ^{
            contentOffset = self.contentOffset;
            self.userInteractionEnabled = true;
        });
        while (contentOffset.y  > 999999999 - 2) {
            [NSThread sleepForTimeInterval:0.01];
        }
        CGPoint t_contentOffset = CGPointMake(0, -PYRefreshViewHeight);
        CGFloat y_value = (contentOffset.y - t_contentOffset.y) / 20;
        while (ABS(contentOffset.y - t_contentOffset.y) > ABS(y_value)) {
            contentOffset.y -= y_value;
            y_value -= y_value/30;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.contentOffset = contentOffset;
            });
            [NSThread sleepForTimeInterval:0.005];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            UIEdgeInsets inset = self.contentInset;
            inset.top = PYRefreshViewHeight;
            self.contentInset = inset;
            self.userInteractionEnabled = true;
        });
    });
}
-(void) py_beginRefreshFooter{
    if(self.py_blockRefreshFooter == nil) return;
    if(self.py_footerView.state != kPYRefreshEnd && self.py_footerView.state != kPYRefreshNoThing && self.py_footerView.state != kPYRefreshDoing){
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block CGPoint contentOffset = CGPointMake(0, 999999999 - 1);
        __block CGSize contentSize = CGSizeZero;
        __block CGFloat frameHeight = 0;
        dispatch_async(dispatch_get_main_queue(), ^{
            contentOffset = self.contentOffset;
            contentSize = self.contentSize;
            frameHeight = self.frameHeight;
            self.userInteractionEnabled = true;
        });
        while (contentOffset.y  > 999999999 - 2) {
            [NSThread sleepForTimeInterval:0.01];
        }
        CGPoint t_contentOffset = CGPointMake(0, MAX(contentSize.height, frameHeight) - frameHeight + PYRefreshViewHeight);
        CGFloat y_value = (contentOffset.y - t_contentOffset.y) / 20;
        while (ABS(contentOffset.y - t_contentOffset.y) > ABS(y_value)) {
            contentOffset.y -= y_value;
            y_value -= y_value/30;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.contentOffset = contentOffset;
            });
            [NSThread sleepForTimeInterval:0.005];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            UIEdgeInsets inset = self.contentInset;
            inset.bottom = PYRefreshViewHeight;
            self.contentInset = inset;
            self.userInteractionEnabled = true;
        });
    });
}
-(void) py_endRefreshHeader{
    if(self.py_blockRefreshHeader == nil) return;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block CGPoint contentOffset = CGPointMake(0, -CGFLOAT_MAX);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.py_headerView.state = kPYRefreshEnd;
            contentOffset = self.contentOffset;
            self.userInteractionEnabled = false;
        });
        const CGFloat v = PYRefreshViewHeight / 30.0;
        while (contentOffset.y < 0) {
            dispatch_async(dispatch_get_main_queue(),^{
                contentOffset = self.contentOffset;
                contentOffset.y += v;
                self.contentOffset = contentOffset;
            });
            [NSThread sleepForTimeInterval:0.005];
        }
        dispatch_async(dispatch_get_main_queue(),^{
            UIEdgeInsets inset = self.contentInset;
            inset.top = 0;
            self.contentInset = inset;
            self.contentOffset = CGPointMake(0, 0);
            self.userInteractionEnabled = true;
        });
    });
}
-(void) py_endRefreshFooter{
    if(self.py_blockRefreshFooter == nil) return;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block CGPoint contentOffset = CGPointMake(0, CGFLOAT_MAX);
        __block CGFloat contentHeight = 0;
        __block CGFloat frameHeight = 0;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.py_footerView.state = kPYRefreshEnd;
            contentOffset = self.contentOffset;
            contentHeight = self.contentSize.height;
            frameHeight = self.frameHeight;
            self.userInteractionEnabled = false;
        });
        const CGFloat v = PYRefreshViewHeight / 30.0;
        while (contentOffset.y > MAX(contentHeight, frameHeight) - frameHeight) {
            dispatch_async(dispatch_get_main_queue(),^{
                contentOffset = self.contentOffset;
                contentOffset.y -= v;
                self.contentOffset = contentOffset;
                contentHeight = self.contentSize.height;
                frameHeight = self.frameHeight;
            });
            [NSThread sleepForTimeInterval:0.01];
        }
        dispatch_async(dispatch_get_main_queue(),^{
            UIEdgeInsets inset = self.contentInset;
            inset.bottom = 0;
            self.contentInset = inset;
            self.contentOffset = CGPointMake(0, MAX(self.contentSize.height, self.frameHeight) - self.frameHeight);
            self.userInteractionEnabled = true;
        });
    });
}

@end

