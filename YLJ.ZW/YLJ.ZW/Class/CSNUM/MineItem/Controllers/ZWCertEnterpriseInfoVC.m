//
//  ZWCertEnterpriseInfoVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/3/31.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWCertEnterpriseInfoVC.h"
#import <TPKeyboardAvoidingTableView.h>
#import <YYTextView.h>
#import "ZWCollectionViewCell.h"
#import "ZWCollectionViewAddCell.h"
#import <TZImagePickerController.h>

#import "ZWExhibitionServerSelectIndustriesVC.h"
#import "ZWSelectIndustriesVC.h"
#import "ZWSelectIndustriesVC_v2.h"

#import "ZWLabelView.h"

#import "ZWAgentCountriesVC.h"
#import "ZWCPCitiesModel.h"

#import "ZWCPCitiesModel.h"

#import "ZWChosenIndustriesModel.h"

#import <MBProgressHUD.h>

#import "ZWExbihitorsIndustriesModel.h"

#import "ZWIndustriesItemView.h"

#import "ZWAreaManager.h"


#define magin 0.05*kScreenWidth

@interface ZWCertEnterpriseInfoVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,YYTextViewDelegate,UITextFieldDelegate,ZWAreaManagerDelegate>{
    UIImagePickerController *_imagePickerController;
}
@property(nonatomic, strong)TPKeyboardAvoidingTableView *tableView;

@property(nonatomic, strong)UICollectionView *collectView;
@property(nonatomic, strong)UICollectionViewFlowLayout *layout;

@property(nonatomic, strong)UIButton *imageBtn;

@property(nonatomic, strong)UIImage *logoImage;//logo图片
@property(nonatomic, strong)UIImage *licenseImage;//执照
@property(nonatomic, assign)NSInteger tapType;//1.为logo调用相册相机，2.为图片信息调用相册相机，3.为营业执照调用相册相机
@property(nonatomic, strong)NSMutableArray *imageInfoArray;//图片信息数组
@property(nonatomic, strong)NSMutableArray *httpImages;//网络图片

@property(nonatomic, strong)NSArray *certIndustries;

@property(nonatomic, strong)ZWLabelView *labelView;

@property(nonatomic, strong)ZWCPCitiesModel *countriesModel;//记录选择的国家模型
@property(nonatomic, strong)ZWCPCitiesModel *provincesModel;//记录选择的省份模型
@property(nonatomic, strong)ZWCPCitiesModel *citiesModel;//记录选择的城市模型

@property(nonatomic, strong)NSString *areaName;

@property(nonatomic, strong)NSMutableArray *serverLabels;//服务商标签

@property(nonatomic, strong)NSString *oldLogo;//记录老logo
@property(nonatomic, strong)NSString *oldLicense;//记录老执照

@end

@implementation ZWCertEnterpriseInfoVC

-(TPKeyboardAvoidingTableView *)tableView {
    if (!_tableView) {
        _tableView = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) style:UITableViewStyleGrouped];
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    _tableView.separatorInset = UIEdgeInsetsMake(0, magin, 0, 0);
    _tableView.showsVerticalScrollIndicator = NO;
    return _tableView;
}

-(UICollectionView *)collectView
{
    if (!_collectView) {
        _collectView=[[UICollectionView alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 0.05*kScreenWidth, 0.9*kScreenWidth, 0.5*kScreenWidth) collectionViewLayout:_layout];
    }
    _collectView.delegate=self;
    _collectView.dataSource=self;
    _collectView.backgroundColor = [UIColor whiteColor];
    [_collectView registerClass:[ZWCollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
    [_collectView registerClass:[ZWCollectionViewAddCell class] forCellWithReuseIdentifier:@"addCell"];
    _collectView.showsVerticalScrollIndicator=YES;
    _collectView.showsHorizontalScrollIndicator=YES;
    _collectView.bounces = NO;
    return _collectView;
}

-(NSMutableArray *)imageInfoArray {
    if (!_imageInfoArray) {
        _imageInfoArray = [NSMutableArray array];
    }
    return _imageInfoArray;
}

-(NSMutableArray *)httpImages {
    if (!_httpImages) {
        _httpImages = [NSMutableArray array];
    }
    return _httpImages;
}
-(ZWAuthenticationModel *)model {
    if (!_model) {
        _model = [[ZWAuthenticationModel alloc]init];
    }
    return _model;
}

-(NSMutableArray *)serverLabels {
    if (!_serverLabels) {
        _serverLabels = [NSMutableArray array];
    }
    return _serverLabels;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBar];
    [self createUI];
    [self createNotice];
}
-(void)textViewDidChangeNotification:(NSNotification *)obj{
    YYTextView *textView = (YYTextView *)obj.object;
    NSString *string = textView.text;
    NSLog(@"%ld",(long)textView.tag);
    
    NSInteger maxLength;
    if (textView.tag == 2) {
        maxLength = 500;
    }else {
        maxLength = 30;
    }
    //获取高亮部分
    YYTextRange *selectedRange = [textView valueForKey:@"_markedTextRange"];
    NSRange range = [selectedRange asRange];
    NSString *realString = [string substringWithRange:NSMakeRange(0, string.length - range.length)];
    if (realString.length >= maxLength){
        textView.text = [realString substringWithRange:NSMakeRange(0, maxLength)];
    }
}


- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
    [[YNavigationBar sharedInstance]createRightBarWithTitle:@"提交" barItem:self.navigationItem target:self action:@selector(rightItemClick:)];
}

- (void)createNotice {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChangeNotification:) name:YYTextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(certTakeIndustryList:) name:@"certTakeIndustryList" object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:YYTextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"certTakeIndustryList" object:nil];
}

- (void)certTakeIndustryList:(NSNotification *)notice {
    self.certIndustries = notice.object;
    NSMutableArray *myArray = [NSMutableArray array];
    for (ZWChosenIndustriesModel *model in self.certIndustries) {
        [myArray addObject:model.industries3Id];
    }
    self.model.industryIdList = myArray;
    [self.tableView reloadData];
}

