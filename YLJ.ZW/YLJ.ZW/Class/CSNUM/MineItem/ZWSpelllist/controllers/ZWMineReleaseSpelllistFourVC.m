//
//  ZWMineReleaseSpelllistFourVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/6/3.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWMineReleaseSpelllistFourVC.h"
#import "ZWReleaseSpellList02View.h"

@interface ZWMineReleaseSpelllistFourVC ()
@property(nonatomic, strong)ZWReleaseSpellList02View *spellList02View;
@end

@implementation ZWMineReleaseSpelllistFourVC

-(ZWReleaseSpellList02View *)spellList02View {
    if (!_spellList02View) {
        _spellList02View = [[ZWReleaseSpellList02View alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight-0.1*kScreenWidth) withModel:[ZWSpellListModel new] withType:0];
    }
    _spellList02View.selectType = @"4";
    return _spellList02View;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.spellList02View];
}

@end
