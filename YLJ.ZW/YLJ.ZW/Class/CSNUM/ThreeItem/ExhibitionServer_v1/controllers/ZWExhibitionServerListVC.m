//
//  ZWExhibitionServerListVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/3/16.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWExhibitionServerListVC.h"
#import "UButton.h"
#import "ZWServerCompanyView.h"
#import "ZWServerSpellListView.h"
#import "ZWExhibitinServerSecondaryIndustryModel.h"

#import "CSSearchVC.h"

@interface ZWExhibitionServerListVC ()
@property(nonatomic, strong)NSMutableArray *btnArray;
@property(nonatomic, strong)UIScrollView *topScrollView;
@property(nonatomic, assign)CGFloat theOffset;

@property(nonatomic, strong)ZWServerCompanyView *CompanyView;
@property(nonatomic, strong)ZWServerSpellListView *SpellListView;

@property(nonatomic, strong)NSMutableArray *industryArray;

@property(nonatomic, strong)NSString *firstIndustry;

@end

@implementation ZWExhibitionServerListVC

- (NSMutableArray *)btnArray {
    if (!_btnArray) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNavigationBar];
    [self createSearchBar];
    [self createRequst];
}
- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
}
- (void)goBack:(UIBarButtonItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self createTopBar];
    [self createCompanyView];
}

- (void)createSearchBar{
    ZWSearchBar *searchBar = [[ZWSearchBar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    searchBar.layer.masksToBounds = YES;
    self.navigationItem.titleView = searchBar;
    searchBar.backgroundColor = [UIColor clearColor];
    searchBar.isFirstResponser = NO;
    searchBar.isShowRightBtn = YES;
    searchBar.iconName = @"icon_search";
    searchBar.iconSize = CGSizeMake(15, 15);
    searchBar.insetsIcon = UIEdgeInsetsMake(0, 13, 0, 0);
    searchBar.placeHolder = @"请输入要搜索的内容";
    searchBar.cusFontPlaceHolder = 20;
    searchBar.colorSearchBg = [UIColor whiteColor];
    searchBar.raidus = 14;
    searchBar.insetsSearchBg = UIEdgeInsetsMake(8, 0, 8, 0);
    searchBar.cusFontTxt = 14;
    searchBar.colorTxtInput = [UIColor redColor];
    searchBar.isEditable = NO;
    searchBar.colorTitleBtn = [UIColor redColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapItemClick:)];
    [searchBar.txtField addGestureRecognizer:tap];
}

- (void)tapItemClick:(UITapGestureRecognizer *)recognizer {
    CSSearchVC *searchVC = [[CSSearchVC alloc]init];
    if (self.currentIndex == 4) {
        searchVC.type = 2;
    }else {
        searchVC.type = 1;
    }
//    searchVC.city = self.selectedCity;
    searchVC.city = @"";
    searchVC.parameterType = @"";
    searchVC.isAnimation = 0;
    [self.navigationController pushViewController:searchVC animated:NO];
}

- (void)createTopBar {
    self.topScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.2*kScreenWidth)];
    self.topScrollView.backgroundColor = [UIColor colorWithRed:245/255.0 green:246/255.0 blue:248/255.0 alpha:1.0];
    self.topScrollView.contentSize = CGSizeMake(kScreenWidth/6.5*10, 0.2*kScreenWidth);
    self.topScrollView.showsVerticalScrollIndicator = NO;
    self.topScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.topScrollView];
    
    CGFloat itemWidth = kScreenWidth/6.5;
    CGFloat itemHeight = kScreenWidth/6.5;
    NSArray *titleArr = @[@"会展设计",
                          @"技术媒体",
                          @"租赁/翻译",
                          @"展览工厂",
                          @"会展拼单",
                          @"五金建材",
                          @"广告器材",
                          @"酒店/餐饮",
                          @"物流运输",
                          @"保险服务"];
    
    NSArray *iconArr = @[@"exhibition_design_icon",
                         @"technology_media_icon",
                         @"translation_lease_icon",
                         @"fuwu_exhibition_factory_icon",
                         @"exhibition_spell_list_icon",
                         @"fuwu_metal_build_materials_icon",
                         @"fuwu_advertising_materials_icon",
                         @"fuwu_exhibition_food_beverage_icon",
                         @"fuwu_logistics_icon",
                         @"fuwu_Insurance_services_icon"];
    
    for (int i = 0; i<titleArr.count; i++) {
        int row = i/10;
        int col = i%10;
        UIButton *mainBtn = [UCButton buttonWithType:UIButtonTypeCustom];
        mainBtn.frame = CGRectMake(itemWidth*col, 10+row*itemHeight, itemWidth, itemHeight);
        mainBtn.titleLabel.font = [UIFont systemFontOfSize:0.03*kScreenWidth];
        [mainBtn setImage:[UIImage imageNamed:iconArr[i]] forState:UIControlStateNormal];
        [mainBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [mainBtn setTitle:titleArr[i] forState:UIControlStateNormal];
        mainBtn.titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        mainBtn.titleLabel.font = smallFont;
        mainBtn.tag = i;
        [mainBtn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == self.currentIndex) {
            [mainBtn setTitleColor:skinColor forState:UIControlStateNormal];
        }
        [self.btnArray addObject:mainBtn];
        [self.topScrollView addSubview:mainBtn];
    }
    [self menuScrollToCenter:self.currentIndex];
    
    UIView *linView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topScrollView.frame), kScreenWidth, 0.5)];
    linView.backgroundColor = [UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1];
    [self.view addSubview:linView];
}

