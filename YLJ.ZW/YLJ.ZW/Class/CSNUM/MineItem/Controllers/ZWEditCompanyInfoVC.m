//
//  ZWEditCompanyInfoVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/5.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWEditCompanyInfoVC.h"
#import "ZWEditCompanyIntroductionVC.h"
#import "ZWMineRqust.h"
#import "ZWMineResponse.h"
#import <UIButton+WebCache.h>
#import <TPKeyboardAvoidingScrollView.h>
#import <IQActionSheetPickerView.h>

#import "ZWSelectIndustriesVC.h"

#import "ZWSelectIndustriesVC.h"

#import "ZWChosenIndustriesModel.h"

#import "ZWAgentCountriesVC.h"

#import "ZWCPCitiesModel.h"

@interface ZWEditCompanyInfoVC ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate,IQActionSheetPickerViewDelegate>{
    UIImagePickerController *_imagePickerController;
}
@property(nonatomic, strong)TPKeyboardAvoidingScrollView *myScrollView;
@property(nonatomic, strong)UIButton *imageBtn;
@property(nonatomic, strong)UITextField *companyName;//公司名称
@property(nonatomic, strong)UITextField *companyEmail;//公司邮箱
@property(nonatomic, strong)UITextField *companyUrl;//公司邮箱
@property(nonatomic, strong)UITextField *companyTel;//公司邮箱
@property(nonatomic, strong)UITextField *companyAddress;//公司邮箱
@property(nonatomic, strong)UITextField *mainProject;//公司主营
@property(nonatomic, strong)UITextField *demandInstructions;//需求说明
@property(nonatomic, strong)UITextField *identityText;//身份
@property(nonatomic, strong)NSString *identityId;

@property(nonatomic, strong)NSArray *industriesArray;

@property(nonatomic, strong)ZWAuthenticationModel *model;

@property(nonatomic, strong)NSArray *dataArray;//数据
@property(nonatomic, strong)NSDictionary *parameter;//需要传到下一个页面的参数

@property(nonatomic, strong)UIButton *areaBtn;

@property(nonatomic, strong)NSString *areaName;

@property(nonatomic, strong)ZWCPCitiesModel *countriesModel;//记录选择的国家模型
@property(nonatomic, strong)ZWCPCitiesModel *provincesModel;//记录选择的省份模型
@property(nonatomic, strong)ZWCPCitiesModel *citiesModel;//记录选择的城市模型


@property(nonatomic, strong)UILabel *noticeLabel;

@end

@implementation ZWEditCompanyInfoVC


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[YNavigationBar sharedInstance]createNavigationBarWithStatusBarStyle:UIStatusBarStyleLightContent withType:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNavigationBar];
    if (self.merchantStatus == 3) {
        [self createRequest];
    }
    [self createNotice];
}
- (void)createNotice {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshCityStateItem:) name:@"refreshCityStateItem" object:nil];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refreshCityStateItem" object:nil];
}
- (void)refreshCityStateItem:(NSNotification *)notice {
    NSArray *selectArray = notice.object;
    NSString *str = @"";
    
    for (int i = 0 ; i<selectArray.count ; i++) {
        ZWCPCitiesModel *model = selectArray[i];
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@  ",model.value]];
        if ([model.value isEqualToString:@"中国"]) {
            if (i == 0) {
                self.countriesModel = model;
            }else if (i== 1) {
                self.provincesModel = model;
            }else {
                self.citiesModel = model;
            }
        }else {
            if (i == 0) {
                self.countriesModel = model;
            }else {
                self.citiesModel = model;
            }
        }
    }
    
    NSLog(@"我的国家身份和城市 = %@",str);
    self.areaName = str;
    if (selectArray.count != 0) {
        CGFloat countriesWidth = [[ZWToolActon shareAction]adaptiveTextWidth:self.areaName labelFont:normalFont];
        self.areaBtn.frame = CGRectMake(CGRectGetMinX(self.noticeLabel.frame), CGRectGetMaxY(self.noticeLabel.frame), countriesWidth, 0.12*kScreenWidth);
        [self.areaBtn setTitle:self.areaName forState:UIControlStateNormal];
    }
}

