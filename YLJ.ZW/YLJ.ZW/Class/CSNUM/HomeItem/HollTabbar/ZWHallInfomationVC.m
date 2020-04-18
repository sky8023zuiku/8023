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
@property(nonatomic, strong)NSArray *httpImages;

@property(nonatomic, strong)SDCycleScrollView *cycleScrollView;
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

-(SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.45*kScreenWidth) delegate:self placeholderImage:[UIImage imageNamed:@"fu_img_no_01"]];
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
        _cycleScrollView.showPageControl = YES;
        _cycleScrollView.autoScrollTimeInterval = 3;
    }
    return _cycleScrollView;
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
            
            CGFloat titleWith = [[ZWToolActon shareAction]adaptiveTextWidth:@"网址：" labelFont:normalFont];
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 0, titleWith, 0.1*kScreenWidth)];
            titleLabel.text = @"网址：";
            titleLabel.font = normalFont;
            [cell.contentView addSubview:titleLabel];
            
            UILabel *webset = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), 0, 0.9*kScreenWidth-CGRectGetWidth(titleLabel.frame), 0.1*kScreenWidth)];
            webset.font = normalFont;
            if (self.model.website.length == 0) {
                webset.text =@"暂无";
            }else {
                webset.text = self.model.website;
            }
            [cell.contentView addSubview:webset];
            
        }else {
            
            CGFloat titleWith = [[ZWToolActon shareAction]adaptiveTextWidth:@"电话：" labelFont:normalFont];
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 0, titleWith, 0.1*kScreenWidth)];
            titleLabel.text = @"电话：";
            titleLabel.font = normalFont;
            [cell.contentView addSubview:titleLabel];
            
            UILabel *webset = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), 0, 0.9*kScreenWidth-CGRectGetWidth(titleLabel.frame), 0.1*kScreenWidth)];
            webset.font = normalFont;
            webset.textColor = skinColor;
            if (self.model.telephone.length == 0) {
                webset.text =@"暂无";
            }else {
                webset.text = self.model.telephone;
            }
            [cell.contentView addSubview:webset];
            
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
                cell.textLabel.font = normalFont;
            }
            cell.textLabel.numberOfLines = 0;
        }
    }
}

#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            CGFloat rowHeight = [[ZWToolActon shareAction]adaptiveTextHeight:self.model.profile textFont:normalFont textWidth:0.9*kScreenWidth];
            return rowHeight+20;
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
        self.cycleScrollView.imageURLStringsGroup = imageArray;
        [view addSubview:self.cycleScrollView];
        self.httpImages = imageArray;
    }else {
        view.backgroundColor = zwGrayColor;
    }
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            if (self.model.telephone) {
                [self takeCallWithValue:self.model.telephone];
            }
        }
    }
}
- (void)takeCallWithValue:(NSString *)value {
    NSLog(@"我的值是什么%@",value);
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",value];
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:str];
    [application openURL:URL];
}

//点击图片的代理
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
   NSLog(@"index = %ld",(long)index);
    [[ZWPhotoBrowserAction shareAction]showImageViewUrls:self.httpImages tapIndex:index];
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
