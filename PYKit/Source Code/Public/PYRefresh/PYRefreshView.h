//
//  PYRefreshView.h
//  PYKit
//
//  Created by wlpiaoyi on 2018/1/2.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pyutilea.h"

extern CGFloat PYRefreshViewHeight;
extern NSString * PYRefreshDownBeginText;
extern NSString * PYRefreshDownDoText;
extern NSString * PYRefreshDownDoingText;
extern NSString * PYRefreshDownEndText;
extern NSString * PYRefreshUpBeginText;
extern NSString * PYRefreshUpDoText;
extern NSString * PYRefreshUpDoingText;
extern NSString * PYRefreshUpEndText;

typedef enum _kPYRefreshState {
    kPYRefreshNoThing = 0b1,
    kPYRefreshBegin = 0b1000,
    kPYRefreshDo= kPYRefreshBegin | (kPYRefreshBegin >> 1),
    kPYRefreshDoing = kPYRefreshBegin | (kPYRefreshBegin >> 2),
    kPYRefreshEnd = kPYRefreshBegin | (kPYRefreshBegin >> 3)
} kPYRefreshState;

typedef enum _kPYRefreshType {
    kPYRefreshHeader = 0b0,
    kPYRefreshFooter = 0b1
} kPYRefreshType;

@interface PYRefreshView : UIView
PYPNA kPYRefreshType type;
PYPNA kPYRefreshState state;
PYPNA CGFloat scheduleHeight;
@end