- (void)goBack:(UINavigationItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightItemClick:(UINavigationItem *)item {
    if (!self.logoImage) {
        [self showOneAlertWithTitle:@"企业logo不能为空"];
        return;
    }
    if (self.model.name.length == 0) {
        [self showOneAlertWithTitle:@"公司名称不能为空"];
        return;
    }
    if (self.model.telephone.length == 0) {
        [self showOneAlertWithTitle:@"公司电话不能为空"];
        return;
    }
    if (self.areaName.length == 0) {
        [self showOneAlertWithTitle:@"请选择所属区域"];
        return;
    }
    if (self.model.address.length == 0) {
        [self showOneAlertWithTitle:@"公司地址不能为空"];
        return;
    }
    if (self.model.profile.length == 0) {
        [self showOneAlertWithTitle:@"公司简介不能为空"];
        return;
    }
    if (self.model.industryIdList.count == 0) {
        [self showOneAlertWithTitle:@"请选择所属行业"];
        return;
    }
    
    if (![self.identityId isEqualToString:@"2"]) {
        if (self.model.product.length == 0) {
            [self showOneAlertWithTitle:@"至少设置一个服务标签"];
            return;
        }
        if (self.model.speciality.length == 0) {
            [self showOneAlertWithTitle:@"请输入服务类型"];
            return;
        }
    }
    if (self.model.product.length == 0) {
        [self showOneAlertWithTitle:@"主营项目不能为空"];
        return;
    }
    if ([self.identityId isEqualToString:@"2"]) {
        if (self.model.requirement.length == 0) {
            [self showOneAlertWithTitle:@"需求说明不能为空"];
            return;
        }
    }
    if (self.httpImages.count + self.imageInfoArray.count<1) {
        [self showOneAlertWithTitle:@"图片信息不能少于一张"];
        return;
    }
    if (!self.licenseImage) {
        [self showOneAlertWithTitle:@"请上传营业执照"];
        return;
    }
    __weak typeof (self) weakSelf = self;
    [[ZWAlertAction sharedAction]showTwoAlertTitle:@"温馨提示" message:@"是否确认提交" cancelTitle:@"否" confirmTitle:@"是" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf uploadLogo];
    } actionCancel:^(UIAlertAction * _Nonnull actionCancel) {
        
    } showInView:self];
}


- (id)arrayOrDicWithObject:(id)origin {
   if ([origin isKindOfClass:[NSArray class]]) {
       //数组
       NSMutableArray *array = [NSMutableArray array];
       for (NSObject *object in origin) {
           if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]]) {
               //string , bool, int ,NSinteger
               [array addObject:object];

           } else if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]]) {
               //数组或字典
               [array addObject:[self arrayOrDicWithObject:(NSArray *)object]];

           } else {
               //model
               [array addObject:[self dicFromObject:object]];
           }
       }

       return [array copy];

   } else if ([origin isKindOfClass:[NSDictionary class]]) {
       //字典
       NSDictionary *originDic = (NSDictionary *)origin;
       NSMutableDictionary *dic = [NSMutableDictionary dictionary];
       for (NSString *key in originDic.allKeys) {
           id object = [originDic objectForKey:key];

           if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]]) {
               //string , bool, int ,NSinteger
               [dic setObject:object forKey:key];

           } else if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]]) {
               //数组或字典
               [dic setObject:[self arrayOrDicWithObject:object] forKey:key];

           } else {
               //model
               [dic setObject:[self dicFromObject:object] forKey:key];
           }
       }

       return [dic copy];
   }

   return [NSNull null];
}


//model转化为字典
- (NSDictionary *)dicFromObject:(NSObject *)object {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([object class], &count);
 
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertyList[i];
        const char *cName = property_getName(property);
        NSString *name = [NSString stringWithUTF8String:cName];
        NSObject *value = [object valueForKey:name];//valueForKey返回的数字和字符串都是对象
 
        if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
            //string , bool, int ,NSinteger
            [dic setObject:value forKey:name];
 
        } else if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
            //字典或字典
            [dic setObject:[self arrayOrDicWithObject:(NSArray*)value] forKey:name];
 
        } else if (value == nil) {
            //null
            //[dic setObject:[NSNull null] forKey:name];//这行可以注释掉?????
 
        } else {
            //model
            [dic setObject:[self dicFromObject:value] forKey:name];
        }
        
    }
    return [dic copy];
}


- (void)createUI {
    NSLog(@"-----%@",self.identityId);
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self createLayout];
    [self processTheData];
    [self.view addSubview:self.tableView];
}

- (void)processTheData {
    
    //将行业信息衔接上
    if (self.merchantStatus == 3) {
        NSMutableArray *industryIds = [NSMutableArray array];
        NSMutableArray *industries = [NSMutableArray array];
        for (NSDictionary *myDic in self.model.industryIdList) {
            NSString *industryId = myDic[@"thirdIndustryId"];
            ZWChosenIndustriesModel *model = [ZWChosenIndustriesModel parseJSON:myDic];
            [industryIds addObject:industryId];
            [industries addObject:model];
        }
        self.model.industryIdList = industryIds;
        self.certIndustries = industries;
    }
    //将公司logo衔接上
    if (self.model.coverFile) {
        self.oldLogo = self.model.coverFile;
        UIImage *logImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,self.model.coverFile]]]];
        self.logoImage = logImage;
        
    }
    //将认证信息衔接上
    if (self.model.licenseFile) {
        self.oldLicense = self.model.licenseFile;
        UIImage *licImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,self.model.licenseFile]]]];
        self.licenseImage = licImage;
        NSLog(@"-----我的logo图片 = %@%@",httpImageUrl,self.model.licenseFile);
    }
    //将图片信息衔接上
    [self.httpImages addObjectsFromArray:self.model.profileFiles];
    
}


- (void)createLayout {
    _layout=[[UICollectionViewFlowLayout alloc]init];
    [_layout prepareLayout];
    _layout.minimumInteritemSpacing = 1;
    _layout.minimumLineSpacing=4;
}

#pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.identityId isEqualToString:@"2"]) {
        return 8;
    }else {
        return 7;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return 6;
    }else {
        return 1;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *myCell = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myCell];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:myCell];
    }else {
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([self.identityId isEqualToString:@"2"]) {
        [self createTableViewCell:cell cellForRowAtIndexPath:indexPath];
    }else {
        [self createServiceTableViewCell:cell cellForRowAtIndexPath:indexPath];
    }
    
    return cell;
}

