//
//  SelecteBarController.m
//  PYKit
//
//  Created by wlpiaoyi on 2017/9/18.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import "SelecteBarController.h"
#import "PYSelectorBarView.h"
#import "pyutilea.h"

@interface SelecteBarController ()<UIScrollViewDelegate>
kPNSNN UIView * contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet PYSelectorBarView *selectorBarView;
@end

@implementation SelecteBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    _contentView = [UIView new];
    [self.scrollView addSubview:_contentView];
    NSArray * array = [NSArray arrayWithObjects:[self createButton],[self createButton],[self createButton],[self createButton],[self createButton], nil];
    _selectorBarView.buttons = array;
    _selectorBarView.contentWidth = 400;
    _scrollView.pagingEnabled = YES;
    for (int i = 0; i < array.count; i++) {
        [_contentView addSubview:[self createView]];
    }
    _scrollView.delegate = self;
    [PYViewAutolayoutCenter persistConstraintHorizontal:_contentView.subviews relationmargins:UIEdgeInsetsZero relationToItems:PYEdgeInsetsItemNull() offset:0];
    [_selectorBarView setBlockSelecteItem:^BOOL(int index){
        [_scrollView setContentOffset:CGPointMake(index * _scrollView.frameWidth , 0) animated:YES];
        return YES;
    }];
}
-(UIButton *) createButton{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"menu" forState:UIControlStateNormal];
    [button setTitle:@"menus" forState:UIControlStateSelected];
    return button;
}
-(UIView *) createView{
    UIView * view = [UIView new];
    [view setCornerRadiusAndBorder:2 borderWidth:2 borderColor:[UIColor redColor]];
    return view;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [_selectorBarView setSelectIndex:((NSUInteger)(scrollView.contentOffset.x/scrollView.frameWidth)) animation:YES];
}
-(void) viewDidLayoutSubviews{
    CGRect r = CGRectMake(0, 0, self.scrollView.frameWidth * 5, self.scrollView.frameHeight);
    self.scrollView.contentSize = r.size;
    self.contentView.frame = r;
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
