//
//  ZWMineVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/17.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWMineVC.h"
#import "ZWMessageCenterVC.h"
#import "ZWMessageCenterV2VC.h"
#import "ZWEditorUserInfoVC.h"
#import "ZWMyCatalogueVC.h"
#import "ZWIntegralExchangeVC.h"
#import "ZWMyOrderVC.h"
#import "ZWMyCollectionVC.h"
//#import "ZWUserManagerVC.h"
#import "ZWChildUserManagerVC.h"
#import "ZWMyReleaseVC.h"

#import "ZWSetVC.h"

#import "ZWMineRqust.h"
#import <UIImageView+WebCache.h>

#import "ZWImageBrowser.h"

#import "ZWMyAccountVC.h"

#import "ZWTopUpModel.h"

#import "UButton.h"

#import "ZWMyIndustriesVC.h"

#import "ZWMyInvitationVC.h"

#import "ZWMyShareVC.h"

#import "ZWEditCompanyInfoVC.h"
#import "ZWCertificationStatusVC.h"

#import "ZWSelectCertificationVC.h"

#import "ZWMineResponse.h"

#define IMAGE_HEIGHT 0.01*kScreenWidth
#define SCROLL_DOWN_LIMIT 100
#define LIMIT_OFFSET_Y -(IMAGE_HEIGHT + SCROLL_DOWN_LIMIT)
@interface ZWMineVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UIImageView *topBG;
    UIView *BGView;
}
@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)UIImageView *headImage;//头像

@property(nonatomic, strong)NSDictionary *userInfo;

@property(nonatomic, assign)NSInteger roleId;

@end

@implementation ZWMineVC

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight-zwTabBarHeight) style:UITableViewStyleGrouped];
    }
    _tableView.contentInset=UIEdgeInsetsMake(IMAGE_HEIGHT, 0, 0, 0);
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    [_tableView setSeparatorColor:[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0]];
    _tableView.backgroundColor = [UIColor colorWithRed:247/255.0 green:250/255.0 blue:252/255.0 alpha:1.0];
    return _tableView;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self createNavigationBar];
    [self requestUserInfoData];
    [[YNavigationBar sharedInstance]createNavigationBarWithStatusBarStyle:UIStatusBarStyleLightContent withType:0];
}

- (void)requestUserInfoData {
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]getReqeustWithURL:zwTakeUserInfo parametes:@{} successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (zw_issuccess) {
            NSDictionary *myDic = data[@"data"];
            if (myDic) {
                [[ZWSaveDataAction shareAction]saveUserInfoData:myDic];
            }
            [strongSelf.tableView reloadData];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNotice];
}
- (void)createNotice {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestUserInfoData) name:@"refreshPersonalCenter" object:nil];
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refreshPersonalCenter" object:nil];
}

- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createRightBarWithImage:[UIImage imageNamed:@"main_message_icon"] barItem:self.navigationItem target:self action:@selector(rightItemClick:)];
}
- (void)rightItemClick:(UINavigationItem *)item {
    ZWMessageCenterVC *messageCenterVC = [[ZWMessageCenterVC alloc]init];
    messageCenterVC.title = @"消息中心";
    messageCenterVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:messageCenterVC animated:YES];
    
//    ZWMessageCenterV2VC *messageCenterV2VC = [[ZWMessageCenterV2VC alloc]init];
//    messageCenterV2VC.title = @"消息中心";
//    messageCenterV2VC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:messageCenterV2VC animated:YES];
    
}

