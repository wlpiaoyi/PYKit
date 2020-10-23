//
//  PYTestCalendarController.m
//  PYKit
//
//  Created by wlpiaoyi on 2018/1/30.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import "PYTestCalendarController.h"
#import "PYCalendarView.h"
#import "pyinterflowa.h"

@interface PYTestCalendarController ()

@end

@implementation PYTestCalendarController
- (IBAction)onclickSheet:(id)sender {
    
    PYCalendarView * cv = [PYCalendarView new];
    cv.backgroundColor = [UIColor whiteColor];
    cv.frameHeight = 300;
    cv.dateEnableStart = [NSDate date];
    cv.dateEnableEnd = [[NSDate date] offsetMonth:3];
    cv.date = [[NSDate date] offsetDay:3];
    cv.sheetIsHiddenOnClick = false;
    [cv sheetShowWithTitle:@"日期选择" previousName:@"上一页" nextName:@"下一页" blockOpt:^(UIView * _Nullable view, NSUInteger index) {
        ((PYCalendarView*)view).date = [((PYCalendarView*)view).date offsetMonth:index ? 1 : -1];
    }];
    [cv setBlockSelected:^(PYCalendarView * _Nonnull view) {
        UIView * v = [UIView new];
        [v toastShow:3 message:[((PYCalendarView*)view).date dateFormateDate:nil]];
        [view sheetHidden];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
