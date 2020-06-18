//
//  ZWMyBusinessCardListVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/4/22.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWMyBusinessCardListVC.h"
#import "UButton.h"
#import "ZWAddBusinessCardVC.h"
#import "ZWBusinessCardModel.h"

@interface ZWMyBusinessCardListVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)ZWBaseEmptyTableView *tableView;
@property(nonatomic, strong)NSArray *dataArray;
@property(nonatomic, assign)NSInteger selectIndex;

@end

@implementation ZWMyBusinessCardListVC

-(ZWBaseEmptyTableView *)tableView {
    if (!_tableView) {
        
        _tableView = [[ZWBaseEmptyTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBar];
    [self createUI];
    [self createRequest];
    [self createNotice];
}

- (void)createNotice {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshBusinessCardData:) name:@"refreshBusinessCardData" object:nil];
}

- (void)refreshBusinessCardData:(NSNotification *)notice {
    [self createRequest];
}

- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
    [[YNavigationBar sharedInstance]createRightBarWithImage:[UIImage imageNamed:@"add_icon"] barItem:self.navigationItem target:self action:@selector(rightItemClick:)];
}

- (void)goBack:(UINavigationItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightItemClick:(UINavigationItem *)item {
    
    if (self.dataArray.count >=3) {
        [self showAlertWithMessage:@"添加名片的数量已达上限"];
        return;
    }
    
    ZWAddBusinessCardVC *CardVC = [[ZWAddBusinessCardVC alloc]init];
    [self.navigationController pushViewController:CardVC animated:YES];
}

- (void)createUI {
    self.selectIndex = -1;
    self.view.backgroundColor = zwGrayColor;
    [self.view addSubview:self.tableView];
    
    if (self.type == 0) {
        UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        delBtn.frame = CGRectMake(0.05*kScreenWidth, kScreenHeight-0.2*kScreenWidth-zwNavBarHeight, 0.9*kScreenWidth, 0.1*kScreenWidth);
        [delBtn setTitle:@"投递" forState:UIControlStateNormal];
        delBtn.layer.cornerRadius = 5;
        delBtn.backgroundColor = skinColor;
        [delBtn addTarget:self action:@selector(delBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:delBtn];
    }
}

- (void)delBtnClick:(UIButton *)btn {
    
    if (self.selectIndex<0) {
        [self showAlertWithMessage:@"请选择名片"];
        return;
    }
    
    __weak typeof (self) weakSelf = self;
    [[ZWAlertAction sharedAction]showTwoAlertTitle:@"提示" message:@"是否确认将该名片投递给商家" cancelTitle:@"否" confirmTitle:@"是" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf sendBusinessCard];
    } actionCancel:^(UIAlertAction * _Nonnull actionCancel) {
        
    } showInView:self];
    
}

