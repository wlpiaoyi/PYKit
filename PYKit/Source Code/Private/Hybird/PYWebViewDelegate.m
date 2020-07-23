//
//  PYWebViewDelegate.m
//  PYKit
//
//  Created by wlpiaoyi on 2019/2/28.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import "PYWebViewDelegate.h"
#import "PYHybirdUtile.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <objc/runtime.h>
#import <WebKit/WebKit.h>
#import "pyutilea.h"
#import "pyinterflowa.h"



@interface UIView(__PY_WEBVIEW_TEMP)
kPNA CGFloat schedule;
@end

@interface WKWebView(__PY_WEBVIEW_TEMP)
kPNSNA id interfacesDict;
kPNSNN WKNavigation * navigation;
kPNSNA id <WKNavigationDelegate> navigationDelegatec;
kPNSNA id <WKUIDelegate> UIDelegatec;
kPNSNN UIView * progressView;
-(void) showProgress:(CGFloat) progeress;
-(void) hiddenProgress;
@end

NSString * PYWebViewPrompt = @"qqpiaoyi_prompt";

@implementation PYWebViewUIDelegate
#pragma WKUIDelegate ==>
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    if([webView.UIDelegatec respondsToSelector:_cmd]){
        return [webView.UIDelegatec webView:webView createWebViewWithConfiguration:configuration forNavigationAction:navigationAction windowFeatures:windowFeatures];
    }else{
        return nil;
    }
}
- (void)webViewDidClose:(WKWebView *)webView{
    if([webView.UIDelegatec respondsToSelector:_cmd]){
        return [webView.UIDelegatec webViewDidClose:webView];
    }
}
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    if([webView.UIDelegatec respondsToSelector:_cmd]){
        [webView.UIDelegatec webView:webView runJavaScriptAlertPanelWithMessage:message initiatedByFrame:frame completionHandler:completionHandler];
    }else{
        UIView * dialog = [UIView new];
        dialog.dialogShowView.popupBlockTap = ^(UIView * _Nullable view) {};
        [dialog dialogShowWithTitle:webView.title ? :  webView.title  message:message block:^(UIView * _Nonnull view, BOOL isConfirm) {
            [view dialogHidden];
            completionHandler();
        } buttonConfirm:@"确定" buttonCancel:nil];
    }
}
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    if([webView.UIDelegatec respondsToSelector:_cmd]){
        [webView.UIDelegatec webView:webView runJavaScriptConfirmPanelWithMessage:message initiatedByFrame:frame completionHandler:completionHandler];
    }else{
        UIView * dialog = [UIView new];
        dialog.dialogShowView.popupBlockTap = ^(UIView * _Nullable view) {};
        [dialog dialogShowWithTitle:webView.title ? :  webView.title  message:message block:^(UIView * _Nonnull view, BOOL isConfirm) {
            [view dialogHidden];
            completionHandler(isConfirm);
        } buttonConfirm:@"确定" buttonCancel:@"取消"];
    }
}
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    if ([prompt isEqual:PYWebViewPrompt]) {
        NSDictionary * jsDict = [[defaultText dataUsingEncoding:NSUTF8StringEncoding] toDictionary];
        NSDictionary * interfaceDict = webView.interfacesDict[jsDict[@"instanceName"]];
        NSDictionary * resultDict = [PYHybirdUtile invokeInstanceFromJs:jsDict interfaceDict:interfaceDict];
        completionHandler([[resultDict toData] toString]);
    }else{
        if([webView.UIDelegatec respondsToSelector:_cmd]){
            [webView.UIDelegatec webView:webView runJavaScriptTextInputPanelWithPrompt:prompt defaultText:defaultText initiatedByFrame:frame completionHandler:completionHandler];
        }else{
            completionHandler(@"success");
        }
    }
}
- (BOOL)webView:(WKWebView *)webView shouldPreviewElement:(WKPreviewElementInfo *)elementInfo{
    if([webView.UIDelegatec respondsToSelector:_cmd]){
        return [webView.UIDelegatec webView:webView shouldPreviewElement:elementInfo];
    }else{
        return true;
    }
}
- (nullable UIViewController *)webView:(WKWebView *)webView previewingViewControllerForElement:(WKPreviewElementInfo *)elementInfo defaultActions:(NSArray<id <WKPreviewActionItem>> *)previewActions{
    if([webView.UIDelegatec respondsToSelector:_cmd]){
        return [webView.UIDelegatec webView:webView previewingViewControllerForElement:elementInfo defaultActions:previewActions];
    }else{
        return nil;
    }
}
- (void)webView:(WKWebView *)webView commitPreviewingViewController:(UIViewController *)previewingViewController{
    if([webView.UIDelegatec respondsToSelector:_cmd]){
        [webView.UIDelegatec webView:webView commitPreviewingViewController:previewingViewController];
    }
}
#pragma WKUIDelegate <==
@end


@implementation PYWebViewNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    if([webView.navigationDelegatec respondsToSelector:_cmd]){
        [webView.navigationDelegatec webView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
    }else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    if([webView.navigationDelegatec respondsToSelector:_cmd]){
        [webView.navigationDelegatec webView:webView decidePolicyForNavigationResponse:navigationResponse decisionHandler:decisionHandler];
    }else{
        decisionHandler(WKNavigationResponsePolicyAllow);
    }
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    webView.navigation = navigation;
    [webView showProgress:0.3];
    
    if([webView.navigationDelegatec respondsToSelector:_cmd]){
        [webView.navigationDelegatec webView:webView didStartProvisionalNavigation:navigation];
    }
}
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    webView.navigation = navigation;
    webView.progressView.schedule = 0.6;
    
    if([webView.navigationDelegatec respondsToSelector:_cmd]){
        [webView.navigationDelegatec webView:webView didReceiveServerRedirectForProvisionalNavigation:navigation];
    }
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    if(webView.navigation == navigation) [webView hiddenProgress];
    if([webView.navigationDelegatec respondsToSelector:_cmd]){
        [webView.navigationDelegatec webView:webView didFailProvisionalNavigation:navigation withError:error];
    }
}
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
    webView.progressView.schedule = 0.8;
    
    if([webView.navigationDelegatec respondsToSelector:_cmd]){
        [webView.navigationDelegatec webView:webView didCommitNavigation:navigation];
    }
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    if(webView.navigation == navigation) [webView hiddenProgress];
    
    if([webView.navigationDelegatec respondsToSelector:_cmd]){
        [webView.navigationDelegatec webView:webView didFinishNavigation:navigation];
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    if([webView.navigationDelegatec respondsToSelector:_cmd]){
        [webView.navigationDelegatec webView:webView didFailNavigation:navigation withError:error];
    }
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    if([webView.navigationDelegatec respondsToSelector:_cmd]){
        [webView.navigationDelegatec webView:webView didReceiveAuthenticationChallenge:challenge completionHandler:completionHandler];
    }else{
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
    }
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    if([webView.navigationDelegatec respondsToSelector:_cmd]){
        [webView.navigationDelegatec webViewWebContentProcessDidTerminate:webView];
    }
}

@end
