//
//  UIScrollView+PYRefreshPrivate.m
//  PYKit
//
//  Created by wlpiaoyi on 2018/1/4.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import "UIScrollView+PYRefreshPrivate.h"
@protocol PYRefreshDelegateHookTag<NSObject>
@end

void * PYRefreshPointer = &PYRefreshPointer;

@interface UIScrollView()
kPNSNN PYRefreshView * py_headerView;
kPNSNN PYRefreshView * py_footerView;
kPNCNA void (^py_blockRefreshHeader)(UIScrollView * _Nonnull scrollView);
kPNCNA void (^py_blockRefreshFooter)(UIScrollView * _Nonnull scrollView);
-(void) py_beginRefreshHeader;
-(void) py_beginRefreshFooter;
-(void) py_endRefreshHeader;
-(void) py_endRefreshFooter;
@end

@interface PYRefreshScrollViewDelegate()
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDecelerating:(nonnull UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(nonnull UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
@end

@implementation UIScrollView(PYRefreshPrivate)

- (void)py_refresh_setContentOffset:(CGPoint)contentOffset{
    [self py_refresh_setContentOffset:contentOffset];
    if(self.dragging){
        PYRefreshView * refreshView = nil;
        if(self.contentOffset.y < 0){
            if(![self py_refresh_canHeaderExce]) return;
            refreshView  = self.py_headerView;
            refreshView.scheduleHeight = -self.contentOffset.y;
        }else if(self.contentOffset.y + self.frameHeight > MAX(self.contentSize.height, self.frameHeight)){
            if(![self py_refresh_canFooterExce]) return;
            refreshView  = self.py_footerView;
            refreshView.scheduleHeight = self.contentOffset.y + self.frameHeight - MAX(self.contentSize.height, self.frameHeight);
        }
        if(refreshView){
            refreshView.frameWidth = self.frameWidth;
            if(refreshView.frameHeight <  PYRefreshViewHeight
               && (refreshView.state ==  kPYRefreshDo
                   || refreshView.state ==  kPYRefreshNoThing)){
                   refreshView.state = kPYRefreshBegin;
               }else if(refreshView.frameHeight >=  PYRefreshViewHeight
                        && refreshView.state == kPYRefreshBegin){
                   refreshView.state = kPYRefreshDo;
               }
        }
    }else{
        PYRefreshView * refreshView = nil;
        if(self.contentOffset.y < 0){
            if(![self py_refresh_canHeaderExce]) return;
            refreshView  = self.py_headerView;
            if(refreshView.state != kPYRefreshNoThing && refreshView.state != kPYRefreshEnd) return;
            refreshView.scheduleHeight = -self.contentOffset.y;
        }else if(self.contentOffset.y + self.frameHeight > MAX(self.contentSize.height, self.frameHeight)){
            if(![self py_refresh_canFooterExce]) return;
            refreshView  = self.py_footerView;
            if(refreshView.state != kPYRefreshNoThing && refreshView.state != kPYRefreshEnd) return;
            refreshView.scheduleHeight = self.contentOffset.y + self.frameHeight - MAX(self.contentSize.height, self.frameHeight);
        }
    }
}
-(void) py_refresh_setDelegate:(id<UIScrollViewDelegate>)delegate{
    [self py_refresh_setDelegate:delegate];
    if(delegate == nil || [delegate isKindOfClass:[PYRefreshScrollViewDelegate class]]) return;
    if(class_conformsToProtocol([delegate class], @protocol(PYRefreshDelegateHookTag))) return;
    @synchronized([delegate class]){
        if(!class_conformsToProtocol([delegate class], @protocol(PYRefreshDelegateHookTag))){
            class_addProtocol([delegate class], @protocol(PYRefreshDelegateHookTag));
            [UIScrollView PY_REFRESH_HOOKDELEGATE:delegate action:@selector(scrollViewWillBeginDragging:)];
            [UIScrollView PY_REFRESH_HOOKDELEGATE:delegate action:@selector(scrollViewDidScroll:)];
            [UIScrollView PY_REFRESH_HOOKDELEGATE:delegate action:@selector(scrollViewDidEndDecelerating:)];
            [UIScrollView PY_REFRESH_HOOKDELEGATE:delegate action:@selector(scrollViewDidEndDragging:willDecelerate:)];
        }
    }
}
+(void) PY_REFRESH_HOOKDELEGATE:(id<UIScrollViewDelegate>) delegate action:(SEL) action{
    Method m1 = class_getInstanceMethod([delegate class], action);
    Method m2 = class_getInstanceMethod([PYRefreshScrollViewDelegate class], action);
    Method m3 = class_getInstanceMethod([PYRefreshScrollViewDelegate class], sel_getUid([NSString stringWithFormat:@"hook_%s",sel_getName(action)].UTF8String));
    Method m4 = class_getInstanceMethod([PYRefreshScrollViewDelegate class], sel_getUid([NSString stringWithFormat:@"exchage_%s",sel_getName(action)].UTF8String));
    if(m1){
        class_addMethod([delegate class], method_getName(m4), method_getImplementation(m2), method_getTypeEncoding(m4));
        class_addMethod([delegate class], method_getName(m3), method_getImplementation(m1), method_getTypeEncoding(m3));
        class_replaceMethod([delegate class], method_getName(m1), method_getImplementation(m3), method_getTypeEncoding(m1));
    }else if(m2){
        kPrintLogln("PYRefreshView delegate add method [%s]", method_getName(m2));
        if(!class_addMethod([delegate class], method_getName(m2), method_getImplementation(m2), method_getTypeEncoding(m2))){
            kPrintErrorln("PYRefreshView delegate add method [%s] erro", method_getName(m2));
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
-(void) py_refresh_HeaderInsetOffset:(BOOL) flag{
    UIEdgeInsets inset = self.contentInset;
    inset.top = flag ? PYRefreshViewHeight : 0;
    self.contentInset = inset;
    self.userInteractionEnabled = true;
}
-(void) py_refresh_FooterInsetOffset:(BOOL) flag{
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = flag ? PYRefreshViewHeight : 0;
    self.contentInset = inset;
    self.userInteractionEnabled = true;
}

-(BOOL) py_refresh_canHeaderExce{
    if(!self.py_blockRefreshHeader) return false;
    if(self.py_headerView.state == kPYRefreshDoing) return false;
    return true;
}
-(BOOL) py_refresh_canFooterExce{
    if(!self.py_blockRefreshFooter) return false;
    if(self.py_footerView.state == kPYRefreshDoing) return false;
    return true;
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
            m1 = class_getInstanceMethod([UIScrollView class], @selector(py_refresh_setDelegate:));
            m2 = class_getInstanceMethod([UIScrollView class], @selector(setDelegate:));
            method_exchangeImplementations(m1, m2);
        });
        param.delegate = [PYRefreshScrollViewDelegate new];
        if(!self.delegate)self.delegate = param.delegate;
        self.py_headerView = [PYRefreshView new];
        self.py_footerView = [PYRefreshView new];
        self.py_headerView.type = kPYRefreshHeader;
        self.py_footerView.type = kPYRefreshFooter;
        [self addSubview:self.py_headerView];
        [self addSubview:self.py_footerView];
        [PYUtile getCurrentController].automaticallyAdjustsScrollViewInsets = false;
    }
    kDISPATCH_MAIN_THREAD(^{
        param.headerView.hidden = param.blockRefreshHeader == nil;
        param.footerView.hidden = param.blockRefreshFooter == nil;
    });
    
    if(self.delegate == nil || [self.delegate isKindOfClass:[PYRefreshScrollViewDelegate class]]) return param;
    if(class_conformsToProtocol([self.delegate class], @protocol(PYRefreshDelegateHookTag))) return param;
    @synchronized([self.delegate class]){
        if(!class_conformsToProtocol([self.delegate class], @protocol(PYRefreshDelegateHookTag))){
            self.delegate = self.delegate;
        }
    }
    return param;
}

@end

@implementation PYRefreshScrollViewDelegate
- (void) hook_scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self hook_scrollViewWillBeginDragging:scrollView];
    [self exchage_scrollViewWillBeginDragging:scrollView];
}
-(void) exchage_scrollViewWillBeginDragging:(UIScrollView *)scrollView{}
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y < 0){
        if(![scrollView py_refresh_canHeaderExce]) return;
        scrollView.py_headerView.state = kPYRefreshBegin;
    }else if(scrollView.contentOffset.y + scrollView.frameHeight > MAX(scrollView.contentSize.height, scrollView.frameHeight)){
        if(![scrollView py_refresh_canFooterExce]) return;
        scrollView.py_footerView.state = kPYRefreshBegin;
    }
}
//- (void) hook_scrollViewDidScroll:(UIScrollView *)scrollView{
//    [self hook_scrollViewDidScroll:scrollView];
//    [self exchage_scrollViewDidScroll:scrollView];
//}
//-(void) exchage_scrollViewDidScroll:(UIScrollView *)scrollView{}
//- (void)scrollViewDidScroll:(nonnull UIScrollView *)scrollView{
//
//}