- (void)createUI {
    
    self.title = @"个人中心";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    topBG=[[UIImageView alloc]init];
    topBG.frame=CGRectMake(0, -IMAGE_HEIGHT, kScreenWidth, IMAGE_HEIGHT);
    topBG.backgroundColor = [UIColor colorWithRed:65/255.0 green:163/255.0 blue:255/255.0 alpha:1.0];
    [self.tableView addSubview:topBG];
    
}
#pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        NSDictionary *myDic = [[ZWSaveDataAction shareAction]takeUserInfoData];
        int roleId = [myDic[@"roleId"] intValue];
        if (roleId == 1||roleId == 5||roleId == 6||roleId == 7||roleId == 8||roleId == 12||roleId == 13) {
            return 4;
        } else if(roleId ==2||roleId==3 ||roleId ==4) {
            return 7;
        }else {
            return 5;
        }
    } else {
        return 1;
    }
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self createTableViewCell:cell cellForRowAtIndexPath:indexPath];
    return cell;
}
- (void)createTableViewCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.font = normalFont;
    if (indexPath.section == 0) {
        NSDictionary *myDic = [[ZWSaveDataAction shareAction]takeUserInfoData];
        int roleId = [myDic[@"roleId"] intValue];
        if(roleId ==2||roleId==3 ||roleId ==4) {
            
            if (indexPath.row == 0) {
                cell.textLabel.text = @"企业入驻";
                cell.imageView.image = [UIImage imageNamed:@"mine_enterprises_icon"];
            }else if (indexPath.row == 1) {
                cell.textLabel.text = @"我的订单";
                cell.imageView.image = [UIImage imageNamed:@"ren_icon_dingdan"];
            }else if (indexPath.row == 2) {
                cell.textLabel.text = @"我的收藏";
                cell.imageView.image = [UIImage imageNamed:@"ren_icon_shouc"];
            }else if (indexPath.row == 3) {
                cell.textLabel.text = @"我的发布";
                cell.imageView.image = [UIImage imageNamed:@"ren_icon_fabu"];
            }else if (indexPath.row == 4) {
                cell.textLabel.text = @"我的行业";
                cell.imageView.image = [UIImage imageNamed:@"ren_icon_zi"];
            }
            else if (indexPath.row == 5) {
                cell.textLabel.text = @"我的分享";
                cell.imageView.image = [UIImage imageNamed:@"my_share_icon"];
            }
            else {
                cell.textLabel.text = @"我的邀请";
                cell.imageView.image = [UIImage imageNamed:@"my_invitation_icon"];
            }
            
        }else if (roleId==9 ||roleId ==10) {
            
            if (indexPath.row == 0) {
                cell.textLabel.text = @"企业入驻";
                cell.imageView.image = [UIImage imageNamed:@"mine_enterprises_icon"];
            }else if (indexPath.row == 1) {
                cell.textLabel.text = @"我的订单";
                cell.imageView.image = [UIImage imageNamed:@"ren_icon_dingdan"];
            }else if (indexPath.row == 2) {
                cell.textLabel.text = @"我的收藏";
                cell.imageView.image = [UIImage imageNamed:@"ren_icon_shouc"];
            }else if (indexPath.row == 3) {
                cell.textLabel.text = @"子用户管理";
                cell.imageView.image = [UIImage imageNamed:@"ren_icon_shouc"];
            }else {
                cell.textLabel.text = @"我的邀请";
                cell.imageView.image = [UIImage imageNamed:@"my_invitation_icon"];
            }
            
        }else {
            
            if (indexPath.row == 0) {
                cell.textLabel.text = @"企业入驻";
                cell.imageView.image = [UIImage imageNamed:@"mine_enterprises_icon"];
            }else if (indexPath.row == 1) {
                cell.textLabel.text = @"我的订单";
                cell.imageView.image = [UIImage imageNamed:@"ren_icon_dingdan"];
            }else if (indexPath.row == 2) {
                cell.textLabel.text = @"我的收藏";
                cell.imageView.image = [UIImage imageNamed:@"ren_icon_shouc"];
            } else {
                cell.textLabel.text = @"我的邀请";
                cell.imageView.image = [UIImage imageNamed:@"my_invitation_icon"];
            }
            
        }
    } else {
        cell.textLabel.text = @"设置";
        cell.imageView.image = [UIImage imageNamed:@"ren_icon_she"];
    }
}


