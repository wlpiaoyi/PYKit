//
//  ViewController.m
//  PYKit
//
//  Created by wlpiaoyi on 2017/4/19.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import "ViewController.h"
#import "pyutilea.h"
#import "PYDisplayImageView.h"
#import "UITextField+PYCheck.h"
#import "TextFieldCheckController.h"
#import "PYAudioRecord.h"
#import "PYAudioPlayer.h"
#import "PYCalendarView.h"
#import "PYWebView.h"
#import "PYViewAutolayoutCenter.h"
#import "UIView+Dialog.h"
#import "PY3DOrthogonView.h"
#import "PYAsyImageView.h"
#import "PYTestSliderController.h"
#import "PYImagePickerController.h"
#import "PYCameraPickerController.h"
#import "PYNavigationControll.h"


@interface ViewController () <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,PYNavigationSetterTag>{
@private
    PY3DOrthogonView * a3dView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
PYPNSNN NSArray * datas;
@end

@implementation ViewController
- (void)viewDidLoad {
//    [PYAsyImageView clearCaches];
    [super viewDidLoad];
    self.datas = @[
                   @{@"name":@"refresh", @"id":@"refresh"},
                   @{@"name":@"calendar", @"id":@"calendar"},
                   @{@"name":@"image", @"id":@"image"},
                   @{@"name":@"slider", @"id":@"slider"},
                   @{@"name":@"check", @"id":@"check"},
                   @{@"name":@"map", @"id":@"map"},
                   @{@"name":@"webview", @"id":@"webview"},
                   @{@"name":@"camera", @"id":@"PYCameraPickerController"},
                   @{@"name":@"photo", @"id":@"PYImagePickerController"}
                   ];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
//    [self.textField pyClearTextFieldCheck];
//    self.textField.delegate = self;
//    [self.textField pyCheckFloatForMax:9999.99 min:33 precision:2];
//    [self.calendarView synSpesqlInfo];
//    @unsafeify(self);
//    [self.textField setBlockInputEndMatch:^(NSString * _Nonnull identify, BOOL * _Nonnull checkResult){
//        @strongify(self);
//        NSLog(@"");
//    }];

//    PYWebView * webView = [PYWebView new];
//    [self.view addSubview:webView];
//    webView.frameSize = CGSizeMake(100, 100);
//    webView.center = CGPointMake(0, 0);
////    [PYViewAutolayoutCenter persistConstraint:webView relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:PYEdgeInsetsItemNull()];
//    [webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
//    ((PYDisplayImageView*)self.viewImage).imageView.image = [UIImage imageNamed:@"timg.jpeg"];//@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1494325479616&di=12bf378980ba10da9c81426c753c952c&imgtype=0&src=http%3A%2F%2Fimg2.niutuku.com%2F1312%2F0850%2F0850-niutuku.com-30110.jpg";//@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1492615837709&di=d1557b3e4bc4106d8969cc023f29a3c6&imgtype=0&src=http%3A%2F%2Fc.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2F8601a18b87d6277fc422bbe028381f30e924fc32.jpg";
//    [((PYDisplayImageView*)self.viewImage) synchronizedImageSize];
//
//    a3dView = [PY3DOrthogonView new];
//    [self.view addSubview:a3dView];
//    [PYViewAutolayoutCenter persistConstraint:a3dView size:CGSizeMake(200, 200)];
//    [PYViewAutolayoutCenter persistConstraint:a3dView centerPointer:CGPointMake(0, 0)];
//    a3dView.size = PY3DSizeMake(800, 100, 100);
//    UILabel * view = [UILabel new];
//    view.backgroundColor = [UIColor redColor];
//    view.text= @"front";
//    a3dView.viewFront = view;
//    view = [UILabel new];
//    view.backgroundColor = [UIColor greenColor];
//    view.text= @"behind";
//    a3dView.viewBehind = view;
//    view = [UILabel new];
//    view.text= @"left";
//    view.backgroundColor = [UIColor blueColor];
//    a3dView.viewLeft = view;
//    view = [UILabel new];
//    view.text= @"right";
//    view.backgroundColor = [UIColor yellowColor];
//    a3dView.viewRight = view;
//    view = [UILabel new];
//    view.text= @"up";
//    view.backgroundColor = [UIColor orangeColor];
//    a3dView.viewUp= view;
//    view = [UILabel new];
//    view.text= @"down";
//    view.backgroundColor = [UIColor purpleColor];
//    a3dView.viewDown = view;
//    [a3dView syn3DTranslate];
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * data = self.datas[indexPath.row];
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    cell.textLabel.text= data[@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    kFORMAT(@"%d,%ld", indexPath.row, indexPath.section);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([(self.datas[indexPath.row][@"id"]) isEqual:@"PYImagePickerController"]){
        PYImagePickerController * vc = [PYImagePickerController new];
        vc.maxSelected = 3;
        vc.blockSelected = ^(NSArray<PHAsset *> * _Nonnull selectedAssets, BOOL isiCloud) {
            
        };
        [self presentViewController:vc animated:YES completion:^{
            
        }];
        return;
    }
    if([(self.datas[indexPath.row][@"id"]) isEqual:@"PYCameraPickerController"]){
        PYCameraPickerController * vc = [PYCameraPickerController new];
        vc.blockCamera = ^BOOL(UIImage * _Nonnull image) {
            return YES;
        };
        [self presentViewController:vc animated:YES completion:^{
            
        }];
        return;
    }
    [self performSegueWithIdentifier:self.datas[indexPath.row][@"id"] sender:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
