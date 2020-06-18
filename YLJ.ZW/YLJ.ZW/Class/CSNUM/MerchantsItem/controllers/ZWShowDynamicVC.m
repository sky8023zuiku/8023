//
//  ZWShowDynamicVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/19.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWShowDynamicVC.h"
#import "ZWDynamicDetailVC.h"
#import "ZWNewDynamicModel.h"
#import "ZWExExhibitorsDetailsVC.h"
#import "ZWExExhibitorsModel.h"
@interface ZWShowDynamicVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSArray *dataArray;
@end

@implementation ZWShowDynamicVC
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) style:UITableViewStylePlain];
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    [self.view addSubview:self.tableView];
}
#pragma UITableViewDataSource
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
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    ZWNewDynamicModel *model = self.dataArray[indexPath.row];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 0.3*kScreenWidth-1, kScreenWidth-30, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:235/255.0 green:236/255.0 blue:237/255.0 alpha:1.0];
    [cell.contentView addSubview:lineView];
    
    UIImageView *titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(lineView.frame), 15, 0.3*kScreenWidth-10, 0.3*kScreenWidth-30)];
    [titleImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,model.images[@"url"]]] placeholderImage:[UIImage imageNamed:@"fu_img_no_02"]];
    [cell.contentView addSubview:titleImage];

    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleImage.frame)+10, CGRectGetMinY(titleImage.frame), kScreenWidth-CGRectGetWidth(titleImage.frame)-40, 20)];
    titleLabel.text = model.exhibitionName;
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.font = normalFont;
    [cell.contentView addSubview:titleLabel];

    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleImage.frame)+10, CGRectGetMaxY(titleImage.frame)-40, CGRectGetWidth(titleLabel.frame), 40)];
    if (model.exposition.length == 0) {
        detailLabel.text = @"展位号：暂无";
    }else {
        detailLabel.text = [NSString stringWithFormat:@"%@",model.exposition];
    }
    
    detailLabel.textColor = [UIColor grayColor];
    detailLabel.font = smallFont;
    detailLabel.numberOfLines = 2;
    [cell.contentView addSubview:detailLabel];

}

#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0.3*kScreenWidth;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZWNewDynamicModel *model = self.dataArray[indexPath.row];

    ZWExExhibitorsModel *shareModel = [ZWExExhibitorsModel alloc];
    shareModel.merchantId = model.merchantId;
    shareModel.exhibitorId = model.exhibitorId;
    shareModel.exhibitionId = model.exhibitionId;
    shareModel.coverImages = model.images[@"url"];
    ZWExExhibitorsDetailsVC *detailsVC = [[ZWExExhibitorsDetailsVC alloc]init];
    detailsVC.title = @"展商详情";
    detailsVC.shareModel = shareModel;
    [self.navigationController pushViewController:detailsVC animated:YES];
    
}

- (void)createRequest {
    if (self.exhibitorId) {
        
        NSDictionary *parametes = @{@"merchantId":self.exhibitorId,
                                    @"pageNo":@"1",
                                    @"pageSize":@"10"};
        
        __weak typeof (self) weakSelf = self;
        [[ZWDataAction sharedAction]postFormDataReqeustWithURL:zwExhibitorsNewDynamic parametes:parametes successBlock:^(NSDictionary * _Nonnull data) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            if (zw_issuccess) {
                NSArray *myData = data[@"data"][@"result"];
                NSMutableArray *myArray = [NSMutableArray array];
                for (NSDictionary *myDic in myData) {
                    ZWNewDynamicModel *model = [ZWNewDynamicModel mj_objectWithKeyValues:myDic];
                    [myArray addObject:model];
                }
                strongSelf.dataArray = myArray;
                [strongSelf.tableView reloadData];
            }
        } failureBlock:^(NSError * _Nonnull error) {
            
        } showInView:self.view];
        
    }

}


@end
