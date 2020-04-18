//
//  ZWEditorUserInfoVC.m
//  YLJ.ZW
//
//  Created by G G on 2019/8/26.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWEditorUserInfoVC.h"
#import "ZWEditCompanyInfoVC.h"
#import "ZWMineRqust.h"
#import "ZWMineResponse.h"
#import <UIButton+WebCache.h>

#import "ZWEditorUserInfoModel.h"

@interface ZWEditorUserInfoVC ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    UIImagePickerController *_imagePickerController;
}

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSArray *dataSource;
@property(nonatomic, strong)ZWUserInfoModel *userInfoModel;
@property(nonatomic, strong)ZWEditorUserInfoModel *updateModel;//上传的模型
@property(nonatomic, strong)UIImage *headImage;
@property(nonatomic, strong)UIButton *headBtn;
@property(nonatomic, assign)NSInteger isUpdate;//记录是否更新头像0为未更新1为更新
@property(nonatomic, strong)NSString *identityName;//记录身份

@end

@implementation ZWEditorUserInfoVC
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
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self createViewWillAppearAction];
}
- (void)createViewWillAppearAction {
    NSLog(@"%@",self.excavatorLabels);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNavigationBar];
    [self createRequst];
    [self createNotice];
}
- (void)createNotice {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(createRequst) name:@"refreshUserInformation" object:nil];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refreshUserInformation" object:nil];
}
- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
    [[YNavigationBar sharedInstance]createRightBarWithTitle:@"保存" barItem:self.navigationItem target:self action:@selector(rightItemClick:)];
}
- (void)goBack:(UINavigationItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightItemClick:(UINavigationItem *)item {
    NSLog(@"%@",self.headBtn.currentBackgroundImage);
    __weak typeof (self) weakSelf = self;
    [[ZWAlertAction sharedAction]showTwoAlertTitle:@"提示" message:@"是否确认修改资料" cancelTitle:@"否" confirmTitle:@"是" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        __strong typeof (self) strongSelf = weakSelf;
        [strongSelf uploadHeadPortrait];
    } actionCancel:^(UIAlertAction * _Nonnull actionCancel) {
        
    } showInView:self];
}
- (void)createRequst {
    ZWPersonalInfoRequst *requst = [[ZWPersonalInfoRequst alloc]init];
    __weak typeof(self) weakSelf = self;
    [requst getRequestCompleted:^(YHBaseRespense *respense) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (respense.isFinished) {
            
            NSLog(@"%@", [[ZWToolActon shareAction]transformDic:respense.data]);
            NSMutableArray *myArry = [NSMutableArray array];
            NSDictionary *data = respense.data;
            strongSelf.userInfoModel = [ZWUserInfoModel parseJSON:data];
            [myArry addObject:strongSelf.userInfoModel];
            strongSelf.dataSource = myArry;
            
            NSMutableArray *myLabels = [NSMutableArray array];
            NSMutableArray *myLabelsId = [NSMutableArray array];
            for (NSDictionary *nameDic in strongSelf.userInfoModel.industryList) {
                [myLabels addObject:nameDic[@"name"]];
                [myLabelsId addObject:nameDic[@"id"]];
            }
            
            strongSelf.labels = myLabels;
            strongSelf.labelArray = myLabels;
            strongSelf.labelsId = myLabelsId;
            strongSelf.indexCount = self.userInfoModel.industryList.count;
            strongSelf.identityName = self.userInfoModel.identityName;
            [strongSelf.tableView reloadData];
            
        }else {
            
        }
    }];
}

- (void)uploadHeadPortrait {
    if (self.headBtn.currentBackgroundImage) {
        [ZWOSSConstants syncUploadImage:self.headBtn.currentBackgroundImage complete:^(NSArray<NSString *> * _Nonnull names, UploadImageState state) {
            if (state == 1) {
                [self uploadUserInfoWithHeadImage:names[0]];
            }else {
                [self showNoticeWithOneItem:@"上传个人信息失败，请检查网络或稍后再试"];
            }
        }];
    }else {
        [self showNoticeWithOneItem:@"头像上传失败"];
    }
}