- (void)createRequest {
    
    ZWEditorAuthenticationInfoRequest *request = [[ZWEditorAuthenticationInfoRequest alloc]init];
    __weak typeof (self) weakSelf = self;
    [request getRequestCompleted:^(YHBaseRespense *respense) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (respense.isFinished) {
            NSLog(@"%@",respense.data);
            [strongSelf.imageBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,respense.data[@"coverFile"]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"ren_bianji_icon_chuan"]];
            strongSelf.companyName.text = respense.data[@"name"];
            strongSelf.companyEmail.text = respense.data[@"email"];
            strongSelf.companyUrl.text = respense.data[@"website"];
            strongSelf.companyTel.text = respense.data[@"telephone"];
            strongSelf.companyAddress.text = respense.data[@"address"];
            strongSelf.mainProject.text = respense.data[@"product"];
            strongSelf.demandInstructions.text = respense.data[@"requirement"];
            
            NSNumber *identityId = respense.data[@"identityId"];
            if ([identityId isEqualToNumber:@2]) {
                strongSelf.identityText.text = @"展商";
                strongSelf.identityId = @"2";
            }else if ([identityId isEqualToNumber:@3]) {
                strongSelf.identityText.text = @"展会服务商";
                strongSelf.identityId = @"3";
            }else if ([identityId isEqualToNumber:@4]) {
                strongSelf.identityText.text = @"设计公司";
                strongSelf.identityId = @"4";
            }else {
                
            }
            
            NSArray *myData = respense.data[@"industryVoList"];
            NSMutableArray *myArray = [NSMutableArray array];
            for (NSDictionary *myDic in myData) {
                ZWChosenIndustriesModel *model = [[ZWChosenIndustriesModel alloc]init];
                model.industries2Id = myDic[@"secondIndustryId"];
                model.industries2Name = myDic[@"secondIndustryName"];
                model.industries3Id = myDic[@"thirdIndustryId"];
                model.industries3Name = myDic[@"thirdIndustryName"];
                [myArray addObject:model];
            }
            
            strongSelf.industriesArray = myArray;
    
            strongSelf.parameter = @{@"profile":respense.data[@"profile"],
                                     @"profileList":respense.data[@"profileList"],
                                     @"licenseFile":respense.data[@"licenseFile"],
                                     @"authenticationId":respense.data[@"authenticationId"],
                                     @"coverFile":respense.data[@"coverFile"]};
        }
    }];
    
}


