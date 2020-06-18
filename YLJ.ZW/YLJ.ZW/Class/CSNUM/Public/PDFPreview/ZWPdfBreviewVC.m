//
//  ZWPdfBreviewVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/6/18.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWPdfBreviewVC.h"
#import <WebKit/WebKit.h>
#import "ZWPdfManager.h"
@interface ZWPdfBreviewVC ()

@end

@implementation ZWPdfBreviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBar];
    [self createUI];
}

- (void)createUI {
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight)];
    NSURLRequest *req = [NSURLRequest requestWithURL:self.url];
    [webView loadRequest:req];
    [self.view addSubview:webView];
}

- (void)createNavigationBar {
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = skinColor;
    self.navigationController.navigationBar.translucent = NO;
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"ren_bianji_icon_topshang"] barItem:self.navigationItem target:self action:@selector(backItemClick:)];
    [[YNavigationBar sharedInstance]createRightBarWithImage:[UIImage imageNamed:@"download_icon"] barItem:self.navigationItem target:self action:@selector(rightItemClick:)];
}

- (void)backItemClick:(UIBarButtonItem *)item {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightItemClick:(UIBarButtonItem *)item {
    NSString *urlStr = [self.url absoluteString];
    [[ZWPdfManager shareManager]downloadPdfProfile:self withUrl:urlStr withFileName:self.title];
}

@end
