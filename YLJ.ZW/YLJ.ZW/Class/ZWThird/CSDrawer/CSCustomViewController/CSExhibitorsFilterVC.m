//
//  CSExhibitorsFilterVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/6/10.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "CSExhibitorsFilterVC.h"

#import "REFrostedViewController.h"
#import "ZWExhibitorsMenu.h"
#import "CSFilterManager.h"


@interface CSExhibitorsFilterVC ()
@property(nonatomic, strong)ZWExhibitorsMenu *exhibitorsMenu;
@end

@implementation CSExhibitorsFilterVC
//展商筛选
- (ZWExhibitorsMenu *)exhibitorsMenu {
    if (!_exhibitorsMenu) {
        _exhibitorsMenu = [[ZWExhibitorsMenu alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/3*2, kScreenHeight-zwTabBarHeight-zwNavBarHeight) style:UITableViewStyleGrouped];
    }
    return _exhibitorsMenu;
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
        for (int i = 0; i < 3; i++) {
            [arrFilter addObject:@{@"id":@"",@"name":@""}];
        }
    }else {
        [arrFilter addObject:self.selcetDictionary[@"industry"]];
        [arrFilter addObject:self.selcetDictionary[@"country"]];
        [arrFilter addObject:self.selcetDictionary[@"city"]];
    }
    
    if (arrFilter) {
        self.exhibitorsMenu.selectData = [NSMutableArray array];
        [self.exhibitorsMenu.selectData addObjectsFromArray:arrFilter];
        [self.view addSubview:self.exhibitorsMenu];
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
            @"industry":@{@"id":@"",@"name":@""}
        };
    }else {
        dicFilter= @{
            @"industry":self.exhibitorsMenu.selectData[0],
            @"country":self.exhibitorsMenu.selectData[1],
            @"city":self.exhibitorsMenu.selectData[2]
        };
    }
    
    if ([[CSFilterManager shareManager].delegate respondsToSelector:@selector(takeFilterData:)]) {
        [[CSFilterManager shareManager].delegate takeFilterData:dicFilter];
    }
    
    if (btn.tag == 0) {
        NSDictionary *myDic = @{@"myId":@"",@"name":@""};
        for (int i = 0; i<self.exhibitorsMenu.selectData.count; i++) {
            [self.exhibitorsMenu.selectData replaceObjectAtIndex:i withObject:myDic];
        }
        [self.exhibitorsMenu reloadData];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"takeExhibitorsDrawerValue" object:self.exhibitorsMenu.selectData];
    }else {
        [self.frostedViewController hideMenuViewController];
    }
    
}


@end