- (void)createNavigationBar {
    UIBarButtonItem *leftOne = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack:)];
    leftOne.tintColor = [UIColor whiteColor];
    UIBarButtonItem *leftTwo = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ren_bianji_icon_topshang"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack:)];
    leftTwo.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItems = @[leftOne,leftTwo];
    
    [[YNavigationBar sharedInstance]createRightBarWithTitle:@"下一步" barItem:self.navigationItem target:self action:@selector(rightItemClcik:)];
}
- (void)goBack:(UINavigationItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightItemClcik:(UIBarButtonItem *)item {
    if (!self.imageBtn.imageView.image) {
        [self showOneAlertWithTitle:@"请上传公司Logo"];
        return;
    }
    if ([self.companyName.text isEqualToString:@""]) {
        [self showOneAlertWithTitle:@"公司名称不能为空"];
        return;
    }
//    if ([self.companyEmail.text isEqualToString:@""]) {
//        [self showOneAlertWithTitle:@"公司邮箱不能为空"];
//        return;
//    }
//    if ([self.companyUrl.text isEqualToString:@""]) {
//        [self showOneAlertWithTitle:@"公司网址不能为空"];
//        return;
//    }
    if ([self.companyTel.text isEqualToString:@""]) {
        [self showOneAlertWithTitle:@"公司电话不能为空"];
        return;
    }
    if ([self.companyAddress.text isEqualToString:@""]) {
        [self showOneAlertWithTitle:@"公司地址不能为空"];
        return;
    }
    if ([self.mainProject.text isEqualToString:@""]) {
        [self showOneAlertWithTitle:@"主营项目不能为空"];
        return;
    }
    if ([self.demandInstructions.text isEqualToString:@""]) {
        [self showOneAlertWithTitle:@"需求说明不能为空"];
        return;
    }
    if ([self.identityText.text isEqualToString:@""]) {
        [self showOneAlertWithTitle:@"请点击选择身份"];
        return;
    }
    if ([self.identityText.text isEqualToString:@"展商"]) {
        [self takeListOfIndustries];
    }else {
        ZWEditCompanyIntroductionVC *introductionVC = [[ZWEditCompanyIntroductionVC alloc]init];
        introductionVC.title = @"公司简介上传";
        introductionVC.model = [self takeModel];
        introductionVC.model.industryIdList = @[];
        introductionVC.coverImage = self.imageBtn.imageView.image;
        introductionVC.merchantStatus = self.merchantStatus;
        if (self.merchantStatus == 3) {
            introductionVC.parameter = self.parameter;
        }
        [self.navigationController pushViewController:introductionVC animated:YES];
    }
}

- (void)takeListOfIndustries {
    
    __weak typeof(self) weakSelf = self;
    [[ZWDataAction sharedAction]getReqeustWithURL:zwIndustriesList parametes:@{} successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (zw_issuccess) {

            ZWSelectIndustriesVC *industriesVC = [[ZWSelectIndustriesVC alloc]init];
            industriesVC.myIndustries = data[@"data"];
            industriesVC.title = @"选择您所涉及的行业";
            industriesVC.model = [strongSelf takeModel];
            industriesVC.coverImage = strongSelf.imageBtn.imageView.image;
            industriesVC.merchantStatus = strongSelf.merchantStatus;
            industriesVC.industriesArr = strongSelf.industriesArray;
            industriesVC.type = 1;
            if (strongSelf.merchantStatus == 3) {
                industriesVC.parameter = strongSelf.parameter;
            }
            [strongSelf.navigationController pushViewController:industriesVC animated:YES];
            
        }
    } failureBlock:^(NSError * _Nonnull error) {

    } showInView:self.view];

}

- (ZWAuthenticationModel *)takeModel {
    ZWAuthenticationModel * model = [[ZWAuthenticationModel alloc]init];
    model.identityId = self.identityId;
    model.name = self.companyName.text;
    model.email = self.companyEmail.text;
    model.website = self.companyUrl.text;
    model.telephone = self.companyTel.text;
    model.address = self.companyAddress.text;
    model.product = self.mainProject.text;
    model.requirement = self.demandInstructions.text;
    model.profile = @"";
    model.profileFiles = @[];
    model.licenseFile = @"";
    model.country = self.countriesModel.value;
    if (self.provincesModel) {
        model.province = self.provincesModel.value;
    }else {
        model.province = @"";
    }
    if (self.citiesModel) {
        model.city = self.citiesModel.value;
    }else {
        model.city = @"";
    }
    return model;
}


