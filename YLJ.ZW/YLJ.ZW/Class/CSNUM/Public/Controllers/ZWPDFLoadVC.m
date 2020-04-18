//
//  ZWPDFLoadVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/3/28.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWPDFLoadVC.h"
#import <WebKit/WebKit.h>
@interface ZWPDFLoadVC ()<WKNavigationDelegate>

@property (nonatomic,strong) WKWebView* webView;
@property (strong, nonatomic) UIProgressView *progressView;

@end

@implementation ZWPDFLoadVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"浏览"; // 标题
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, zwNavBarHeight, kScreenWidth, kScreenHeight-zwNavBarHeight)];
    _webView.navigationDelegate = self;
    _webView .backgroundColor = [UIColor whiteColor];
    NSLog(@"========%@",self.pdfUrl);
    NSArray *array = [self.pdfUrl componentsSeparatedByString:@","];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",httpImageUrl,[array objectAtIndex:1]];
    
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,urlStr]]];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    
//    _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 65, CGRectGetWidth(self.view.frame),2)];
//    [self.view addSubview:_progressView];
//
//    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld context:nil];
//    [self createData];
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
////    NSLog(@" %s,change = %@",__FUNCTION__,change);
//    if ([keyPath isEqual: @"estimatedProgress"] && object == _webView) {
//        [self.progressView setAlpha:1.0f];
//        [self.progressView setProgress:_webView.estimatedProgress animated:YES];
//        if(_webView.estimatedProgress >= 1.0f)
//        {
//            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
//                [self.progressView setAlpha:0.0f];
//            } completion:^(BOOL finished) {
//                [self.progressView setProgress:0.0f animated:NO];
//            }];
//        }
//    }
//    else {
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    }
//}
//
//- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
//    NSLog(@"webViewDidStartLoad");
//}
//
//- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//    NSLog(@"webViewDidFinishLoad");
////    self.wuwangluo.hidden = YES;
//
//}
//
//- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
//    NSLog(@"webViewDidFail");
//}
//
//- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
////    NSLog(@"webViewDidFailProvisional");
////    dispatch_async(dispatch_get_main_queue(), ^{
////       [MyController showAlert:@"网络连接异常,请检查网络" view:self.view];
////    });
////    self.wuwangluo.hidden = NO;
////    [self.view bringSubviewToFront:self.wuwangluo];
//
//}
//
//- (void)createData{
//    [self loadExamplePage:_webView];
//}
//
//- (void)loadExamplePage:(WKWebView*)webView {
//
//    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,self.pdfUrl]]]; // 网络地址
//    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"1111111" ofType:@"pdf"]; // 本地
//    //    NSURL *url = [NSURL fileURLWithPath:path];
//    //    NSURLRequest *request=[NSURLRequest requestWithURL:url];
//    [_webView loadRequest:request];
//}
//
//- (void)dealloc {
//    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
//    // if you have set either WKWebView delegate also set these to nil here
//    [_webView setNavigationDelegate:nil];
//    [_webView setUIDelegate:nil];
//}
//
//- (void) backBtnClicked {
//    NSArray * types = @[WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeDiskCache];
//    NSSet *websiteDataTypes = [NSSet setWithArray:types];
//    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
//    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
//    }];
//    [self.navigationController popViewControllerAnimated:YES];
//}

@end