- (void)createTableViewCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        UIImageView *logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 0.05*kScreenWidth, 0.25*kScreenWidth, 0.25*kScreenWidth)];
        if (self.logoImage) {
            logoImageView.image = self.logoImage;
        }else {
            logoImageView.image = [UIImage imageNamed:@"add_placeholder_image"];
        }
        logoImageView.userInteractionEnabled = YES;
        logoImageView.layer.cornerRadius = 2;
        logoImageView.layer.masksToBounds = YES;
        [cell.contentView addSubview:logoImageView];
        
        UITapGestureRecognizer *tapLogo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLogoClick:)];
        [logoImageView addGestureRecognizer:tapLogo];
        
        UILabel *noticeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(logoImageView.frame), CGRectGetMaxY(logoImageView.frame), 0.84*kScreenWidth, 30)];
        noticeLabel.text = @"注：此处为企业LOGO图片上传";
        noticeLabel.font = smallFont;
        noticeLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        [cell.contentView addSubview:noticeLabel];
        
    }else if (indexPath.section == 1) {
        
        NSArray *titles = @[@"公司名称：",@"公司电话：",@"公司邮箱：",@"公司网址：",@"所属区域：",@"详细地址："];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(magin, 0, 0.2*kScreenWidth, 0.1*kScreenWidth)];
        titleLabel.text = titles[indexPath.row];
        titleLabel.font = normalFont;
        [cell.contentView addSubview:titleLabel];
        
        NSArray *values = @[@"请输入公司名称",@"请输入公司电话",@"请输入公司邮箱",@"请输入公司网址",@"",@"请输入详细地址"];
        UITextField *valueText = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), 0, kScreenWidth-CGRectGetMaxX(titleLabel.frame)-magin-0.05*kScreenWidth, 0.1*kScreenWidth)];
        valueText.placeholder = values[indexPath.row];
        valueText.tag = indexPath.row;
        if (indexPath.row == 0) {
            valueText.text = self.model.name;
        }else if (indexPath.row == 1) {
            valueText.text = self.model.telephone;
        }else if (indexPath.row == 2) {
            valueText.text = self.model.email;
        }else if (indexPath.row == 3) {
            valueText.text = self.model.website;
        }else if (indexPath.row == 4) {
//            self.areaName =
            if (self.areaName) {
                valueText.text = self.areaName;
            }else {
                valueText.text = @"请选择所属区域";
            }
            valueText.enabled = NO;
            valueText.textColor = skinColor;
        }else {
            valueText.text = self.model.address;
        }
        valueText.font = normalFont;
        [valueText addTarget:self action:@selector(takeTextValue:) forControlEvents:UIControlEventAllEditingEvents];
        [cell.contentView addSubview:valueText];
        UIImageView *accImage = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(valueText.frame)+magin/2, 0.025*kScreenWidth, 0.05*kScreenWidth, 0.05*kScreenWidth)];
        accImage.image = [UIImage imageNamed:@"certification_edit_icon"];
        if (indexPath.row == 4) {
            accImage.image = [UIImage imageNamed:@"certification_right_arrow"];
        }
        [cell.contentView addSubview:accImage];
        
    }else if (indexPath.section == 2) {
        YYTextView *textView = [[YYTextView alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 0.05*kScreenWidth, 0.9*kScreenWidth, 0.3*kScreenWidth)];
        textView.placeholderText = @"请输入公司简介";
        textView.text = self.model.profile;
        textView.tag = indexPath.section;
        textView.font = normalFont;
        textView.placeholderFont = normalFont;
        textView.tag = indexPath.section;
        textView.delegate = self;
        [cell.contentView addSubview:textView];
    }else if (indexPath.section == 3) {
        
        
        UIButton *addIndustry = [UIButton buttonWithType:UIButtonTypeCustom];
        addIndustry.frame = CGRectMake(0.85*kScreenWidth, 0, 0.15*kScreenWidth, 0.065*kScreenWidth);
        [addIndustry setTitle:@"添加" forState:UIControlStateNormal];
        addIndustry.backgroundColor = skinColor;
        addIndustry.titleLabel.font = smallMediumFont;
        [addIndustry addTarget:self action:@selector(addIndustryClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:addIndustry];
        [self setTheRoundedCorners:addIndustry];
        
        UIView *toolView = [[UIView alloc]initWithFrame:CGRectMake(0, 0.075*kScreenWidth, kScreenWidth, 0.275*kScreenWidth)];
        [cell.contentView addSubview:toolView];
        
        
        CGFloat itemWidth = 0.82*kScreenWidth/5;
        CGFloat itemMargin = 0.03*kScreenWidth;
        NSMutableArray *myArray = [NSMutableArray array];
        for (ZWChosenIndustriesModel *model in self.certIndustries) {
            ZWExbihitorsIndustriesModel *modelO = [[ZWExbihitorsIndustriesModel alloc]init];
            modelO.secondIndustryId = [NSString stringWithFormat:@"%@",model.industries2Id];
            modelO.secondIndustryName = [NSString stringWithFormat:@"%@",model.industries2Name];
            modelO.thirdIndustryId = [NSString stringWithFormat:@"%@",model.industries3Id];
            modelO.thirdIndustryName = [NSString stringWithFormat:@"%@",model.industries3Name];
            [myArray addObject:modelO];
            
        }
        
        
        for (int i = 0; i<myArray.count; i++) {
            
            ZWExbihitorsIndustriesModel *model = myArray[i];
            ZWIndustriesItemView *industriesItemView = [[ZWIndustriesItemView alloc]initWithFrame:CGRectMake(itemMargin+(itemMargin+itemWidth)*i, 0.05*kScreenWidth, itemWidth, itemWidth)];
            industriesItemView.backgroundColor = zwGrayColor;
            industriesItemView.layer.cornerRadius = 3;
            industriesItemView.layer.masksToBounds = YES;
            industriesItemView.model = model;
            [toolView addSubview:industriesItemView];

        }

    }else if (indexPath.section == 4) {
        
        if ([self.identityId isEqualToString:@"2"]) {
            YYTextView *textView = [[YYTextView alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 0.05*kScreenWidth, 0.9*kScreenWidth, 0.3*kScreenWidth)];
            textView.placeholderText = @"请输入主营项目";
            textView.font = normalFont;
            textView.tag = indexPath.section;
            textView.placeholderFont = normalFont;
            textView.text = self.model.product;
            textView.tag = indexPath.section;
            textView.delegate = self;
            [cell.contentView addSubview:textView];
        } else {
            [self createBusinessInformationWith:cell];
        }
    }else if (indexPath.section == 5) {
        YYTextView *textView = [[YYTextView alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 0.05*kScreenWidth, 0.9*kScreenWidth, 0.3*kScreenWidth)];
        textView.placeholderText = @"请输入需求说明";
        textView.font = normalFont;
        textView.placeholderFont = normalFont;
        textView.tag = indexPath.section;
        textView.text = self.model.requirement;
        textView.delegate = self;
        [cell.contentView addSubview:textView];
    }else if (indexPath.section == 6) {
        NSInteger cuont = self.httpImages.count +self.imageInfoArray.count;
        CGFloat with;
        if (cuont>=3 && cuont<6) {
            with =  (0.5*kScreenWidth)/3*2;
        }else if (cuont>=6) {
            with =  0.5*kScreenWidth;;
        }else {
            with =  (0.5*kScreenWidth)/3;
        }
        self.collectView.frame = CGRectMake(0.05*kScreenWidth, 0.05*kScreenWidth, 0.9*kScreenWidth, with);
        self.collectView.backgroundColor = [UIColor redColor];
        [cell.contentView addSubview:self.collectView];
    }else {
        UIImageView *licenseImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 0.05*kScreenWidth, 0.24*kScreenWidth, 0.3*kScreenWidth)];
        if (self.licenseImage) {
            licenseImageV.image = self.licenseImage;
        }else {
            licenseImageV.image = [UIImage imageNamed:@"add_placeholder_image"];
        }
        licenseImageV.layer.cornerRadius = 2;
        licenseImageV.layer.masksToBounds = YES;
        licenseImageV.userInteractionEnabled = YES;
        licenseImageV.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1];
        [cell.contentView addSubview:licenseImageV];
        
        UITapGestureRecognizer *tapLicense = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLicenseClick:)];
        [licenseImageV addGestureRecognizer:tapLicense];
        
    }
    
}

