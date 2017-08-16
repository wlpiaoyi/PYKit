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
    PYSpesalInfo spesals[60];
    unsigned int spesalLength;
}
@property (nonatomic, assign, nullable) id<PYCalenderDateView> delegate;
PYPNSNN NSDate * dateEnableStart;
PYPNSNN NSDate * dateEnableEnd;
PYPNSNN NSDate * date;
PYPNSNN UIFont * fontDay;
PYPNSNN UIColor * colorDay;
PYPNSNN UIFont * fontLunar;
PYPNSNN UIColor * colorLunar;
PYPNSNN UIColor * colorDisable;
PYPNSNN UIColor * colorWeekend;
PYPNSNN UIFont * fontSpesal;
-(nonnull instancetype) initWithDate:(nonnull NSDate *) date DateStart:(nonnull NSDate *) dateStart dateEnd:(nonnull NSDate *) dateEnd;
-(void) reloadDate;
-(void) reloadOther;
@end
