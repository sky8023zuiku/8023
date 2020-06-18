//
//  ZWMineSpellListFailureVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/6/1.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWMineSpellListFailureVC.h"
#import "ZWReleaseSpellList01View.h"
#import "ZWReleaseSpellList02View.h"
#import "ZWReleaseSpellList03View.h"
#import "ZWReleaseSpellList04View.h"

@interface ZWMineSpellListFailureVC ()

@property(nonatomic, strong)ZWReleaseSpellList01View *spellList01View;
@property(nonatomic, strong)ZWReleaseSpellList02View *spellList02View;
@property(nonatomic, strong)ZWReleaseSpellList03View *spellList03View;
@property(nonatomic, strong)ZWReleaseSpellList04View *spellList04View;

@end

@implementation ZWMineSpellListFailureVC
-(ZWReleaseSpellList01View *)spellList01View {
    if (!_spellList01View) {
        _spellList01View = [[ZWReleaseSpellList01View alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) withModel:self.model withType:1];
    }
    return _spellList01View;
}

-(ZWReleaseSpellList02View *)spellList02View {
    if (!_spellList02View) {
        _spellList02View = [[ZWReleaseSpellList02View alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) withModel:self.model withType:1];
    }
    return _spellList02View;
}

-(ZWReleaseSpellList03View *)spellList03View {
    if (!_spellList03View) {
        _spellList03View = [[ZWReleaseSpellList03View alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) withModel:self.model withType:1];
    }
    return _spellList03View;
}

-(ZWReleaseSpellList04View *)spellList04View {
    if (!_spellList04View) {
        _spellList04View = [[ZWReleaseSpellList04View alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) withModel:self.model withType:1];
    }
    return _spellList04View;
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createUI {
    if ([self.model.type isEqualToString:@"1"]) {
        self.title = @"木结构拼单";
    }else if ([self.model.type isEqualToString:@"2"]) {
        self.title = @"桁架拼单";
    }else if ([self.model.type isEqualToString:@"3"]) {
        self.title = @"型材铝料拼单";
    }else if ([self.model.type isEqualToString:@"4"]) {
        self.title = @"看馆拼单";
    }else if ([self.model.type isEqualToString:@"5"]) {
        self.title = @"保险拼单";
    }else {
        self.title = @"货车拼单";
    }
    if ([self.model.type isEqualToString:@"4"]) {
        [self.view addSubview:self.spellList02View];
    }else if ([self.model.type isEqualToString:@"5"]) {
        [self.view addSubview:self.spellList03View];
    }else if ([self.model.type isEqualToString:@"6"]) {
        [self.view addSubview:self.spellList04View];
    }else {
        [self.view addSubview:self.spellList01View];
    }
    
}



@end
