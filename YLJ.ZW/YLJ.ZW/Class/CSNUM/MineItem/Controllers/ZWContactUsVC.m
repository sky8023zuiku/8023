//
//  ZWContactUsVC.m
//  YLJ.ZW
//
//  Created by G G on 2019/8/30.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWContactUsVC.h"
#import "ZWMineRqust.h"
#import "ZWMineResponse.h"

@interface ZWContactUsVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)NSString *type;

@property(nonatomic, strong)NSArray *dataSource;

@end

@implementation ZWContactUsVC
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight-0.1*kScreenWidth) style:UITableViewStyleGrouped];
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
    [self createUI];
    [self createNotice];
    [self createRequest];
}

- (void)createNotice {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(noticeResponse:) name:@"pageThatNeedsAResponse" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshContactList) name:@"refreshContactList" object:nil];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"pageThatNeedsAResponse" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refreshContactList" object:nil];
}
- (void)noticeResponse:(NSNotification *)notice {
    self.type = notice.object[@"type"];
    [self.tableView reloadData];
}
- (void)refreshContactList {
    [self createRequest];
}
- (void)createRequest {
    ZWContactListRequest *request = [[ZWContactListRequest alloc]init];
    request.exhibitorId = self.exhibitorId;
    [request postFormDataWithProgress:nil RequestCompleted:^(YHBaseRespense *respense) {
        if (respense.isFinished) {
            NSLog(@"%@",respense.data);
            NSArray *dataArray = respense.data;
            NSMutableArray *myArray = [NSMutableArray array];
            for (NSDictionary *myDic in dataArray) {
                ZWContactListModel *model = [ZWContactListModel parseJSON:myDic];
                [myArray addObject:model];
            }
            self.dataSource = myArray;
            [self.tableView reloadData];
        }
    }];
}

- (void)createUI {
    [self.view addSubview:self.tableView];
}
#pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
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
    if (indexPath.row == 0||indexPath.row == 1) {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 0.12*kScreenWidth-1, kScreenWidth-20, 1)];
        lineView.backgroundColor = [UIColor colorWithRed:235/255.0 green:236/255.0 blue:237/255.0 alpha:1.0];
        [cell.contentView addSubview:lineView];
    }
    
    ZWContactListModel *model = self.dataSource[indexPath.section];
    
    if (indexPath.row == 0) {
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 0.5*kScreenWidth-10, 0.12*kScreenWidth)];
        nameLabel.text = [NSString stringWithFormat:@"姓名：%@",model.contacts];
        nameLabel.font = normalFont;
        [cell.contentView addSubview:nameLabel];
        
        UILabel *businessLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame), 0, 0.5*kScreenWidth, CGRectGetHeight(nameLabel.frame))];
        businessLabel.text = [NSString stringWithFormat:@"职务：%@",model.post];
        businessLabel.font = normalFont;
        [cell.contentView addSubview:businessLabel];
        
        if ([self.type isEqualToString:@"完成"]) {
            UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            deleteBtn.frame = CGRectMake(kScreenWidth-30, 10, 20, 20);
            deleteBtn.tag = indexPath.section;
            [deleteBtn setBackgroundImage:[UIImage imageNamed:@"ren_wding_icon_shan"] forState:UIControlStateNormal];
            [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:deleteBtn];
        }        
    }else if(indexPath.row == 1) {
        UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 0.5*kScreenWidth-10, 0.12*kScreenWidth)];
        if ([model.type isEqualToString:@"0"]) {
            phoneLabel.text = @"手机：保密";
        }else {
            phoneLabel.text = [NSString stringWithFormat:@"手机：%@",model.phone];
        }
        phoneLabel.font = normalFont;
        [cell.contentView addSubview:phoneLabel];
        
        UILabel *telLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(phoneLabel.frame), 0, 0.5*kScreenWidth, CGRectGetHeight(phoneLabel.frame))];
        telLabel.text = [NSString stringWithFormat:@"电话：%@",model.telephone];
        telLabel.font = normalFont;
        [cell.contentView addSubview:telLabel];
    }else {
        UILabel *wechatLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 0.5*kScreenWidth-10, 0.12*kScreenWidth)];
        wechatLabel.text = [NSString stringWithFormat:@"微信：%@",model.wechat];
        wechatLabel.font = normalFont;
        [cell.contentView addSubview:wechatLabel];
        
        UILabel *emailLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(wechatLabel.frame), 0, 0.12*kScreenWidth, CGRectGetHeight(wechatLabel.frame))];
        emailLabel.text = @"邮箱：";
        emailLabel.font = normalFont;
        [cell.contentView addSubview:emailLabel];
        
        UILabel *emailDetail = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(emailLabel.frame), 0, 0.38*kScreenWidth, CGRectGetHeight(wechatLabel.frame))];
        emailDetail.text = [NSString stringWithFormat:@"%@",model.mail];
        emailDetail.font = smallMediumFont;
        emailDetail.textColor = [UIColor colorWithRed:121/255.0 green:170/255.0 blue:251/255.0 alpha:1.0];
        [cell.contentView addSubview:emailDetail];
    }
}
#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0.12*kScreenWidth;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.05*kScreenWidth;
    }else {
        return 0.1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.02*kScreenWidth;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (void)deleteBtnClick:(UIButton *)btn {
    [[ZWAlertAction sharedAction]showTwoAlertTitle:@"提示" message:@"是否确定要删除" cancelTitle:@"否" confirmTitle:@"是" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        [self deleteContact:btn.tag];
    } actionCancel:^(UIAlertAction * _Nonnull actionCancel) {
        
    } showInView:self];
    
}
- (void)deleteContact:(NSInteger)index {
    ZWContactListModel *model = self.dataSource[index];
    ZWContactDeleteRequest *request = [[ZWContactDeleteRequest alloc]init];
    request.cardId = model.contactId;
    __weak typeof (self) weakSelf = self;
    [request postFormDataWithProgress:nil RequestCompleted:^(YHBaseRespense *respense) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (respense.isFinished) {
            NSLog(@"联系人删除成功");
            [strongSelf createRequest];
        }
    }];
}
@end
