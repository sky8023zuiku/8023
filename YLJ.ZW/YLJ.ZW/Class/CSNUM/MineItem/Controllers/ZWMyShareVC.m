//
//  ZWMyShareVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/3/11.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWMyShareVC.h"
#import "ZWMyShareBindListModel.h"
#import "UIViewController+YCPopover.h"
#import "ZWMyShareBindAlertVC.h"
#import "ZWMyShareListVC.h"
#import "ZWMyShareCodeVC.h"
#import "ZWExhibitionNaviVC.h"

#import "ZWMyShareExhibitorModel.h"


#import "JhScrollActionSheetView.h"
#import "JhPageItemModel.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface ZWMyShareVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSArray *dataArray;
@property(nonatomic, assign)NSInteger page;

@property(nonatomic, strong)NSMutableArray *shareArray;

@property(nonatomic, strong)ZWMyShareExhibitorModel *shareModel;

@property(nonatomic, strong)NSString *total;//累计的分享码个数
@property(nonatomic, strong)NSString *unbindCount;//未使用的分享码个数

@end

@implementation ZWMyShareVC

-(UITableView *)tableView {
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNavigationBar];
    [self createRequest];
    [self createNotice];
}
- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
//     [[YNavigationBar sharedInstance]createRightBarWithImage:[UIImage imageNamed:@"search_icon"] barItem:self.navigationItem target:self action:@selector(rightItemClick:)];
//    [[YNavigationBar sharedInstance]createRightBarWithTitle:@"购码" barItem:self.navigationItem target:self action:@selector(rightItemClick:)];
}

- (void)createNotice {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(RefreshTheBindList:) name:@"RefreshTheBindList" object:nil];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"RefreshTheBindList" object:nil];
}

- (void)RefreshTheBindList:(NSNotification *)notice {
    [self showAlertWithMessage:@"绑定成功"];
    [self createRequest];
}

- (void)goBack:(UINavigationItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightItemClick:(UINavigationItem *)item {
    
}
- (void)createUI {
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
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    ZWMyShareBindListModel *model = self.dataArray[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 0.025*kScreenWidth, 0.2*kScreenWidth, 0.2*kScreenWidth)];
    imageView.image = [UIImage imageNamed:@"h1.jpg"];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,model.url]] placeholderImage:[UIImage imageNamed:@"zw_zfzw_icon"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.layer.cornerRadius = 5;
    imageView.layer.borderWidth = 0.5;
    imageView.layer.borderColor = [UIColor grayColor].CGColor;
    [cell.contentView addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+10, CGRectGetMinY(imageView.frame), 0.65*kScreenWidth-40, 0.08*kScreenWidth)];
    titleLabel.text = model.exhibitionName;
    titleLabel.font = smallMediumFont;
    titleLabel.numberOfLines = 2;
    [cell.contentView addSubview:titleLabel];
    
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), CGRectGetMinY(titleLabel.frame), 0.1*kScreenWidth+25, 0.05*kScreenWidth)];
    numLabel.text = [NSString stringWithFormat:@"（%@/%@）",model.bindSize,model.total];
    numLabel.font = boldSmallFont;
    numLabel.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:numLabel];
    
    NSInteger total = [model.total integerValue];
    NSInteger bindSize = [model.bindSize integerValue];
    NSInteger xValue = total-bindSize;
    if (xValue > 50) {
        numLabel.textColor = [UIColor greenColor];
    }else {
        if (xValue == 0) {
            numLabel.textColor = [UIColor redColor];
        }else {
            numLabel.textColor = [UIColor orangeColor];
        }
    }
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame), CGRectGetMaxY(titleLabel.frame), CGRectGetWidth(titleLabel.frame), 0.05*kScreenWidth)];
    dateLabel.text = [NSString stringWithFormat:@"时间：%@～%@",[model.startTime substringWithRange:NSMakeRange(0,10)],[model.endTime substringWithRange:NSMakeRange(0,10)]];
    dateLabel.font = smallFont;
    dateLabel.textColor = [UIColor grayColor];
    [cell.contentView addSubview:dateLabel];
    
