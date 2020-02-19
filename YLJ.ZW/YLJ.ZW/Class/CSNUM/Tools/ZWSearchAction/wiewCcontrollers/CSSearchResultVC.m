//
//  CSSearchResultVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/18.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "CSSearchResultVC.h"
#import "CSSearchVC.h"
#import "CSSearchSuggestionVC.h"
#import "ZWResultsCatalogueSearchView.h"
#import "ZWServiceProviderSearchResultsView.h"
#import "ZWSpellListSearchResultsView.h"
#import "ZWExhibitionCatalogueSearchView.h"
#import "CSSearchView.h"
#import "CSSearchBarStyle.h"
#import "ZWMineResponse.h"
#import "ZWMineRqust.h"
#import "ZWServiceRequst.h"
#import "ZWServiceResponse.h"
#import <MJRefresh.h>
#import "ZWMerchantSearchView.h"
#import "ZWExhExhibitorsResultSearchView.h"
#import "ZWPlanExhibitionSearchView.h"
#import "ZWExhibitionHallSearchView.h"
@interface CSSearchResultVC ()<UISearchBarDelegate>
@property (nonatomic, strong) CSSearchBarStyle *searchBar;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, assign) BOOL activity;
@property (nonatomic, strong) UIBarButtonItem *rightItem;
@property (nonatomic, strong) ZWServiceProviderSearchResultsView *serviceProviderResultView;//服务商页面
@property (nonatomic, strong) ZWResultsCatalogueSearchView *catalogueResultView;//已购会刊页面
@property (nonatomic, strong) ZWSpellListSearchResultsView *spellListResultsView;//拼单页面
@property (nonatomic, strong) ZWExhibitionCatalogueSearchView *exhibitionCatalogueResultView;//在线会刊页面
@property (nonatomic, strong) ZWMerchantSearchView *merchantSearchView;//行业展商页面
@property (nonatomic, strong) ZWExhExhibitorsResultSearchView *exhExhibitorsSearchView;//展会展商页面
@property (nonatomic, strong) ZWPlanExhibitionSearchView *planExhibitionSearchView;//计划展会页面
@property (nonatomic, strong) ZWExhibitionHallSearchView *exhibitionHallSearchView;//计划展会页面


@property (nonatomic, strong) CSSearchView *searchView;
@property (nonatomic, strong) CSSearchSuggestionVC *searchSuggestVC;
@property (nonatomic, strong) NSMutableArray<ZWMyCatalogueModel *> *dataSource;

@property (nonatomic, assign) NSInteger page;//页面
@end

@implementation CSSearchResultVC

- (CSSearchView *)searchView
{
    if (!_searchView) {
        self.searchView = [[CSSearchView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) hotArray:self.hotArray historyArray:self.historyArray];
        __weak CSSearchResultVC *weakSelf = self;
        _searchView.backgroundColor = [UIColor whiteColor];
        _searchView.tapAction = ^(NSString *str) {
            [weakSelf setSearchResultWithStr:str];
            [weakSelf createRequst:str];
        };
    }
    return _searchView;
}

- (CSSearchSuggestionVC *)searchSuggestVC
{
    if (!_searchSuggestVC) {
        self.searchSuggestVC = [[CSSearchSuggestionVC alloc] init];
        _searchSuggestVC.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _searchSuggestVC.view.hidden = YES;
        __weak CSSearchResultVC *weakSelf = self;
        _searchSuggestVC.searchBlock = ^(NSString *searchTest) {
            [weakSelf setSearchResultWithStr:searchTest];
            [weakSelf createRequst:searchTest];
        };
    }
    return _searchSuggestVC;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataSource = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setBarButtonItem];
    //    [self.view addSubview:self.resultView];
    [self.view addSubview:self.searchSuggestVC.view];
    [self createNavigationBar];
    [self createData];
    [self createView];
}