- (void)itemClick:(UCButton *)btn {
    for (UIButton *selectBtn in self.btnArray) {
        if (btn.tag == selectBtn.tag) {
            [selectBtn setTitleColor:skinColor forState:UIControlStateNormal];
        }else {
            [selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    [self menuScrollToCenter:btn.tag];
    
    [self createParametersWithIndex:btn.tag];
    
}

- (void)createParametersWithIndex:(NSInteger)index {
    
     if (index == 0) {
            self.firstIndustry = @"1";//会展设计
        }else if (index == 1) {
            self.firstIndustry = @"2";//技术媒体
        }else if (index == 2) {
            self.firstIndustry = @"4";//租赁翻译
        }else if (index == 3) {
            self.firstIndustry = @"3";//展览工厂
        }else if (index == 4) {
//            self.firstIndustry = @"";//会展拼单
        }else if (index == 5) {
            self.firstIndustry = @"7";//五金建材
        }else if (index == 6) {
            self.firstIndustry = @"6";//广告器材
        }else if (index == 7) {
            self.firstIndustry = @"5";//酒店餐饮
        }else if (index == 8) {
            self.firstIndustry = @"8";//物流运输
        }else {
            self.firstIndustry = @"9";//保险服务
        }
    
    if (self.currentIndex==index) {
        return;
    }
    self.currentIndex = index;
   
    if (index == 4) {
        [self.mySpellParameter setValue:@"" forKey:@"type"];
    }else {
        [self.myParameter setValue:self.firstIndustry forKey:@"firstIndustry"];
    }
    [self createCompanyView];
    
}

- (void)menuScrollToCenter:(NSInteger)index{
    CGFloat itemWidth = kScreenWidth/6.5;
    UIButton *Btn = self.btnArray[index];
    CGFloat left = Btn.center.x - kScreenWidth / 2.0;
    left = left <= 0 ? 0 : left;
    CGFloat maxLeft = itemWidth * self.btnArray.count - kScreenWidth;
    left = left >= maxLeft ? maxLeft : left;
    [self.topScrollView setContentOffset:CGPointMake(left, 0) animated:YES];
}

-(ZWServerCompanyView *)CompanyView {
    if (!_CompanyView) {
        _CompanyView = [[ZWServerCompanyView alloc]initWithFrame:CGRectMake(0, 0.2*kScreenWidth+0.5, kScreenWidth, kScreenHeight-zwNavBarHeight-0.2*kScreenWidth)];
    }
    return _CompanyView;
}

-(ZWServerSpellListView *)SpellListView {
    if (!_SpellListView) {
        _SpellListView = [[ZWServerSpellListView alloc]initWithFrame:CGRectMake(0, 0.2*kScreenWidth+0.5, kScreenWidth, kScreenHeight-zwNavBarHeight-0.2*kScreenWidth)];
    }
    return _SpellListView;
}

- (void)createCompanyView {
    
    if (self.CompanyView) {
        [self.CompanyView removeFromSuperview];
    }
    if (self.SpellListView) {
        [self.SpellListView removeFromSuperview];
    }
    NSLog(@"5555-----5555==%ld",(long)_currentIndex);
    if (_currentIndex == 4) {
        self.SpellListView.mySpellParameters = self.mySpellParameter;
        [self.view addSubview:self.SpellListView];
    }else {
        self.CompanyView.parameters = self.myParameter;
        [self.view addSubview:self.CompanyView];
    }
    
}

- (void)createRequst {
    
}



@end