#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0.12*kScreenWidth;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 0.5*kScreenWidth;
    }else {
        return 0.05*kScreenWidth;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self createShuffling:section];
}
- (UIView *)createShuffling:(NSInteger)section {
    NSDictionary *myDic = [[ZWSaveDataAction shareAction]takeUserInfoData];
    NSLog(@"--我的个人中心数据--%@",myDic);
    UIView *tool = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth)];
    tool.backgroundColor = [UIColor colorWithRed:247/255.0 green:250/255.0 blue:252/255.0 alpha:1.0];
    if (myDic) {
        if (section == 0) {
            UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.35*kScreenWidth)];
            headView.backgroundColor = [UIColor colorWithRed:65/255.0 green:163/255.0 blue:255/255.0 alpha:1.0];
            [tool addSubview:headView];
            
            self.headImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 0.03*kScreenWidth, 0.18*kScreenWidth, 0.18*kScreenWidth)];
            self.headImage.layer.cornerRadius = 0.09*kScreenWidth;
            self.headImage.layer.masksToBounds = YES;
            self.headImage.userInteractionEnabled = YES;
            [self.headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,myDic[@"headImages"]]] placeholderImage:[UIImage imageNamed:@"icon_no_60"]];
            [headView addSubview:self.headImage];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageClick:)];
            [self.headImage addGestureRecognizer:tap];
            
            
            UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.headImage.frame)+0.02*kScreenWidth, CGRectGetMinY(self.headImage.frame)+0.02*kScreenWidth, kScreenWidth-CGRectGetMaxX(self.headImage.frame)-0.3*kScreenWidth, 0.065*kScreenWidth)];
            nameLabel.text = [NSString stringWithFormat:@"%@",myDic[@"userName"]];
