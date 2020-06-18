//
//  ZWConditionsListVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/6/11.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWConditionsListVC.h"
#import "ZWExhibitionMerchantCell.h"
#import "ZWBoothPictureVC.h"
#import "ZWExExhibitorsModel.h"
#import "ZWExExhibitorsDetailsVC.h"
#import "UButton.h"

@interface ZWConditionsListVC ()<UITableViewDelegate,UITableViewDataSource,ZWExhibitionMerchantCellDelegate>
@property(nonatomic, strong)UITableView *tableView;
@end

@implementation ZWConditionsListVC

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwTabBarHeight) style:UITableViewStyleGrouped];
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor whiteColor];
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBar];
    [self createUI];
}

- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
}

- (void)goBack:(UIBarButtonItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createUI {
    self.title = @"展会展商";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
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
    [self createTableViewCell:cell cellForRowAtIndexPath:indexPath];
    return cell;
}

- (void)createTableViewCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZWExExhibitorsModel *model = self.dataArray[indexPath.row];
    
    ZWExhibitionMerchantCell *merchantCell = [[ZWExhibitionMerchantCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.3*kScreenWidth-1)];
    merchantCell.delegate = self;
    merchantCell.titleLabel.font = boldSmallMediumFont;
    merchantCell.mainBusiness.font = [UIFont systemFontOfSize:0.03*kScreenWidth];
    merchantCell.demandLabel.font = [UIFont systemFontOfSize:0.03*kScreenWidth];
    merchantCell.boothNumber.font = [UIFont systemFontOfSize:0.03*kScreenWidth];
    merchantCell.tag = indexPath.row;
    merchantCell.model = model;
    [cell.contentView addSubview:merchantCell];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0.3*kScreenWidth;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.3*kScreenWidth;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    ZWSelectBtn *btn = [[ZWSelectBtn alloc]initWithFrame:CGRectMake(0.4*kScreenWidth, 0.1*kScreenWidth, 0.2*kScreenWidth, 0.04*kScreenWidth)];
    [btn setImage:[UIImage imageNamed:@"batch_icon"] forState:UIControlStateNormal];
    [btn setTitle:@"换一批" forState:UIControlStateNormal];
    btn.titleLabel.font = normalFont;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.userInteractionEnabled = NO;
    [view addSubview:btn];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [view addGestureRecognizer:tap];
    
    return view;
}

- (void)tapClick:(UIGestureRecognizer *)tap {
    NSDictionary *myDic = @{
           @"exhibitionId":self.exhibitionId,
           @"industryId":[NSString stringWithFormat:@"%@",self.industryId]
       };
       if (myDic) {
           __weak typeof (self) weakSelf = self;
           [[ZWDataAction sharedAction]postReqeustWithURL:zwExExhibitoersPairList parametes:myDic successBlock:^(NSDictionary * _Nonnull data) {
               if (zw_issuccess) {
                   __strong typeof (weakSelf) strongSelf = weakSelf;
                   NSArray *myData = data[@"data"][@"exhibitorList"];
                   NSMutableArray *myArray = [NSMutableArray array];
                   for (NSDictionary *myDic in myData) {
                       ZWExExhibitorsModel *model = [ZWExExhibitorsModel parseJSON:myDic];
                       [myArray addObject:model];
                   }
                   strongSelf.dataArray = myArray;
                   [strongSelf.tableView reloadData];
               }
           } failureBlock:^(NSError * _Nonnull error) {
                   
           } showInView:self.view];
       }
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZWExExhibitorsModel *model = self.dataArray[indexPath.row];
    ZWExExhibitorsDetailsVC *detailsVC = [[ZWExExhibitorsDetailsVC alloc]init];
    detailsVC.title = @"展商详情";
    detailsVC.shareModel = model;
    [self.navigationController pushViewController:detailsVC animated:YES];
}

-(void)exhibitorsItemWithIndex:(ZWExhibitionMerchantCell *)cell withIndex:(NSInteger)index {
    ZWExExhibitorsModel *model = self.dataArray[index];
    __block ZWExhibitionMerchantCell *myCell = cell;
    [[ZWDataAction sharedAction]getReqeustWithURL:zwExhibitionExhibitorCollectionCancel parametes:@{@"exhibitorId":model.exhibitorId} successBlock:^(NSDictionary * _Nonnull data) {
        if (zw_issuccess) {
            NSLog(@"%@",cell.collectionBtnBackImageName);
            if ([cell.collectionBtnBackImageName isEqualToString:@"zhanlist_icon_xin_wei"]) {
                myCell.collectionBtnBackImageName = @"zhanlist_icon_xin_xuan";
            }else {
                myCell.collectionBtnBackImageName = @"zhanlist_icon_xin_wei";
            }
            [myCell.collectionBtn setBackgroundImage:[UIImage imageNamed:myCell.collectionBtnBackImageName] forState:UIControlStateNormal];
        }
    } failureBlock:^(NSError * _Nonnull error) {

    }];
}

-(void)clickBtnWithIndex:(NSInteger)index {
    
    ZWExExhibitorsModel *model = self.dataArray[index];
    ZWBoothPictureVC *vc = [[ZWBoothPictureVC alloc]init];
    vc.imageUrl = model.expositionUrl;
    vc.title = @"展位图";
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
