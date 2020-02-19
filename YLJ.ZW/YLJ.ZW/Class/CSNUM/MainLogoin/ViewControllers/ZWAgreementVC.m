//
//  ZWAgreementVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/11/6.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWAgreementVC.h"
#import <WebKit/WebKit.h>
@interface ZWAgreementVC ()<WKUIDelegate,WKNavigationDelegate>
@property(nonatomic, strong)WKWebView *webView;
@end

@implementation ZWAgreementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createWebView];
    [self createNavigationBar];
}
- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
}
- (void)goBack:(UINavigationItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createWebView {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"注册协议与隐私政策";
    WKWebViewConfiguration *conf = [[WKWebViewConfiguration alloc]init];
    conf.preferences = [[WKPreferences alloc]init];
    conf.preferences.minimumFontSize = 10;
    conf.preferences.javaScriptEnabled = YES;
    conf.userContentController = [[WKUserContentController alloc]init];
    conf.processPool = [[WKProcessPool alloc]init];

    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0.01*kScreenWidth, 0, 0.98*kScreenWidth, kScreenHeight-zwNavBarHeight) configuration:conf];
    self.webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"agreement.html" ofType:nil];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
    
}

@end
