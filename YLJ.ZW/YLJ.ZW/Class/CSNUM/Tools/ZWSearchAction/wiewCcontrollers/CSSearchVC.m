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

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) CSSearchView *searchView;
@property (nonatomic, strong) NSMutableArray *hotArray;
@property (nonatomic, strong) NSMutableArray *historyArray;
@property (nonatomic, strong) CSSearchSuggestionVC *searchSuggestVC;

@property (nonatomic, strong) UIBarButtonItem *rightItem;

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
    if (!_searchBar.isFirstResponder) {
        [self.searchBar becomeFirstResponder];
    }
    
//    if ([self.searchBar respondsToSelector:@selector(becomeFirstResponder)]) {
//        [self.searchBar performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0];
//    }
    
    [[YNavigationBar sharedInstance]createNavigationBarWithStatusBarStyle:UIStatusBarStyleLightContent withType:0];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    // 回收键盘
    [self.searchBar resignFirstResponder];
    _searchSuggestVC.view.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    __weak typeof (self) weakSelf = self;
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            __strong typeof (weakSelf) strongSelf = weakSelf;
//            [strongSelf setBarButtonItem];
//        });
//    });
    
    [self setBarButtonItem];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.searchSuggestVC.view];
    [self addChildViewController:_searchSuggestVC];
}
- (void)setBarButtonItem
{
    [self.navigationItem setHidesBackButton:YES];
    // 创建搜索框
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 7, self.view.frame.size.width, 30)];
    CSSearchBarStyle *searchBar = [[CSSearchBarStyle alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(titleView.frame) - 25, 30)];
    searchBar.placeholder = @"请输入搜索内容";
    searchBar.backgroundImage = [UIImage new];
    searchBar.delegate = self;
    searchBar.showsCancelButton = YES;
    searchBar.tintColor = skinColor;
    
    if ([[[UIDevice currentDevice]systemVersion] floatValue] >= 13.0) {
        searchBar.searchTextField.font = smallMediumFont;
        searchBar.searchTextField.backgroundColor = [UIColor whiteColor];
        searchBar.layer.cornerRadius = 7.0f;
        searchBar.layer.masksToBounds = YES;
    }else {
        UITextField *searchField = [searchBar valueForKey:@"_searchField"];
        searchField.backgroundColor = [UIColor whiteColor];
        searchField.font = smallMediumFont;
        searchField.layer.cornerRadius = 7.0f;
        searchField.layer.masksToBounds = YES;
    }
    
    [titleView addSubview:searchBar];
    self.searchBar = searchBar;
//    [self.searchBar becomeFirstResponder];
    self.navigationItem.titleView = titleView;

//    CGFloat height = searchBar.bounds.size.height;
//    CGFloat top = (height - 30.0) / 2.0;
//    CGFloat bottom = top;
//    searchBar.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
    CGFloat height = _searchBar.bounds.size.height;
    CGFloat top = (height - 30.0) / 2.0;
    CGFloat bottom = top;
    searchBar.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    [self createCancelBtn:searchBar];
    self.navigationItem.titleView = titleView;
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
- (void)presentVCFirstBackClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
/** 点击取消 */
- (void)cancelDidClick
{
    [self.searchBar resignFirstResponder];
    
    [self dismissViewControllerAnimated:NO completion:nil];
}


- (void)pushToSearchResultWithSearchStr:(NSString *)str
{
    self.searchBar.text = str;
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


#pragma mark - UISearchBarDelegate -


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self pushToSearchResultWithSearchStr:searchBar.text];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.navigationItem.rightBarButtonItem = _rightItem;
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    self.navigationItem.rightBarButtonItem = _rightItem;
    searchBar.showsCancelButton = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchBar.text == nil || [searchBar.text length] <= 0) {
        _searchSuggestVC.view.hidden = YES;
        [self.view bringSubviewToFront:_searchView];
    } else {
        _searchSuggestVC.view.hidden = NO;
        [self.view bringSubviewToFront:_searchSuggestVC.view];
        [_searchSuggestVC searchTestChangeWithTest:searchBar.text];
    }
}
@end
