//
//  PYWebView+PYSchedule.m
//  PYKit
//
//  Created by wlpiaoyi on 2019/12/7.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import "PYWebView+PYSchedule.h"

@interface PYWebView()

kPNSNA id <WKNavigationDelegate> navigationDelegatet;
kPNSNA id <WKUIDelegate> UIDelegatet;

kPNANA id <WKNavigationDelegate> navigationDelegatec;
kPNANA id <WKUIDelegate> UIDelegatec;
kPNSNN NSMutableDictionary<NSString* , NSDictionary *> * interfacesDict;
kPNSNN WKNavigation * navigation;

kPNSNN PYScheduleView * progressView;
kPNSNA NSTimer * timer;

@end

@implementation PYWebView(PYSchedule)

-(void) initSchedule{
    self.progressView = [PYScheduleView new];
    [self addSubview:self.progressView];
    [PYViewAutolayoutCenter persistConstraint:self.progressView size:CGSizeMake(DisableConstrainsValueMAX, 7)];
    [PYViewAutolayoutCenter persistConstraint:self.progressView relationmargins:UIEdgeInsetsMake(0, 0 , DisableConstrainsValueMAX, 0) relationToItems:PYEdgeInsetsItemNull()];
    self.progressView.hidden = YES;
}

-(void) showProgress:(CGFloat) progeress{
    if(!self.isShowProgress) return;
    self.progressView.schedule = progeress;
    self.progressView.hidden = NO;
    self.progressView.alpha = 1;
#pragma NSTimer导致的处理内存溢出
    kAssign(self);
    self.progressView.block = ^{
        kStrong(self);
        [self scheduledTimerEnd];
    };
    if(self.timer) [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:300 target:self.progressView selector:@selector(forBlock) userInfo:nil repeats:NO];
}
-(void) scheduledTimerEnd{
    NSError * erro = [NSError errorWithDomain:NSNetServicesErrorDomain code:1860504 userInfo:@{@"describle":@"Gateway Timeout"}];
    [self.navigationDelegatec webView:self didFailProvisionalNavigation:self.navigation withError:erro];
}
-(void) hiddenProgress{
    if(!self.isShowProgress) return;
    if(self.timer) [self.timer invalidate];
    self.timer = nil;
    self.progressView.schedule = 1;
    [UIView animateWithDuration:0.25 animations:^{
        self.progressView.alpha = 0;
    } completion:^(BOOL finished) {
        if(self.progressView.alpha != 1){
            self.progressView.hidden = YES;
            self.progressView.alpha = 1;
            
        }
    }];
}

@end



@implementation PYScheduleView{
    UIView * _pView;
    UIView * _bView;
    UIView * _psView;
    UIView * _bsView;
    NSLayoutConstraint * _lcph;
}
-(instancetype) init{
    self = [super init];
    _pView = [UIView new];
    _bView = [UIView new];
    _psView = [UIView new];
    _bsView = [UIView new];
    [_pView addSubview:_psView];
    [_bView addSubview:_bsView];
    self.pColor = [UIColor orangeColor];
    self.bColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    self.backgroundColor = [UIColor clearColor];
    _pView.backgroundColor = [UIColor clearColor];
    _bView.backgroundColor = [UIColor clearColor];
    [self addSubview:_bView];
    [_bView addSubview:_pView];
    [PYViewAutolayoutCenter persistConstraint:_bView relationmargins:UIEdgeInsetsMake(3, 3, 3, 3) relationToItems:PYEdgeInsetsItemNull()];
    [PYViewAutolayoutCenter persistConstraint:_pView relationmargins:UIEdgeInsetsMake(0, 0, 0, DisableConstrainsValueMAX) relationToItems:PYEdgeInsetsItemNull()];
    _lcph = [PYViewAutolayoutCenter persistConstraint:_pView size:CGSizeMake(0, DisableConstrainsValueMAX)].allValues.firstObject;
    [PYViewAutolayoutCenter persistConstraint:_psView relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:PYEdgeInsetsItemNull()];
    [PYViewAutolayoutCenter persistConstraint:_bsView relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:PYEdgeInsetsItemNull()];
    return self;
}

-(void) forBlock{
    if(self.block) _block();
}

-(void) setSchedule:(CGFloat)schedule{
    _schedule = MIN(MAX(0, schedule), 1);
    _lcph.constant = _bView.frameWidth * _schedule;
}

-(void) setPColor:(UIColor *)pColor{
    _pColor = pColor;
    _psView.backgroundColor = _pColor;
    [_pView setShadowColor:_pColor.CGColor shadowRadius:2];
}
-(void) setBColor:(UIColor *)bColor{
    _bColor = bColor;
    _bsView.backgroundColor = _bColor;
    self.backgroundColor = nil;
    [_bView setShadowColor:_bColor.CGColor shadowRadius:2];
}

-(void) setBackgroundColor:(UIColor *)backgroundColor{
    [super setBackgroundColor:[UIColor clearColor]];
}
kSOULDLAYOUTMSTART
self.schedule = self.schedule;
[_bsView setCornerRadiusAndBorder:self.frameHeight/2 -3 borderWidth:0 borderColor:[UIColor clearColor]];
[_psView setCornerRadiusAndBorder:self.frameHeight/2 - 3 borderWidth:0 borderColor:[UIColor clearColor]];
kSOULDLAYOUTMEND
@end
