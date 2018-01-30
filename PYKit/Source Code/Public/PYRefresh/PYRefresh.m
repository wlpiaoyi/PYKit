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
-(PYRefreshView *) py_headerView{
    return [self py_RefreshParam].headerView;
}
-(void) setPy_headerView:(PYRefreshView *)py_headerView{
    [self py_RefreshParam].headerView = py_headerView;
}
-(PYRefreshView *) py_footerView{
    return [self py_RefreshParam].footerView;
}
-(void) setPy_footerView:(PYRefreshView *)py_footerView{
    [self py_RefreshParam].footerView = py_footerView;
}
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
    if(self.py_headerView.state != kPYRefreshEnd && self.py_headerView.state != kPYRefreshNoThing && self.py_headerView.state != kPYRefreshDo){
        return;
    }
    [[self py_RefreshParam].headerLock lock];
    [self py_refresh_HeaderInsetOffset:YES];
    self.py_headerView.state = kPYRefreshDoing;
    [self setContentOffset:CGPointMake(self.contentOffset.x, -PYRefreshViewHeight) animated:YES];
    [[self py_RefreshParam].headerLock unlock];
}
-(void) py_beginRefreshFooter{
    if(self.py_blockRefreshFooter == nil) return;
    if(self.py_footerView.state != kPYRefreshEnd && self.py_footerView.state != kPYRefreshNoThing && self.py_footerView.state != kPYRefreshDo){
        return;
    }
    [[self py_RefreshParam].footerLock lock];
    [self py_refresh_FooterInsetOffset:YES];
    self.py_footerView.state = kPYRefreshDoing;
    [self setContentOffset:CGPointMake(self.contentOffset.x, MAX(self.contentSize.height, self.frameHeight) - self.frameHeight + PYRefreshViewHeight) animated:YES];
    [[self py_RefreshParam].footerLock unlock];
}
-(void) py_endRefreshHeader{
    if(self.py_blockRefreshHeader == nil) return;
    [[self py_RefreshParam].headerLock lock];
    CGPoint contentOffset = self.contentOffset;
    [self py_refresh_HeaderInsetOffset:NO];
    self.contentOffset = contentOffset;
    if(contentOffset.y < 0){
      [self setContentOffset:CGPointMake(contentOffset.x, 0) animated:YES];
    }
    self.py_headerView.state = kPYRefreshEnd;
    [[self py_RefreshParam].headerLock unlock];
}
-(void) py_endRefreshFooter{
    if(self.py_blockRefreshFooter == nil) return;
    [[self py_RefreshParam].footerLock lock];
    CGPoint contentOffset = self.contentOffset;
    [self py_refresh_FooterInsetOffset:NO];
    self.contentOffset = contentOffset;
    if(contentOffset.y > MAX(self.contentSize.height, self.frameHeight) - self.frameHeight){
        [self setContentOffset:CGPointMake(self.contentOffset.x, MAX(self.contentSize.height, self.frameHeight) - self.frameHeight) animated:YES];
    }
    self.py_footerView.state = kPYRefreshEnd;
    [[self py_RefreshParam].footerLock unlock];
}

@end

