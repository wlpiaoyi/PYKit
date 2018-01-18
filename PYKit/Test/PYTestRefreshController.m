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
kPNSNN UIView * contentView;
@end

@implementation PYTestRefreshController

- (void)viewDidLoad {
    [super viewDidLoad];
    _scrollView.delegate = self;
    [self.scrollView setCornerRadiusAndBorder:1 borderWidth:1 borderColor:[UIColor greenColor]];
    self.scrollView.contentSize  = CGSizeMake(0, 800);
    kAssign(self);
    [self.scrollView setPy_blockRefreshHeader:^(UIScrollView * _Nonnull scrollView) {
        kStrong(self);
        [self.scrollView py_endRefreshHeader];
    }];
    [self.scrollView setPy_blockRefreshFooter:^(UIScrollView * _Nonnull scrollView) {
        kStrong(self);
//        [self.scrollView py_endRefreshFooter];
    }];
    self.contentView = [UIView new];
    [self.contentView setCornerRadiusAndBorder:1 borderWidth:1 borderColor:[UIColor redColor]];
    [self.scrollView addSubview:_contentView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"begin");
}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"did");
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void) viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _contentView.frameSize = self.scrollView.frameSize;
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
