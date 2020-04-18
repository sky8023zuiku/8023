//
//  ZWPlansDetailVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/18.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWPlansDetailVC.h"
#import "ZWExhPlanDetailModel.h"
#import "ZWImageBrowser.h"
@interface ZWPlansDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)ZWExhPlanDetailModel *model;
@property(nonatomic, strong)UIImageView *imageView;
@end

@implementation ZWPlansDetailVC

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) style:UITableViewStyleGrouped];
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return _tableView;
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNavigationBar];
    [self requestPlanData];
}
- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(backBtn:)];
}
- (void)backBtn:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    UIButton *bottomBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.035*kScreenWidth, kScreenHeight-zwTabBarHeight-zwNavBarHeight, 0.93*kScreenWidth, 0.1*kScreenWidth)];
    bottomBtn.backgroundColor = skinColor;
    bottomBtn.layer.cornerRadius = 5;
    bottomBtn.layer.masksToBounds = YES;
    [bottomBtn setBackgroundImage:[UIImage imageNamed:@"navigation_back_image"] forState:UIControlStateNormal];
    [bottomBtn setTitle:@"注 册 参 观" forState:UIControlStateNormal];
    bottomBtn.titleLabel.font = boldNormalFont;
    bottomBtn.adjustsImageWhenHighlighted = NO;
    [bottomBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomBtn];
    
}
- (void)bottomBtnClick:(UIButton *)btn {
    
    if (self.model.sponsorUrl.length != 0) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.model.sponsorUrl] options:@{} completionHandler:nil];
        } else {
             [[UIApplication sharedApplication] openURL: [NSURL URLWithString:self.model.sponsorUrl]];
        }
    }else {
        [self showOneAlertWithMessage:@"该展会暂时无法注册参观，请耐心等待"];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }else {
        return 1;
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
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            CGFloat height = [[ZWToolActon shareAction]adaptiveTextHeight:self.model.name textFont:boldNormalFont textWidth:kScreenWidth-40];
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.035*kScreenWidth, 10, kScreenWidth-40, height)];
            titleLabel.text = self.model.name;
            titleLabel.font = boldNormalFont;
            titleLabel.numberOfLines = 0;
            [cell.contentView addSubview:titleLabel];
        }else {
            self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.035*kScreenWidth, 0, 0.93*kScreenWidth, 0.93*kScreenWidth)];
            self.imageView.layer.cornerRadius = 5;
            self.imageView.layer.masksToBounds = YES;
            self.imageView.userInteractionEnabled = YES;
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,self.model.url]] placeholderImage:[UIImage imageNamed:@"zw_zfzw_icon"]];
            self.imageView.contentMode = UIViewContentModeScaleAspectFill;
            self.imageView.clipsToBounds = YES;
            [cell.contentView addSubview:self.imageView];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageViewClick:)];
            [self.imageView addGestureRecognizer:tap];
        }
    }else {
        UILabel *countriesLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.035*kScreenWidth, 0.035*kScreenWidth, kScreenWidth/2-20, 20)];
        countriesLabel.text =[NSString stringWithFormat:@"国    家：%@",self.model.country];
        countriesLabel.font = normalFont;
        [cell.contentView addSubview:countriesLabel];
        
        UILabel *cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(countriesLabel.frame), CGRectGetMinY(countriesLabel.frame), CGRectGetWidth(countriesLabel.frame), CGRectGetHeight(countriesLabel.frame))];
        cityLabel.text = [NSString stringWithFormat:@"城    市：%@",self.model.city];
        cityLabel.font = normalFont;
        [cell.contentView addSubview:cityLabel];
        
        UILabel *pavilionLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(countriesLabel.frame), CGRectGetMaxY(cityLabel.frame)+15, kScreenWidth-40, CGRectGetHeight(countriesLabel.frame))];
        pavilionLabel.text =[NSString stringWithFormat:@"展    馆：%@",self.model.hallName];
        pavilionLabel.font = normalFont;
        [cell.contentView addSubview:pavilionLabel];
        
        NSString *startTime = [self.model.startTime stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
        NSString *endTime = [self.model.endTime stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
        UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(pavilionLabel.frame), CGRectGetMaxY(pavilionLabel.frame)+15, CGRectGetWidth(pavilionLabel.frame), CGRectGetHeight(pavilionLabel.frame))];
        dateLabel.text = [NSString stringWithFormat:@"开展时间：%@-%@",startTime,endTime];
        dateLabel.font = normalFont;
        [cell.contentView addSubview:dateLabel];
        
        NSString *text = [self.model.industryName componentsJoinedByString:@"、"];
        UILabel *industryLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(dateLabel.frame), CGRectGetMaxY(dateLabel.frame)+15, CGRectGetWidth(dateLabel.frame), CGRectGetHeight(dateLabel.frame))];
        industryLabel.text = [NSString stringWithFormat:@"行业类别：%@",text];
        industryLabel.font = normalFont;
        [cell.contentView addSubview:industryLabel];
        
        UILabel *unitLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(industryLabel.frame), CGRectGetMaxY(industryLabel.frame)+15, CGRectGetWidth(industryLabel.frame), CGRectGetHeight(industryLabel.frame))];
        unitLabel.text = [NSString stringWithFormat:@"主办单位：%@",self.model.sponsor];
        unitLabel.font = normalFont;
        [cell.contentView addSubview:unitLabel];
    }
}
- (void)tapImageViewClick:(UITapGestureRecognizer *)sender {
    [ZWImageBrowser showImageV_img:self.imageView];
}
#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            CGFloat height = [[ZWToolActon shareAction]adaptiveTextHeight:self.model.name textFont:boldNormalFont textWidth:kScreenWidth-40];
            return height+20;
        }else {
            return 0.965*kScreenWidth;
        }
    }else {
        return 0.8*kScreenWidth;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1;
    }else {
        return 0.02*kScreenWidth;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 0.035*kScreenWidth+zwTabBarHeight;
    }else {
        return 0.01;
    }
}

- (void)requestPlanData {
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]getReqeustWithURL:zwPlanExhibitionDetail parametes:@{@"id":self.ID} successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (zw_issuccess) {
            NSDictionary *myData = data[@"data"];
            ZWExhPlanDetailModel *model = [ZWExhPlanDetailModel parseJSON:myData];
            strongSelf.model = model;
            [strongSelf.tableView reloadData];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    } showInView:self.view];
}


- (void)showOneAlertWithMessage:(NSString *)message {
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:message confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        
    } showInView:self];
}

@end
