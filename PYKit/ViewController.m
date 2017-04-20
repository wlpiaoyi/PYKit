//
//  ViewController.m
//  PYKit
//
//  Created by wlpiaoyi on 2017/4/19.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import "ViewController.h"
#import "PYDisplayImageView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet PYDisplayImageView *viewImage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ((PYDisplayImageView*)self.viewImage).imgUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1492615837709&di=d1557b3e4bc4106d8969cc023f29a3c6&imgtype=0&src=http%3A%2F%2Fc.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2F8601a18b87d6277fc422bbe028381f30e924fc32.jpg";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