//            nameLabel.text = @"上海某个地方的某个公司";
//            nameLabel.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:0.5];
            nameLabel.font = boldBigFont;
            nameLabel.layer.cornerRadius = 0.0325*kScreenWidth;
            nameLabel.layer.masksToBounds = YES;
            nameLabel.textColor = [UIColor whiteColor];
            [headView addSubview:nameLabel];
            
            
            CGFloat memBerwidth = [[ZWToolActon shareAction]adaptiveTextWidth:myDic[@"roleName"] labelFont:boldSmallFont]+20;
            UIButton *memBerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            memBerBtn.frame = CGRectMake(CGRectGetMinX(nameLabel.frame), CGRectGetMaxY(nameLabel.frame)+0.02*kScreenWidth, memBerwidth, 0.05*kScreenWidth);
            [memBerBtn setTitle:myDic[@"roleName"] forState:UIControlStateNormal];
            [memBerBtn setTitleColor:zwGrayColor forState:UIControlStateNormal];
            memBerBtn.layer.cornerRadius = 0.025*kScreenWidth;
            memBerBtn.layer.masksToBounds = YES;
            memBerBtn.titleLabel.font = boldSmallFont;
            [headView addSubview:memBerBtn];
            
            NSDictionary *myDic = [[ZWSaveDataAction shareAction]takeUserInfoData];
            int roleId = [myDic[@"roleId"] intValue];
            if (roleId == 3 || roleId == 6 || roleId == 9) {
                [memBerBtn setBackgroundImage:[UIImage imageNamed:@"silver_image"] forState:UIControlStateNormal];
                [memBerBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            }else if (roleId == 4 || roleId == 7 || roleId == 10) {
                [memBerBtn setBackgroundImage:[UIImage imageNamed:@"gold_images"] forState:UIControlStateNormal];
                [memBerBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            }else {
//                [memBerBtn setBackgroundImage:[UIImage imageNamed:@"copper_image"] forState:UIControlStateNormal];
                memBerBtn.backgroundColor = [UIColor colorWithRed:20/255.0 green:58/255.0 blue:102/255.0 alpha:0.5];
                [memBerBtn setTitleColor:zwGrayColor forState:UIControlStateNormal];
            }
            
            
//            CGFloat certificationWidth = [[ZWToolActon shareAction]adaptiveTextWidth:@"已认证" labelFont:boldSmallFont]+10;
//            UILabel *certificationLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(memBerBtn.frame)+5, CGRectGetMinY(memBerBtn.frame)+CGRectGetHeight(memBerBtn.frame)/2-5, certificationWidth, CGRectGetHeight(memBerBtn.frame)/2+5)];
//            certificationLabel.text = @"未认证";
//            certificationLabel.font = boldSmallFont;
//            certificationLabel.textAlignment = NSTextAlignmentCenter;
//            [headView addSubview:certificationLabel];
//
//            if (roleId == 1 || roleId == 12 || roleId == 13) {
//                certificationLabel.text = @"未认证";
//                certificationLabel.textColor = zwGrayColor;
//            }else {
//                certificationLabel.text = @"已认证";
//                certificationLabel.textColor = zwGrayColor;
//            }
            
            
            CGFloat width = [[ZWToolActon shareAction]adaptiveTextWidth:@"编辑" labelFont:normalFont]+10;
            ZWLeftImageBtn *editorBtn = [[ZWLeftImageBtn alloc]initWithFrame:CGRectMake(kScreenWidth-width-0.05*kScreenWidth-20, CGRectGetMinY(memBerBtn.frame), width+0.05*kScreenWidth, 0.05*kScreenWidth)];
            [editorBtn setImage:[UIImage imageNamed:@"editor_icon"] forState:UIControlStateNormal];
            [editorBtn setTitle:@"编辑" forState:UIControlStateNormal];
            [editorBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            editorBtn.titleLabel.font = normalFont;
            [editorBtn addTarget:self action:@selector(editorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [headView addSubview:editorBtn];
            
            UIView *toolView = [[UIView alloc]initWithFrame:CGRectMake(20, 0.25*kScreenWidth, kScreenWidth-40, 0.2*kScreenWidth)];
            toolView.layer.cornerRadius = 5;
            toolView.layer.shadowColor = [UIColor blackColor].CGColor;
            // 阴影偏移，默认(0, -3)
            toolView.layer.shadowOffset = CGSizeMake(0,0);
            // 阴影透明度，默认0
            toolView.layer.shadowOpacity = 0.1;
            // 阴影半径，默认3
            toolView.layer.shadowRadius = 5;
            toolView.backgroundColor = [UIColor whiteColor];
            [tool addSubview:toolView];
            
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetWidth(toolView.frame)/2-0.5, 10, 1, 0.2*kScreenWidth-20)];
            lineView.backgroundColor = [UIColor colorWithRed:235/255.0 green:236/255.0 blue:237/255.0 alpha:1.0];
            [toolView addSubview:lineView];
            
            UILabel *catalogueLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, CGRectGetWidth(toolView.frame)/2, (CGRectGetHeight(toolView.frame)-10)/3)];
            catalogueLabel.text = @"展会";
            catalogueLabel.textAlignment = NSTextAlignmentCenter;
            catalogueLabel.font = smallMediumFont;
            [toolView addSubview:catalogueLabel];
            
            UILabel *numOne = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(catalogueLabel.frame), CGRectGetWidth(toolView.frame)/2, CGRectGetHeight(catalogueLabel.frame))];
            numOne.text = [NSString stringWithFormat:@"%@",myDic[@"exhibitions"]];
            numOne.textAlignment = NSTextAlignmentCenter;
            numOne.font = smallMediumFont;
            [toolView addSubview:numOne];
            
            UIButton *catalogueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            catalogueBtn.frame = CGRectMake(0, CGRectGetMaxY(numOne.frame), CGRectGetWidth(numOne.frame), CGRectGetHeight(numOne.frame));
            [catalogueBtn setTitle:@"立即查看" forState:UIControlStateNormal];
            [catalogueBtn setTitleColor: [UIColor colorWithRed:0/255.0 green:107/255.0 blue:181/255.0 alpha:1.0] forState:UIControlStateNormal];
            catalogueBtn.titleLabel.font = smallMediumFont;
            [catalogueBtn addTarget:self action:@selector(catalogueBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [toolView addSubview:catalogueBtn];
            
            UILabel *integralLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView.frame), CGRectGetMinY(catalogueLabel.frame), CGRectGetWidth(toolView.frame)/2, CGRectGetHeight(catalogueLabel.frame))];
            integralLabel.text = @"会展币";
            integralLabel.textAlignment = NSTextAlignmentCenter;
            integralLabel.font = smallMediumFont;
            [toolView addSubview:integralLabel];
            
            UILabel *numTwo = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(integralLabel.frame), CGRectGetMaxY(catalogueLabel.frame), CGRectGetWidth(toolView.frame)/2, CGRectGetHeight(integralLabel.frame))];
            numTwo.text = [NSString stringWithFormat:@"%@",myDic[@"score"]];
            numTwo.textAlignment = NSTextAlignmentCenter;
            numTwo.font = smallMediumFont;
            [toolView addSubview:numTwo];
            
            UIButton *integralBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            integralBtn.frame = CGRectMake(CGRectGetMinX(numTwo.frame), CGRectGetMaxY(numOne.frame), CGRectGetWidth(numOne.frame), CGRectGetHeight(numOne.frame));
            [integralBtn setTitle:@"我要充值" forState:UIControlStateNormal];
            [integralBtn setTitleColor: [UIColor colorWithRed:0/255.0 green:107/255.0 blue:181/255.0 alpha:1.0] forState:UIControlStateNormal];
            integralBtn.titleLabel.font = smallMediumFont;
            [integralBtn addTarget:self action:@selector(integralBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [toolView addSubview:integralBtn];

        }
        
    } else {
        [self requestUserInfoData];
    }
    return tool;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *myDic = [[ZWSaveDataAction shareAction]takeUserInfoData];
    int roleId = [myDic[@"roleId"] intValue];
    
    if (indexPath.section == 0) {

        if (roleId == 2||roleId == 3||roleId == 4) {
            if (indexPath.row == 0) {
                [self zwGoToEnterprisesVC];
            }else if (indexPath.row == 1) {
                [self gotoMyOrderVC];
            }else if (indexPath.row == 2) {
                [self gotoMyCollectionVC];
            }else if (indexPath.row == 3) {
                ZWMyReleaseVC *ReleaseVC = [[ZWMyReleaseVC alloc]init];
                ReleaseVC.title = @"我的发布";
                ReleaseVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:ReleaseVC animated:YES];
            }else if (indexPath.row == 4) {
                ZWMyIndustriesVC *industriesVC = [[ZWMyIndustriesVC alloc]init];
                industriesVC.title = @"我的行业";
                industriesVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:industriesVC animated:YES];
            }
            else if (indexPath.row == 5) {
                ZWMyShareVC *shareVC = [[ZWMyShareVC alloc]init];
                shareVC.title = @"我的分享";
                shareVC.userId = myDic[@"userId"];
                shareVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:shareVC animated:YES];
            }
            else {
                [self gotoMyInvitationVC];
            }
        }else if (roleId==9||roleId==10) {
            if (indexPath.row == 0) {
                [self zwGoToEnterprisesVC];
            }else if (indexPath.row == 1) {
                [self gotoMyOrderVC];
            }else if (indexPath.row == 2) {
                [self gotoMyCollectionVC];
            }else if (indexPath.row == 3) {
                ZWChildUserManagerVC *userManagerVC = [[ZWChildUserManagerVC alloc]init];
                userManagerVC.title = @"子用户管理";
                userManagerVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:userManagerVC animated:YES];
            }else {
                [self gotoMyInvitationVC];
            }
        }else {
            if (indexPath.row == 0) {
                [self zwGoToEnterprisesVC];
            }else if (indexPath.row == 1) {
                [self gotoMyOrderVC];
            }else if (indexPath.row == 2) {
                [self gotoMyCollectionVC];
            }else{
                [self gotoMyInvitationVC];
            }
        }
    } else {
        ZWSetVC *setVC= [[ZWSetVC alloc]init];
        setVC.title = @"设置";
        setVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:setVC animated:YES];
    }
}

