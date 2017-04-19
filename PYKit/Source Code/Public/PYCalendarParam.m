//
//  PYCalendarParam.m
//  PYCalendar
//
//  Created by wlpiaoyi on 2016/12/13.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "PYCalendarParam.h"

//int PYDateMinusFotDays(PYDate date1, PYDate date2){
//    int days = 0;
//    for (int year = date2.year; year < date1.year; year ++) {
//        days += (year % 4)  ? 365 : 366;
//    }
//    if(date1.month > date2.month){
//        for (int month = date2.month; month < date1.month; month++) {
//            switch (month) {
//                case 2:
//                    days += date1.year%4 ? 28 : 29;
//                    break;
//                case 4:
//                    days += 30;
//                    break;
//                case 6:
//                    days += 30;
//                    break;
//                case 9:
//                    days += 30;
//                    break;
//                case 11:
//                    days += 30;
//                    break;
//                default:
//                    days += 31;
//                    break;
//            }
//        }
//        days += date1.day - date2.day;
//    }else if(date2.month > date1.month){
//        for (int month = date1.month; month < date2.month; month++) {
//            switch (month) {
//                case 2:
//                    days -= date1.year%4 ? 28 : 29;
//                    break;
//                case 4:
//                    days -= 30;
//                    break;
//                case 6:
//                    days -= 30;
//                    break;
//                case 9:
//                    days -= 30;
//                    break;
//                case 11:
//                    days -= 30;
//                    break;
//                default:
//                    days -= 31;
//                    break;
//            }
//        }
//        days -= date2.day - date1.day;
//    }
//    return  days;
//}

UIColor * _Nonnull PYCalendarBGC;
UIFont * _Nonnull PYCalendarWeekFont;
UIColor * _Nonnull PYCalendarWeekColor;
UIFont * _Nonnull PYCalendarDayFont;
UIColor * _Nonnull PYCalendarDayColor;
UIFont * _Nonnull PYCalendarLunarFont;
UIColor * _Nonnull PYCalendarLunarColor;
UIColor * _Nonnull PYCalendarDisableColor;
@implementation PYCalendarParam

+(void) loadCalendarData{
    PYCalendarBGC = [UIColor clearColor];
    PYCalendarWeekFont = [UIFont systemFontOfSize:10];
    PYCalendarWeekColor = [UIColor grayColor];
    PYCalendarDayFont = [UIFont systemFontOfSize:14];
    PYCalendarDayColor = [UIColor darkGrayColor];
    PYCalendarLunarFont = [UIFont systemFontOfSize:10];
    PYCalendarLunarColor = [UIColor orangeColor];
    PYCalendarDisableColor = [UIColor lightGrayColor];
}

@end
