//
//  ViewController.m
//  PYKit
//
//  Created by wlpiaoyi on 2017/4/19.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import "ViewController.h"
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

@interface ViewController () <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>{
@private
    PY3DOrthogonView * a3dView;
}
//@property (weak, nonatomic) IBOutlet PYDisplayImageView *viewImage;
//@property (weak, nonatomic) IBOutlet PYCalendarView *calendarView;
//@property (weak, nonatomic) IBOutlet UITextField *textField;
//@property (strong, nonatomic) IBOutlet UITextView * textView;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
PYPNSNN NSArray * datas;
//@property (nonatomic,strong) PYAudioPlayer *player;
@end

@implementation ViewController

- (void)viewDidLoad {
//    [PYAsyImageView clearCaches];
    [super viewDidLoad];
    self.datas = @[
                   @{@"name":@"refresh", @"sel":@"goToRefresh"},
                   @{@"name":@"calendar", @"sel":@"goToCalendar"}
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
//    kDISPATCH_GLOBAL_QUEUE_DEFAULT(^{
//        CGFloat v = 0;
//        while (true) {
//            v++;
//            kDISPATCH_MAIN_THREAD(^{
//                [a3dView angleWithDegreex:45 degreey:v degreez:45];
//            });
//            [NSThread sleepForTimeInterval:0.01];
//        }
//    });
}
//- (void)py_attributeTapReturnString:(NSString *)string range:(NSRange)range index:(NSInteger)index
//{
//    NSString *message = [NSString stringWithFormat:@"点击了“%@”字符\nrange: %@\nindex: %ld",string,NSStringFromRange(range),index];
//    UIView * view = [UIView new];
//    [view dialogShowWithTitle:nil message:message block:^(UIView * _Nonnull view, NSUInteger index) {
//        [view dialogHidden];
//    } buttonNames:@[@"确定"]];
//}
//- (void)textFieldDidBeginEditing:(UITextField *)textField{
//}
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    return YES;
//}
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
////    [self presentViewController:[TextFieldCheckController new] animated:YES completion:^{
////
////    }];
//    return YES;
//}
//- (IBAction)start:(id)sender {
//    NSURL * url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/record.mp3",documentDir]];
//    [[PYAudioRecord getSingleInstance] start:url settings:@{AVFormatIDKey:@(kAudioFormatMPEGLayer3)}];
//}
//- (IBAction)stop:(id)sender {
//    [[PYAudioRecord getSingleInstance] stop];
//    NSFileManager *fm = [NSFileManager defaultManager];
////    [fm removeItemAtPath:[pathWav relativePath] error:&erro];
//
//    self.player = [PYAudioPlayer sharedPYAudioPlayer];
//    NSError *error;
//    NSArray<NSString *> * array =  [fm subpathsOfDirectoryAtPath:documentDir error:&error];
//    if (!error) {
//        for (NSString * path in array) {
//            [self.player addAudioUrl:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", documentDir, path]]];
//        }
//        [self.player play];
//    }
//}

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
//    PYAsyImageView * asyImgView = [PYAsyImageView new];
//    [cell.contentView addSubview:asyImgView];
//    asyImgView.frameSize = CGSizeMake(200, 44);
//    [asyImgView setBlockDisplay:^(bool isSuccess, bool isCahes, PYAsyImageView * _Nonnull imageView) {
//        imageView.image = [imageView.image cutImage:CGRectMake(0, 0, 100, 100)];
//    }];
//    asyImgView.imgUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1511768544898&di=cfdcff062b8a746e0d5999777f529bb6&imgtype=0&src=http%3A%2F%2Fimg2.niutuku.com%2Fdesk%2F1208%2F2027%2Fntk-2027-16107.jpg";
//    [asyImgView setCornerRadiusAndBorder:1 borderWidth:1 borderColor:[UIColor redColor]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SEL actioin = sel_getUid(((NSString *)self.datas[indexPath.row][@"sel"]).UTF8String);
    [self performSelector:actioin];
}
-(void) goToRefresh{
    [self performSegueWithIdentifier:@"refresh" sender:nil];
}
-(void) goToCalendar{
    [self performSegueWithIdentifier:@"calendar" sender:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
