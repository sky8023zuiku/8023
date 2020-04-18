//
//  ZWCompanyProfileVC.m
//  YLJ.ZW
//
//  Created by G G on 2019/8/30.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWCompanyProfileVC.h"
#import "ZWMineRqust.h"
#import <UIImageView+WebCache.h>

@interface ZWCompanyProfileVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)NSArray *dataArray;

@property(nonatomic, strong)NSString *companyIntroduction;

@end

@implementation ZWCompanyProfileVC
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight-44) style:UITableViewStyleGrouped];
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
    [self createRequest];

}
- (void)createRequest {
    ZWExhibitorsIntroduceRequst *request = [[ZWExhibitorsIntroduceRequst alloc]init];
    request.merchantId= self.exhibitorId;
    __weak typeof (self) weakSelf = self;
    [request postFormDataWithProgress:nil RequestCompleted:^(YHBaseRespense *respense) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (respense.isFinished) {
            NSLog(@"---%@",respense.data);
            strongSelf.companyIntroduction = respense.data[@"zwMerchantVo"][@"profile"];
        }
        [strongSelf.tableView reloadData];
    }];
}
- (void)createUI {
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
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth-20, 0.5*kScreenWidth-10)];
//    imageView.image = [UIImage imageNamed:@"h1.jpg"];
//    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,self.dataArray[indexPath.row]]] placeholderImage:[UIImage imageNamed:@"fu_img_no_02"]];
//    [cell.contentView addSubview:imageView];
//    NSLog(@"------%@%@",httpImageUrl,self.dataArray[indexPath.row]);
}
#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0.5*kScreenWidth;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kScreenHeight-zwNavBarHeight-44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    
    NSString *myText;
    if ([self.companyIntroduction isEqualToString:@""]) {
        myText =@"无";
    }else {
        myText =self.companyIntroduction;
    }
    CGFloat height = [[ZWToolActon shareAction]adaptiveTextHeight:myText textFont:normalFont textWidth:kScreenWidth-20];
    
    UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth-20, height+20)];
    myLabel.text = myText;
    myLabel.numberOfLines = 0;
    myLabel.font = normalFont;
    [view addSubview:myLabel];
    return view;
}

@end