- (void)createServiceTableViewCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
            
            UIImageView *logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 0.05*kScreenWidth, 0.25*kScreenWidth, 0.25*kScreenWidth)];
            if (self.logoImage) {
                logoImageView.image = self.logoImage;
            }else {
                logoImageView.image = [UIImage imageNamed:@"add_placeholder_image"];
            }
            logoImageView.userInteractionEnabled = YES;
            logoImageView.layer.cornerRadius = 2;
            logoImageView.layer.masksToBounds = YES;
            [cell.contentView addSubview:logoImageView];
            
            UITapGestureRecognizer *tapLogo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLogoClick:)];
            [logoImageView addGestureRecognizer:tapLogo];
            
            UILabel *noticeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(logoImageView.frame), CGRectGetMaxY(logoImageView.frame), 0.84*kScreenWidth, 30)];
            noticeLabel.text = @"注：此处为企业LOGO图片上传";
            noticeLabel.font = smallFont;
            noticeLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
            [cell.contentView addSubview:noticeLabel];
            
        }else if (indexPath.section == 1) {
            
            NSArray *titles = @[@"公司名称：",@"公司电话：",@"公司邮箱：",@"公司网址：",@"所属区域：",@"详细地址："];
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(magin, 0, 0.2*kScreenWidth, 0.1*kScreenWidth)];
            titleLabel.text = titles[indexPath.row];
            titleLabel.font = normalFont;
            [cell.contentView addSubview:titleLabel];
            
            NSArray *values = @[@"请输入公司名称",@"请输入公司电话",@"请输入公司邮箱",@"请输入公司网址",@"",@"请输入详细地址"];
            UITextField *valueText = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), 0, kScreenWidth-CGRectGetMaxX(titleLabel.frame)-magin-0.05*kScreenWidth, 0.1*kScreenWidth)];
            valueText.placeholder = values[indexPath.row];
            valueText.tag = indexPath.row;
            if (indexPath.row == 0) {
                valueText.text = self.model.name;
            }else if (indexPath.row == 1) {
                valueText.text = self.model.telephone;
            }else if (indexPath.row == 2) {
                valueText.text = self.model.email;
            }else if (indexPath.row == 3) {
                valueText.text = self.model.website;
            }else if (indexPath.row == 4) {
    //            self.areaName =
                if (self.areaName) {
                    valueText.text = self.areaName;
                }else {
                    valueText.text = @"请选择所属区域";
                }
                valueText.enabled = NO;
                valueText.textColor = skinColor;
            }else {
                valueText.text = self.model.address;
            }
            valueText.font = normalFont;
            [valueText addTarget:self action:@selector(takeTextValue:) forControlEvents:UIControlEventAllEditingEvents];
            [cell.contentView addSubview:valueText];
            UIImageView *accImage = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(valueText.frame)+magin/2, 0.025*kScreenWidth, 0.05*kScreenWidth, 0.05*kScreenWidth)];
            accImage.image = [UIImage imageNamed:@"certification_edit_icon"];
            if (indexPath.row == 4) {
                accImage.image = [UIImage imageNamed:@"certification_right_arrow"];
            }
            [cell.contentView addSubview:accImage];
            
        }else if (indexPath.section == 2) {
            YYTextView *textView = [[YYTextView alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 0.05*kScreenWidth, 0.9*kScreenWidth, 0.3*kScreenWidth)];
            textView.placeholderText = @"请输入公司简介";
            textView.text = self.model.profile;
            textView.tag = indexPath.section;
            textView.font = normalFont;
            textView.placeholderFont = normalFont;
            textView.tag = indexPath.section;
            textView.delegate = self;
            [cell.contentView addSubview:textView];
        }else if (indexPath.section == 3) {
            
            
            UIButton *addIndustry = [UIButton buttonWithType:UIButtonTypeCustom];
            addIndustry.frame = CGRectMake(0.85*kScreenWidth, 0, 0.15*kScreenWidth, 0.065*kScreenWidth);
            [addIndustry setTitle:@"添加" forState:UIControlStateNormal];
            addIndustry.backgroundColor = skinColor;
            addIndustry.titleLabel.font = smallMediumFont;
            [addIndustry addTarget:self action:@selector(addIndustryClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:addIndustry];
            [self setTheRoundedCorners:addIndustry];
            
            UIView *toolView = [[UIView alloc]initWithFrame:CGRectMake(0, 0.075*kScreenWidth, kScreenWidth, 0.275*kScreenWidth)];
            [cell.contentView addSubview:toolView];
            
            
            CGFloat itemWidth = 0.82*kScreenWidth/5;
            CGFloat itemMargin = 0.03*kScreenWidth;
            NSMutableArray *myArray = [NSMutableArray array];
            for (ZWChosenIndustriesModel *model in self.certIndustries) {
                ZWExbihitorsIndustriesModel *modelO = [[ZWExbihitorsIndustriesModel alloc]init];
                modelO.secondIndustryId = [NSString stringWithFormat:@"%@",model.industries2Id];
                modelO.secondIndustryName = [NSString stringWithFormat:@"%@",model.industries2Name];
                modelO.thirdIndustryId = [NSString stringWithFormat:@"%@",model.industries3Id];
                modelO.thirdIndustryName = [NSString stringWithFormat:@"%@",model.industries3Name];
                [myArray addObject:modelO];
                
            }
            
            
            for (int i = 0; i<myArray.count; i++) {
                
                ZWExbihitorsIndustriesModel *model = myArray[i];
                ZWIndustriesItemView *industriesItemView = [[ZWIndustriesItemView alloc]initWithFrame:CGRectMake(itemMargin+(itemMargin+itemWidth)*i, 0.05*kScreenWidth, itemWidth, itemWidth)];
                industriesItemView.backgroundColor = zwGrayColor;
                industriesItemView.layer.cornerRadius = 3;
                industriesItemView.layer.masksToBounds = YES;
                industriesItemView.model = model;
                [toolView addSubview:industriesItemView];

            }

        }else if (indexPath.section == 4) {
            
            if ([self.identityId isEqualToString:@"2"]) {
                YYTextView *textView = [[YYTextView alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 0.05*kScreenWidth, 0.9*kScreenWidth, 0.3*kScreenWidth)];
                textView.placeholderText = @"请输入主营项目";
                textView.font = normalFont;
                textView.tag = indexPath.section;
                textView.placeholderFont = normalFont;
                textView.text = self.model.product;
                textView.tag = indexPath.section;
                textView.delegate = self;
                [cell.contentView addSubview:textView];
            } else {
                [self createBusinessInformationWith:cell];
            }
            
        }else if (indexPath.section == 5) {
            NSInteger cuont = self.httpImages.count +self.imageInfoArray.count;
            CGFloat with;
            if (cuont>=3 && cuont<6) {
                with =  (0.5*kScreenWidth)/3*2;
            }else if (cuont>=6) {
                with =  0.5*kScreenWidth;;
            }else {
                with =  (0.5*kScreenWidth)/3;
            }
            self.collectView.frame = CGRectMake(0.05*kScreenWidth, 0.05*kScreenWidth, 0.9*kScreenWidth, with);
            self.collectView.backgroundColor = [UIColor redColor];
            [cell.contentView addSubview:self.collectView];
        }else {
            UIImageView *licenseImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 0.05*kScreenWidth, 0.24*kScreenWidth, 0.3*kScreenWidth)];
            if (self.licenseImage) {
                licenseImageV.image = self.licenseImage;
            }else {
                licenseImageV.image = [UIImage imageNamed:@"add_placeholder_image"];
            }
            licenseImageV.layer.cornerRadius = 2;
            licenseImageV.layer.masksToBounds = YES;
            licenseImageV.userInteractionEnabled = YES;
            licenseImageV.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1];
            [cell.contentView addSubview:licenseImageV];
            
            UITapGestureRecognizer *tapLicense = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLicenseClick:)];
            [licenseImageV addGestureRecognizer:tapLicense];
            
        }
}

