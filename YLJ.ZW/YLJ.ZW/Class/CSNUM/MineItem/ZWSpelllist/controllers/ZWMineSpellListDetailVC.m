//
//  ZWMineSpellListDetailVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/6/1.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWMineSpellListDetailVC.h"
#import "ZWSpellListType01View.h"
#import "ZWSpellListType02View.h"
#import "ZWSpellListType03View.h"
#import "ZWSpellListType04View.h"
#import "UIViewController+YCPopover.h"
#import "ZWShareScreenshotsViewController.h"
#import "ZWMineSpellListDetailVC.h"

#import "ZWMineSpellListFailureVC.h"

@interface ZWMineSpellListDetailVC ()
@property(nonatomic, strong)ZWSpellListType01View *type01View;
@property(nonatomic, strong)ZWSpellListType02View *type02View;
@property(nonatomic, strong)ZWSpellListType03View *type03View;
@property(nonatomic, strong)ZWSpellListType04View *type04View;
@end

@implementation ZWMineSpellListDetailVC

-(ZWSpellListType01View *)type01View {
    if (!_type01View) {
        _type01View = [[ZWSpellListType01View alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) withModel:self.model withType:1];
    }
    return _type01View;
}
-(ZWSpellListType02View *)type02View {
    if (!_type02View) {
        _type02View = [[ZWSpellListType02View alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) withModel:self.model withType:1];
    }
    return _type02View;
}
-(ZWSpellListType03View *)type03View {
    if (!_type03View) {
        _type03View = [[ZWSpellListType03View alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) withModel:self.model withType:1];
    }
    return _type03View;
}
-(ZWSpellListType04View *)type04View {
    if (!_type04View) {
        _type04View = [[ZWSpellListType04View alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) withModel:self.model withType:1];
    }
    return _type04View;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBar];
    [self createUI];
}
- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
}

- (void)goBack:(UIBarButtonItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createUI {
    self.title = @"拼单详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([self.model.type isEqualToString:@"4"]) {
        [self.view addSubview:self.type02View];
    }else if ([self.model.type isEqualToString:@"5"]) {
        [self.view addSubview:self.type03View];
    }else if ([self.model.type isEqualToString:@"6"]) {
        [self.view addSubview:self.type04View];
    }else {
        [self.view addSubview:self.type01View];
    }
}
- (void)editorBtnClick:(UIButton *)btn {
    ZWMineSpellListFailureVC *spellDetailVC = [[ZWMineSpellListFailureVC alloc]init];
    spellDetailVC.model = self.model;
    [self.navigationController pushViewController:spellDetailVC animated:YES];
}
@end