- (void)gotoMyOrderVC {
    ZWMyOrderVC *myOrderVC = [[ZWMyOrderVC alloc]init];
    myOrderVC.title = @"我的订单";
    myOrderVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myOrderVC animated:YES];
}
- (void)gotoMyCollectionVC {
    ZWMyCollectionVC *collectionVC = [[ZWMyCollectionVC alloc]init];
    collectionVC.title = @"我的收藏";
    collectionVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:collectionVC animated:YES];
}

- (void)gotoMyInvitationVC {
    ZWMyInvitationVC *invitationVC = [[ZWMyInvitationVC alloc]init];
    invitationVC.title = @"我的邀请";
    invitationVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:invitationVC animated:YES];
}

- (void)editorBtnClick:(UIButton *)btn {
    ZWEditorUserInfoVC *userInfoVC = [[ZWEditorUserInfoVC alloc]init];
    userInfoVC.hidesBottomBarWhenPushed = YES;
    userInfoVC.title = @"个人资料";
    [self.navigationController pushViewController:userInfoVC animated:YES];
}

- (void)catalogueBtnClick:(UIButton *)btn {
    ZWMyCatalogueVC *catalogueVC = [[ZWMyCatalogueVC alloc]init];
    catalogueVC.title = @"我的展会";
    catalogueVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:catalogueVC animated:YES];
}

