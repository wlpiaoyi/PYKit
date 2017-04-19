//
//  PYDatePikerView.m
//  PYCalendar
//
//  Created by wlpiaoyi on 15/12/9.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import "PYDatePikerView.h"
#import <CoreText/CoreText.h>
#import "pyutilea.h"
#import "NSDate+Lunar.h"

NSInteger PYDatePickerMaxRow = 9999;
NSInteger PYDatePickerMaxYear = 2099;
NSInteger PYDatePickerMinYear = 1901;
NSInteger PYDatePickerWith = 220;

@interface PYDatePikerView()<UIPickerViewDataSource, UIPickerViewDelegate>
@property (strong, nonatomic) UIPickerView *pikerDate;
@property (strong, nonatomic) UIPickerView *pikerMonth;
@property (strong, nonatomic) UIFont *fontYear;
@property (strong, nonatomic) UIFont *fontMonth;
@property (strong, nonatomic) UIColor *colorYear;
@property (strong, nonatomic) UIColor *colorMonth;
@property (strong, nonatomic) UIColor *colorDisable;
@property (nonatomic) BOOL isScrolled;

@end
@implementation PYDatePikerView
@synthesize selectedDate;

-(instancetype) init{
    if (self = [super init]) {
        [self initParams];
    }
    return self;
}
-(void) initParams{
    self.fontYear = self.fontMonth = [UIFont systemFontOfSize:14];
    self.colorYear = self.colorMonth = [UIColor blueColor];
    self.colorDisable = [UIColor grayColor];
    self.pikerDate = [UIPickerView new];
    self.pikerDate.delegate = self;
    self.pikerDate.dataSource = self;
    self.pikerDate.frameWidth = PYDatePickerWith;
    self.frameSize = CGSizeMake(PYDatePickerWith, 160);
    [self addSubview:self.pikerDate];
    [PYViewAutolayoutCenter persistConstraint:self.pikerDate relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:PYEdgeInsetsItemNull()];
    self.selectedDate = [NSDate date];
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return PYDatePickerMaxRow;
}

- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *arg;
    UIFont *font;
    UIColor *color;
    if (component == 0) {
        NSInteger year;
        [PYDatePikerView getYear:&year row:row];
        arg = [NSString stringWithFormat:@"%d年",(int)year];
        font = self.fontYear;
        color = self.colorYear;
    }else{
        NSInteger month;
        [PYDatePikerView getMonth:&month row:row];
        arg =  [NSString stringWithFormat:@"%d月",(int)month + 1];
        font = self.fontMonth;
        color = self.colorMonth;
    }
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:arg];
    [attribute setAttributes:@{(NSString*)kCTForegroundColorAttributeName: (id)color.CGColor} range:NSMakeRange(0, attribute.length)];
    return attribute;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return PYDatePickerWith * .5;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}
-(void) setSelectedDate:(nonnull NSDate *) _selectedDate_{
    [self.pikerDate reloadAllComponents];
    NSInteger yRow;
    [PYDatePikerView getRow:&yRow year:_selectedDate_.year];
    NSInteger mRow;
    [PYDatePikerView getRow:&mRow month:_selectedDate_.month];
    [self.pikerDate selectRow:yRow inComponent:0 animated:NO];
    [self.pikerDate selectRow:mRow inComponent:1 animated:NO];
    selectedDate = _selectedDate_;
}
-(nonnull NSDate *) selectedDate{
    NSInteger year,month;
    [PYDatePikerView getYear:&year row:[self.pikerDate selectedRowInComponent:0]];
    [PYDatePikerView getMonth:&month row:[self.pikerDate selectedRowInComponent:1]];
    selectedDate = [NSDate dateWithYear:year month:month + 1 day:1 hour:0 munite:0 second:0];
    return selectedDate;
}
//-(void) layoutSubviews{
//    [super layoutSubviews];
//    if (IOS8_OR_LATER) {
//        self.pikerDate.frameOrigin= CGPointMake((self.frameWidth - PYDatePickerWith)/2, 0);
//        self.pikerDate.frameSize = CGSizeMake(PYDatePickerWith, self.frameHeight);
//    }
//}

+(void) getYear:(NSInteger *) yearPointer row:(NSInteger) row{
    *yearPointer = row % (PYDatePickerMaxYear - PYDatePickerMinYear + 1) + PYDatePickerMinYear;
}
+(void) getMonth:(NSInteger*) monthPointer row:(NSInteger) row{
    *monthPointer = row % 12;
}
+(void) getRow:(NSInteger *) rowPointer year:(NSInteger) year{
    NSInteger row = PYDatePickerMaxRow / 2;
    row = row - (row % (PYDatePickerMaxYear - PYDatePickerMinYear + 1)) + (year - PYDatePickerMinYear);
    *rowPointer = row;
}
+(void) getRow:(NSInteger *) rowPointer month:(NSInteger) month{
    NSInteger row = PYDatePickerMaxRow / 2;
    row = row - (row % 12) + month -1;
    *rowPointer = row;
}

@end
