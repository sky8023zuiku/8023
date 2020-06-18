//
//  ZWIntegralRulesVC.m
//  YLJ.ZW
//
//  Created by G G on 2019/8/29.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWIntegralRulesVC.h"
#import <WebKit/WebKit.h>

@interface ZWIntegralRulesVC ()<WKUIDelegate,WKNavigationDelegate>

@property(nonatomic, strong)WKWebView *webView;

@end

@implementation ZWIntegralRulesVC

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNavigationBar];
}

- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
}
- (void)goBack:(UIBarButtonItem *)item {
    if (self.status == 1) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)createUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    WKWebViewConfiguration *conf = [[WKWebViewConfiguration alloc]init];
    conf.preferences = [[WKPreferences alloc]init];
    conf.preferences.minimumFontSize = 10;
    conf.preferences.javaScriptEnabled = YES;
    conf.userContentController = [[WKUserContentController alloc]init];
    conf.processPool = [[WKProcessPool alloc]init];

    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0.01*kScreenWidth, 0, 0.98*kScreenWidth, kScreenHeight-zwNavBarHeight) configuration:conf];
    self.webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"rules_ex_coin.html" ofType:nil];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
    

}
@end
