//
//  ZWMineReleaseSpelllistSixVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/6/3.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWMineReleaseSpelllistSixVC.h"
#import "ZWReleaseSpellList04View.h"

@interface ZWMineReleaseSpelllistSixVC ()
@property(nonatomic, strong)ZWReleaseSpellList04View *spellList04View;
@end

@implementation ZWMineReleaseSpelllistSixVC

- (ZWReleaseSpellList04View *)spellList04View {
    if (!_spellList04View) {
        _spellList04View = [[ZWReleaseSpellList04View alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight-0.1*kScreenWidth) withModel:[ZWSpellListModel new] withType:0];
    }
    _spellList04View.selectType = @"6";
    return _spellList04View;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.spellList04View];
}

@end