- (void)createBusinessInformationWith:(UITableViewCell *)cell {
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.3*kScreenWidth)];
    [cell.contentView addSubview:topView];
    
    CGFloat width = [[ZWToolActon shareAction]adaptiveTextWidth:@"服务标签（点击标签可删除）：" labelFont:normalFont];
    UILabel *serverTitle = [[UILabel alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 0, width, 0.1*kScreenWidth)];
    serverTitle.text = @"服务标签（点击标签可删除）：";
    serverTitle.font = normalFont;
    [cell.contentView addSubview:serverTitle];
    
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    setBtn.frame = CGRectMake(CGRectGetMaxX(serverTitle.frame), 0, 0.2*kScreenWidth, 0.1*kScreenWidth);
    [setBtn setTitle:@"添加" forState:UIControlStateNormal];
    setBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [setBtn addTarget:self action:@selector(setBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:setBtn];
    
    UIView *middleView = [[UIView alloc]initWithFrame:CGRectMake(0.04*kScreenWidth, CGRectGetMaxY(serverTitle.frame), 0.92*kScreenWidth, 0.15*kScreenWidth)];
    middleView.backgroundColor = zwGrayColor;
    middleView.layer.cornerRadius = 5;
    [cell.contentView addSubview:middleView];
    
    
    NSArray *bgColors = @[[UIColor colorWithRed:20/255.0 green:180/255.0 blue:230/255.0 alpha:1.0],[UIColor colorWithRed:255/255.0 green:159/255.0 blue:0/255.0 alpha:1.0],[UIColor colorWithRed:107/255.0 green:210/255.0 blue:251/255.0 alpha:1.0]];
    
    CGFloat interval = 15;
    for (int i = 0; i < self.serverLabels.count; i++) {
        
        CGFloat widthB = [[ZWToolActon shareAction]adaptiveTextWidth:self.serverLabels[i] labelFont:normalFont];
        CGFloat btnWidth = widthB+10;
        UIButton *labelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        labelBtn.frame = CGRectMake(interval, 0.045*kScreenWidth, btnWidth, 0.06*kScreenWidth);
        [labelBtn setTitle:self.serverLabels[i] forState:UIControlStateNormal];
        labelBtn.titleLabel.font = smallFont;
        labelBtn.backgroundColor = bgColors[i];
        labelBtn.tag = i;
        [labelBtn addTarget:self action:@selector(labelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [middleView addSubview:labelBtn];
        [self setTheTagRoundedCorners:labelBtn];
        interval += btnWidth+15;
        
    }
    
    self.model.product = [self.serverLabels componentsJoinedByString:@","];
    
//    UILabel *serverType = [[UILabel alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, CGRectGetMaxY(middleView.frame)+0.025*kScreenWidth, 0.2*kScreenWidth, 0.1*kScreenWidth)];
//    serverType.text = @"服务类型：";
//    serverType.font = normalFont;
//    [cell.contentView addSubview:serverType];
//
//    UITextField * serverText = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(serverType.frame), CGRectGetMinY(serverType.frame), 0.65*kScreenWidth, CGRectGetHeight(serverType.frame))];
//    serverText.placeholder = @"请输入服务类型";
//    serverText.font = normalFont;
//    [serverText addTarget:self action:@selector(takeServerTextValue:) forControlEvents:UIControlEventAllEditingEvents];
//    [cell.contentView addSubview:serverText];
//
//    UIImageView *accImage = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(serverText.frame)+0.025*kScreenWidth, CGRectGetMinY(serverText.frame)+0.025*kScreenWidth, 0.05*kScreenWidth, 0.05*kScreenWidth)];
//    accImage.image = [UIImage imageNamed:@"certification_edit_icon"];
//    [cell.contentView addSubview:accImage];
    
}

- (void)setTheTagRoundedCorners:(UIButton *)btn {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:btn.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(6,6)];//圆角大小
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = btn.bounds;
    maskLayer.path = maskPath.CGPath;
    btn.layer.mask = maskLayer;
}

- (void)setBtnClick:(UIButton *)btn {
    if (self.serverLabels.count<3) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请输入服务标签内容" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        alertController.textFields.firstObject.delegate = self;
        __weak typeof (self) weakSelf = self;
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            UITextField * userNameTextField = alertController.textFields.firstObject;
            NSLog(@"%@",userNameTextField.text);
            [strongSelf.serverLabels addObject:userNameTextField.text];
            [strongSelf.tableView reloadData];
        }]];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField*_Nonnull textField) {
            textField.placeholder=@"内容（四个字以内，能设置三个标签）";
            textField.delegate = self;
        }];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else {
        
        [self showOneAlertWithTitle:@"最多只能设置三个服务标签"];
        
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField.text.length + string.length > 4) {
        return NO;
    }
    if (textField.text.length < range.location + range.length) {
        return NO;
    }
    return YES;
}