//    UILabel *adressLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(dateLabel.frame), CGRectGetMaxY(dateLabel.frame), CGRectGetWidth(titleLabel.frame), 0.05*kScreenWidth)];
//    adressLabel.text = [NSString stringWithFormat:@"地点：%@  %@",model.country ,model.city];
//    adressLabel.font = smallFont;
//    adressLabel.textColor = [UIColor grayColor];
//    [cell.contentView addSubview:adressLabel];
    
    UIButton *bindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bindBtn.frame = CGRectMake(CGRectGetMinX(dateLabel.frame), CGRectGetMaxY(dateLabel.frame)+5, 0.15*kScreenWidth, 0.05*kScreenWidth);
    bindBtn.backgroundColor = skinColor;
    [bindBtn setTitle:@"绑定分享码" forState:UIControlStateNormal];
    bindBtn.titleLabel.font = smallFont;
    bindBtn.tag = indexPath.row;
    [bindBtn addTarget:self action:@selector(bindBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:bindBtn];
    
    UIButton *shareListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareListBtn.frame = CGRectMake(CGRectGetMaxX(bindBtn.frame)+0.05*kScreenWidth, CGRectGetMaxY(dateLabel.frame)+5, 0.15*kScreenWidth, 0.05*kScreenWidth);
    shareListBtn.backgroundColor = [UIColor orangeColor];
    [shareListBtn setTitle:@"分享列表" forState:UIControlStateNormal];
    shareListBtn.titleLabel.font = smallFont;
    shareListBtn.tag = indexPath.row;
    [shareListBtn addTarget:self action:@selector(shareListBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:shareListBtn];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(CGRectGetMaxX(shareListBtn.frame)+0.05*kScreenWidth, CGRectGetMaxY(dateLabel.frame)+5, 0.15*kScreenWidth, 0.05*kScreenWidth);
    shareBtn.backgroundColor = skinColor;
    [shareBtn setTitle:@"分享展商" forState:UIControlStateNormal];
    shareBtn.titleLabel.font = smallFont;
    shareBtn.tag = indexPath.row;
    [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:shareBtn];
    
    [self setTheRoundedCorners:bindBtn];
    [self setTheRoundedCorners:shareListBtn];
    [self setTheRoundedCorners:shareBtn];
}

- (void)setTheRoundedCorners:(UIButton *)btn {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:btn.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(8,8)];//圆角大小
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = btn.bounds;
    maskLayer.path = maskPath.CGPath;
    btn.layer.mask = maskLayer;
}

- (void)bindBtnClick:(UIButton *)btn {
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]postReqeustWithURL:zwGetShareCodeList parametes:@{@"userId":self.userId} successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (zw_issuccess) {
            ZWMyShareBindListModel *model = strongSelf.dataArray[btn.tag];
            ZWMyShareBindAlertVC *alertVC = [[ZWMyShareBindAlertVC alloc]init];
            alertVC.exhibitionId = model.exhibitionId;
            alertVC.exhibitionName = model.exhibitionName;
            alertVC.shareCodeNum = data[@"data"][@"unBindCount"];
            [strongSelf.navigationController yc_centerPresentController:alertVC presentedSize:CGSizeMake(0.7*kScreenWidth, 0.55*kScreenWidth) completeHandle:^(BOOL presented) {
                
            }];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    } showInView:self.view];
}

- (void)shareListBtnClick:(UIButton *)btn {
    ZWMyShareBindListModel *model = self.dataArray[btn.tag];
    ZWMyShareListVC *shareVC = [[ZWMyShareListVC alloc]init];
    shareVC.exhibitionId = model.exhibitionId;
    shareVC.title = model.exhibitionName;
    [self.navigationController pushViewController:shareVC animated:YES];
}

- (void)shareBtnClick:(UIButton *)btn {
    ZWMyShareBindListModel *model = self.dataArray[btn.tag];
    NSInteger total = [model.total integerValue];
    NSInteger bindSize = [model.bindSize integerValue];
    NSInteger xValue = total-bindSize;
    if (xValue > 0) {
        [self shareInformationWithIndex:btn.tag];
    }else {
        [self showAlertWithMessage:@"该展会的分享码已不足，请先绑定分享码"];
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0.25*kScreenWidth;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.15*kScreenWidth;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *tool = [[UIView alloc]init];
    tool.backgroundColor = zwGrayColor;
    
    UILabel *cumulative = [[UILabel alloc]initWithFrame:CGRectMake(20, 0.025*kScreenWidth, 0.5*kScreenWidth-15, 0.05*kScreenWidth)];
    cumulative.text = [NSString stringWithFormat:@"累计分享码%@个",self.total];
    cumulative.font = smallMediumFont;
    [tool addSubview:cumulative];
    
    UILabel *remainLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(cumulative.frame), CGRectGetMaxY(cumulative.frame)+0.01*kScreenWidth, 0.5*kScreenWidth-15, CGRectGetHeight(cumulative.frame))];
    remainLabel.text = [NSString stringWithFormat:@"剩余未绑定分享码%@个",self.unbindCount];
    remainLabel.font = smallMediumFont;
    [tool addSubview:remainLabel];
    
    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    buyBtn.frame = CGRectMake(0.8*kScreenWidth-15, 0.045*kScreenWidth, 0.2*kScreenWidth, 0.07*kScreenWidth);
    [buyBtn setTitle:@"购买分享码" forState:UIControlStateNormal];
    buyBtn.layer.cornerRadius = 5;
    buyBtn.layer.masksToBounds = YES;
    buyBtn.backgroundColor = skinColor;
    buyBtn.titleLabel.font = smallMediumFont;
    [buyBtn addTarget:self action:@selector(buyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [tool addSubview:buyBtn];
    
    return tool;
}

- (void)buyBtnClick:(UIButton *)btn {
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]postReqeustWithURL:zwGetShareCodeList parametes:@{@"userId":self.userId} successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (zw_issuccess) {
            ZWMyShareCodeVC *shareCodeVC = [[ZWMyShareCodeVC alloc]init];
            shareCodeVC.title = @"分享码";
            shareCodeVC.myData = data[@"data"];
            shareCodeVC.userId = self.userId;
            [strongSelf.navigationController pushViewController:shareCodeVC animated:YES];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    } showInView:self.view];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZWMyShareBindListModel *model = self.dataArray[indexPath.row];
    ZWExhibitionNaviVC *naviVC = [[ZWExhibitionNaviVC alloc]init];
    naviVC.title = @"展会导航";
    naviVC.exhibitionId = model.exhibitionId;
    naviVC.price = model.price;
    [self.navigationController pushViewController:naviVC animated:YES];
}


