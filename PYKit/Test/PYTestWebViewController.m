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

@interface PYTestWebViewController ()<WKNavigationDelegate>
kPNSNA PYWebView * webView;
@end

@implementation PYTestWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [PYWebView new];
    [self.view addSubview:self.webView];
    [PYViewAutolayoutCenter persistConstraint:self.webView relationmargins:UIEdgeInsetsMake(60, 0, 0, 0) relationToItems:PYEdgeInsetsItemNull()];
//    [self.webView loadHTMLString:[NSString stringWithContentsOfFile:kFORMAT(@"%@/1.html", bundleDir) encoding:NSUTF8StringEncoding error:nil] baseURL:nil];
    self.webView.isShowProgress = YES;
    self.webView.navigationDelegate = self;
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:kFORMAT(@"https://www.cnblogs.com/wb145230/p/4610017.html?uuid=%@", PYUUID(20))]]];
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
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
