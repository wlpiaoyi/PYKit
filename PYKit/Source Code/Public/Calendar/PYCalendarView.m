//
//  PYCalendarView.m
//  PYCalendar
//
//  Created by wlpiaoyi on 2016/12/14.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "PYCalendarView.h"
#import "PYCalendarHeadView.h"
#import "PYCalenderDateView.h"
#import "PYViewAutolayoutCenter.h"
#import "PYCalendarLocation.h"
#import "PYGraphicsDraw.h"
#import "NSDate+Lunar.h"
#import "calendar_lunar.h"
#import "PYDatePikerView.h"
#import "pyinterflowa.h"
BOOL PYCalendarHasGuide = false;

@interface PYCalendarView()<PYCalenderDateView>
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *topSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *buttomSwipeGestureRecognizer;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;
@end

@implementation PYCalendarView{
@private
    PYCalenderDateView * dateView;
    PYCalendarHeadView * weeakView;
    NSLayoutConstraint * lcWeekTop;
    CGSize orgSize;
    PYCalendarRect * crs;
    int crsLength;
    NSDate * currentMonth;
    UIView * viewGuide;
    bool isTouched;
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
    _dateEnableStart = [[NSDate date] offsetMonth:-3];
    _dateEnableEnd = [self.dateEnableStart offsetMonth:6];
    _date = [[NSDate date] setCompentsWithBinary:0b111000];
    dateView = [[PYCalenderDateView alloc] initWithDate:self.date DateStart:self.dateEnableStart dateEnd:self.dateEnableEnd];
    weeakView = [PYCalendarHeadView new];
    self.date = self.date;
    orgSize = CGSizeZero;
    [self addSubview:weeakView];
    [self addSubview:dateView];
    self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.topSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.buttomSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    self.topSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    self.buttomSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    self.longPressGestureRecognizer.minimumPressDuration = .5;
    
    [self addGestureRecognizer:self.leftSwipeGestureRecognizer];
    [self addGestureRecognizer:self.rightSwipeGestureRecognizer];
    [self addGestureRecognizer:self.topSwipeGestureRecognizer];
    [self addGestureRecognizer:self.buttomSwipeGestureRecognizer];
    [self addGestureRecognizer:self.longPressGestureRecognizer];
    
    [PYViewAutolayoutCenter persistConstraint:weeakView size:CGSizeMake(DisableConstrainsValueMAX, [PYUtile getFontHeightWithSize:weeakView.font.pointSize fontName:weeakView.font.fontName] + 5)];
    [PYViewAutolayoutCenter persistConstraint:weeakView relationmargins:UIEdgeInsetsMake(DisableConstrainsValueMAX, 0, DisableConstrainsValueMAX, 0) relationToItems:PYEdgeInsetsItemNull()];
    lcWeekTop = [PYViewAutolayoutCenter persistConstraint:weeakView relationmargins:UIEdgeInsetsMake(20, DisableConstrainsValueMAX, DisableConstrainsValueMAX, DisableConstrainsValueMAX) relationToItems:PYEdgeInsetsItemNull()].allValues.firstObject;
    PYEdgeInsetsItem e = PYEdgeInsetsItemNull();
    e.top = (__bridge void * _Nullable)(weeakView);
    [PYViewAutolayoutCenter persistConstraint:dateView relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:e];
    isTouched = false;
    dateView.delegate = self;
    if(PYCalendarHasGuide){
        viewGuide = [UIView new];
        viewGuide.backgroundColor = [UIColor clearColor];
        [self addSubview: viewGuide];
        [PYViewAutolayoutCenter persistConstraint:viewGuide relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:PYEdgeInsetsItemNull()];
        UIImageView * imageTop = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PYKit.bundle/arrow_top.png"]];
        UIImageView * imageLeft = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PYKit.bundle/arrow_left.png"]];
        UIImageView * imageButtom = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PYKit.bundle/arrow_buttom.png"]];
        UIImageView * imageRight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PYKit.bundle/arrow_right.png"]];
        UIImageView * imageTap = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PYKit.bundle/circle_tap.png"]];
        [viewGuide addSubview:imageTop];
        [viewGuide addSubview:imageLeft];
        [viewGuide addSubview:imageButtom];
        [viewGuide addSubview:imageRight];
        [viewGuide addSubview:imageTap];
        [PYViewAutolayoutCenter persistConstraint:imageTop size:CGSizeMake(30, 71)];
        [PYViewAutolayoutCenter persistConstraint:imageButtom size:CGSizeMake(30, 71)];
        [PYViewAutolayoutCenter persistConstraint:imageLeft size:CGSizeMake(71, 30)];
        [PYViewAutolayoutCenter persistConstraint:imageRight size:CGSizeMake(71,30)];
        [PYViewAutolayoutCenter persistConstraint:imageTap size:CGSizeMake(50, 50)];
        [PYViewAutolayoutCenter persistConstraint:imageTop centerPointer:CGPointMake(0, DisableConstrainsValueMAX)];
        [PYViewAutolayoutCenter persistConstraint:imageButtom centerPointer:CGPointMake(0, DisableConstrainsValueMAX)];
        [PYViewAutolayoutCenter persistConstraint:imageLeft centerPointer:CGPointMake(DisableConstrainsValueMAX, 0)];
        [PYViewAutolayoutCenter persistConstraint:imageRight centerPointer:CGPointMake(DisableConstrainsValueMAX, 0)];
        [PYViewAutolayoutCenter persistConstraint:imageTap centerPointer:CGPointMake(0, 0)];
        [PYViewAutolayoutCenter persistConstraint:imageTop relationmargins:UIEdgeInsetsMake(0, DisableConstrainsValueMAX, DisableConstrainsValueMAX, DisableConstrainsValueMAX) relationToItems:PYEdgeInsetsItemNull()];
        [PYViewAutolayoutCenter persistConstraint:imageTop relationmargins:UIEdgeInsetsMake(DisableConstrainsValueMAX, DisableConstrainsValueMAX, DisableConstrainsValueMAX, DisableConstrainsValueMAX) relationToItems:PYEdgeInsetsItemNull()];
        [PYViewAutolayoutCenter persistConstraint:imageButtom relationmargins:UIEdgeInsetsMake(DisableConstrainsValueMAX, DisableConstrainsValueMAX, 0, DisableConstrainsValueMAX) relationToItems:PYEdgeInsetsItemNull()];
        [PYViewAutolayoutCenter persistConstraint:imageLeft relationmargins:UIEdgeInsetsMake(DisableConstrainsValueMAX, 0, DisableConstrainsValueMAX, DisableConstrainsValueMAX) relationToItems:PYEdgeInsetsItemNull()];
        [PYViewAutolayoutCenter persistConstraint:imageRight relationmargins:UIEdgeInsetsMake(DisableConstrainsValueMAX, DisableConstrainsValueMAX, DisableConstrainsValueMAX, 0) relationToItems:PYEdgeInsetsItemNull()];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(animationHidden) name:@"animationHidden" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(animationShow) name:@"animationShow" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"animationHidden" object:nil];
    }
    self->spesalLength = 0;
    self->spesals[self->spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 1, 1), "元旦节",false);
    self->spesals[self->spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 2, 14), "情人节",false);
    self->spesals[self->spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 2, 14), "情人节",false);
    self->spesals[self->spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 3, 8), "妇女节",false);
    self->spesals[self->spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 3, 12), "植树节",false);
    self->spesals[self->spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 4, 4), "清明节",false);
    self->spesals[self->spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 5, 1), "劳动节",false);
    self->spesals[self->spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 5, 4), "青年节",false);
    self->spesals[self->spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 6, 1), "儿童节",false);
    self->spesals[self->spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 7, 1), "建党节",false);
    self->spesals[self->spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 8, 1), "建军节",false);
    self->spesals[self->spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 9, 10), "教师节",false);
    self->spesals[self->spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 10, 1), "国庆节",false);
    self->spesals[self->spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 12, 24), "平安夜",false);
    self->spesals[self->spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 12, 25), "圣诞夜",false);
    self->spesals[self->spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 1, 1), "春节",true);
    self->spesals[self->spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 5, 5), "端午节",true);
    self->spesals[self->spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 7, 7), "七夕节",true);
    self->spesals[self->spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 7, 15), "中原节",true);
    self->spesals[self->spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 8, 15), "中秋节",true);
    self->spesals[self->spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 9, 9), "重阳节",true);
    self->spesals[self->spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 12, 8), "腊八节",true);
    self->spesals[self->spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 12, 30), "除夕夜",true);
    self->spesals[self->spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 1, 15), "元宵节",true);
    [self synSpesqlInfo];
}

