//
//  PYTestWebViewController.m
//  PYKit
//
//  Created by wlpiaoyi on 2019/3/6.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import "PYTestWebViewController.h"
#import "pyutilea.h"
#import "PYWebView.h"
#import "PYUtile.h"

@interface PYTestWebViewController ()<WKNavigationDelegate>{
    NSTimer * timer;
}
kPNSNA PYWebView * webView;
@end

@implementation PYTestWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [PYWebView new];
    [self.view addSubview:self.webView];
    [PYViewAutolayoutCenter persistConstraint:self.webView relationmargins:UIEdgeInsetsZero controller:self];
    
//    [self.webView loadHTMLString:[NSString stringWithContentsOfFile:kFORMAT(@"%@/1.html", bundleDir) encoding:NSUTF8StringEncoding error:nil] baseURL:nil];
    [self.webView reloadInjectJS];
    [self.webView addJavascriptInterface:self name:@"native"];
    
    self.webView.isShowProgress = YES;
    [self.webView loadHTMLString:[NSString stringWithContentsOfFile:kFORMAT(@"%@/1.html", bundleDir) encoding:NSUTF8StringEncoding error:nil] baseURL:[NSURL URLWithString:@"http://js.nicedit.com"]];
    timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self.webView evaluateJavaScript:@"getContext()" completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
            NSLog(@"%@", obj);
        }];
    }];
    [timer fire];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
}
-(void) loaded{
    
    threadJoinGlobal(^{
        [NSThread sleepForTimeInterval:3];
        threadJoinMain(^{

            [self.webView evaluateJavaScript:@"addImg(\"http://img1.imgtn.bdimg.com/it/u=3407885482,422281971&fm=26&gp=0.jpg\")" completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
                NSLog(@"");
            }];
        });
    });
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) dealloc{
    NSLog(@"======");
}

@end