- (void)sendBusinessCard {

    ZWBusinessCardModel *model = self.dataArray[self.selectIndex];
    
    NSDictionary *myParametes = @{
        @"cardId":model.cardId,
        @"merchantId":self.merchantId
    };
    if (myParametes) {
        [[ZWDataAction sharedAction]postReqeustWithURL:zwSendBusinessCard parametes:myParametes successBlock:^(NSDictionary * _Nonnull data) {
            if (zw_issuccess) {
                [self showAlertWithMessage:@"名片投递成功"];
            }
        } failureBlock:^(NSError * _Nonnull error) {
            
        } showInView:self.view];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
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
    
    ZWBusinessCardModel *model = self.dataArray[indexPath.section];
    
    UIView * cardTool = [[UIView alloc]initWithFrame:CGRectMake(0.03*kScreenWidth, 0, 0.94*kScreenWidth, 0.6*kScreenWidth)];
    cardTool.backgroundColor = cardSkin;
    cardTool.layer.cornerRadius = 5;
    cardTool.layer.borderColor = cardSkin.CGColor;
    cardTool.layer.borderWidth = 1;
    cardTool.layer.masksToBounds = YES;
    [cell.contentView addSubview:cardTool];
    
    if (model.merchantName.length == 0) {
        
        CGFloat nameWith = [[ZWToolActon shareAction]adaptiveTextWidth:model.contacts labelFont:[UIFont fontWithName:@"Helvetica-Bold" size:0.06*kScreenWidth]];
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 0.06*kScreenWidth, nameWith, 0.075*kScreenWidth)];
        nameLabel.text = model.contacts;
        nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:0.06*kScreenWidth];
        nameLabel.textColor = [UIColor whiteColor];
        [cardTool addSubview:nameLabel];
        
        UILabel *positionLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame)+5, CGRectGetMaxY(nameLabel.frame)-CGRectGetHeight(nameLabel.frame)/2-3, 0.3*kScreenWidth, CGRectGetHeight(nameLabel.frame)/2)];
        if (model.post.length == 0) {
            positionLabel.text = @"";
        }else {
            positionLabel.text =[NSString stringWithFormat:@"(%@)",model.post];
        }
        positionLabel.font = smallFont;
        positionLabel.textColor = [UIColor whiteColor];
        [cardTool addSubview:positionLabel];
        
    }else {
        CGFloat nameWith = [[ZWToolActon shareAction]adaptiveTextWidth:model.contacts labelFont:boldBigFont];
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 0.03*kScreenWidth, nameWith, 0.075*kScreenWidth)];
        nameLabel.text = model.contacts;
        nameLabel.font = boldBigFont;
        nameLabel.textColor = [UIColor whiteColor];
        [cardTool addSubview:nameLabel];
        
        UILabel *positionLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame)+5, CGRectGetMaxY(nameLabel.frame)-CGRectGetHeight(nameLabel.frame)/2-6, 0.3*kScreenWidth, CGRectGetHeight(nameLabel.frame)/2)];
        if (model.post.length == 0) {
            positionLabel.text = @"";
        }else {
            positionLabel.text =[NSString stringWithFormat:@"(%@)",model.post];
        }
        positionLabel.font = smallFont;
        positionLabel.textColor = [UIColor whiteColor];
        [cardTool addSubview:positionLabel];
        
        UILabel *companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, CGRectGetMaxY(nameLabel.frame), 0.84*kScreenWidth, 0.075*kScreenWidth)];
        if (model.merchantName.length == 0) {
            companyLabel.text = @"";
        }else {
            companyLabel.text = model.merchantName;
        }
        companyLabel.font = normalFont;
        companyLabel.textColor = [UIColor whiteColor];
        [cardTool addSubview:companyLabel];
    }
    
    if (self.type == 0) {
        if (indexPath.section == self.selectIndex) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.86*kScreenWidth, -1, 0.08*kScreenWidth, 0.08*kScreenWidth)];
            imageView.image = [UIImage imageNamed:@"tick_icon"];
            imageView.backgroundColor = [UIColor whiteColor];
            [self setTheRoundedCorners:imageView];
            [cardTool addSubview:imageView];
        } else {
            UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.86*kScreenWidth, -1, 0.08*kScreenWidth, 0.08*kScreenWidth)];
            numberLabel.backgroundColor = [UIColor whiteColor];
            numberLabel.textColor = cardSkin;
            numberLabel.textAlignment = NSTextAlignmentCenter;
            numberLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.section+1];
            numberLabel.font = boldNormalFont;
            [self setTheRoundedCorners:numberLabel];
            [cardTool addSubview:numberLabel];
        }
    }else {
        UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.86*kScreenWidth, -1, 0.08*kScreenWidth, 0.08*kScreenWidth)];
        numberLabel.backgroundColor = [UIColor whiteColor];
        numberLabel.textColor = cardSkin;
        numberLabel.textAlignment = NSTextAlignmentCenter;
        numberLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.section+1];
        numberLabel.font = boldNormalFont;
        [self setTheRoundedCorners:numberLabel];
        [cardTool addSubview:numberLabel];
    }
    
    UIView *contenView = [[UIView alloc]initWithFrame:CGRectMake(0, 0.2*kScreenWidth, 0.94*kScreenWidth, 0.4*kScreenWidth)];
    contenView.backgroundColor = [UIColor whiteColor];
    [cardTool addSubview:contenView];
    
    //电话
    ZWLeftImageBtn *phoneBtn = [[ZWLeftImageBtn alloc]initWithFrame:CGRectMake(0.03*kScreenWidth, 0.04*kScreenWidth, 0.4*kScreenWidth, 0.04*kScreenWidth)];
    [phoneBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [phoneBtn setTitle:[self takeValue:model.phone] forState:UIControlStateNormal];
    [phoneBtn setImage:[self imageWithName:@"icon_card_phone"] forState:UIControlStateNormal];
    phoneBtn.titleLabel.font = normalFont;
    [contenView addSubview:phoneBtn];
    
    ZWLeftImageBtn *qqBtn = [[ZWLeftImageBtn alloc]initWithFrame:CGRectMake(CGRectGetMaxX(phoneBtn.frame), 0.04*kScreenWidth, 0.4*kScreenWidth, 0.04*kScreenWidth)];
    [qqBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [qqBtn setTitle:[self takeValue:model.qq] forState:UIControlStateNormal];
    [qqBtn setImage:[self imageWithName:@"exhibitor_contects_qq_icon"] forState:UIControlStateNormal];
    qqBtn.titleLabel.font = normalFont;
    [contenView addSubview:qqBtn];
    
    ZWLeftImageBtn *emailBtn = [[ZWLeftImageBtn alloc]initWithFrame:CGRectMake(CGRectGetMinX(phoneBtn.frame), CGRectGetMaxY(phoneBtn.frame)+0.04*kScreenWidth, 0.88*kScreenWidth, 0.04*kScreenWidth)];
    [emailBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [emailBtn setTitle:[self takeValue:model.mail] forState:UIControlStateNormal];
    [emailBtn setImage:[self imageWithName:@"exhibitor_contects_email_icon"] forState:UIControlStateNormal];
    emailBtn.titleLabel.font = normalFont;
    [contenView addSubview:emailBtn];
    
    ZWLeftImageBtn *addrssBtn = [[ZWLeftImageBtn alloc]initWithFrame:CGRectMake(CGRectGetMinX(emailBtn.frame), CGRectGetMaxY(emailBtn.frame)+0.04*kScreenWidth, 0.88*kScreenWidth, 0.04*kScreenWidth)];
    [addrssBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [addrssBtn setTitle:[self takeValue:model.address] forState:UIControlStateNormal];
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
    
    CGFloat valueH = [[ZWToolActon shareAction]adaptiveTextHeight:[self takeValue:model.requirement]  textFont:normalFont textWidth:0.88*kScreenWidth-CGRectGetMaxX(demandTitle.frame)];
    UILabel *demandValue = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(demandTitle.frame), CGRectGetMinY(demandTitle.frame), 0.88*kScreenWidth-CGRectGetWidth(demandTitle.frame), valueH)];
    demandValue.text = [self takeValue:model.requirement];
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
    UIImage *imgae = [[ZWToolActon shareAction]modifyTheColorWithImageName:name imageColor:skinColor];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.type == 0) {
        self.selectIndex = indexPath.section;
        [tableView reloadData];
    }else {
//        ZWBusinessCardModel *model = self.dataArray[indexPath.section];
//        ZWAddBusinessCardVC *CardVC = [[ZWAddBusinessCardVC alloc]init];
//        CardVC.cardModel = model;
//        [self.navigationController pushViewController:CardVC animated:YES];
    }

}

