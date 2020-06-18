//
//  ZWMessageCardDetailVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/4/26.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWMessageCardDetailVC.h"
#import "ZWBusinessCardModel.h"
#import "UButton.h"

@interface ZWMessageCardDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)ZWBusinessCardModel *model;
@end

@implementation ZWMessageCardDetailVC
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self takeData];
    [self createUI];
    [self createNavigationBar];
    
}
- (void)createUI {
    self.title = @"名片";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

- (void)takeData {
    
    NSData *jsonData = [self.cardStr  dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    self.model = [ZWBusinessCardModel parseJSON:dic];
}

- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
}
- (void)goBack:(UIBarButtonItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
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
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = zwGrayColor;
    
    UIColor * cardSkin = skinColor;
    
    UIView * cardTool = [[UIView alloc]initWithFrame:CGRectMake(0.03*kScreenWidth, 0, 0.94*kScreenWidth, 0.6*kScreenWidth)];
    cardTool.backgroundColor = cardSkin;
    cardTool.layer.cornerRadius = 5;
    cardTool.layer.borderColor = cardSkin.CGColor;
    cardTool.layer.borderWidth = 1;
    cardTool.layer.masksToBounds = YES;
    [cell.contentView addSubview:cardTool];
    
    if (self.model.merchantName.length == 0) {
        
        CGFloat nameWith = [[ZWToolActon shareAction]adaptiveTextWidth:self.model.contacts labelFont:[UIFont fontWithName:@"Helvetica-Bold" size:0.06*kScreenWidth]];
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 0.06*kScreenWidth, nameWith, 0.075*kScreenWidth)];
        nameLabel.text = self.model.contacts;
        nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:0.06*kScreenWidth];
        nameLabel.textColor = [UIColor whiteColor];
        [cardTool addSubview:nameLabel];
        
        UILabel *positionLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame)+5, CGRectGetMaxY(nameLabel.frame)-CGRectGetHeight(nameLabel.frame)/2-3, 0.3*kScreenWidth, CGRectGetHeight(nameLabel.frame)/2)];
        if (self.model.post.length == 0) {
            positionLabel.text = @"";
        }else {
            positionLabel.text =[NSString stringWithFormat:@"(%@)",self.model.post];
        }
        positionLabel.font = smallFont;
        positionLabel.textColor = [UIColor whiteColor];
        [cardTool addSubview:positionLabel];
        
    }else {
        CGFloat nameWith = [[ZWToolActon shareAction]adaptiveTextWidth:self.model.contacts labelFont:boldBigFont];
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 0.03*kScreenWidth, nameWith, 0.075*kScreenWidth)];
        nameLabel.text = self.model.contacts;
        nameLabel.font = boldBigFont;
        nameLabel.textColor = [UIColor whiteColor];
        [cardTool addSubview:nameLabel];
        
        UILabel *positionLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame)+5, CGRectGetMaxY(nameLabel.frame)-CGRectGetHeight(nameLabel.frame)/2-6, 0.3*kScreenWidth, CGRectGetHeight(nameLabel.frame)/2)];
        if (self.model.post.length == 0) {
            positionLabel.text = @"";
        }else {
            positionLabel.text =[NSString stringWithFormat:@"(%@)",self.model.post];
        }
        positionLabel.font = smallFont;
        positionLabel.textColor = [UIColor whiteColor];
        [cardTool addSubview:positionLabel];
        
        UILabel *companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, CGRectGetMaxY(nameLabel.frame), 0.84*kScreenWidth, 0.075*kScreenWidth)];
        if (self.model.merchantName.length == 0) {
            companyLabel.text = @"";
        }else {
            companyLabel.text = self.model.merchantName;
        }
        companyLabel.font = normalFont;
        companyLabel.textColor = [UIColor whiteColor];
        [cardTool addSubview:companyLabel];
    }
    
    UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.86*kScreenWidth, -1, 0.08*kScreenWidth, 0.08*kScreenWidth)];
    numberLabel.backgroundColor = [UIColor whiteColor];
    numberLabel.textColor = cardSkin;
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.section+1];
    numberLabel.font = boldNormalFont;
    [self setTheRoundedCorners:numberLabel];
    [cardTool addSubview:numberLabel];
    
    UIView *contenView = [[UIView alloc]initWithFrame:CGRectMake(0, 0.2*kScreenWidth, 0.94*kScreenWidth, 0.4*kScreenWidth)];
    contenView.backgroundColor = [UIColor whiteColor];
    [cardTool addSubview:contenView];
    
    //电话
    ZWLeftImageBtn *phoneBtn = [[ZWLeftImageBtn alloc]initWithFrame:CGRectMake(0.03*kScreenWidth, 0.04*kScreenWidth, 0.4*kScreenWidth, 0.04*kScreenWidth)];
    [phoneBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [phoneBtn setTitle:self.model.phone forState:UIControlStateNormal];
    [phoneBtn setImage:[self imageWithName:@"icon_card_phone"] forState:UIControlStateNormal];
    phoneBtn.titleLabel.font = normalFont;
    [contenView addSubview:phoneBtn];
    
    ZWLeftImageBtn *qqBtn = [[ZWLeftImageBtn alloc]initWithFrame:CGRectMake(CGRectGetMaxX(phoneBtn.frame), 0.04*kScreenWidth, 0.4*kScreenWidth, 0.04*kScreenWidth)];
    [qqBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [qqBtn setTitle:self.model.qq forState:UIControlStateNormal];
    [qqBtn setImage:[self imageWithName:@"exhibitor_contects_qq_icon"] forState:UIControlStateNormal];
    qqBtn.titleLabel.font = normalFont;
    [contenView addSubview:qqBtn];
    
    ZWLeftImageBtn *emailBtn = [[ZWLeftImageBtn alloc]initWithFrame:CGRectMake(CGRectGetMinX(phoneBtn.frame), CGRectGetMaxY(phoneBtn.frame)+0.04*kScreenWidth, 0.88*kScreenWidth, 0.04*kScreenWidth)];
    [emailBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [emailBtn setTitle:self.model.mail forState:UIControlStateNormal];
    [emailBtn setImage:[self imageWithName:@"exhibitor_contects_email_icon"] forState:UIControlStateNormal];
    emailBtn.titleLabel.font = normalFont;
    [contenView addSubview:emailBtn];
    
    ZWLeftImageBtn *addrssBtn = [[ZWLeftImageBtn alloc]initWithFrame:CGRectMake(CGRectGetMinX(emailBtn.frame), CGRectGetMaxY(emailBtn.frame)+0.04*kScreenWidth, 0.88*kScreenWidth, 0.04*kScreenWidth)];
    [addrssBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [addrssBtn setTitle:self.model.address forState:UIControlStateNormal];
    [addrssBtn setImage:[self imageWithName:@"exhibitor_contectus_adress_icon"] forState:UIControlStateNormal];
    addrssBtn.titleLabel.font = normalFont;
    [contenView addSubview:addrssBtn];
    
    CGFloat titleH = [[ZWToolActon shareAction]adaptiveTextHeight:@"需求：" textFont:normalFont textWidth:100];
    CGFloat titleW = [[ZWToolActon shareAction]adaptiveTextWidth:@"需求：" labelFont:normalFont];
    UILabel *demandTitle = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(addrssBtn.frame), CGRectGetMaxY(addrssBtn.frame)+0.04*kScreenWidth, titleW, titleH)];
    demandTitle.text = @"需求：";
    demandTitle.font = normalFont;
    demandTitle.textColor = [UIColor darkGrayColor];
    [contenView addSubview:demandTitle];
    
    CGFloat valueH = [[ZWToolActon shareAction]adaptiveTextHeight:[self takeValue:self.model.requirement]  textFont:normalFont textWidth:0.88*kScreenWidth-CGRectGetMaxX(demandTitle.frame)];
    UILabel *demandValue = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(demandTitle.frame), CGRectGetMinY(demandTitle.frame), 0.88*kScreenWidth-CGRectGetWidth(demandTitle.frame), valueH)];
    demandValue.text = [self takeValue:self.model.requirement];
    demandValue.textColor = [UIColor darkGrayColor];
    demandValue.numberOfLines = 2;
    demandValue.font = normalFont;
    [contenView addSubview:demandValue];
    
}

- (NSString *)takeValue:(NSString *)text {
    if (text.length == 0) {
        return @"无";
    }else {
        return text;
    }
}

- (UIImage *)imageWithName:(NSString *)name {
    UIImage *imgae =  [self imageWithImageName:name imageColor:skinColor];
    return imgae;
}

- (UIImage *)imageWithImageName:(NSString *)name imageColor:(UIColor *)imageColor {
    
    UIImage *image = [UIImage imageNamed:name];
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    [imageColor setFill];
    CGRect bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    UIRectFill(bounds);
    [image drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tintedImage;
    
}

- (void)setTheRoundedCorners:(UIView *)view {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:(UIRectCornerBottomLeft) cornerRadii:CGSizeMake(5,5)];//圆角大小
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0.6*kScreenWidth;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.03*kScreenWidth;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}


@end
