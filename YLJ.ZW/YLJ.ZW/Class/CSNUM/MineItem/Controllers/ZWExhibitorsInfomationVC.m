//
//  ZWExhibitorsInfomationVC.m
//  YLJ.ZW
//
//  Created by G G on 2019/8/30.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWExhibitorsInfomationVC.h"
#import "ZWMineRqust.h"
#import "ZWMineResponse.h"
#import <IQActionSheetPickerView.h>

#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import <QuickLook/QuickLook.h>
#import "ZWDeliverMessageVC.h"
#import "ZWPdfManager.h"

@interface ZWExhibitorsInfomationVC ()<IQActionSheetPickerViewDelegate,UITableViewDelegate,UITableViewDataSource>

//@property (nonatomic,strong) ZWNavExhibitorModel *ExhibitorModel;
@property (strong, nonatomic) QLPreviewController *previewController;
@property (copy, nonatomic) NSURL *fileURL;

@property(nonatomic, strong)NSArray *dataSource;

@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)NSString *nature;

@end

@implementation ZWExhibitorsInfomationVC

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createRquest];
    NSLog(@"5555---5555%ld",(long)self.enterType);
}

- (void)createRquest {
    
    ZWExhibitorsDeltailRequst *request = [[ZWExhibitorsDeltailRequst alloc]init];
    request.exhibitorId = self.exhibitorId;
    __weak typeof (self) weakSelf = self;
    [request postRequestCompleted:^(YHBaseRespense *respense) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (respense.isFinished) {
            NSLog(@"%@",respense.data);
            NSDictionary *dataDic = respense.data[@"exhibitor"];
            NSMutableArray *array = [NSMutableArray array];
            ZWExhibitorDetailsModel *model = [ZWExhibitorDetailsModel  mj_objectWithKeyValues:dataDic];
            [array addObject:model];
            strongSelf.dataSource = array;
        }else {
           NSLog(@"%@",[[ZWToolActon shareAction]transformDic:respense.data]);
        }
        [strongSelf.tableView reloadData];
    }];
    
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
    return 10;
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
    
    NSArray *titles = @[@"会展名称：",@"公司名称：",@"主营项目：",@"展位编号：",@"公司邮箱：",@"展台属性：",@"公司网址：",@"公司电话：",@"公司地址：",@"需求说明："];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 0.21*kScreenWidth, 0.12*kScreenWidth)];
    titleLabel.text = titles[indexPath.row];
    titleLabel.font = normalFont;
    titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    [cell.contentView addSubview:titleLabel];
    
    ZWExhibitorDetailsModel *model = self.dataSource[0];
    UITextField *detailText = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), 0, 0.79*kScreenWidth-30, 0.12*kScreenWidth)];
    if (indexPath.row == 0) {
        detailText.text = model.exhibitionName;
    }else if(indexPath.row == 1) {
        detailText.text = model.merchantName;
    }else if (indexPath.row == 2) {
        detailText.text = model.product;
    }else if (indexPath.row == 3) {
        detailText.text = model.exposition;
    }else if (indexPath.row == 4) {
        detailText.text = model.email;
    }else if (indexPath.row == 5) {
        detailText.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
        detailText.frame = CGRectMake(CGRectGetMaxX(titleLabel.frame), 0.03*kScreenWidth, 60, 0.06*kScreenWidth);
        detailText.textAlignment = NSTextAlignmentCenter;
        detailText.layer.shadowColor = [UIColor blackColor].CGColor;
        detailText.layer.shadowRadius = 5;
        if (model.nature) {
            if ([model.nature isEqualToString:@"1"]) {
                detailText.text = @"标摊";
            }else if ([model.nature isEqualToString:@"2"]) {
                detailText.text = @"特装";
            }else {
                detailText.text = @"未标注";
            }
        }
    }else if (indexPath.row == 6) {
        detailText.text = model.website;
    }else if (indexPath.row == 7) {
        detailText.text = model.telephone;
    }else if (indexPath.row == 8) {
        detailText.text = model.address;
    }else {
        detailText.text = model.requirement;
        if (self.enterType == 1) {
            detailText.placeholder = @"点击输入需求说明";
        }
    }
    detailText.font = normalFont;
    detailText.enabled = NO;
    detailText.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    [cell.contentView addSubview:detailText];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 0.12*kScreenWidth-1, kScreenWidth-30, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:235/255.0 green:236/255.0 blue:237/255.0 alpha:1.0];
    [cell.contentView addSubview:lineView];
}
#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0.12*kScreenWidth;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.enterType == 0) {
        return 0.6*kScreenWidth;
    }else {
        return 0.3*kScreenWidth;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 5) {
        if (self.enterType == 1) {
            NSArray *myArray = @[@"标摊",@"特装"];
            IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"请选择展台属性" delegate:self];
            [picker setActionSheetPickerStyle:IQActionSheetPickerStyleTextPicker];
            [picker setTitlesForComponents:@[myArray]];
            [picker show];
        }
    }
    if (indexPath.row == 9) {
        if (self.enterType == 1) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请输入需求说明" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UITextField * userNameTextField = alertController.textFields.firstObject;
                NSLog(@"用户名：%@",userNameTextField.text);
                [self uploadRequirement:userNameTextField.text];
            }]];
            [alertController addTextFieldWithConfigurationHandler:^(UITextField*_Nonnull textField) {
                textField.placeholder=@"请输入需求说明";
            }];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}
