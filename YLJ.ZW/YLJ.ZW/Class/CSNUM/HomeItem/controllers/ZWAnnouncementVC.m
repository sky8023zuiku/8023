//
//  ZWAnnouncementVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/2/6.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWAnnouncementVC.h"
#import "ZWImageBrowser.h"
@interface ZWAnnouncementVC ()
@property(nonatomic, strong)UIImageView *imageView;
@end

@implementation ZWAnnouncementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBar];
    [self createUI];
}

- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
}
- (void)goBack:(UINavigationItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"----%@",self.imageUrl);
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@",httpImageUrl,self.imageUrl];
    NSString * urlStr = [imageUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, kScreenWidth-30, 0.8*kScreenHeight)];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlStr]] placeholderImage:[UIImage imageNamed:@"fu_img_no_02"]];
    self.imageView.userInteractionEnabled = YES;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageClick:)];
    [self.imageView addGestureRecognizer:tap];
    
}
- (void)tapImageClick:(UIGestureRecognizer *)gesture {
    [ZWImageBrowser showImageV_img:self.imageView];
}

@end