- (void)createUI {
    
    self.myScrollView = [[TPKeyboardAvoidingScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight)];
    [self.view addSubview:self.myScrollView];
    
    self.areaName = @"请点击选择区域";
    
    self.view.backgroundColor = [UIColor whiteColor];

    self.imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.imageBtn.frame = CGRectMake(0.08*kScreenWidth, 10, 0.2*kScreenWidth, 0.2*kScreenWidth);
    [self.imageBtn setBackgroundImage:[UIImage imageNamed:@"ren_bianji_icon_chuan"] forState:UIControlStateNormal];
    self.imageBtn.adjustsImageWhenHighlighted = NO;
    [self.imageBtn addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.myScrollView addSubview:self.imageBtn];

    self.noticeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.imageBtn.frame), CGRectGetMaxY(self.imageBtn.frame), 0.84*kScreenWidth, 30)];
    self.noticeLabel.text = @"注：此处为企业LOGO图片上传";
    self.noticeLabel.font = smallFont;
    self.noticeLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    [self.myScrollView addSubview:self.noticeLabel];
    
    
    CGFloat countriesWidth = [[ZWToolActon shareAction]adaptiveTextWidth:self.areaName labelFont:normalFont];
    self.areaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.areaBtn.frame = CGRectMake(CGRectGetMinX(self.noticeLabel.frame), CGRectGetMaxY(self.noticeLabel.frame), countriesWidth, 0.12*kScreenWidth);
    [self.areaBtn setTitle:self.areaName forState:UIControlStateNormal];
    [self.areaBtn setTitleColor:skinColor forState:UIControlStateNormal];
    self.areaBtn.titleLabel.font = normalFont;
    [self.areaBtn addTarget:self action:@selector(countriesBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.myScrollView addSubview:self.areaBtn];
        
    //公司名称
    UIView *lineOne = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.noticeLabel.frame), CGRectGetMaxY(self.areaBtn.frame), CGRectGetWidth(self.noticeLabel.frame), 1)];
    lineOne.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1.0];
    [self.myScrollView addSubview:lineOne];

    UILabel *titleOne = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0.2*kScreenWidth, 0.12*kScreenWidth)];
    titleOne.text = @"公司名称：";
    titleOne.font = normalFont;
    titleOne.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];

    self.companyName = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMinX(lineOne.frame), CGRectGetMaxY(lineOne.frame), CGRectGetWidth(lineOne.frame), 0.12*kScreenWidth)];
    self.companyName.leftView = titleOne;
    self.companyName.leftViewMode = UITextFieldViewModeAlways;
    self.companyName.placeholder = @"请输入公司名称";
    self.companyName.font = normalFont;
    [self.myScrollView addSubview:self.companyName];

    //公司邮箱
    UIView *lineTwo = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.companyName.frame), CGRectGetMaxY(self.companyName.frame), CGRectGetWidth(self.companyName.frame), 1)];
    lineTwo.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1.0];
    [self.myScrollView addSubview:lineTwo];

    UILabel *titleTwo = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0.2*kScreenWidth, 0.12*kScreenWidth)];
    titleTwo.text = @"公司邮箱：";
    titleTwo.font = normalFont;
    titleTwo.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];

    self.companyEmail = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMinX(lineTwo.frame), CGRectGetMaxY(lineTwo.frame), CGRectGetWidth(lineTwo.frame), 0.12*kScreenWidth)];
    self.companyEmail.leftView = titleTwo;
    self.companyEmail.leftViewMode = UITextFieldViewModeAlways;
    self.companyEmail.placeholder = @"请输入公司邮箱";
    self.companyEmail.font = normalFont;
    [self.myScrollView addSubview:self.companyEmail];

    //公司网址
    UIView *lineThree = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.companyEmail.frame), CGRectGetMaxY(self.companyEmail.frame), CGRectGetWidth(self.companyEmail.frame), 1)];
    lineThree.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1.0];
    [self.myScrollView addSubview:lineThree];

    UILabel *titleThree = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0.2*kScreenWidth, 0.12*kScreenWidth)];
    titleThree.text = @"公司网址：";
    titleThree.font = normalFont;
    titleThree.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];

    self.companyUrl = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMinX(lineThree.frame), CGRectGetMaxY(lineThree.frame), CGRectGetWidth(lineThree.frame), 0.12*kScreenWidth)];
    self.companyUrl.leftView = titleThree;
    self.companyUrl.leftViewMode = UITextFieldViewModeAlways;
    self.companyUrl.placeholder = @"请输入公司网址";
    self.companyUrl.font = normalFont;
    [self.myScrollView addSubview:self.companyUrl];

    //公司电话
    UIView *lineFour = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.companyUrl.frame), CGRectGetMaxY(self.companyUrl.frame), CGRectGetWidth(self.companyUrl.frame), 1)];
    lineFour.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1.0];
    [self.myScrollView addSubview:lineFour];

    UILabel *titleFour = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0.2*kScreenWidth, 0.12*kScreenWidth)];
    titleFour.text = @"公司电话：";
    titleFour.font = normalFont;
    titleFour.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];

    self.companyTel = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMinX(lineFour.frame), CGRectGetMaxY(lineFour.frame), CGRectGetWidth(lineFour.frame), 0.12*kScreenWidth)];
    self.companyTel.leftView = titleFour;
    self.companyTel.leftViewMode = UITextFieldViewModeAlways;
    self.companyTel.placeholder = @"请输入公司电话";
    self.companyTel.font = normalFont;
    [self.myScrollView addSubview:self.companyTel];

    //公司地址
    UIView *lineFive = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.companyTel.frame), CGRectGetMaxY(self.companyTel.frame), CGRectGetWidth(self.companyTel.frame), 1)];
    lineFive.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1.0];
    [self.myScrollView addSubview:lineFive];

    UILabel *titleFive = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0.2*kScreenWidth, 0.12*kScreenWidth)];
    titleFive.text = @"公司地址：";
    titleFive.font = normalFont;
    titleFive.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];

    self.companyAddress = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMinX(lineFive.frame), CGRectGetMaxY(lineFive.frame), CGRectGetWidth(lineFive.frame), 0.12*kScreenWidth)];
    self.companyAddress.leftView = titleFive;
    self.companyAddress.leftViewMode = UITextFieldViewModeAlways;
    self.companyAddress.placeholder = @"请输入公司地址";
    self.companyAddress.font = normalFont;
    [self.myScrollView addSubview:self.companyAddress];

    //主营项目
    UIView *lineSix = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.companyAddress.frame), CGRectGetMaxY(self.companyAddress.frame), CGRectGetWidth(self.companyAddress.frame), 1)];
    lineSix.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1.0];
    [self.myScrollView addSubview:lineSix];

    UILabel *titleSix = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0.2*kScreenWidth, 0.12*kScreenWidth)];
    titleSix.text = @"主营项目：";
    titleSix.font = normalFont;
    titleSix.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];

    self.mainProject = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMinX(lineSix.frame), CGRectGetMaxY(lineSix.frame), CGRectGetWidth(lineSix.frame), 0.12*kScreenWidth)];
    self.mainProject.leftView = titleSix;
    self.mainProject.leftViewMode = UITextFieldViewModeAlways;
    self.mainProject.placeholder = @"请输入公司主营项目";
    self.mainProject.font = normalFont;
    [self.myScrollView addSubview:self.mainProject];

    //需求说明
    UIView *lineSeven = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.mainProject.frame), CGRectGetMaxY(self.mainProject.frame), CGRectGetWidth(self.mainProject.frame), 1)];
    lineSeven.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1.0];
    [self.myScrollView addSubview:lineSeven];

    UILabel *titleSeven = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0.2*kScreenWidth, 0.12*kScreenWidth)];
    titleSeven.text = @"需求说明：";
    titleSeven.font = normalFont;
    titleSeven.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];

    self.demandInstructions = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMinX(lineSeven.frame), CGRectGetMaxY(lineSeven.frame), CGRectGetWidth(lineSeven.frame), 0.12*kScreenWidth)];
    self.demandInstructions.leftView = titleSeven;
    self.demandInstructions.leftViewMode = UITextFieldViewModeAlways;
    self.demandInstructions.placeholder = @"请输入公司需求说明";
    self.demandInstructions.font = normalFont;
    [self.myScrollView addSubview:self.demandInstructions];
    
    //选择身份
    UIView *lineEight = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.demandInstructions.frame), CGRectGetMaxY(self.demandInstructions.frame), CGRectGetWidth(self.demandInstructions.frame), 1)];
    lineEight.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1.0];
    [self.myScrollView addSubview:lineEight];
    
    UILabel *titleEight= [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0.2*kScreenWidth, 0.12*kScreenWidth)];
    titleEight.text = @"选择身份：";
    titleEight.font = normalFont;
    titleEight.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    
    self.identityText = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMinX(lineEight.frame), CGRectGetMaxY(lineEight.frame), CGRectGetWidth(lineEight.frame), CGRectGetHeight(self.demandInstructions.frame))];
    self.identityText.leftView = titleEight;
    self.identityText.leftViewMode = UITextFieldViewModeAlways;
    self.identityText.font = normalFont;
    self.identityText.placeholder = @"点击选择身份";
    self.identityText.enabled = NO;
    self.identityText.textColor = skinColor;
    [self.myScrollView addSubview:self.identityText];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(CGRectGetMinX(lineEight.frame), CGRectGetMaxY(lineEight.frame), CGRectGetWidth(lineEight.frame), CGRectGetHeight(self.demandInstructions.frame));
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.myScrollView addSubview:btn];
    
}

