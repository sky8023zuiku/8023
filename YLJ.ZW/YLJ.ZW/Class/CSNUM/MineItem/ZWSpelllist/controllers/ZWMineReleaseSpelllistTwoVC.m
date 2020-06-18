//
//  ZWMineReleaseSpelllistTwoVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/6/3.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWMineReleaseSpelllistTwoVC.h"
#import "ZWReleaseSpellList01View.h"
@interface ZWMineReleaseSpelllistTwoVC ()
@property(nonatomic, strong)ZWReleaseSpellList01View *spellList01View;
@end

@implementation ZWMineReleaseSpelllistTwoVC

- (ZWReleaseSpellList01View *)spellList01View {
    if (!_spellList01View) {
        _spellList01View = [[ZWReleaseSpellList01View alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight-0.1*kScreenWidth) withModel:[ZWSpellListModel new] withType:0];
    }
    _spellList01View.selectType = @"2";
    return _spellList01View;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.spellList01View];
}

@end
