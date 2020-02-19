//
//  ZWHallInfomationVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/1/9.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWHallInfomationVC.h"
#import <SDCycleScrollView.h>
#import "ZWHallDetailModel.h"
@interface ZWHallInfomationVC ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)ZWHallDetailModel *model;
@end

@implementation ZWHallInfomationVC

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) style:UITableViewStyleGrouped];
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0 );
    _tableView.backgroundColor = [UIColor clearColor];
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.title = @"展馆信息";
    [[YNavigationBar sharedInstance]createRightBarWithImage:[UIImage imageNamed:@""] barItem:self.tabBarController.navigationItem target:self action:@selector(rightItemClick:)];
}

- (void)rightItemClick:(UIBarButtonItem *)item {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self initData];
}
- (void)createUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}


#pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }else {
        return 2;
    }
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self createTableViewCell:cell cellForRowAtIndexPath:indexPath];
    
    return cell;
}
- (void)createTableViewCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.font = normalFont;
    if (indexPath.section == 0) {
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 0.1*kScreenWidth-1, 0.9*kScreenWidth, 1)];
        lineView.backgroundColor = zwGrayColor;
        [cell.contentView addSubview:lineView];
        
        if (indexPath.row == 0) {
            cell.textLabel.text = self.model.hallName;
        }else if (indexPath.row == 1) {
            
            if (self.model.website.length == 0) {
                cell.textLabel.text =@"暂无";
            }else {
                cell.textLabel.text = [NSString stringWithFormat:@"网址：%@",self.model.website];
            }
            
        }else {
            if (self.model.telephone.length == 0) {
                cell.textLabel.text =@"暂无";
            }else {
                cell.textLabel.text = [NSString stringWithFormat:@"电话：%@",self.model.telephone];
            }
            lineView.backgroundColor = [UIColor whiteColor];
        }
    }else {
        if (indexPath.row == 0) {
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 0.1*kScreenWidth-1, 0.9*kScreenWidth, 1)];
            lineView.backgroundColor = zwGrayColor;
            [cell.contentView addSubview:lineView];
            
            cell.textLabel.text = @"展馆介绍";
            cell.textLabel.font = boldBigFont;
        }else {
            if (self.model.profile.length == 0) {
                cell.textLabel.text =@"暂无";
            }else {
                cell.textLabel.text =self.model.profile;
            }
            cell.textLabel.numberOfLines = 0;
        }
    }
}

#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            NSString *str = self.model.profile;
            CGFloat rowHeight = [[ZWToolActon shareAction]adaptiveTextHeight:str font:normalFont]+0.1*kScreenWidth;
            return rowHeight;
        }else {
           return 0.1*kScreenWidth;
        }
    }else {
        return 0.1*kScreenWidth;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.45*kScreenWidth;
    }else {
        return 0.02*kScreenWidth;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    NSMutableArray *imageArray = [NSMutableArray array];
    for (NSString *name in self.model.imageVos) {
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@",httpImageUrl,name];
        [imageArray addObject:imageUrl];
    }
    if (section == 0) {
//        NSArray *images = @[@"h1.jpg",@"h2.jpg",@"h3.jpg"];
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.45*kScreenWidth) delegate:self placeholderImage:[UIImage imageNamed:@"fu_img_no_01"]];
        cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
        cycleScrollView.showPageControl = YES;
        cycleScrollView.imageURLStringsGroup = imageArray;
        cycleScrollView.autoScrollTimeInterval = 3;
        [view addSubview:cycleScrollView];
    }else {
        view.backgroundColor = zwGrayColor;
    }
    return view;
}

- (void)initData {
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]getReqeustWithURL:zwHallDetail parametes:@{@"hallId":self.hallId} successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (zw_issuccess) {
            NSDictionary *myDic = data[@"data"];
            strongSelf.model = [ZWHallDetailModel parseJSON:myDic];
            [strongSelf.tableView reloadData];
        }
    } failureBlock:^(NSError * _Nonnull error) {

    }];

}

@end
