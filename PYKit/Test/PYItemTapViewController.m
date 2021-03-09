//
//  PYItemTapViewController.m
//  PYKit
//
//  Created by wlpiaoyi on 2020/12/3.
//  Copyright © 2020 wlpiaoyi. All rights reserved.
//

#import "PYItemTapViewController.h"
#import "PYLongpressMoveItemView.h"

@interface PYItemTapViewController ()
@property (weak, nonatomic) IBOutlet PYLongpressMoveItemView *itemTapView;
kPNSNA NSMutableArray * datas;
@end

@implementation PYItemTapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"xxx" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onclickAdd) forControlEvents:UIControlEventTouchUpInside];
    self.itemTapView.viewTail = button;
    self.itemTapView.itemSize = CGSizeMake(76, 76);
    self.datas = @[
        @"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1705581946,4177791147&fm=26&gp=0.jpg",
        @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1464095493,1223754104&fm=26&gp=0.jpg",
        @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2140697723,2949229006&fm=26&gp=0.jpg",
        @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=1557726684,1767006402&fm=26&gp=0.jpg",
        @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3536409337,1163688008&fm=11&gp=0.jpg",
        @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=2303417984,2128545381&fm=26&gp=0.jpg",
        @"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3313045614,1054782385&fm=26&gp=0.jpg",
        @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=119427962,1769112978&fm=26&gp=0.jpg"].mutableCopy;

    self.itemTapView.maxCount = self.datas.count;
    self.itemTapView.datas = @[].mutableCopy;
}
- (IBAction)onlickConfirm:(id)sender {
    self.itemTapView.isShowDelCtx = NO;
}

-(void) onclickAdd{
    for (id data in self.datas) {
        if([self.itemTapView.datas containsObject:data]) continue;
        [self.itemTapView addData:data animations:YES];
        break;
    }
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
