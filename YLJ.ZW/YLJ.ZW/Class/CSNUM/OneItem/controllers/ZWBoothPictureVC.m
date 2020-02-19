//
//  ZWBoothPictureVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/25.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWBoothPictureVC.h"
#import "ZWImageBrowser.h"
@interface ZWBoothPictureVC ()
@property(nonatomic, strong)UIImageView *imageView;
@end

@implementation ZWBoothPictureVC

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
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, kScreenWidth-30, 0.5*kScreenWidth)];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlStr]] placeholderImage:[UIImage imageNamed:@"fu_img_no_02"]];
    self.imageView.userInteractionEnabled = YES;
    [self.view addSubview:self.imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageClick:)];
    [self.imageView addGestureRecognizer:tap];
    
}
- (void)tapImageClick:(UIGestureRecognizer *)gesture {
    [ZWImageBrowser showImageV_img:self.imageView];
}
@end
