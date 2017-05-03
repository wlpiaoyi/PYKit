//
//  PYCalendarView.h
//  PYCalendar
//
//  Created by wlpiaoyi on 2016/12/14.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PYCalendarView : UIView
@property (nonatomic, strong, nonnull) NSDate * date;
@property (nonatomic, copy, nullable) void (^blockSelected) (PYCalendarView * _Nonnull view);
-(void) showDataOperationView;
@end