- (void)btnClick:(UIButton *)btn {
    NSLog(@"能点吗");
    [[ZWDataAction sharedAction]getReqeustWithURL:zwIdentitiesList parametes:@{} successBlock:^(NSDictionary * _Nonnull data) {
        if (zw_issuccess) {
            NSArray *array = data[@"data"];
            NSMutableArray *myArray = [NSMutableArray array];
            for (NSDictionary *myDic in array) {
                ZWIdentityModel *model = [ZWIdentityModel parseJSON:myDic];
                [myArray addObject:model];
            }
            NSMutableArray *indArray = [NSMutableArray array];
            for (ZWIdentityModel *model in myArray) {
                NSString *indStr = model.name;
                [indArray addObject:indStr];
            }
            [indArray removeObjectAtIndex:0];
            IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"请选择展台属性" delegate:self];
            [picker setActionSheetPickerStyle:IQActionSheetPickerStyleTextPicker];
            [picker setTitlesForComponents:@[indArray]];
            [picker show];
        }else {
            [self showOneAlertWithTitle:@"获取身份失败，请稍后再试"];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    } showInView:self.view];
}

- (void)actionSheetPickerView:(nonnull IQActionSheetPickerView *)pickerView didSelectTitlesAtIndexes:(nonnull NSArray<NSNumber*>*)indexes {
    NSLog(@"----%@",indexes[0]);
    int a = [indexes[0] intValue];
    if (a == 0) {
        self.identityText.text = @"展商";
        self.identityId = @"2";
    }else if (a == 1) {
        self.identityText.text = @"展会服务商";
        self.identityId = @"3";
    }else {
        self.identityText.text = @"设计公司";
        self.identityId = @"4";
    }
}


