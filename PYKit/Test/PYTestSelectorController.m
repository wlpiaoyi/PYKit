//
//  PYTestSelectorController.m
//  PYKit
//
//  Created by wlpiaoyi on 2018/1/2.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import "PYTestSelectorController.h"
#import "PYSelectorBarView.h"
#import "PYSelectorScrollView.h"
#import "pyutilea.h"
#import "PYNavigationControll.h"

@interface PYTestSelectorController ()<PYNavigationSetterTag>
@property (weak, nonatomic) IBOutlet PYSelectorScrollView *scroll;
@property (weak, nonatomic) IBOutlet PYSelectorBarView *bar;
@end

@implementation PYTestSelectorController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray * labels = [NSMutableArray new];
    for (int i = 0; i<self.bar.buttons.count; i++) {
        UILabel * label = [UILabel new];
        label.frameSize = CGSizeMake(20, 20);
        label.numberOfLines = 1;
        label.backgroundColor = [UIColor redColor];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"10";
        [label setCornerRadiusAndBorder:label.frameWidth/2 borderWidth:0 borderColor:nil];
        [labels addObject:label];
    }
    
    self.bar.selectorTagOffWidth = 40;
    self.bar.displayTags = labels;
    [self.bar setBlockSelecteItem:^BOOL(NSUInteger index) {
        if(index == 0){
            UIButton * b = [UIButton buttonWithType:UIButtonTypeSystem];
            [b setTitle:@"aaaa" forState:UIControlStateNormal];
            self.bar.buttons = @[b];
        }
        return true;
    }];
    
    NSMutableArray * btns = [NSMutableArray new];
    for (int i = 0; i<5; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:@"xx" forState:UIControlStateNormal];
        if(i == 1){
            [btn setTitle:@"xxxxxxxxxxxxxxxxx" forState:UIControlStateNormal];
        }
        if(i == 3){
            [btn setTitle:@"xxxxxxxxxx" forState:UIControlStateNormal];
        }
        if(i == 2){
            [btn setTitle:@"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" forState:UIControlStateNormal];
        }
        [btns addObject:btn];
    }
    self.scroll.buttons = btns;
    self.scroll.contentWidth = 80 * 5;
    self.scroll.isScorllSelected = YES;
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void) viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}
- (IBAction)onclick:(id)sender {
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
