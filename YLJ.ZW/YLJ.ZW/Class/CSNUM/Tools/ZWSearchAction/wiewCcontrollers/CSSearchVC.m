//
//  CSSearchVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/18.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "CSSearchVC.h"
#import "CSSearchResultVC.h"
#import "CSSearchSuggestionVC.h"
#import "CSSearchView.h"
#import "CSSearchBarStyle.h"

@interface CSSearchVC ()<UISearchBarDelegate>

@property (nonatomic, strong) CSSearchView *searchView;
@property (nonatomic, strong) NSMutableArray *hotArray;
@property (nonatomic, strong) NSMutableArray *historyArray;
@property (nonatomic, strong) CSSearchSuggestionVC *searchSuggestVC;
@property (nonatomic, strong) UIBarButtonItem *rightItem;
@property (nonatomic, strong) ZWSearchBar *searchBar;

@end

@implementation CSSearchVC

- (NSMutableArray *)hotArray
{
    if (!_hotArray) {
        self.hotArray = [NSMutableArray arrayWithObjects:@"热门1", @"热门2", @"热门3", @"热门4", @"热门5", @"热门6", @"热门7", @"热门8", nil];
    }
    return _hotArray;
}

- (NSMutableArray *)historyArray
{
    if (!_historyArray) {
        _historyArray = [NSKeyedUnarchiver unarchiveObjectWithFile:kHistorySearchPath];
        if (!_historyArray) {
            self.historyArray = [NSMutableArray array];
        }
    }
    return _historyArray;
}

- (CSSearchView *)searchView
{
    if (!_searchView) {
        self.searchView = [[CSSearchView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) hotArray:self.hotArray historyArray:self.historyArray];
        __weak CSSearchVC *weakSelf = self;
        _searchView.tapAction = ^(NSString *str) {
            [weakSelf pushToSearchResultWithSearchStr:str];
        };
    }
    return _searchView;
}

- (CSSearchSuggestionVC *)searchSuggestVC
{
    if (!_searchSuggestVC) {
        self.searchSuggestVC = [[CSSearchSuggestionVC alloc] init];
        _searchSuggestVC.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64);
        _searchSuggestVC.view.hidden = YES;
        _searchSuggestVC.type = self.type;
        _searchSuggestVC.parameterType = self.parameterType;
        _searchSuggestVC.city = self.city;
        
        _searchSuggestVC.exhibitionId = self.exhibitionId;
        NSLog(@"-2-2-2-2-%@",_searchSuggestVC.exhibitionId);
        NSLog(@"-2-2-2-2-%@",_searchSuggestVC.city);
        
        __weak CSSearchVC *weakSelf = self;
        _searchSuggestVC.searchBlock = ^(NSString *searchTest) {
            [weakSelf pushToSearchResultWithSearchStr:searchTest];
        };
    }
    return _searchSuggestVC;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.searchBar.txtField becomeFirstResponder];
    [[YNavigationBar sharedInstance]createNavigationBarWithStatusBarStyle:UIStatusBarStyleLightContent withType:0];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.searchBar.txtField resignFirstResponder];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    _searchSuggestVC.view.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[YNavigationBar sharedInstance]createSkinNavigationBar:self.navigationController.navigationBar withBackColor:skinColor withTintColor:[UIColor whiteColor]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarButtonItem];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.searchSuggestVC.view];
    [self addChildViewController:_searchSuggestVC];
}
- (void)setBarButtonItem
{
    [self.navigationItem setHidesBackButton:YES];

    ZWSearchBar *searchBar = [[ZWSearchBar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    searchBar.layer.masksToBounds = YES;
    searchBar.backgroundColor = [UIColor redColor];
    self.navigationItem.titleView = searchBar;
    searchBar.backgroundColor = skinColor;
    searchBar.isFirstResponser = YES;
    searchBar.iconName = @"icon_search";
    searchBar.iconSize = CGSizeMake(15, 15);
    searchBar.insetsIcon = UIEdgeInsetsMake(0, 13, 0, 0);
    searchBar.placeHolder = @"请输入要搜索的内容";
    searchBar.cusFontPlaceHolder = 20;
    searchBar.colorSearchBg = [UIColor whiteColor];
    searchBar.raidus = 14;
    searchBar.insetsSearchBg = UIEdgeInsetsMake(8, 0, 8, 60);
    searchBar.cusFontTxt = 15;
    searchBar.isShowRightBtn = YES;
    searchBar.titleBtn = @"取消";
    searchBar.colorTxtInput = [UIColor blackColor];
    searchBar.colorTitleBtn = [UIColor whiteColor];
    self.searchBar = searchBar;
    __weak typeof (self) weakSelf = self;
    [searchBar setTxtfieldEditingCallback:^(NSString *text) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (text == nil || [text length] <= 0) {
            strongSelf.searchSuggestVC.view.hidden = YES;
            [self.view bringSubviewToFront:strongSelf.searchView];
        } else {
            strongSelf.searchSuggestVC.view.hidden = NO;
            [self.view bringSubviewToFront:strongSelf.searchSuggestVC.view];
            [strongSelf.searchSuggestVC searchTestChangeWithTest:text];
        }
    }];
    [searchBar setClickSearchCallback:^(NSString *keyword) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf pushToSearchResultWithSearchStr:keyword];
    }];
    [searchBar setClickRightBtnCallback:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (strongSelf.isAnimation == 0) {
            [strongSelf.navigationController popViewControllerAnimated:NO];
        }else {
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (void)pushToSearchResultWithSearchStr:(NSString *)str
{
    CSSearchResultVC *searchResultVC = [[CSSearchResultVC alloc] init];
    searchResultVC.type = self.type;
    searchResultVC.parameterType = self.parameterType;
    searchResultVC.city = self.city;
    searchResultVC.searchStr = str;
    searchResultVC.hotArray = _hotArray;
    searchResultVC.historyArray = _historyArray;
    searchResultVC.exhibitionId = self.exhibitionId;
    searchResultVC.isRreadAll = self.isRreadAll;
    searchResultVC.price = self.price;
    [self.navigationController pushViewController:searchResultVC animated:YES];
    [self setHistoryArrWithStr:str];
}

- (void)setHistoryArrWithStr:(NSString *)str
{
    for (int i = 0; i < _historyArray.count; i++) {
        if ([_historyArray[i] isEqualToString:str]) {
            [_historyArray removeObjectAtIndex:i];
            break;
        }
    }
    [_historyArray insertObject:str atIndex:0];
    [NSKeyedArchiver archiveRootObject:_historyArray toFile:kHistorySearchPath];
}
@end
