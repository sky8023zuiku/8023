//
//  CSMenuViewController.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/11/11.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "CSMenuViewController.h"

#import "REFrostedViewController.h"

#import "ZWExhibitorsMenu.h"
#import "ZWExhibitionMenu.h"

@interface CSMenuViewController ()

@property(nonatomic, strong)UICollectionViewFlowLayout *layout;

@property(nonatomic, strong)ZWExhibitorsMenu *exhibitorsMenu;
@property(nonatomic, strong)ZWExhibitionMenu *exhibitionMenu;

@end

@implementation CSMenuViewController

- (ZWExhibitorsMenu *)exhibitorsMenu {
    if (!_exhibitorsMenu) {
        _exhibitorsMenu = [[ZWExhibitorsMenu alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/3*2, kScreenHeight-zwTabBarHeight-zwNavBarHeight) style:UITableViewStyleGrouped];
    }
    return _exhibitorsMenu;
}

- (ZWExhibitionMenu *)exhibitionMenu {
    if (!_exhibitionMenu) {
        _exhibitionMenu = [[ZWExhibitionMenu alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/3*2, kScreenHeight-zwTabBarHeight-zwNavBarHeight) style:UITableViewStyleGrouped];
    }
    return _exhibitionMenu;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNavgationBar];
    NSLog(@"------------------------------------%ld",(long)self.screenType);
}
- (void)createNavgationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithTitle:@"选择" barItem:self.navigationItem target:self action:@selector(show)];
}
- (void)show {

}
- (void)createUI {
//    self.title = @"选择";
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = skinColor;
    
    _layout=[[UICollectionViewFlowLayout alloc]init];
    [_layout prepareLayout];
    //设置每个cell与相邻的cell之间的间距
    _layout.minimumInteritemSpacing = 1;
    _layout.sectionInset = UIEdgeInsetsMake(0, 0.03*kScreenWidth, 0.03*kScreenWidth, 0.03*kScreenWidth);
    _layout.minimumLineSpacing=0.03*kScreenWidth;
    _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    if (self.screenType == 1) {
        
        self.exhibitorsMenu.selectData = [NSMutableArray array];
        [self.exhibitorsMenu.selectData addObjectsFromArray:self.screenValues];
        [self.view addSubview:self.exhibitorsMenu];
        
    } else if (self.screenType == 2) {
        
        self.exhibitionMenu.selectData = [NSMutableArray array];
        [self.exhibitionMenu.selectData addObjectsFromArray:self.screenValues];
        [self.view addSubview:self.exhibitionMenu];
        
    } else if (self.screenType == 3) {
        
        self.exhibitionMenu.selectData = [NSMutableArray array];
        [self.exhibitionMenu.selectData addObjectsFromArray:self.screenValues];
        [self.view addSubview:self.exhibitionMenu];
        
    } else {
        
        self.exhibitionMenu.selectData = [NSMutableArray array];
        [self.exhibitionMenu.selectData addObjectsFromArray:self.screenValues];
        [self.view addSubview:self.exhibitionMenu];
        
    }
    
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
    NSDictionary *myDic = @{@"myId":@"",@"name":@""};
    if (btn.tag == 0) {
        if (self.screenType == 1) {
    
            for (int i = 0; i<self.exhibitorsMenu.selectData.count; i++) {
                [self.exhibitorsMenu.selectData replaceObjectAtIndex:i withObject:myDic];
            }
            [self.exhibitorsMenu reloadData];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"takeExhibitorsDrawerValue" object:self.exhibitorsMenu.selectData];
            
        } else if (self.screenType == 2) {
            for (int i = 0; i<self.exhibitionMenu.selectData.count; i++) {
                [self.exhibitionMenu.selectData replaceObjectAtIndex:i withObject:myDic];
            }
            [self.exhibitionMenu reloadData];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"takeExhibitionDrawerValue" object:self.exhibitionMenu.selectData];
            
        } else if (self.screenType == 3) {
            
            for (int i = 0; i<self.exhibitionMenu.selectData.count; i++) {
                [self.exhibitionMenu.selectData replaceObjectAtIndex:i withObject:myDic];
            }
            [self.exhibitionMenu reloadData];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"takeMyExhibitionDrawerValue" object:self.exhibitionMenu.selectData];
        
        } else {
            
            for (int i = 0; i<self.exhibitionMenu.selectData.count; i++) {
                [self.exhibitionMenu.selectData replaceObjectAtIndex:i withObject:myDic];
            }
            [self.exhibitionMenu reloadData];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"takePlanScreenDrawerValue" object:self.exhibitionMenu.selectData];
            
        }
        
    }else {
        if (self.screenType == 1) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"takeExhibitorsDrawerValue" object:self.exhibitorsMenu.selectData];
        } else if (self.screenType == 2) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"takeExhibitionDrawerValue" object:self.exhibitionMenu.selectData];
        } else if (self.screenType == 3) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"takeMyExhibitionDrawerValue" object:self.exhibitionMenu.selectData];
        } else {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"takePlanScreenDrawerValue" object:self.exhibitionMenu.selectData];
        }
        [self.frostedViewController hideMenuViewController];
    }
    
}

@end