- (void)labelBtnClick:(UIButton *)btn {
    [self.serverLabels removeObjectAtIndex:btn.tag];
    [self.tableView reloadData];
}

- (void)takeTextValue:(UITextField *)textField {
    NSLog(@"%@",textField.text);
    if (textField.tag == 0) {
        self.model.name = textField.text;
    }else if (textField.tag == 1) {
        self.model.telephone = textField.text;
    }else if (textField.tag == 2) {
        self.model.email = textField.text;
    }else if (textField.tag == 3) {
        self.model.website = textField.text;
    }else if (textField.tag == 4) {
        
    }else {
        self.model.address = textField.text;
    }
}

- (void)textViewDidChange:(YYTextView *)textView {
    if (textView.tag == 2) {
        self.model.profile = textView.text;
    }else if (textView.tag == 4) {
        self.model.product = textView.text;
    }else if (textView.tag == 5) {
        if ([self.identityId isEqualToString:@"2"]) {
            self.model.requirement = textView.text;
        }else {
            self.model.speciality = textView.text;
        }
    }else {
        
    }
   NSLog(@"%@",textView.text);
}

//- (void)takeServerTextValue:(UITextField *)textField {
//    NSLog(@"----%@",textField.text);
//    self.model.speciality = textField.text;
//}

- (void)setTheRoundedCorners:(UIButton *)btn {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:btn.bounds byRoundingCorners:(UIRectCornerBottomLeft) cornerRadii:CGSizeMake(5,5)];//圆角大小
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = btn.bounds;
    maskLayer.path = maskPath.CGPath;
    btn.layer.mask = maskLayer;
}

- (void)tapLogoClick:(UITapGestureRecognizer *)tap {
    [self callTheBottomPopup:1];
}
- (void)tapLicenseClick:(UITapGestureRecognizer *)tap {
    [self callTheBottomPopup:3];
}

- (void)addIndustryClick:(UIButton *)btn {
    
    if ([self.identityId isEqualToString:@"2"]) {
        __weak typeof(self) weakSelf = self;
        [[ZWDataAction sharedAction]getReqeustWithURL:zwIndustriesList parametes:@{} successBlock:^(NSDictionary * _Nonnull data) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            if (zw_issuccess) {
                
                ZWSelectIndustriesVC_v2 *industriesVC = [[ZWSelectIndustriesVC_v2 alloc]init];
                industriesVC.myIndustries = data[@"data"];
                industriesVC.title = @"选择您所涉及的行业";
                industriesVC.type = 1;
                industriesVC.industriesArr = strongSelf.certIndustries;
                [strongSelf.navigationController pushViewController:industriesVC animated:YES];
                
            }
        } failureBlock:^(NSError * _Nonnull error) {

        } showInView:self.view];
    }else {
        __weak typeof (self) weakSelf = self;
        [[ZWDataAction sharedAction]getReqeustWithURL:zwGetExhibitionServerIndustriesList parametes:@{} successBlock:^(NSDictionary * _Nonnull data) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            if (zw_issuccess) {
                
                ZWExhibitionServerSelectIndustriesVC *industriesVC = [[ZWExhibitionServerSelectIndustriesVC alloc]init];
                industriesVC.myIndustries = data[@"data"];
                industriesVC.title = @"选择您所涉及的行业";
                industriesVC.industriesArr = strongSelf.certIndustries;
                [strongSelf.navigationController pushViewController:industriesVC animated:YES];
                
            }
        } failureBlock:^(NSError * _Nonnull error) {
            
        } showInView:self.view];
    }
}


