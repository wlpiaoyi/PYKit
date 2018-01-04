//
//  PYTestRefreshController.m
//  PYKit
//
//  Created by wlpiaoyi on 2018/1/2.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import "PYTestRefreshController.h"
#import "PYRefresh.h"

@implementation PYRefreshScrollview
-(void) dealloc{
}
@end

@interface PYTestRefreshController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation PYTestRefreshController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.contentSize  = CGSizeMake(0, 600);
    kAssign(self);
    [self.scrollView setPy_blockRefreshHeader:^(UIScrollView * _Nonnull scrollView) {
        kStrong(self);
        kDISPATCH_GLOBAL_QUEUE_DEFAULT(^{
            [NSThread sleepForTimeInterval:2];
            kDISPATCH_MAIN_THREAD(^{
                [self.scrollView py_endRefreshHeader];
            });
        });
    }];
    [self.scrollView setPy_blockRefreshFooter:^(UIScrollView * _Nonnull scrollView) {
        kStrong(self);
        
        kDISPATCH_GLOBAL_QUEUE_DEFAULT(^{
            [NSThread sleepForTimeInterval:2];
            kDISPATCH_MAIN_THREAD(^{
                [self.scrollView py_endRefreshFooter];
            });
        });
    }];
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
