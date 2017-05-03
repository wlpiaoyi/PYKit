//
//  PYCalenderDateView.m
//  PYCalendar
//
//  Created by wlpiaoyi on 2016/12/14.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "PYCalenderDateView.h"
#import "PYCalendarGraphics.h"
#import "PYCalendarLocation.h"
#import "PYCalendarParam.h"
#import "NSDate+Lunar.h"
#import "pyutilea.h"

static PYDate  PYCalenderDateMin;
static PYDate PYCalenderDateMax;
@interface PYCalenderDateView()<PYCalendarLocation>{
    CGFloat heightFontDay;
    CGFloat heightFontLunar;
    PYGraphicsThumb * gtDate;
    PYGraphicsThumb * gtOther;
    PYGraphicsThumb * gtText;
    CGRect orgFrame;
    CALayer * layerDate;
    CALayer * layerOther;
    CALayer * layerText;
    int currentMonth;
}

@end

@implementation PYCalenderDateView
+(void) initialize{
    PYCalenderDateMin = PYDateMake(1901, 1, 1);
    PYCalenderDateMax = PYDateMake(2099, 12, 31);
}
-(instancetype) init{
    if(self = [super init]){
        [self initParams];
    }
    return self;
}
-(instancetype) initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initParams];
    }
    return self;
}
-(instancetype) initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        [self initParams];
    }
    return self;
}
-(void) initParams{

    orgFrame = CGRectNull;
    self.fontDay = PYCalendarDayFont;
    self.colorDay = PYCalendarDayColor;
    self.fontLunar = PYCalendarLunarFont;
    self.colorLunar = PYCalendarLunarColor;
    self.colorDisable = PYCalendarDisableColor;
    self.date = [NSDate date];
    
    @unsafeify(self);
    gtOther = [PYGraphicsThumb graphicsThumbWithView:self block:^(CGContextRef  _Nonnull ctx, id  _Nullable userInfo) {
        @strongify(self);
        [self drawOtherWithContext:ctx];
    }];
    gtDate = [PYGraphicsThumb graphicsThumbWithView:self block:^(CGContextRef  _Nonnull ctx, id  _Nullable userInfo) {
        @strongify(self);
        [self drawDateWithContext:ctx];
    }];
    gtText = [PYGraphicsThumb graphicsThumbWithView:self block:^(CGContextRef  _Nonnull ctx, id  _Nullable userInfo) {
        @strongify(self);
        [self drawTextWithContext:ctx];
    }];
}

-(void) setFontDay:(UIFont *)fontDay{
    _fontDay = fontDay;
    [PYUtile getFontHeightWithSize:_fontDay.pointSize fontName:fontDay.fontName];
}

-(void) setFontLunar:(UIFont *)fontLunar{
    _fontLunar = fontLunar;
    [PYUtile getFontHeightWithSize:_fontLunar.pointSize fontName:_fontLunar.fontName];
}

-(void) setDate:(NSDate *)date{
    int year,month;
    year = date.year;
    month = date.month;
    if(PYCalenderDateMin.year > year ||  (PYCalenderDateMin.year == year && PYCalenderDateMin.month > month) ){
        date = [NSDate dateWithYear:PYCalenderDateMax.year month:PYCalenderDateMax.month day:PYCalenderDateMax.day hour:0 munite:0 second:0];
    }else if(PYCalenderDateMax.year < year || (PYCalenderDateMax.year == year && PYCalenderDateMax.month < month) ){
        date = [NSDate dateWithYear:PYCalenderDateMin.year month:PYCalenderDateMin.month day:PYCalenderDateMin.day hour:0 munite:0 second:0];
    }
    _date = date;
    currentMonth = _date.month;
    [PYCalendarLocation locationMonthWithDate:_date bounds:self.bounds locationsLengthPointer:&locationLength iterator:self];
}

-(void) reloadDate{
    [self reloadOther];
    layerDate = [gtDate executDisplay:nil];
}

-(void) reloadOther{
    layerText = [gtText executDisplay:nil];
    layerOther = [gtOther executDisplay:nil];
}

-(void) iteratorDayIntMonth:(PYCalendarRect) rect{
    locations[rect.index] = rect;
}

-(void) drawDateWithContext:(nullable CGContextRef) context{
    [PYGraphicsDraw startDraw:&context];
    [PYGraphicsDraw drawTextWithContext:context attribute:[NSAttributedString new] rect:self.bounds y:self.bounds.size.height scaleFlag:true];
    for (int i = 0; i < locationLength; i++){
        PYCalendarRect cr = locations[i];
        if(self.delegate && [self.delegate respondsToSelector:@selector(drawTextWithContext:bounds:calendarRect:)]){
            [self.delegate drawTextWithContext:context bounds:self.bounds calendarRect:cr];
        }
        UIColor * colorDay = currentMonth == cr.date.month ? self.colorDay : self.colorDisable;
        UIColor * colorLunar = currentMonth == cr.date.month ? self.colorLunar : self.colorDisable;
        [PYCalendarGraphics drawDayWithContext:context bounds:self.bounds borderWith:2 dateRect:cr heightDay:heightFontDay heightLunar:heightFontLunar fontDay:_fontDay fontLunar:_fontLunar colorDay:colorDay colorLunar:colorLunar];
    }
    [PYGraphicsDraw endDraw:&context];
}

-(void) drawOtherWithContext:(nullable CGContextRef) context{
    [PYGraphicsDraw startDraw:&context];
    int num = locationLength / 7;
    CGFloat height = self.frameHeight / (CGFloat)num;
    CGPoint startP = CGPointMake(0, -.25);
    CGPoint endP = CGPointMake(self.frameWidth, -.25);
    for (int i = 0; i < num; i++) {
        startP.y += height;
        endP.y = startP.y;
        [PYGraphicsDraw drawLineWithContext:context startPoint:startP endPoint:endP strokeColor:self.colorDisable.CGColor strokeWidth:.25 lengthPointer:nil length:0];
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(drawOtherWithContext:bounds:locationLength:locations:)]){
        [self.delegate drawOtherWithContext:context bounds:self.bounds locationLength:locationLength locations:locations];
    }
    [PYGraphicsDraw endDraw:&context];
    
}

-(void) drawTextWithContext:(nullable CGContextRef) context{
    [PYGraphicsDraw drawTextWithContext:context attribute:[NSAttributedString new] rect:self.bounds y:self.bounds.size.height scaleFlag:true];
    if(self.delegate && [self.delegate respondsToSelector:@selector(drawTextWithContext:bounds:locationLength:locations:)]){
        [self.delegate drawTextWithContext:context bounds:self.bounds locationLength:locationLength locations:locations];
    }
}
-(void) layoutSubviews{
    [super layoutSubviews];
    if(!CGRectEqualToRect(orgFrame, self.frame)){
        self.date = self.date;
        [self reloadDate];
    }
    orgFrame = self.frame;
}
@end
