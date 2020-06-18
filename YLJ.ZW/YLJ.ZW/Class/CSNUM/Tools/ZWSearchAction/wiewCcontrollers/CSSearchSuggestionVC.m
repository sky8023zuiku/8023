//
//  CSSearchSuggestionVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/18.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "CSSearchSuggestionVC.h"
#import "ZWMineRqust.h"
#import "ZWMineResponse.h"
#import "ZWMerchantSearchRequst.h"
#import "ZWExExhibitorsFuzzySearchModel.h"
#import "ZWPlanExhibitionFuzzyModel.h"

#import "ZWSpellListModel.h"

@interface CSSearchSuggestionVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *contentView;
@property (nonatomic, copy)   NSString *searchTest;
@property (nonatomic, strong) NSArray *dataSource;

@end
@implementation CSSearchSuggestionVC

- (UITableView *)contentView
{
    if (!_contentView) {
        self.contentView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _contentView.delegate = self;
        _contentView.dataSource = self;
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.tableFooterView = [UIView new];
    }
    return _contentView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.contentView];
}
- (void)searchTestChangeWithTest:(NSString *)text
{
    if (self.type == 1) {
        [self createExhibitorAssociationListRequst:text];
    }else if (self.type == 2) {
        [self createSpellListVCRequst:text];
    }else if (self.type == 3||self.type == 4) {
        [self createCatalogueSearchRequst:text];
    }else if (self.type == 5) {
        [self createMerchantSearchRequst:text];
    }else if (self.type == 6){
        [self createExhExhibitorSearchRequst:text];
    }else if (self.type == 7){
        [self createPlanExhibitionSearchRequst:text];
    }else {
        [self createExhibitionHallSearchRequst:text];
    }
}
//服务商搜索
- (void)createExhibitorAssociationListRequst:(NSString *)text {
    __weak typeof(self) weakSelf = self;
    [[ZWDataAction sharedAction]getReqeustWithURL:zwServiceProviderSearchList parametes:@{@"name":text} successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (self) strongSelf = weakSelf;
        if (zw_issuccess) {
            NSLog(@"%@",[[ZWToolActon shareAction]transformDic:data[@"data"]]);
            strongSelf.dataSource = data[@"data"];
            [strongSelf.contentView reloadData];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];

}
//拼单列表搜索名称
- (void)createSpellListVCRequst:(NSString *)text {
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]postReqeustWithURL:zwGetExhibitionServerSpellSearchList parametes:@{@"name":text,@"city":self.city} successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (zw_issuccess) {
            strongSelf.dataSource = data[@"data"];
            [strongSelf.contentView reloadData];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];
    
}

- (void)createCatalogueSearchRequst:(NSString *)text {
    ZWMyCatalogueSearchRequst *request = [[ZWMyCatalogueSearchRequst alloc]init];
    request.name = text;
    __weak typeof (self) weakSelf = self;
    [request getRequestCompleted:^(YHBaseRespense *respense) {
        __strong typeof (self) strongSelf = weakSelf;
        if (respense.isFinished) {
            NSLog(@"%@",respense.data);
            NSArray *myData = respense.data;
            NSMutableArray *myArray = [NSMutableArray array];
            for (NSDictionary *myDic in myData) {
                ZWMyCatalogueSearchModel *model =[ZWMyCatalogueSearchModel parseJSON:myDic];
                [myArray addObject:model];
            }
            strongSelf.dataSource = myArray;
            [strongSelf.contentView reloadData];
        }
    }];
}
//行业展商列表
- (void)createMerchantSearchRequst:(NSString *)text {
    ZWMerchantSearchRequst *request = [[ZWMerchantSearchRequst alloc]init];
    request.name = text;
    __weak typeof (self) weakSelf = self;
    [request getRequestCompleted:^(YHBaseRespense *respense) {
        __strong typeof (self) strongSelf = weakSelf;
        if (respense.isFinished) {
            NSLog(@"%@",respense.data);
            NSArray *myData = respense.data;
            NSMutableArray *myArray = [NSMutableArray array];
            for (NSDictionary *myDic in myData) {
                ZWMerchantSearchModel *model =[ZWMerchantSearchModel ff_convertModelWithJsonDic:myDic];
                [myArray addObject:model];
            }
            strongSelf.dataSource = myArray;
            [strongSelf.contentView reloadData];
        }
    }];
}

