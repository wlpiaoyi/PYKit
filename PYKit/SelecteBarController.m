//
//  SelecteBarController.m
//  PYKit
//
//  Created by wlpiaoyi on 2017/9/18.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import "SelecteBarController.h"
#import "PYSelectorScrollView.h"
#import "pyutilea.h"

@interface SelecteBarController ()<UIScrollViewDelegate,PYSelectorBarViewDelegate>{
    BOOL a;
}
kPNSNN UIView * contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet PYSelectorScrollView *selectorBarView;
@end

@implementation SelecteBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    _contentView = [UIView new];
    [self.scrollView addSubview:_contentView];
    _scrollView.pagingEnabled = YES;
    for (int i = 0; i < _selectorBarView.buttons.count; i++) {
        [_contentView addSubview:[self createView:i]];
    }
    _selectorBarView.delegate = self;
    _scrollView.delegate = self;
    _selectorBarView.isScorllSelected = true;
    [PYViewAutolayoutCenter persistConstraintHorizontal:_contentView.subviews relationmargins:UIEdgeInsetsZero relationToItems:PYEdgeInsetsItemNull() offset:0];
    kAssign(self);
    [_selectorBarView setBlockSelecteItem:^BOOL(NSUInteger index){
        kStrong(self);
        [self.scrollView setContentOffset:CGPointMake(index * self.scrollView.frameWidth , 0) animated:YES];
        return YES;
    }];
}
-(UIView *) createView:(int) index{
    UILabel * view = [UILabel new];
    [view setCornerRadiusAndBorder:2 borderWidth:2 borderColor:[UIColor redColor]];
    view.text = @(index+1).stringValue;
    view.font = kFontB(30);
    view.textColor = kRGB(255, 0, 0);
    return view;
}

-(BOOL) selectorBarView:(nonnull PYSelectorBarView *) selectorBarView selectedItemIndex:(NSUInteger) selecteItemIndex{
    [self.scrollView setContentOffset:CGPointMake(selecteItemIndex * self.scrollView.frameWidth , 0) animated:YES];
    return YES;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [_selectorBarView setSelectIndex:((NSUInteger)(scrollView.contentOffset.x/scrollView.frameWidth)) animation:YES];
}
-(void) viewDidLayoutSubviews{
    CGRect r = CGRectMake(0, 0, self.scrollView.frameWidth * _selectorBarView.buttons.count, self.scrollView.frameHeight);
    self.scrollView.contentSize = r.size;
    self.contentView.frame = r;
    [_scrollView setContentOffset:CGPointMake(self.selectorBarView.selectIndex * _scrollView.frameWidth , 0) animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void) dealloc{
    
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