#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.identityId isEqualToString:@"2"]) {
        if (indexPath.section == 0) {
            return 0.4*kScreenWidth;
        }else if (indexPath.section == 1) {
            return 0.1*kScreenWidth;
        }else if (indexPath.section == 4) {
            if ([self.identityId isEqualToString:@"2"]) {
                return 0.4*kScreenWidth;
            }else {
                return 0.3*kScreenWidth;
            }
        }else if (indexPath.section == 6) {
            NSInteger cuont = self.httpImages.count +self.imageInfoArray.count;
            if (cuont>=3 && cuont<6) {
                return (0.5*kScreenWidth/3)*2+0.1*kScreenWidth;
            }else if (cuont>=6) {
                return 0.6*kScreenWidth;
            }else {
                return (0.5*kScreenWidth/3)+0.1*kScreenWidth;
            }
        }else {
            return 0.4*kScreenWidth;
        }
    }else {
       if (indexPath.section == 0) {
            return 0.4*kScreenWidth;
        }else if (indexPath.section == 1) {
            return 0.1*kScreenWidth;
        }else if (indexPath.section == 4) {
            if ([self.identityId isEqualToString:@"2"]) {
                return 0.4*kScreenWidth;
            }else {
                return 0.3*kScreenWidth;
            }
        }else if (indexPath.section == 5) {
            NSInteger cuont = self.httpImages.count +self.imageInfoArray.count;
            if (cuont>=3 && cuont<6) {
                return (0.5*kScreenWidth/3)*2+0.1*kScreenWidth;
            }else if (cuont>=6) {
                return 0.6*kScreenWidth;
            }else {
                return (0.5*kScreenWidth/3)+0.1*kScreenWidth;
            }
        }else {
            return 0.4*kScreenWidth;
        }
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }else {
        return 0.08*kScreenWidth;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    
    NSArray *arraies;
    if ([self.identityId isEqualToString:@"2"]) {
        arraies = @[@"",@"基本信息",@"公司简介（限500个字）",@"所属行业",@"主营项目（限制30个字）",@"需求说明（限30个字）",@"企业宣传图片（限9张，长按图片可删除）",@"营业执照（只作审核凭证不对外展示）"];
    } else {
        arraies = @[@"",@"基本信息",@"公司简介（限500个字）",@"所属行业",@"服务信息",@"企业宣传图片（限9张，长按图片可删除）",@"营业执照（只作审核凭证不对外展示）"];
    }
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.04*kScreenWidth, 0, 0.82*kScreenWidth, 0.08*kScreenWidth)];
    titleLabel.text = arraies[section];
    titleLabel.font = boldNormalFont;
    [view addSubview:titleLabel];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.row == 4) {
            [[ZWAreaManager shareManager]areaSelectionShow:self];
            [ZWAreaManager shareManager].delegate = self;
        }
    }
}
- (void)accessToAreas:(NSDictionary *)dic {
    
    self.model.country = dic[@"country"][@"value"];
    if (dic[@"province"][@"value"]) {
        self.model.province = dic[@"province"][@"value"];
    }else {
        self.model.province = @"";
    }
    if (dic[@"city"][@"value"]) {
        self.model.city = dic[@"city"][@"value"];
    }else {
        self.model.city = @"";
    }
    self.areaName = [NSString stringWithFormat:@"%@ %@ %@",self.model.country,self.model.province,self.model.city];
    [self.tableView reloadData];
    
}
/*UICollectionView*/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = self.httpImages.count+self.imageInfoArray.count;
    if (count<9) {
        return count+1;
    }else {
        return count;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId=@"cellID";
    
    NSInteger count = self.httpImages.count+self.imageInfoArray.count;
    if (indexPath.row==count) {
        ZWCollectionViewAddCell *addCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"addCell" forIndexPath:indexPath];
        return addCell;
    }else {
        ZWCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
        cell.tag = indexPath.row;
        if (indexPath.row>=self.httpImages.count) {
            cell.mianImageView.image = self.imageInfoArray[indexPath.item-self.httpImages.count];
        }else {
            [cell.mianImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,self.httpImages[indexPath.row][@"url"]]] placeholderImage:[UIImage imageNamed:@"fu_img_no_02"]];
        }
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        [cell addGestureRecognizer:longPress];
        
        return cell;
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)press {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof (self) weakSelf = self;
    UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        
        if (press.view.tag<strongSelf.httpImages.count) {
            [strongSelf deleteHttpImage:press.view.tag];
            
        }else {
            [strongSelf.imageInfoArray removeObjectAtIndex:press.view.tag-self.httpImages.count];
            [strongSelf.tableView reloadData];
            [strongSelf.collectView reloadData];
            
        }
    }];
    [alertController addAction:actionOne];
    UIAlertAction *actionThree = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];
    [alertController addAction:actionThree];
    [self presentViewController:alertController animated:YES completion:nil];
           
}

- (void)deleteHttpImage:(NSInteger )index {
    NSDictionary *myParametes = @{
        @"authenticationId":self.model.authenticationId,
        @"profilesImageId":self.httpImages[index][@"id"]
    };
    if (myParametes) {
        __weak typeof (self) weakSelf = self;
        [[ZWDataAction sharedAction]postReqeustWithURL:zwDeleteImageInfo parametes:myParametes successBlock:^(NSDictionary * _Nonnull data) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            if (zw_issuccess) {
               [ZWOSSConstants syncDeleteImage:self.httpImages[index][@"url"] complete:^(DeleteImageState state) {
                    if (state == 1) {
                        NSLog(@"网络图片删除成功");
                        
                    }
                }];
                [strongSelf.httpImages removeObjectAtIndex:index];
                [strongSelf.tableView reloadData];
                [strongSelf.collectView reloadData];
            }else {
                NSLog(@"删除失败");
            }
        } failureBlock:^(NSError * _Nonnull error) {
            
        } showInView:self.view];
    }
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((0.9*kScreenWidth)/3-3, (0.5*kScreenWidth)/3-2);
}

