//
//  UIScrollView+PYRefreshPrivate.m
//  PYKit
//
//  Created by wlpiaoyi on 2018/1/4.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import "UIScrollView+PYRefreshPrivate.h"

void * PYRefreshPointer = &PYRefreshPointer;

@interface UIScrollView()
-(void) py_beginRefreshHeader;
-(void) py_beginRefreshFooter;
-(void) py_endRefreshHeader;
-(void) py_endRefreshFooter;
@end

@implementation UIScrollView(PYRefreshPrivate)
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

- (void)py_refresh_setContentOffset:(CGPoint)contentOffset{
    [self py_refresh_setContentOffset:contentOffset];
    UIScrollView * scrollView = self;
    if(scrollView.isDragging){
        if(scrollView.py_headerView.state == kPYRefreshEnd || scrollView.py_headerView.state == kPYRefreshNoThing){
            scrollView.py_headerView.state = kPYRefreshBegin;
        }else if(scrollView.py_footerView.state == kPYRefreshEnd || scrollView.py_footerView.state == kPYRefreshNoThing){
            scrollView.py_footerView.state = kPYRefreshBegin;
        }
    }else{
        if(scrollView.py_headerView.state == kPYRefreshDo && scrollView.contentOffset.y < 0){
            if(scrollView.py_headerView.frameHeight >= PYRefreshViewHeight){
                scrollView.py_headerView.state = kPYRefreshDoing;
                [scrollView py_beginRefreshHeader];
                if([scrollView py_RefreshParam].blockRefreshHeader){
                    [scrollView py_RefreshParam].blockRefreshHeader(scrollView);
                }
            }
        }else if(scrollView.py_footerView.state == kPYRefreshDo && scrollView.contentOffset.y + scrollView.frameHeight > MAX(scrollView.contentSize.height, scrollView.frameHeight)){
            if(scrollView.py_footerView.frameHeight >= PYRefreshViewHeight){
                scrollView.py_footerView.state = kPYRefreshDoing;
                [scrollView py_beginRefreshFooter];
                if([scrollView py_RefreshParam].blockRefreshFooter){
                    [scrollView py_RefreshParam].blockRefreshFooter(scrollView);
                }
            }
        }
    }
    if(scrollView.contentOffset.y < 0){
        if(scrollView.py_headerView.state != kPYRefreshDoing){
            scrollView.py_headerView.frameWidth = scrollView.frameWidth;
            scrollView.py_headerView.scheduleHeight = -scrollView.contentOffset.y;
            if(scrollView.py_headerView.frameHeight < PYRefreshViewHeight){
                if(scrollView.py_headerView.state == kPYRefreshDo){
                    scrollView.py_headerView.state = kPYRefreshBegin;
                }
            }else if(self.isDragging == true){
                scrollView.py_headerView.state = kPYRefreshDo;
            }
        }
    }else if(scrollView.contentOffset.y + scrollView.frameHeight > MAX(scrollView.contentSize.height, scrollView.frameHeight)){
        if(scrollView.py_footerView.state != kPYRefreshDoing){
            scrollView.py_footerView.scheduleHeight = scrollView.contentOffset.y + scrollView.frameHeight - MAX(scrollView.contentSize.height, scrollView.frameHeight);
            scrollView.py_footerView.frameWidth = scrollView.frameWidth;
            if(scrollView.py_footerView.frameHeight < PYRefreshViewHeight){
                if(scrollView.py_footerView.state == kPYRefreshDo){
                    scrollView.py_footerView.state = kPYRefreshBegin;
                }
            }else if(self.isDragging == true){
                scrollView.py_footerView.state = kPYRefreshDo;
            }
        }
    }
}
-(void) py_refresh_setContentSize:(CGSize)contentSize{
    [self py_refresh_setContentSize:contentSize];
    self.py_headerView.frameX = 0;
    self.py_footerView.frameX = 0;
    self.py_headerView.frameY = -self.py_headerView.frameHeight;
    self.py_footerView.frameY = MAX(contentSize.height, self.frameHeight);
    
}
-(void) py_refresh_layoutSubviews{
    [self py_refresh_layoutSubviews];
    self.py_headerView.frameWidth = self.frameWidth;
    self.py_footerView.frameWidth = self.frameWidth;
    [self setContentSize:self.contentSize];
}

-(PYRefreshParam *) py_RefreshParam{
    PYRefreshParam * param = objc_getAssociatedObject(self, PYRefreshPointer);
    if(param == nil){
        param = [PYRefreshParam new];
        objc_setAssociatedObject(self, PYRefreshPointer, param, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        kDISPATCH_ONCE_BLOCK(^{
            Method m1 = class_getInstanceMethod([UIScrollView class], @selector(py_refresh_layoutSubviews));
            Method m2 = class_getInstanceMethod([UIScrollView class], @selector(layoutSubviews));
            method_exchangeImplementations(m1, m2);
            m1 = class_getInstanceMethod([UIScrollView class], @selector(py_refresh_setContentSize:));
            m2 = class_getInstanceMethod([UIScrollView class], @selector(setContentSize:));
            method_exchangeImplementations(m1, m2);
            m1 = class_getInstanceMethod([UIScrollView class], @selector(py_refresh_setContentOffset:));
            m2 = class_getInstanceMethod([UIScrollView class], @selector(setContentOffset:));
            method_exchangeImplementations(m1, m2);
        });
        self.py_headerView = [PYRefreshView new];
        self.py_footerView = [PYRefreshView new];
        self.py_headerView.type = kPYRefreshHeader;
        self.py_footerView.type = kPYRefreshFooter;
        [self addSubview:self.py_headerView];
        [self addSubview:self.py_footerView];
    }
    param.headerView.hidden = param.blockRefreshHeader == nil;
    param.footerView.hidden = param.blockRefreshFooter == nil;
    return param;
}

@end


@implementation PYRefreshParam
-(instancetype) init{
    self = [super init];
    return self;
}
@end;
