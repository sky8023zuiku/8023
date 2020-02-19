//
//  ZWAreaCodeVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/11/25.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWAreaCodeVC.h"
#import "ZWAreaCodeModels.h"
@interface ZWAreaCodeVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSArray *pres;
@property(nonatomic, strong)NSArray *HOT;
@property(nonatomic, strong)ZWAreaCodeModels *areaCodeMolel;
@property(nonatomic, strong)NSMutableDictionary *countriesDic;
@property (nonatomic, strong)NSMutableArray *GroupTempArray;
@end

@implementation ZWAreaCodeVC
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBar];
    [self createUI];
    [self createRequest];
}
- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
}
- (void)goBack:(UINavigationItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"选择国家和地区";
    [self.view addSubview:self.tableView];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.GroupTempArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *Array = [self.countriesDic objectForKey:self.GroupTempArray[section]];
    return Array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *myCell = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myCell];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:myCell];
    }else {
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    NSArray *Aaray = [self.countriesDic objectForKey:self.GroupTempArray[indexPath.section]];
    ZWAreaCodeModels *model = [Aaray objectAtIndex:indexPath.row];
    cell.textLabel.font = normalFont;
    cell.detailTextLabel.font = normalFont;
    cell.textLabel.text = model.country;
    cell.detailTextLabel.text = model.pretel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0.1*kScreenWidth;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.08*kScreenWidth;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = zwGrayColor;
    
    UILabel *myTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.035*kScreenWidth, 0, 0.5*kScreenWidth, 0.08*kScreenWidth)];
    myTitleLabel.text = [self.GroupTempArray objectAtIndex:section];
    [view addSubview:myTitleLabel];
    
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *Aaray = [self.countriesDic objectForKey:self.GroupTempArray[indexPath.section]];
    ZWAreaCodeModels *model = [Aaray objectAtIndex:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(ZWAreaCodeViewControllerDelegate:)]) {
        [self.delegate ZWAreaCodeViewControllerDelegate:model];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//快速索引
- (NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.GroupTempArray;
}
- (NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}

- (void)createRequest {
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]getReqeustWithURL:zwTakeCountriesCode parametes:@{} successBlock:^(NSDictionary * _Nonnull data) {
        if (zw_issuccess) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [strongSelf takePresData:data[@"data"][@"pres"]];
            [strongSelf takeHotData:data[@"data"][@"HOT"]];
            [strongSelf SortData];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    } showInView:self.view];
}

- (void)takePresData:(NSArray *)pres {
    NSMutableArray *myArray = [NSMutableArray array];
    for (NSDictionary *myDic in pres) {
        ZWAreaCodeModels *model = [ZWAreaCodeModels parseJSON:myDic];
        [myArray addObject:model];
    }
    self.pres = myArray;
}

- (void)takeHotData:(NSArray *)hot {
    NSMutableArray *myHotArray = [NSMutableArray array];
    for (NSDictionary *myHotDic in hot) {
        ZWAreaCodeModels *model = [ZWAreaCodeModels parseJSON:myHotDic];
        [myHotArray addObject:model];
    }
    self.HOT = myHotArray;
}

-(void)SortData{
    _countriesDic = [NSMutableDictionary dictionary];
    NSMutableArray *arr=nil;
    for (int i = 0; i < self.pres.count; i++) {
        /*取出每个model*/
        ZWAreaCodeModels *model = self.pres[i];
        NSString *T = model.initial;
        if([[_countriesDic allKeys] containsObject:T]){
            arr=[_countriesDic objectForKey:T];
            [arr addObject:model];
            [_countriesDic setObject:arr forKey:T];
        }else{
            arr= [[NSMutableArray alloc]initWithObjects:model, nil];
            [_countriesDic setObject:arr forKey:T];
        }
    }
    self.GroupTempArray= [NSMutableArray arrayWithArray:[[_countriesDic allKeys] sortedArrayUsingSelector:@selector(compare:)]];
    [self.GroupTempArray insertObject:@"热" atIndex:0];
    [_countriesDic setObject:self.HOT forKey:@"热"];
    
    NSLog(@"----====----%@",self.GroupTempArray);
    
    [self.tableView reloadData];
    
}

@end