- (void)createRequest {
    
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]getReqeustWithURL:zwMyBusinessCardList parametes:@{} successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (zw_issuccess) {
            NSArray *myData = data[@"data"][@"cardList"];
            NSMutableArray *myArray = [NSMutableArray array];
            for (NSDictionary *myDic in myData) {
                ZWBusinessCardModel *model = [ZWBusinessCardModel parseJSON:myDic];
                [myArray addObject:model];
            }
            strongSelf.dataArray = myArray;
            [strongSelf.tableView reloadData];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
//2
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}
//3
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
//4
//点击删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //在这里实现删除操作
    
    //删除数据，和删除动画
//    [self.myarray removeObjectAtIndex:deleteRow];
//    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:deleteRow inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
}
//5
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    //删除
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        __weak typeof (self) weakSelf = self;
        [[ZWAlertAction sharedAction]showTwoAlertTitle:@"提示" message:@"是否确认删除" cancelTitle:@"否" confirmTitle:@"是" actionOne:^(UIAlertAction * _Nonnull actionOne) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [strongSelf deleteCardWithIndex:indexPath];
        } actionCancel:^(UIAlertAction * _Nonnull actionCancel) {
            
        } showInView:self];

    }];
    //编辑
    UITableViewRowAction *editRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
       ZWBusinessCardModel *model = self.dataArray[indexPath.section];
       ZWAddBusinessCardVC *CardVC = [[ZWAddBusinessCardVC alloc]init];
       CardVC.cardModel = model;
       [self.navigationController pushViewController:CardVC animated:YES];
        
    }];
    return @[deleteRowAction,editRowAction];
}


- (void)deleteCardWithIndex:(NSIndexPath *)indexPath {
    
    ZWBusinessCardModel *model = self.dataArray[indexPath.section];
    
    NSDictionary *myParametes = @{
        @"idList":@[model.cardId]
    };
    
    if (myParametes) {
        __weak typeof (self) weakSelf = self;
        [[ZWDataAction sharedAction]postReqeustWithURL:zwDeleteBusinessCard parametes:myParametes successBlock:^(NSDictionary * _Nonnull data) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            if (zw_issuccess) {
                [strongSelf createRequest];
            }
        } failureBlock:^(NSError * _Nonnull error) {
            
        } showInView:self.view];
    }
    
}

- (void)showAlertWithMessage:(NSString *)message {
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:message confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        
    } showInView:self];
}



@end
