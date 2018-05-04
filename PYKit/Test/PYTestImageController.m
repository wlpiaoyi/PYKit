//
//  PYTestImageController.m
//  PYKit
//
//  Created by wlpiaoyi on 2018/3/5.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import "PYTestImageController.h"
#import "PYAsyImageView.h"
#import "PYDisplayImageView.h"

@interface PYTestImageController ()
@property (weak, nonatomic) IBOutlet PYDisplayImageView *dView;
@property (weak, nonatomic) IBOutlet PYAsyImageView *imageView;
@end

@implementation PYTestImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [PYAsyImageView clearCaches];
    self.imageView.imgUrl = @"http://b.hiphotos.baidu.com/image/pic/item/359b033b5bb5c9eab4279cc5d939b6003bf3b3c4.jpg";
    ((PYAsyImageView *)self.dView.imageView).imgUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1522504491061&di=139960c07bd7d5742abf9c6b0816fbcf&imgtype=0&src=http%3A%2F%2Fimgstore.cdn.sogou.com%2Fapp%2Fa%2F100540002%2F680740.jpg";
    ((PYAsyImageView *)self.dView.imageView).imgUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1522504491061&di=139960c07bd7d5742abf9c6b0816fbcf&imgtype=0&src=http%3A%2F%2Fimgstore.cdn.sogou.com%2Fapp%2Fa%2F100540002%2F680740.jpg";
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
