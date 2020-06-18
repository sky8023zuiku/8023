//
//  ZWAreaProvinceSelectionVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/6/3.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWAreaProvinceSelectionVC.h"
#import "ZWAreaCitiesSelectionVC.h"
#import "ZWCPCitiesModel.h"
@interface ZWAreaProvinceSelectionVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *selectArray;
@end

@implementation ZWAreaProvinceSelectionVC

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) style:UITableViewStylePlain];
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNavigationBar];
    NSLog(@"我的国家是%@",self.area);
}
- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
}
- (void)goBack:(UINavigationItem *)item {
    [self.area removeObjectForKey:@"country"];
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
    
    ZWCPCitiesModel *provinceModel = self.dataArray[indexPath.row];
    [self.area setValue:[[ZWToolActon shareAction]dicFromObject:provinceModel] forKey:@"province"];
    NSDictionary * parametes = @{@"areaId":provinceModel.code ,@"level":@"2"};
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
                [[NSNotificationCenter defaultCenter]postNotificationName:@"takeAreaValue" object:self.area];
            }else {
                ZWAreaCitiesSelectionVC *VC = [[ZWAreaCitiesSelectionVC alloc]init];
                VC.dataArray = myArray;
                VC.title = @"选择城市";
                VC.area = self.area;
                [strongSelf.navigationController pushViewController:VC animated:YES];
            }
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    } showInView:self.view];
}

@end