- (void)uploadUserInfoWithHeadImage:(NSString *)imageName {
    
    ZWEditorUserInforRequest *request = [[ZWEditorUserInforRequest alloc]init];
    request.industryIdList = self.excavatorLabels;
    request.userName = self.userInfoModel.userName;
//    request.mail = self.userInfoModel.merchantEmail;
    request.headImages = imageName;
    request.identityId = self.identityId;
//    request.identityId = self.userInfoModel.identityId;
    __weak typeof (self) weakSelf = self;
    [request postRequestCompleted:^(YHBaseRespense *respense) {
        __strong typeof (self) strongSelf = weakSelf;
        if (respense.isFinished) {
            NSLog(@"提交成功");
            [strongSelf deleteImage:strongSelf.userInfoModel.headImages];
            [strongSelf createRequst];
            [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:@"个人信息修改成功" confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
                
            } showInView:strongSelf];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshPersonalCenter" object:nil];
        }else {
            NSLog(@"提交失败");
            [self deleteImage:imageName];
        }
    }];
    
}
- (void)deleteImage:(NSString *)imageName {
    [ZWOSSConstants syncDeleteImage:imageName complete:^(DeleteImageState state) {
        if (state == 1) {
            NSLog(@"图片删除成功");
        }else {
            NSLog(@"图片删除失败");
        }
    }];
}

- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.excavatorLabels = [NSMutableArray array];
    self.isUpdate = 0;
    [self.view addSubview:self.tableView];
}
#pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 2;
    } else if (section == 2) {
        return 2;
    } else {
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
    self.userInfoModel = self.dataSource[0];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0.045*kScreenWidth, 0.12*kScreenWidth-1, 0.91*kScreenWidth, 1)];
    cell.textLabel.font = normalFont;
    cell.detailTextLabel.font = smallMediumFont;
    if (indexPath.section == 0) {
        
        self.headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.headBtn.frame = CGRectMake(kScreenWidth/2-0.1*kScreenWidth, 0.05*kScreenWidth, 0.2*kScreenWidth, 0.2*kScreenWidth);
        self.headBtn.layer.cornerRadius = 0.1*kScreenWidth;
        self.headBtn.layer.masksToBounds = YES;
        self.headBtn.adjustsImageWhenHighlighted = NO;
        if (self.isUpdate == 0) {
            [self.headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,self.userInfoModel.headImages]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_no_60"]];
        }else {
            [self.headBtn setBackgroundImage:self.headImage forState:UIControlStateNormal];
        }
        [self.headBtn addTarget:self action:@selector(headBtnClcik:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:self.headBtn];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.25*kScreenWidth, CGRectGetMaxY(self.headBtn.frame)+10, 0.5*kScreenWidth, 0.1*kScreenWidth)];
        nameLabel.text = self.userInfoModel.userName;
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.font = bigFont;
        nameLabel.textColor = [UIColor colorWithRed:253/255.0 green:219/255.0 blue:128/255.0 alpha:1.0];
        [cell.contentView addSubview:nameLabel];
        
        
    }else if (indexPath.section == 1) {
        if (indexPath.row != 1) {
            lineView.backgroundColor = [UIColor colorWithRed:235/255.0 green:236/255.0 blue:237/255.0 alpha:1.0];
        }
        if (indexPath.row == 0) {
            cell.textLabel.text = @"用户名";
            cell.detailTextLabel.text = self.userInfoModel.userName;
        }else {
            cell.textLabel.text = @"用户账号";
            cell.detailTextLabel.text = self.userInfoModel.phone;
        }
        
    } else if (indexPath.section == 2) {
        if (indexPath.row !=1 ) {
            lineView.backgroundColor = [UIColor colorWithRed:235/255.0 green:236/255.0 blue:237/255.0 alpha:1.0];
        }
        if (indexPath.row == 0) {
            cell.textLabel.text = @"会员等级";
            cell.detailTextLabel.text = self.userInfoModel.memberName;
            cell.detailTextLabel.textColor = [UIColor colorWithRed:253/255.0 green:219/255.0 blue:128/255.0 alpha:1.0];
        }else {
            cell.textLabel.text = @"会员到期时间";
            cell.detailTextLabel.text = self.userInfoModel.invalidTime;
        }
    } else {
        if (indexPath.row != 4) {
            lineView.backgroundColor = [UIColor colorWithRed:235/255.0 green:236/255.0 blue:237/255.0 alpha:1.0];
        }
         if (indexPath.row == 0) {
            cell.textLabel.text = @"公司名称";
            cell.detailTextLabel.text = self.userInfoModel.merchantName;
        }else {
            cell.textLabel.text = @"公司邮箱";
            cell.detailTextLabel.text = self.userInfoModel.merchantEmail;
        }
        
//        else if (indexPath.row == 1) {
//            cell.textLabel.text = @"公司认证";
//            if (self.userInfoModel.merchantStatus == 0) {
//                cell.detailTextLabel.text = @"请上传营业执照认证";
//            }else if(self.userInfoModel.merchantStatus == 1) {
//                cell.detailTextLabel.text = @"审核中";
//            }else if (self.userInfoModel.merchantStatus == 2) {
//                cell.detailTextLabel.text = @"已认证";
//                cell.detailTextLabel.textColor = [UIColor greenColor];
//            }else {
//                cell.detailTextLabel.text = @"认证失败,请重新上传";
//            }
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        }
    }
    [cell.contentView addSubview:lineView];
}

