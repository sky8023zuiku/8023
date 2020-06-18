//
//  ZWMineReleaseSpelllistFiveVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/6/3.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWMineReleaseSpelllistFiveVC.h"
#import "ZWReleaseSpellList03View.h"
@interface ZWMineReleaseSpelllistFiveVC ()
@property(nonatomic, strong)ZWReleaseSpellList03View *spellList03View;
@end

@implementation ZWMineReleaseSpelllistFiveVC

-(ZWReleaseSpellList03View *)spellList03View {
    if (!_spellList03View) {
        _spellList03View = [[ZWReleaseSpellList03View alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight-0.1*kScreenWidth) withModel:[ZWSpellListModel new] withType:0];
    }
    _spellList03View.selectType = @"5";
    return _spellList03View;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.spellList03View];
}

@end