//***********************************************需要区别搜索页面***********************************************************************
- (void)createView {
    if (self.type == 1) {
        [self createServiceProviderSearchResultsView];
    }else if (self.type == 2) {
        [self createSpellListSearchResultsView];
    }else if (self.type == 3){
        [self createCatalogueView];
    }else if (self.type == 4){
        [self createExhibitionCatalogueResultView];
    }else if (self.type == 5){
        [self createMerchantResultView];
    }else if (self.type == 6){
        [self createExhExhibitorsResultView];
    }else if (self.type == 7){
        [self createPlanExhibitionView];
    }else {
        [self createExhibitionHallSearchView];
    }
}
- (void)createRequst:(NSString *)text{
    if (self.type == 1) {
        self.serviceProviderResultView.searchText = text;
    }else if (self.type == 2) {
        self.spellListResultsView.searchText = text;
    }else if (self.type == 3) {
        self.catalogueResultView.searchText = text;
    }else if (self.type == 4) {
        self.exhibitionCatalogueResultView.searchText = text;
    }else if (self.type == 5) {
        self.merchantSearchView.searchText = text;
    }else if (self.type == 6){
        self.exhExhibitorsSearchView.searchText = text;
    }else if (self.type == 7){
        self.planExhibitionSearchView.searchText = text;
    }else {
        self.exhibitionHallSearchView.searchText = text;
    }
}
//***********************************************END***********************************************************************

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
//展会服务搜索页面
- (void)createServiceProviderSearchResultsView {
    if (!self.serviceProviderResultView) {
        self.serviceProviderResultView = [[ZWServiceProviderSearchResultsView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) withParameter:@{@"type":self.parameterType,@"city":self.city}];
        self.serviceProviderResultView.searchText = self.searchStr;
    }
    [self.view addSubview:self.serviceProviderResultView];
}
//拼单列表搜索
- (void)createSpellListSearchResultsView {
    if (!self.spellListResultsView) {
        self.spellListResultsView = [[ZWSpellListSearchResultsView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) withParameter:@{@"type":self.parameterType,@"city":self.city}];
        self.spellListResultsView.searchText = self.searchStr;
    }
    [self.view addSubview:self.spellListResultsView];
}
//我的会刊搜索结果页面
- (void)createCatalogueView {
    if (!self.catalogueResultView) {
        self.catalogueResultView = [[ZWResultsCatalogueSearchView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) withSearchText:@""];
        self.catalogueResultView.searchText = self.searchStr;
    }
    [self.view addSubview:self.catalogueResultView];
}
//在线会刊搜索结果页面
- (void)createExhibitionCatalogueResultView {
    if (!self.exhibitionCatalogueResultView) {
        self.exhibitionCatalogueResultView = [[ZWExhibitionCatalogueSearchView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) withSearchText:@""];
        self.exhibitionCatalogueResultView.searchText = self.searchStr;
    }
    [self.view addSubview:self.exhibitionCatalogueResultView];
}
//行业展商搜索结果页面
- (void)createMerchantResultView {
    if (!self.merchantSearchView) {
        self.merchantSearchView = [[ZWMerchantSearchView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) withSearchText:@""];
        self.merchantSearchView.searchText = self.searchStr;
    }
    [self.view addSubview:self.merchantSearchView];
}
//展会展商搜索结果页面
- (void)createExhExhibitorsResultView {
    if (!self.exhExhibitorsSearchView) {
        NSLog(@"----%@",self.exhibitionId);
        NSLog(@"%ld",(long)self.isRreadAll);
        self.exhExhibitorsSearchView = [[ZWExhExhibitorsResultSearchView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) withParameter:@{@"isRreadAll":[NSString stringWithFormat:@"%ld",(long)self.isRreadAll],@"exhibitionId":self.exhibitionId}];
    }
    self.exhExhibitorsSearchView.searchText = self.searchStr;
    self.exhExhibitorsSearchView.isRreadAll = [NSString stringWithFormat:@"%ld",(long)self.isRreadAll];
    self.exhExhibitorsSearchView.price = self.price;
    [self.view addSubview:self.exhExhibitorsSearchView];
}
//计划展会/注册参观搜索
- (void)createPlanExhibitionView {
    if (!self.planExhibitionSearchView) {
        self.planExhibitionSearchView = [[ZWPlanExhibitionSearchView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight)];
        self.planExhibitionSearchView.searchText = self.searchStr;
    }
    [self.view addSubview:self.planExhibitionSearchView];
}
//展馆展厅搜索View
- (void)createExhibitionHallSearchView {
    if (!self.exhibitionHallSearchView) {
        self.exhibitionHallSearchView =[[ZWExhibitionHallSearchView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight)];
        self.exhibitionHallSearchView.searchText = self.searchStr;
    }
    [self.view addSubview:self.exhibitionHallSearchView];
}

- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(presentVCFirstBackClick:)];
}
- (void)setBarButtonItem
{
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 7, self.view.frame.size.width - 44 - 25, 30)];
    
    _searchBar = [[CSSearchBarStyle alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_titleView.frame), 30)];
    _searchBar.text = _searchStr;
    _searchBar.backgroundImage = [UIImage imageNamed:@"clearImage"];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"请输入搜索内容";
    _searchBar.tintColor = skinColor;

    if ([[[UIDevice currentDevice]systemVersion] floatValue] >= 13.0) {
        _searchBar.tintColor = [UIColor redColor];
        _searchBar.searchTextField.backgroundColor = [UIColor whiteColor];
        _searchBar.searchTextField.font = smallMediumFont;
        _searchBar.layer.cornerRadius = 7.0f;
        _searchBar.layer.masksToBounds = YES;
    }else {
        UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
        searchField.backgroundColor = [UIColor whiteColor];
        searchField.font = smallMediumFont;
        searchField.layer.cornerRadius = 7.0f;
        searchField.layer.masksToBounds = YES;
    }
    
    [_titleView addSubview:_searchBar];
    CGFloat height = _searchBar.bounds.size.height;
    CGFloat top = (height - 30.0) / 2.0;
    CGFloat bottom = top;
    _searchBar.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    [self createCancelBtn:_searchBar];
    self.navigationItem.titleView = _titleView;
    self.navigationItem.rightBarButtonItem = _rightItem;
    
}