#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 0.4*kScreenWidth;
    } else {
        return 0.12*kScreenWidth;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1;
    } else {
        return 0.05*kScreenWidth;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请输入用户名" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UITextField * userNameTextField = alertController.textFields.firstObject;
                NSLog(@"用户名：%@",userNameTextField.text);
                self.userInfoModel.userName = userNameTextField.text;
                [self.tableView reloadData];
            }]];
            [alertController addTextFieldWithConfigurationHandler:^(UITextField*_Nonnull textField) {
                textField.placeholder=@"请输入用户名";
//                textField.secureTextEntry=YES;
            }];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
    
//    if (indexPath.section == 3) {
//        if (indexPath.row == 1) {
//            NSLog(@"------%ld",(long)self.userInfoModel.merchantStatus);
//            if (self.userInfoModel.merchantStatus == 1 || self.userInfoModel.merchantStatus == 2) {
//                NSLog(@"审核中和已通过进入这里");
//            }else {
//                ZWEditCompanyInfoVC *companyInfoVC = [[ZWEditCompanyInfoVC alloc]init];
//                companyInfoVC.title = @"企业信息上传";
//                companyInfoVC.status = 1;
//                companyInfoVC.merchantStatus = self.userInfoModel.merchantStatus;
//                [self.navigationController pushViewController:companyInfoVC animated:YES];
//            }
//        }
//    }
}

- (void)headBtnClcik:(UIButton *)btn {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof (self) weakSelf = self;
    UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf openPhotoLibrary];
    }];
    [alertController addAction:actionOne];
    UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf openCamera];
    }];
    [alertController addAction:actionTwo];
    UIAlertAction *actionThree = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:actionThree];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)createImagePicker {
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.allowsEditing = YES;
}
/**
 *  打开相册
 */
-(void)openPhotoLibrary{
    [self createImagePicker];
    // 进入相册
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:_imagePickerController animated:YES completion:^{
            NSLog(@"打开相册");
        }];
    }else{
        NSLog(@"不能打开相册");
    }
}
/**
 *  调用照相机
 */
- (void)openCamera
{
    [self createImagePicker];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:_imagePickerController animated:YES completion:nil];
    }
    else{
        NSLog(@"没有摄像头");
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage];
    self.headImage = image;
//    self.userInfoModel.headImages = @"";
    self.isUpdate = 1;
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}
//进入拍摄页面点击取消按钮
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showNoticeWithOneItem:(NSString *)message {
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:message confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        
    } showInView:self];
}


@end
