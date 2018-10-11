//
//  PYTestSelectorController.m
//  PYKit
//
//  Created by wlpiaoyi on 2018/1/2.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import "PYTestSelectorController.h"
#import "PYSelectorBarView.h"

@interface PYTestSelectorController ()
@property (weak, nonatomic) IBOutlet PYSelectorBarView *bar;
@end

@implementation PYTestSelectorController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.bar setBlockSelecteItem:^BOOL(NSUInteger index) {
        if(index == 0){
            UIButton * b = [UIButton buttonWithType:UIButtonTypeSystem];
            [b setTitle:@"aaaa" forState:UIControlStateNormal];
            self.bar.buttons = @[b];
        }
        return true;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void) viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
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