- (void)createImagePicker {
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.allowsEditing = YES;
}

- (void)imageBtnClick:(UIButton *)btn {
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
    //判断是否可以打开照相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        //摄像头
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:_imagePickerController animated:YES completion:nil];
    }
    else{
        NSLog(@"没有摄像头");
    }
}
#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info {
    
    UIImage *ima = info[UIImagePickerControllerEditedImage];
    
    [self.imageBtn setImage:ima forState:UIControlStateNormal];

    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
//进入拍摄页面点击取消按钮
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)countriesBtnClick:(UIButton *)btn {
    [self takeSelectData:@{@"areaId":@"",@"level":@"0"} withType:0];
}

- (void)takeSelectData:(NSDictionary *)parametes withType:(NSInteger)type {
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]postReqeustWithURL:zwSelectCPC parametes:parametes successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (zw_issuccess) {
            NSArray *myData = data[@"data"];
            NSMutableArray *myArray = [NSMutableArray array];
            for (NSDictionary *myDic in myData) {
                ZWCPCitiesModel *model = [ZWCPCitiesModel parseJSON:myDic];
                [myArray addObject:model];
            }
            ZWAgentCountriesVC *VC = [[ZWAgentCountriesVC alloc]init];
            VC.dataArray = myArray;
            VC.title = @"选择国家";
            VC.status = self.status;
            [strongSelf.navigationController pushViewController:VC animated:YES];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    } showInView:self.view];
}

-(void)showOneAlertWithTitle:(NSString *)title {
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:title confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        
    } showInView:self];
}

@end