//cell的点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger count = self.httpImages.count+self.imageInfoArray.count;
    if (indexPath.row == count) {
        [self callTheBottomPopup:2];
    }
}

- (void)callTheBottomPopup:(NSInteger)type {
    self.tapType = type;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof (self) weakSelf = self;
    UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf callTheAlbum];
    }];
    [alertController addAction:actionOne];
    UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf callTheCamera];
    }];
    [alertController addAction:actionTwo];
    UIAlertAction *actionThree = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];
    [alertController addAction:actionThree];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)callTheAlbum {
    NSInteger number;
    if (self.tapType == 2) {
        number = 9-(self.imageInfoArray.count);
    }else {
        number = 1;
    }
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc]initWithMaxImagesCount:number columnNumber:5 delegate:self];
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
    if (self.tapType == 1) {
        self.logoImage = photos[0];
    }else if (self.tapType == 2) {
        [self.imageInfoArray addObjectsFromArray:photos];
        [self.collectView reloadData];
    }else {
        self.licenseImage = photos[0];
    }
    [self.tableView reloadData];
}

- (void)createImagePicker {
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.allowsEditing = YES;
}

- (void)callTheCamera {
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
    if (self.tapType == 1) {
        self.logoImage = ima;
    }else if (self.tapType == 2) {
        [self.imageInfoArray addObject:ima];
        [self.collectView reloadData];
    }else {
        self.logoImage = ima;
    }
    NSLog(@"-----%@",self.imageInfoArray);
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
    
   
    
}
//进入拍摄页面点击取消按钮
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)showOneAlertWithTitle:(NSString *)title {
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:title confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        
    } showInView:self];
}




//******************************************************************网络请求*********************************************************************/

- (void)uploadLogo {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof (self) weakSelf = self;
    [ZWOSSConstants syncUploadImage:self.logoImage complete:^(NSArray<NSString *> * _Nonnull names, UploadImageState state) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (state) {
            [strongSelf uploadImagesWithLogoImage:names[0]];
        }else {
            [strongSelf showOneAlertWithTitle:@"企业认证资料提交失败，请检查网络或稍后再试"];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
}

- (void)uploadImagesWithLogoImage:(NSString *)logoImage {
    
    if (self.imageInfoArray.count != 0) {
        
        __weak typeof (self) weakSelf = self;
        [ZWOSSConstants syncUploadImages:self.imageInfoArray complete:^(NSArray<NSString *> * _Nonnull names, UploadImageState state) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            
            if (state == 1) {
                NSLog(@"我的简介图片%@",names);
                [strongSelf uploadImagesWithLogoImage:logoImage withImages:names];
            }else {
                [strongSelf showOneAlertWithTitle:@"企业认证资料提交失败，请检查网络或稍后再试"];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [strongSelf deleteImages:@[logoImage] where:@"logo图片"];
            }

        }];
        
    }else {
        
        [self uploadImagesWithLogoImage:logoImage withImages:@[]];
        
    }
}

- (void)uploadImagesWithLogoImage:(NSString *)logoImage withImages:(NSArray *)images {
    
    __weak typeof (self) weakSelf = self;
    [ZWOSSConstants syncUploadImage:self.licenseImage complete:^(NSArray<NSString *> * _Nonnull names, UploadImageState state) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (state == 1) {
            [strongSelf uploadImagesWithLogoImage:logoImage withImages:images withLicense:names[0]];
        }else {
            [strongSelf showOneAlertWithTitle:@"企业认证资料提交失败，请检查网络或稍后再试"];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSMutableArray *myArray = [NSMutableArray array];
            [myArray addObjectsFromArray:images];
            [myArray addObject:logoImage];
            [strongSelf deleteImages:myArray where:@"logo图片和简介图片"];
        }
    }];
    
}
- (void)uploadImagesWithLogoImage:(NSString *)logoImage withImages:(NSArray *)images withLicense:(NSString *)licenseImage {
    
    self.model.coverFile = logoImage;
    self.model.profileFiles = images;
    self.model.licenseFile = licenseImage;
    self.model.identityId = self.identityId;
    NSDictionary *myDic= [self dicFromObject:self.model];
    
    NSLog(@"--------我的参数-------===---===%@",myDic[@"profileFiles"]);
    if (myDic) {
        __weak typeof (self) weakSelf = self;
        [[ZWDataAction sharedAction]postReqeustWithURL:zwEnterpriseCertification parametes:myDic successBlock:^(NSDictionary * _Nonnull data) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (zw_issuccess) {

                    [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:@"企业认证信息上传成功，我们将在两个工作日内为您审核，请耐心等待" confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
                        __strong typeof (weakSelf) strongSelf = weakSelf;
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshTheCertification" object:nil];
                        [strongSelf.navigationController popViewControllerAnimated:YES];
                    } showInView:strongSelf];

                    if (self.merchantStatus == 3) {

                        NSArray *oldImages = @[self.oldLogo,self.oldLicense];
                        [self deleteImages:oldImages where:@"老logo和老图片删除成功"];

                    }

            }else {

                [strongSelf showOneAlertWithTitle:@"企业认证资料提交失败，请检查网络或稍后再试"];
                NSMutableArray *myArray = [NSMutableArray array];
                [myArray addObjectsFromArray:images];
                [myArray addObject:logoImage];
                [myArray addObject:licenseImage];
                [strongSelf deleteImages:myArray where:@"全部图片"];

            }
        } failureBlock:^(NSError * _Nonnull error) {

            __strong typeof (weakSelf) strongSelf = weakSelf;
            [strongSelf showOneAlertWithTitle:@"企业认证资料提交失败，请检查网络或稍后再试"];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSMutableArray *myArray = [NSMutableArray array];
            [myArray addObjectsFromArray:images];
            [myArray addObject:logoImage];
            [myArray addObject:licenseImage];
            [strongSelf deleteImages:myArray where:@"全部图片"];

        } showInView:self.view];

    }
    
}

- (void)deleteImages:(NSArray *)images where:(NSString *)message {
    
    [ZWOSSConstants syncDeleteImages:images complete:^(DeleteImageState state) {
        if (state == 1) {
            NSLog(@"%@删除成功",message);
        }else {
            NSLog(@"%@删除失败",message);
        }
    }];
    
}


    

@end
