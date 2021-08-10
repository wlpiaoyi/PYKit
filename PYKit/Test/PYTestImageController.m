//
//  PYTestImageController.m
//  PYKit
//
//  Created by wlpiaoyi on 2018/3/5.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import "PYTestImageController.h"
#import "PYAsyImageView.h"
#import "PYAsyGifView.h"
#import "PYDisplayImageView.h"

@interface PYTestImageController ()
@property (weak, nonatomic) IBOutlet PYDisplayImageView *dView;
@property (weak, nonatomic) IBOutlet PYAsyImageView *imageView;
@end

@implementation PYTestImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    PYAsyGifView * gifView = [PYAsyGifView new];
    [self.view addSubview:gifView];
//    [gifView setLocatonPath:kFORMAT(@"%@/1.gif", bundleDir)];
//    [gifView setImgUrl:@"http://qn.100csc.com/1616030861888-shrz-pcxiao.gif"];
//    [gifView py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
//        make.width.height.py_constant(200);
//        make.centerX.centerY.py_constant(0);
//    }];
    
//    gifView = [PYAsyGifView new];
//    [self.view addSubview:gifView];
////    [gifView setLocatonPath:kFORMAT(@"%@/1.gif", bundleDir)];
//    [gifView setImgUrl:@"http://qn.100csc.com/1616030861888-shrz-pcxiao.gif"];
//    [gifView py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
//        make.width.height.py_constant(200);
//        make.centerX.centerY.py_constant(100);
//    }];
//    
//    gifView = [PYAsyGifView new];
//    [self.view addSubview:gifView];
////    [gifView setLocatonPath:kFORMAT(@"%@/1.gif", bundleDir)];
//    [gifView setImgUrl:@"http://qn.100csc.com/1616030861888-shrz-pcxiao.gif"];
//    [gifView py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
//        make.width.height.py_constant(200);
//        make.centerX.centerY.py_constant(-100);
//    }];
//    [gifView start];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [PYAsyImageView clearCaches];
    PY_ASY_NODATA_IMG_DICT = @{@"default": [UIImage imageNamed:@"1.jpg"]};
    PY_ASY_LOADING_IMG_DICT = @{@"default": [UIImage imageNamed:@"2.png"]};
    
        PYAsyImageView * aiv = [[self.view viewWithTag:186201] viewWithTag:18622901];
        aiv.imgUrl = @"http://qn.100csc.com/1617259748124_3.jpg";
//    self.imageView.imgUrl = @"https://www.google.com";
    for(int i = 0; i < 5; i++){
        PYAsyImageView * aiv = [[self.view viewWithTag:186201] viewWithTag:18622901 + i];
        aiv.imgUrl = @[@"http://qn.100csc.com/1606123607424-12558412432_559206019.220x220.jpg",
                       @"http://qn.100csc.com/merchant_2.gif",
                       @"http://qn.100csc.com/1620370658912-cjzx-730x315.gif"
                       ,@"http://qn.100csc.com/merchant_join_pc.gif"
                       ,@"http://qn.100csc.com/1620370698190-1d1fd-730x315.gif"
                       ,@"http://qn.100csc.com/merchant_2.gif"][i];
    };
//    for(int i = 0; i < 5; i++){
//        PYAsyImageView * aiv = [[self.view viewWithTag:186202] viewWithTag:18622901 + i];
//        aiv.imgUrl = @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fattach.bbs.miui.com%2Fforum%2F201410%2F25%2F220832wlwzqq6ble9ql6rd.jpg&refer=http%3A%2F%2Fattach.bbs.miui.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1621496932&t=0abc5f82dfe13ce6ce5599450bb6c536";
//    }
//    self.imageView.imgUrl = @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fattach.bbs.miui.com%2Fforum%2F201304%2F25%2F195133e7a1l7b4f5117y4y.jpg&refer=http%3A%2F%2Fattach.bbs.miui.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1621493364&t=ea1f6004319beb552077e00342d426a7";// @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1598358502232&di=8825620081e9fe7fadf8dc47ea269036&imgtype=0&src=http%3A%2F%2Ft8.baidu.com%2Fit%2Fu%3D3571592872%2C3353494284%26fm%3D79%26app%3D86%26f%3DJPEG%3Fw%3D1200%26h%3D1290";//@"http://120.24.234.64:13102/BRService/fserver/view.do?filename=&access_token=br_token__72EDDBECFCEC46D2B51D444B83564846";//
//    NSArray * a = @[
//      @"http://img6.3lian.com/c23/desk4/05/77/d/01.jpg",
//      @"http://www.kandianying.com/upload/201305/%E6%9D%A8%E5%B9%82%20%E4%BD%99%E6%96%87%E4%B9%90%20(3).jpg",
//      @"http://pic1.win4000.com/wallpaper/5/5306bc5e18592.jpg",
//      @"http://4493bz.1985t.com/uploads/allimg/161013/3-161013101319.jpg",
//      @"http://pic.4j4j.cn/upload/pic/20121023/e2ab92cb7b.jpg",
//      @"http://pic1.win4000.com/wallpaper/c/4fcec99acc4e4.jpg",
//      @"http://img6.3lian.com/c23/desk3/11/35/2.jpg",
//      @"http://pic5.bbzhi.com/fengjingbizhi/gaoqingziranfengjingbizhi/gaoqingziranfengjingbizhi_415650_15.jpg"
//      ];
//    ((PYAsyImageView *)self.dView.imageView).imgUrl = a[(random()%a.count)];
    
//    [((PYAsyImageView *)self.dView.imageView) setBlockDisplay:^(bool isSuccess, bool isCahes, PYAsyImageView * _Nonnull imageView) {
//
//    }];
//    ((PYAsyImageView *)self.dView.imageView).imgUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1522504491061&di=139960c07bd7d5742abf9c6b0816fbcf&imgtype=0&src=http%3A%2F%2Fimgstore.cdn.sogou.com%2Fapp%2Fa%2F100540002%2F680740.jpg";
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