-(void) animationHidden{
    viewGuide.hidden = NO;
    viewGuide.alpha = 1;
    @unsafeify(self);
    [UIView animateWithDuration:.5 animations:^{
        viewGuide.alpha = 0;
    } completion:^(BOOL finished) {
        viewGuide.hidden = YES;
        @strongify(self);
        if(isTouched) return;
        [self animationShow];
    }];
}
-(void) animationShow{
    viewGuide.hidden = NO;
    viewGuide.alpha = 0;
    [UIView animateWithDuration:2 animations:^{
        viewGuide.alpha = 1;
    } completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"animationHidden" object:nil];
    }];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self showDataOperationView];
    }
}
- (void)handleSwipes:(UISwipeGestureRecognizer *)sender {
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        currentMonth = [currentMonth offsetMonth:1];
    }else if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        currentMonth = [currentMonth offsetMonth:-1];
    }else if (sender.direction == UISwipeGestureRecognizerDirectionUp) {
        currentMonth = [currentMonth offsetYear:-1];
    }else if (sender.direction == UISwipeGestureRecognizerDirectionDown) {
        currentMonth = [currentMonth offsetYear:1];
    }
    dateView.date = currentMonth;
    currentMonth = dateView.date;
    _date = [NSDate dateWithYear:currentMonth.year month:currentMonth.month day:1 hour:0 munite:0 second:0];
    [dateView reloadDate];
    if(self.blockChangeDate){
        _blockChangeDate(self);
    }
}
-(void) setDate:(NSDate *)date{
    _date = date;
    currentMonth = [NSDate dateWithYear:_date.year month:_date.month day:1 hour:0 munite:0 second:0];
    dateView.date = currentMonth;
    [dateView reloadDate];
}
-(void) setDateEnableStart:(NSDate *)dateEnableStart{
    _dateEnableStart = dateEnableStart;
    dateView.dateEnableStart = dateEnableStart;
}
-(void) setDateEnableEnd:(NSDate *)dateEnableEnd{
    _dateEnableEnd = dateEnableEnd;
    dateView.dateEnableEnd = dateEnableEnd;
}
-(void) synSpesqlInfo{
    dateView->spesalLength = spesalLength;
    for (int i = 0; i < spesalLength; i++) {
        dateView->spesals[i] = spesals[i];
    }
}
-(void) drawOtherWithContext:(CGContextRef)context bounds:(CGRect)bounds locationLength:(int)locationLength locations:(PYCalendarRect *)locations{
    crs = locations;
    crsLength = locationLength;
    int year,month,day;
    year = self.date.year;
    month = self.date.month;
    day = self.date.day;
    PYDate currentDate = PYDateMake(year, month, day);
    year = _dateEnableStart.year;
    month = _dateEnableStart.month;
    day = _dateEnableStart.day;
    PYDate dateStart = PYDateMake(year, month, day);
    year = _dateEnableEnd.year;
    month = _dateEnableEnd.month;
    day = _dateEnableEnd.day;
    PYDate dateEnd = PYDateMake(year, month, day);
    if(PYDateCompareDate(currentDate, dateStart) < 0){
        currentDate = dateStart;
    }else if(PYDateCompareDate(currentDate, dateEnd) > 0){
        currentDate = dateEnd;
    }
    PYCalendarRect  pcr = PYCalendarRectMake(-1, CGRectNull, PYDateMake(0, 0, 0));
    for (int i = 0; i < locationLength; i++) {
        PYCalendarRect cr = locations[i];
        if(cr.flagEnable && PYDateCompareDate(currentDate, cr.date) == 0){
            pcr = cr;
            break;
        }
    }
    if(pcr.index != -1){
        CGFloat borderW = 2;
        CGPoint startP = CGPointMake(pcr.frame.origin.x, pcr.frame.origin.y + pcr.frame.size.height - borderW/2);
        CGPoint endP = CGPointMake(startP.x + pcr.frame.size.width, startP.y);
        [PYGraphicsDraw drawLineWithContext:context startPoint:startP endPoint:endP strokeColor:[UIColor redColor].CGColor strokeWidth:borderW lengthPointer:nil length:0];
    }
}
-(void) drawTextWithContext:(nullable CGContextRef) context bounds:(CGRect) bounds locationLength:(int) locationLength locations:(PYCalendarRect *)locations{
    crs = locations;
    crsLength = locationLength;
    
    UIFont *f1 = [UIFont italicSystemFontOfSize:60];
    UIColor *c1 = [UIColor colorWithRed:.7 green:.7 blue:.7 alpha:.2];
    NSAttributedString * attribute = [[NSAttributedString alloc] initWithString:[self.date dateFormateDate:@"yy年MM月"] attributes:@{NSForegroundColorAttributeName:c1,NSFontAttributeName:f1}];
    CGSize s = CGSizeMake(999, [PYUtile getFontHeightWithSize:f1.pointSize fontName:f1.fontName]);
    s = [PYUtile getBoundSizeWithAttributeTxt:attribute size:s];
    CGFloat bw = (bounds.size.height - s.height * 3)/4;
    CGRect r = bounds;
    r.origin = CGPointMake((bounds.size.width - s.width)/2,  bw);
    r.size = bounds.size;
    [PYGraphicsDraw drawTextWithContext:context attribute:attribute rect:r y:bounds.size.height scaleFlag:false];
    
    attribute = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@/%@年",self.date.lunarYearName, self.date.lunarYearZodiac] attributes:@{NSForegroundColorAttributeName:c1,NSFontAttributeName:f1}];
    
    s = CGSizeMake(999, [PYUtile getFontHeightWithSize:f1.pointSize fontName:f1.fontName]);
    s = [PYUtile getBoundSizeWithAttributeTxt:attribute size:s];
    r.origin = CGPointMake((bounds.size.width - s.width)/2, r.origin.y + s.height + bw);
    r.size = bounds.size;
    [PYGraphicsDraw drawTextWithContext:context attribute:attribute rect:r y:bounds.size.height scaleFlag:false];
    
    f1 = [UIFont italicSystemFontOfSize:f1.pointSize * .8];
    NSMutableString * arg = [NSMutableString new];
    [arg appendFormat:@"%@ %@",self.date.lunarMonthName,self.date.lunarDayName];
    attribute = [[NSAttributedString alloc] initWithString:arg attributes:@{NSForegroundColorAttributeName:c1,NSFontAttributeName:f1}];
    CGFloat h = r.origin.y + s.height;
    s = CGSizeMake(999, [PYUtile getFontHeightWithSize:f1.pointSize fontName:f1.fontName]);
    s = [PYUtile getBoundSizeWithAttributeTxt:attribute size:s];
    r.origin = CGPointMake((bounds.size.width - s.width)/2, h +  (bounds.size.height  - h - s.height)/2);
    r.size = bounds.size;
    [PYGraphicsDraw drawTextWithContext:context attribute:attribute rect:r y:bounds.size.height scaleFlag:false];
    
}
-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if(!isTouched && PYCalendarHasGuide){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"animationHidden" object:nil];
    }
    isTouched = true;
}
-(void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = touches.anyObject;
    CGPoint touchPoint = [touch locationInView:dateView];
    for (int i = 0; i < crsLength; i++) {
        PYCalendarRect  cr = crs[i];
        if(cr.frame.origin.x > touchPoint.x || cr.frame.origin.y > touchPoint.y) continue;
        if(cr.frame.origin.x + cr.frame.size.width < touchPoint.x || cr.frame.origin.y + cr.frame.size.height < touchPoint.y) continue;
        if(cr.flagEnable == false) return;
        _date = [NSDate dateWithYear:cr.date.year month:cr.date.month day:cr.date.day hour:0 munite:0 second:0];
        break;
    }
    [dateView reloadOther];
    if(self.blockSelected){
        _blockSelected(self);
    }
}
-(void) layoutSubviews{
    [super layoutSubviews];
    if(IOS9_OR_LATER){
        if(!CGSizeEqualToSize(orgSize, self.frameSize)){
            lcWeekTop.constant = self.frameHeight / 20;
        }
        orgSize = self.frameSize;
    }
}
-(void) showDataOperationView{
    PYDatePikerView * dpv = [PYDatePikerView new];
    dpv.selectedDate = self.date;
    @unsafeify(self);
    [dpv dialogShowWithTitle:@"年月调整" block:^(UIView * _Nonnull view, NSUInteger index) {
        @strongify(self);
        [view dialogHidden];
        switch (index) {
            case 0:{
                self.date = ((PYDatePikerView *) view).selectedDate;
            }
                break;
                
            default:
                break;
        }
        if(self.blockChangeDate){
            _blockChangeDate(self);
        }
    } buttonNames:@[@"确定",@"取消"]];
}
-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