- (void) hook_scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self hook_scrollViewDidEndDecelerating:scrollView];
    [self exchage_scrollViewDidEndDecelerating:scrollView];
}
-(void) exchage_scrollViewDidEndDecelerating:(UIScrollView *)scrollView{}
- (void)scrollViewDidEndDecelerating:(nonnull UIScrollView *)scrollView{
    PYRefreshView * refreshView = nil;
    if(scrollView.contentOffset.y < 0){
        if(![scrollView py_refresh_canHeaderExce]) return;
        refreshView  = scrollView.py_headerView;
    }else if(scrollView.contentOffset.y + scrollView.frameHeight > MAX(scrollView.contentSize.height, scrollView.frameHeight)){
        if(![scrollView py_refresh_canFooterExce]) return;
        refreshView  = scrollView.py_footerView;
    }
    if(!refreshView) return;
    
    if(refreshView.state != kPYRefreshDo){
        refreshView.state = kPYRefreshNoThing;
        return;
    }
    if(refreshView.type == kPYRefreshHeader){
        [scrollView py_beginRefreshHeader];
        [scrollView py_RefreshParam].blockRefreshHeader(scrollView);
    }else{
        [scrollView py_beginRefreshFooter];
        [scrollView py_RefreshParam].blockRefreshFooter(scrollView);
    }
}