- (void)createExhExhibitorSearchRequst:(NSString *)text {
    if (self.exhibitionId) {
        __weak typeof (self) weakSelf = self;
        [[ZWDataAction sharedAction]getReqeustWithURL:zwExhExhibitorFuzzySearch parametes:@{@"exhibitionId":self.exhibitionId,@"merchantName":text} successBlock:^(NSDictionary * _Nonnull data) {
            __strong typeof (self) strongSelf = weakSelf;
            if (zw_issuccess) {
                NSArray *myData = data[@"data"];
                NSMutableArray *myArray = [NSMutableArray array];
                for (NSDictionary *myDic in myData) {
                    ZWExExhibitorsFuzzySearchModel *model =[ZWExExhibitorsFuzzySearchModel parseJSON:myDic];
                    [myArray addObject:model];
                }
                strongSelf.dataSource = myArray;
                [strongSelf.contentView reloadData];
            }
        } failureBlock:^(NSError * _Nonnull error) {
            
        }];
    }
}

- (void)createPlanExhibitionSearchRequst:(NSString *)text {
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]getReqeustWithURL:zwFuzzyPlanExhibitionList parametes:@{@"name":text} successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (zw_issuccess) {
            NSArray *myData = data[@"data"];
            NSMutableArray *myArray = [NSMutableArray array];
            for (NSDictionary *myDic in myData) {
                ZWPlanExhibitionFuzzyModel *model = [ZWPlanExhibitionFuzzyModel parseJSON:myDic];
                [myArray addObject:model];
            }
            strongSelf.dataSource = myArray;
            [strongSelf.contentView reloadData];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];
}

- (void)createExhibitionHallSearchRequst:(NSString *)text {
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]getReqeustWithURL:zwHallFuzzyResultt parametes:@{@"fuzzyName":text} successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (zw_issuccess) {
            strongSelf.dataSource = data[@"data"];
            [strongSelf.contentView reloadData];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];
}


#pragma mark - UITableViewDataSource -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    return (_searchTest.length > 0) ? (10 / _searchTest.length) : 0;
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"CellIdentifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (self.type == 1) {
//        ZWServiceProvidersListModel *model = self.dataSource[indexPath.row];
//        cell.textLabel.text = model.name;
        cell.textLabel.text = self.dataSource[indexPath.row];
    }else if (self.type == 2) {
//        ZWServiceSpellListModel *model = self.dataSource[indexPath.row];
        cell.textLabel.text = self.dataSource[indexPath.row];
    }else if (self.type == 3||self.type == 4){
        ZWMyCatalogueSearchModel *model = self.dataSource[indexPath.row];
        cell.textLabel.text = model.name;
    }else if (self.type == 5){
        ZWMerchantSearchModel *model = self.dataSource[indexPath.row];
        cell.textLabel.text = model.name;
    }else if (self.type == 6) {
        ZWExExhibitorsFuzzySearchModel *model = self.dataSource[indexPath.row];
        cell.textLabel.text = model.merchantName;
    }else if (self.type == 7) {
        ZWPlanExhibitionFuzzyModel *model = self.dataSource[indexPath.row];
        cell.textLabel.text = model.name;
    }else {
        cell.textLabel.text = self.dataSource[indexPath.row];
    }
    return cell;
}


#pragma mark - UITableViewDelegate -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == 1) {
//        ZWServiceProvidersListModel *model = self.dataSource[indexPath.row];
        if (self.searchBlock) {
            self.searchBlock(self.dataSource[indexPath.row]);
        }
    }else if (self.type == 2) {
//        ZWServiceSpellListModel *model = self.dataSource[indexPath.row];
        if (self.searchBlock) {
            self.searchBlock(self.dataSource[indexPath.row]);
        }
    }else if (self.type == 3||self.type == 4){
        ZWMyCatalogueSearchModel *model = self.dataSource[indexPath.row];
        if (self.searchBlock) {
            self.searchBlock(model.name);
        }
    }else if(self.type ==5){
        ZWMerchantSearchModel *model = self.dataSource[indexPath.row];
        if (self.searchBlock) {
            self.searchBlock(model.name);
        }
    }else if(self.type == 6){
        ZWExExhibitorsFuzzySearchModel *model = self.dataSource[indexPath.row];
        if (self.searchBlock) {
            self.searchBlock(model.merchantName);
        }
    }else if(self.type == 7){
        ZWPlanExhibitionFuzzyModel *model = self.dataSource[indexPath.row];
        if (self.searchBlock) {
            self.searchBlock(model.name);
        }
    }else {
        if (self.searchBlock) {
            self.searchBlock(self.dataSource[indexPath.row]);
        }
    }
}

@end
