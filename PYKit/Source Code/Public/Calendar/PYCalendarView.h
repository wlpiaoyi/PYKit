//
//  PYCalendarView.h
//  PYCalendar
//
//  Created by wlpiaoyi on 2016/12/14.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYUtile.h"
#import "PYCalendarParam.h"

extern BOOL PYCalendarHasGuide;
@interface PYCalendarView : UIView{
@public
    PYSpesalInfo spesals[60];
    unsigned int spesalLength;
}
@property (nonatomic, strong, nonnull) NSDate * date;
PYPNSNN NSDate * dateEnableStart;
PYPNSNN NSDate * dateEnableEnd;
@property (nonatomic, copy, nullable) void (^blockSelected) (PYCalendarView * _Nonnull view);
@property (nonatomic, copy, nullable) void (^blockChangeDate) (PYCalendarView * _Nonnull view);
-(void) synSpesqlInfo;
-(void) showDataOperationView;
@end