- (void) hook_scrollViewDidEndDragging:(nonnull UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self hook_scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    [self exchage_scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}
-(void) exchage_scrollViewDidEndDragging:(nonnull UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{}
- (void)scrollViewDidEndDragging:(nonnull UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    PYRefreshView * refreshView = nil;
    if(scrollView.contentOffset.y < 0){
        if(![scrollView py_refresh_canHeaderExce]) return;
        refreshView  = scrollView.py_headerView;
    }else if(scrollView.contentOffset.y + scrollView.frameHeight > MAX(scrollView.contentSize.height, scrollView.frameHeight)){
        if(![scrollView py_refresh_canFooterExce]) return;
        refreshView  = scrollView.py_footerView;
    }
    if(!refreshView) return;
    
    if(refreshView.state != kPYRefreshDo){
        refreshView.state = kPYRefreshNoThing;
        return;
    }
    if(refreshView.type == kPYRefreshHeader){
        [scrollView py_refresh_HeaderInsetOffset:YES];
    }else{
        [scrollView py_refresh_FooterInsetOffset:YES];
    }
    if(!decelerate){
        [self scrollViewDidEndDecelerating:scrollView];
    }
}
@end

@implementation PYRefreshParam
-(instancetype) init{
    self = [super init];
//    self.queueHeader = dispatch_queue_create("org.wlpiaoyi.refresh.header", DISPATCH_QUEUE_CONCURRENT);
//    self.groupHeader = dispatch_group_create();
//    self.queueFooter = dispatch_queue_create("org.wlpiaoyi.refresh.footer", DISPATCH_QUEUE_CONCURRENT);
//    self.groupFooter = dispatch_group_create();
    self.footerLock = [NSConditionLock new];
    self.headerLock = [NSConditionLock new];
    return self;
}

@end;
