//
//  PYCalenderDateView.h
//  PYCalendar
//
//  Created by wlpiaoyi on 2016/12/14.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYCalendarParam.h"

@protocol PYCalenderDateView<NSObject>
@optional
-(void) drawTextWithContext:(nullable CGContextRef) context bounds:(CGRect) bounds calendarRect:(PYCalendarRect) rect;
-(void) drawTextWithContext:(nullable CGContextRef) context bounds:(CGRect) bounds locationLength:(int) locationLength locations:(PYCalendarRect[_Nullable 43]) locations;
-(void) drawOtherWithContext:(nullable CGContextRef) context bounds:(CGRect) bounds locationLength:(int) locationLength locations:(PYCalendarRect[_Nullable 43]) locations;
@end

@interface PYCalenderDateView : UIView{
@public
    PYCalendarRect locations[43];
    int locationLength;
}
@property (nonatomic, assign, nullable) id<PYCalenderDateView> delegate;
@property (nonatomic, strong, nonnull) NSDate * date;
@property (nonatomic, strong, nonnull) UIFont * fontDay;
@property (nonatomic, strong, nonnull) UIColor * colorDay;
@property (nonatomic, strong, nonnull) UIFont * fontLunar;
@property (nonatomic, strong, nonnull) UIColor * colorLunar;
@property (nonatomic, strong, nonnull) UIColor * colorDisable;
-(void) reloadDate;
-(void) reloadOther;
@end