- (void)createRequest {
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]getReqeustWithURL:zwShareBindExhibitionList parametes:@{} successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (zw_issuccess) {
            strongSelf.total = data[@"data"][@"total"];
            strongSelf.unbindCount = data[@"data"][@"unbindCount"];
            NSArray *myData = data[@"data"][@"exhibitionList"];
            NSLog(@"%@",myData);
            NSMutableArray *myArray = [NSMutableArray array];
            for (NSDictionary *myDic in myData) {
                ZWMyShareBindListModel *model = [ZWMyShareBindListModel parseJSON:myDic];
                [myArray addObject:model];
            }
            strongSelf.dataArray = myArray;
            [strongSelf.tableView reloadData];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];
}

-(NSMutableArray *)shareArray{
    if (!_shareArray) {
        _shareArray = [NSMutableArray new];
        
        NSArray *data = @[
                          @{
                              @"text" : @"微信",
                              @"img" : @"weixing",
                              },
                          @{
                              @"text" : @"朋友圈",
                              @"img" : @"friends",
                              },
                          @{
                              @"text" : @"微博",
                              @"img" : @"sina",
                              },
                          @{
                              @"text" : @"QQ",
                              @"img" : @"qq",
                              },
                          @{
                              @"text" : @"QQ空间",
                              @"img" : @"kongjian",
                              }];
        
        for (NSDictionary *mydic in data) {
            JhPageItemModel *model = [JhPageItemModel parseJSON:mydic];
            [self.shareArray addObject:model];
        }
    }
    return _shareArray;
}

- (void)shareInformationWithIndex:(NSInteger)index {
    
    ZWMyShareBindListModel *model = self.dataArray[index];
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]getReqeustWithURL:zwGetWebExhibitorDetail parametes:@{@"exhibitorId":model.exhibitorId} successBlock:^(NSDictionary * _Nonnull data) {
        if (zw_issuccess) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            NSLog(@"%@",data);
            NSDictionary *myDic = data[@"data"];
            strongSelf.shareModel = [ZWMyShareExhibitorModel parseJSON:myDic];
            [strongSelf showShareView];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    } showInView:self.view];
    
}

- (void)showShareView {
    __weak typeof (self) weakSelf = self;
    [JhScrollActionSheetView showShareActionSheetWithTitle:@"分享" shareDataArray:self.shareArray handler:^(JhScrollActionSheetView *actionSheet, NSInteger index) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        NSLog(@" 点击分享 index %ld ",(long)index);
        switch (index) {
            case 0:
                [strongSelf createShare:SSDKPlatformTypeWechat];
                break;
            case 1:
                [strongSelf createShare:SSDKPlatformSubTypeWechatTimeline];
                break;
            case 2:
                [strongSelf createShare:SSDKPlatformTypeSinaWeibo];
                break;
            case 3:
                [strongSelf createShare:SSDKPlatformSubTypeQQFriend];
                break;
            case 4:
                [strongSelf createShare:SSDKPlatformSubTypeQZone];
                break;
            default:
                break;
        }
    }];
}

- (void)createShare:(SSDKPlatformType)type {
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSString *text;
    if (type == SSDKPlatformTypeSinaWeibo) {
        text = [NSString stringWithFormat:@"%@?exhibitorId=%@",share_url,self.shareModel.exhibitorId];
    }else {
        text = self.shareModel.exhibitionName;
    }
    [shareParams SSDKSetupShareParamsByText:text
                                     images:[NSString stringWithFormat:@"%@%@",httpImageUrl,self.shareModel.coverImage]
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"%@?exhibitorId=%@",share_url,self.shareModel.exhibitorId]]
                                      title:self.shareModel.merchantName
                                       type:SSDKContentTypeAuto];
    [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                NSLog(@"分享成功");
                break;
            }
            case SSDKResponseStateFail:
            {
                NSLog(@"分享失败");
                break;
            }
            default:
                break;
        }
    }];
}

- (void)showAlertWithMessage:(NSString *)message {
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:message confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        
    } showInView:self];
}


@end