- (void)createCancelBtn:(UISearchBar *)searchBar {
    if ([[[UIDevice currentDevice]systemVersion] floatValue] >= 13.0) {
        for(id cc in [self.searchBar subviews]) {
            for (id zz in [cc subviews]) {
                for (id gg in [zz subviews]) {
                    if([gg isKindOfClass:[UIButton class]]){
                        UIButton *cancelButton = (UIButton *)gg;
                        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
                        [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    }
                }
            }
        }
    }else{
        UIButton*cancelButton = (UIButton *)[_searchBar valueForKey:@"cancelButton"];
        [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    }
}

- (void)rightBtnItemAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"nav_list_single"] forState:UIControlStateNormal];
        [_catalogueResultView refreshResultViewWithIsDouble:NO];
    } else {
        [sender setImage:[UIImage imageNamed:@"icon_wangge"] forState:UIControlStateNormal];
        [_catalogueResultView refreshResultViewWithIsDouble:YES];
    }
}


- (void)cancelDidClick
{
    [_searchBar resignFirstResponder];
}

- (void)presentVCFirstBackClick:(UIButton *)sender
{
    [_searchBar resignFirstResponder];
    if (self.exhibitionId) {
        UIViewController *vc = self.navigationController.viewControllers[2];
        [self.navigationController popToViewController:vc animated:YES];
    }else {
        UIViewController *vc = self.navigationController.viewControllers[1];
        [self.navigationController popToViewController:vc animated:YES];
    }
}


- (void)setSearchResultWithStr:(NSString *)str
{
    [self.searchBar resignFirstResponder];
    _searchBar.text = str;
    [_searchView removeFromSuperview];
    _searchSuggestVC.view.hidden = YES;
}


#pragma mark -  UISearchBarDelegate  -

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"searchBarShouldBeginEditing");
    _activity = !_activity;
    if (_activity) {
        self.navigationItem.rightBarButtonItem = nil;
        _titleView.frame = CGRectMake(0, 7, kScreenWidth - 44 - 16, 30);
        _searchBar.frame = CGRectMake(0, 0, CGRectGetWidth(_titleView.frame), 30);
        searchBar.showsCancelButton = YES;
//        UIButton *cancleBtn = [_searchBar valueForKey:@"cancelButton"];
//        //修改标题和标题颜色
//        [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
//        [cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self createCancelBtn:searchBar];
    }
    
    return YES;
}

//***********************************************搜索传字段需要注意的地方***********************************************************************
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
    NSLog(@"searchBarTextDidBeginEditing-searchTest:%@",searchBar.text);
    if ([searchBar.text length] > 0) {
        _searchSuggestVC.view.hidden = NO;
        [self.view bringSubviewToFront:_searchSuggestVC.view];
        NSLog(@"我的type:%ld",(long)self.type);
        if (self.type == 1||self.type == 2) {
            _searchSuggestVC.type = self.type;
            _searchSuggestVC.parameterType = self.parameterType;
            _searchSuggestVC.city = self.city;
        } else {
            _searchSuggestVC.type = self.type;
        }
        [_searchSuggestVC searchTestChangeWithTest:searchBar.text];
    }
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"searchBarShouldEndEditing");
    self.navigationItem.rightBarButtonItem = _rightItem;
    _titleView.frame = CGRectMake(0, 7, kScreenWidth - 44 - 16, 30);
    _searchBar.frame = CGRectMake(0, 0, CGRectGetWidth(_titleView.frame), 30);
    searchBar.showsCancelButton = NO;
    _activity = NO;
    if (![searchBar.text length]) {
        _searchBar.text = _searchStr;
        [_searchView removeFromSuperview];
    };
    
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"searchBarTextDidEndEditing");
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"textDidChange");
    
    if (searchBar.text == nil || [searchBar.text length] <= 0) {
        _searchSuggestVC.view.hidden = YES;
        [self.view addSubview:self.searchView];
        [self.view bringSubviewToFront:_searchView];
    } else {
        _searchSuggestVC.view.hidden = NO;
        [self.view bringSubviewToFront:_searchSuggestVC.view];
        [_searchSuggestVC searchTestChangeWithTest:searchBar.text];
    }
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    self.navigationItem.rightBarButtonItem = _rightItem;
    _titleView.frame = CGRectMake(0, 7, kScreenWidth - 44 - 25, 30);
    _searchBar.frame = CGRectMake(0, 0, CGRectGetWidth(_titleView.frame), 30);
    searchBar.showsCancelButton = NO;
    _activity = NO;
    
    _searchSuggestVC.view.hidden = YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"searchBarSearchButtonClicked");
    [_searchView removeFromSuperview];
    [self setSearchResultWithStr:searchBar.text];
    [self createRequst:searchBar.text];
}
-(void)createData {
    [self createRequst:self.searchStr];
}

@end