- (void)zwGoToEnterprisesVC {
    
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]getReqeustWithURL:zwCompanyCertification parametes:@{} successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (zw_issuccess) {
            NSDictionary *myData = data[@"data"];
            ZWSelectCertificationVC *selectVC = [[ZWSelectCertificationVC alloc]init];
            selectVC.title = @"选择企业类型";
            selectVC.hidesBottomBarWhenPushed = YES;
            selectVC.authenticationStatus = [myData[@"authenticationStatus"] integerValue];
            selectVC.identityId = [myData[@"identityId"] integerValue];
            [strongSelf.navigationController pushViewController:selectVC animated:YES];
        }
    } failureBlock:^(NSError * _Nonnull error) {

    } showInView:self.view];
    
}

- (void)integralBtnClick:(UIButton *)btn {

    [[ZWDataAction sharedAction]getReqeustWithURL:zwTopUpList parametes:@{@"type":@"0"} successBlock:^(NSDictionary * _Nonnull data) {
        if (zw_issuccess) {
            
            NSArray *myData = data[@"data"];
            NSMutableArray *myArray = [NSMutableArray array];
            for (NSDictionary *myDic in myData) {
                ZWTopUpModel *model = [ZWTopUpModel parseJSON:myDic];
                [myArray addObject:model];
            }
            ZWMyAccountVC *accountVC = [[ZWMyAccountVC alloc]init];
            accountVC.title = @"充值";
            accountVC.jumpType = 1;
            accountVC.models = myArray;
            accountVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:accountVC animated:YES];
            
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    } showInView:self.view];
    
}

- (void)tapImageClick:(UIGestureRecognizer *)tap {
    [ZWImageBrowser showImageV_img:self.headImage];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    //限制下拉的距离
    if(offsetY < LIMIT_OFFSET_Y) {
        [scrollView setContentOffset:CGPointMake(0, LIMIT_OFFSET_Y)];
    }
    CGFloat newOffsetY = scrollView.contentOffset.y;
    if (newOffsetY < -IMAGE_HEIGHT)
    {
        topBG.frame = CGRectMake(0, newOffsetY, kScreenWidth, -newOffsetY);
    }
}

- (void)showAlretWithMessage:(NSString *)message {
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:message confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        
    } showInView:self];
}

@end
