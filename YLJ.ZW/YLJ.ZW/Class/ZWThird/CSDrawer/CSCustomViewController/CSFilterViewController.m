//
//  CSFilterViewController.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/6/8.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "CSFilterViewController.h"

#import "REFrostedViewController.h"
#import "ZWExhibitionMenu.h"
#import "CSFilterManager.h"

@interface CSFilterViewController ()

@property(nonatomic, strong)ZWExhibitionMenu *exhibitionMenu;

@end

@implementation CSFilterViewController

- (ZWExhibitionMenu *)exhibitionMenu {
    if (!_exhibitionMenu) {
        _exhibitionMenu = [[ZWExhibitionMenu alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/3*2, kScreenHeight-zwTabBarHeight-zwNavBarHeight) style:UITableViewStyleGrouped];
    }
    return _exhibitionMenu;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createSelectedData];
    [self createUI];
    [self createNavgationBar];
}
- (void)createNavgationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithTitle:@"选择" barItem:self.navigationItem target:self action:@selector(show)];
}

- (void)createSelectedData {
    
    NSMutableArray *arrFilter = [NSMutableArray array];
    if (self.selcetDictionary.count == 0) {
        for (int i = 0; i<5 ; i++) {
            [arrFilter addObject:@{@"id":@"",@"name":@""}];
        }
    }else {
        [arrFilter addObject:self.selcetDictionary[@"country"]];
        [arrFilter addObject:self.selcetDictionary[@"city"]];
        [arrFilter addObject:self.selcetDictionary[@"industry"]];
        [arrFilter addObject:self.selcetDictionary[@"year"]];
        [arrFilter addObject:self.selcetDictionary[@"month"]];
    }
    
    if (arrFilter) {
        self.exhibitionMenu.selectData = [NSMutableArray array];
        [self.exhibitionMenu.selectData addObjectsFromArray:arrFilter];
        [self.view addSubview:self.exhibitionMenu];
    }
}

- (void)createUI {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = skinColor;
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight-zwTabBarHeight-zwNavBarHeight, kScreenWidth/3*2, zwTabBarHeight)];
    bottomView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1];
    [self.view addSubview:bottomView];
    CGFloat with = kScreenWidth/3*2;
    CGFloat interval = 0.1*with;
    
    CGFloat itemW = 0.7*with/2;
    CGFloat itemH = 30;
    int count = 2;
    NSArray *titles = @[@"重置",@"确认"];
    for (int i = 0; i < 2; i++) {
        int col = i % count;
        UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        bottomBtn.frame = CGRectMake(interval +(interval+itemW)*col, 0.2*zwTabBarHeight, itemW, itemH);
        bottomBtn.backgroundColor = zwGrayColor;
        bottomBtn.tag = i;
        [bottomBtn setTitle:titles[i] forState:UIControlStateNormal];
        [bottomBtn setTitleColor:skinColor forState:UIControlStateNormal];
        bottomBtn.titleLabel.font = normalFont;
        bottomBtn.layer.borderColor = skinColor.CGColor;
        bottomBtn.layer.borderWidth = 1;
        bottomBtn.layer.cornerRadius = 5;
        bottomBtn.layer.masksToBounds = YES;
        [bottomBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:bottomBtn];
    }
}



- (void)bottomBtnClick:(UIButton *)btn {
    
    NSDictionary *dicFilter;
    
    if (btn.tag == 0) {
        dicFilter= @{
            @"country":@{@"id":@"",@"name":@""},
            @"city":@{@"id":@"",@"name":@""},
            @"industry":@{@"id":@"",@"name":@""},
            @"year":@{@"id":@"",@"name":@""},
            @"month":@{@"id":@"",@"name":@""},
        };
    }else {
        dicFilter= @{
            @"country":self.exhibitionMenu.selectData[0],
            @"city":self.exhibitionMenu.selectData[1],
            @"industry":self.exhibitionMenu.selectData[2],
            @"year":self.exhibitionMenu.selectData[3],
            @"month":self.exhibitionMenu.selectData[4],
        };
    }
    
    if ([[CSFilterManager shareManager].delegate respondsToSelector:@selector(takeFilterData:)]) {
        [[CSFilterManager shareManager].delegate takeFilterData:dicFilter];
    }
    
    if (btn.tag == 0) {
        NSDictionary *myDic = @{@"id":@"",@"name":@""};
        for (int i = 0; i<self.exhibitionMenu.selectData.count; i++) {
            [self.exhibitionMenu.selectData replaceObjectAtIndex:i withObject:myDic];
        }
        [self.exhibitionMenu reloadData];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"takeExhibitionDrawerValue" object:self.exhibitionMenu.selectData];
    }else {
       [self.frostedViewController hideMenuViewController];
    }
}

@end
