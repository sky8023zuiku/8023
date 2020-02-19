//
//  ZWAgentCountriesVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/12/25.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWAgentCountriesVC.h"
#import "ZWAgentProvinceVC.h"
#import "ZWAgentCitiesVC.h"
#import "ZWCPCitiesModel.h"

@interface ZWAgentCountriesVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *selectArray;
@end

@implementation ZWAgentCountriesVC
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) style:UITableViewStylePlain];
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNavigationBar];
}
- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
}
- (void)goBack:(UINavigationItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.selectArray = [NSMutableArray array];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *myCell = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myCell];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCell];
    }else {
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    ZWCPCitiesModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.value;
    cell.textLabel.font = normalFont;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZWCPCitiesModel *countriesModel = self.dataArray[indexPath.row];
    NSDictionary *parametes;
    if ([countriesModel.value isEqualToString:@"中国"]) {
        parametes = @{@"areaId":countriesModel.code ,@"level":@"1"};
    }else {
        parametes = @{@"areaId":countriesModel.code ,@"level":@"1"};
    }
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]postReqeustWithURL:zwSelectCPC parametes:parametes successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (zw_issuccess) {
            NSArray *myData = data[@"data"];
            NSMutableArray *myArray = [NSMutableArray array];
            for (NSDictionary *myDic in myData) {
                ZWCPCitiesModel *model = [ZWCPCitiesModel parseJSON:myDic];
                [myArray addObject:model];
            }
            
            if (myArray.count == 0) {
                ZWCPCitiesModel *model = self.dataArray[indexPath.row];
                [self.selectArray addObject:model];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshCityStateItem" object:self.selectArray];
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                if ([countriesModel.value isEqualToString:@"中国"]) {
                    ZWAgentProvinceVC *VC = [[ZWAgentProvinceVC alloc]init];
                    VC.dataArray = myArray;
                    VC.title = @"选择省份";
                    VC.countriesModel = countriesModel;
                    VC.status = self.status;
                    [strongSelf.navigationController pushViewController:VC animated:YES];
                }else {
                    ZWAgentCitiesVC *VC = [[ZWAgentCitiesVC alloc]init];
                    VC.dataArray = myArray;
                    VC.title = @"选择城市";
                    VC.countriesModel = countriesModel;
                    VC.status = self.status;
                    [strongSelf.navigationController pushViewController:VC animated:YES];
                }
            }
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    } showInView:self.view];
    
}

@end