- (void)actionSheetPickerView:(nonnull IQActionSheetPickerView *)pickerView didSelectTitlesAtIndexes:(nonnull NSArray<NSNumber*>*)indexes {
    NSLog(@"----%@",indexes[0]);
    int a = [indexes[0] intValue];
    if (a == 0) {
        //标摊
        self.nature = @"1";
    }else {
        //特装
        self.nature = @"2";
    }
    [self uploadProperties:self.nature];
}
- (void)uploadProperties:(NSString *)nature {
    
    ZWMyExhibitorsDetailsEditorRequest *request = [[ZWMyExhibitorsDetailsEditorRequest alloc]init];
    request.exhibitorId = self.exhibitorId;
    request.nature = nature;
    __weak typeof (self) weakSelf = self;
    [request postRequestCompleted:^(YHBaseRespense *respense) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (respense.isFinished) {
            NSLog(@"%@",respense.data);
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ZWEditExhibitionVC" object:nil];
            [strongSelf createRquest];
        }
    }];
}
- (void)uploadRequirement:(NSString *)str {
    ZWMyExhibitorsDetailsEditorRequest *request = [[ZWMyExhibitorsDetailsEditorRequest alloc]init];
    request.exhibitorId = self.exhibitorId;
    request.nature = self.nature;
    request.requirement = str;
    __weak typeof (self) weakSelf = self;
    [request postRequestCompleted:^(YHBaseRespense *respense) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (respense.isFinished) {
            NSLog(@"%@",respense.data);
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ZWEditExhibitionVC" object:nil];
            [strongSelf createRquest];
        }
    }];
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLB = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 0.21*kScreenWidth, 0.12*kScreenWidth)];
    titleLB.text = @"产品手册：";
    titleLB.font = normalFont;
    titleLB.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    [view addSubview:titleLB];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLB.frame), 10, 80, 80)];
    imageView.backgroundColor = [UIColor orangeColor];
    imageView.image = [UIImage imageNamed:@"ren_fabu_img_pdf"];
    [view addSubview:imageView];
    
    UIButton *browseBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    browseBtn.frame = CGRectMake(CGRectGetMaxX(imageView.frame), CGRectGetMaxY(imageView.frame)-20, 60, 20);
    [browseBtn setTitle:@"浏览" forState:UIControlStateNormal];
    [browseBtn addTarget:self action:@selector(browseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:browseBtn];
    
    if (self.enterType == 0) {
        UIButton *submitMessage = [UIButton buttonWithType:UIButtonTypeCustom];
        submitMessage.frame = CGRectMake(0.1*kScreenWidth, CGRectGetMaxY(imageView.frame)+0.1*kScreenWidth, 0.8*kScreenWidth, 0.1*kScreenWidth);
        submitMessage.backgroundColor = skinColor;
        [submitMessage setTitle:@"投递消息" forState:UIControlStateNormal];
        submitMessage.titleLabel.font = normalFont;
        submitMessage.layer.cornerRadius = 10;
        submitMessage.layer.masksToBounds = YES;
        [submitMessage addTarget:self action:@selector(submitMessageClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:submitMessage];
    }
    return view;
}
- (void)submitMessageClick:(UIButton *)btn {
    ZWExhibitorDetailsModel *model = self.dataSource[0];
    ZWDeliverMessageVC *messageVC = [[ZWDeliverMessageVC alloc]init];
    messageVC.merchantId = model.merchantId;
    messageVC.title = @"投递消息";
    [self.navigationController pushViewController:messageVC animated:YES];
    
}


- (void)browseBtnClick:(UIButton *)btn {
    
    ZWExhibitorDetailsModel *model = self.dataSource[0];
    if (! model.productUrl||[model.productUrl isEqualToString:@""]) {
        [self showOneAlertWithMessage:@"暂无产品手册"];
        return;
    }
    NSArray *array = [model.productUrl componentsSeparatedByString:@","];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",httpImageUrl,[array objectAtIndex:1]];
    NSString *fileName = [NSString stringWithFormat:@"%@",[array objectAtIndex:0]]; //获取文件名称
    [[ZWPdfManager shareManager]createPdfBreview:self withUrl:urlStr withFileName:fileName];
    
}

- (void)showOneAlertWithMessage:(NSString *)message {
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:message confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        
    } showInView:self];
}


@end
