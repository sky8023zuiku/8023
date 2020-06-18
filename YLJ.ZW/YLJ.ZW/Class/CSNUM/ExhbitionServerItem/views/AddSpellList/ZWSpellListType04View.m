//
//  ZWSpellListType04View.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/5/12.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWSpellListType04View.h"
#import "ZWMineSpellListFailureVC.h"
@interface ZWSpellListType04View()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)ZWSpellListModel *model;
@property(nonatomic, assign)CGFloat placeholderH;//cell占位高度
@property(nonatomic, assign)CGFloat titleH;//标题有值时候的高度
@property(nonatomic, assign)CGFloat remarksH;//备注高度
@property(nonatomic, assign)CGFloat demandH;//需求高度

@property(nonatomic, assign)NSInteger type;//

@end

@implementation ZWSpellListType04View

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0.03*kScreenWidth, 0, 0.94*kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    return _tableView;
}

- (instancetype)initWithFrame:(CGRect)frame withModel:(ZWSpellListModel *)model withType:(NSInteger)type {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = zwGrayColor;
        self.model = model;
        self.type = type;
        [self addSubview:self.tableView];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 13;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }else {
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    [self createTableViewWithCell:cell withIndex:indexPath.row];
    return cell;
}

- (void)createTableViewWithCell:(UITableViewCell *)cell withIndex:(NSInteger)index {
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    
    self.placeholderH = [[ZWToolActon shareAction]adaptiveTextHeight:@"这是占位" textFont:smallMediumFont textWidth:0.88*kScreenWidth]+10;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.03*kScreenWidth, 0, 0.18*kScreenWidth, self.placeholderH)];
    titleLabel.font = smallMediumFont;
    titleLabel.textColor = [UIColor darkGrayColor];
    if (index == 0) {
        
    }else if (index == 1) {
        titleLabel.text = @"展会名称：";
    }else if (index == 2) {
        titleLabel.text = @"展馆名称：";
    }else if (index == 3) {
        titleLabel.text = @"布展：";
    }else if (index == 4) {
        titleLabel.text = @"撤展：";
    }else if (index == 5) {
        titleLabel.text = @"出发地：";
    }else if (index == 6) {
        titleLabel.text = @"目的地：";
    }else if (index == 7) {
        titleLabel.text = @"展厅：";
    }else if (index == 8) {
        titleLabel.text = @"联系人：";
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-0.35*kScreenWidth, 0, 0.2*kScreenWidth, 0.2*kScreenWidth)];
        if ([self.model.spellStatus isEqualToString:@"2"]) {
            imageView.image = [UIImage imageNamed:@"Spelling_success_icon"];
        }else if ([self.model.spellStatus isEqualToString:@"3"]) {
            imageView.image = [UIImage imageNamed:@"Spelling_failure_icon"];
        }else {
            imageView.image = [UIImage imageNamed:@""];
        }
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [cell.contentView addSubview:imageView];
    }else if (index == 9) {
        titleLabel.text = @"联系电话：";
    }else if (index == 10) {
        titleLabel.text = @"需求：";
    }else if (index == 11) {
        titleLabel.text = @"备注：";
    }else {
        
    }
    [cell.contentView addSubview:titleLabel];
    titleLabel.attributedText = [[ZWToolActon shareAction]createBothEndsWithLabel:titleLabel textAlignmentWith:0.18*kScreenWidth];

    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), 0, 0.7*kScreenWidth, self.placeholderH)];
    detailLabel.font = smallMediumFont;
    detailLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
    if (index == 0) {
        self.titleH = [[ZWToolActon shareAction]adaptiveTextHeight:self.model.title textFont:normalFont textWidth:0.75*kScreenWidth]+20;
        detailLabel.numberOfLines = 0;
        detailLabel.text = self.model.title;
        detailLabel.textColor = [UIColor blackColor];
        detailLabel.font = normalFont;
        detailLabel.frame = CGRectMake(0.03*kScreenWidth, 0, 0.75*kScreenWidth, self.titleH);
        if (self.type == 1) {
            if ([self.model.spellStatus isEqualToString:@"1"]) {
                UIButton *editorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                editorBtn.frame = CGRectMake(0.94*kScreenWidth-0.15*kScreenWidth, 0.02*kScreenWidth, 0.15*kScreenWidth, 0.05*kScreenWidth);
                editorBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:157/255.0 blue:43/255.0 alpha:1.0];
                [editorBtn setTitle:@"编辑" forState:UIControlStateNormal];
                editorBtn.titleLabel.font = smallMediumFont;
                [editorBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [editorBtn addTarget:self action:@selector(editorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:editorBtn];
                [self setTheRoundedCorners:editorBtn];
            }
        }
    }else if (index == 1) {
        detailLabel.text = [self valueText:self.model.exhibitionName];
    }else if (index == 2) {
        detailLabel.text = [self valueText:self.model.exhibitionHall];
    }else if (index == 3) {
        detailLabel.text = [self valueText:[self timeWithStr:self.model.decorateStartTime]];
    }else if (index == 4) {
        detailLabel.text = [self valueText:[self timeWithStr:self.model.decorateEndTime]];
    }else if (index == 5) {
        detailLabel.text = [self valueText:self.model.origin];
    }else if (index == 6) {
        detailLabel.text = [self valueText:self.model.destination];
    }else if (index == 7) {
        detailLabel.text = [NSString stringWithFormat:@"%@馆",[self valueText:self.model.hallNumber]];
    }else if (index == 8) {
        detailLabel.text = [self valueText:self.model.contacts];
    }else if (index == 9) {
        detailLabel.text = [self valueText:self.model.telephone];
        detailLabel.textColor = skinColor;
    }else if (index == 10) {
        detailLabel.numberOfLines = 0;
        self.demandH = [[ZWToolActon shareAction]adaptiveTextHeight:[self valueText:self.model.requirement] textFont:smallMediumFont textWidth:0.7*kScreenWidth]+10;
        detailLabel.text = [self valueText:self.model.requirement];
        detailLabel.frame = CGRectMake(CGRectGetMaxX(titleLabel.frame), 0, 0.7*kScreenWidth, self.demandH);
    }else if (index == 11) {
        detailLabel.numberOfLines = 0;
        self.remarksH = [[ZWToolActon shareAction]adaptiveTextHeight:[self valueText:self.model.remarks] textFont:smallMediumFont textWidth:0.7*kScreenWidth]+10;
        detailLabel.text = [self valueText:self.model.remarks];
        detailLabel.frame = CGRectMake(CGRectGetMaxX(titleLabel.frame), 0, 0.7*kScreenWidth, self.remarksH);
    }else {
        detailLabel.text = [NSString stringWithFormat:@"截止时间：%@",[self valueText:[self timeTransformation:self.model.invalidTime]]];
        detailLabel.textAlignment = NSTextAlignmentRight;
        detailLabel.textColor = [UIColor grayColor];
    }
    [cell.contentView addSubview:detailLabel];
}
- (void)editorBtnClick:(UIButton *)btn {
    ZWMineSpellListFailureVC *spellDetailVC = [[ZWMineSpellListFailureVC alloc]init];
    spellDetailVC.model = self.model;
    [self.ff_navViewController pushViewController:spellDetailVC animated:YES];
}

- (void)setTheRoundedCorners:(UIView *)view {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft) cornerRadii:CGSizeMake(0.025*kScreenWidth,0.025*kScreenWidth)];//圆角大小
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return self.titleH;
    }else if(indexPath.row == 10) {
        return self.demandH;
    }else if(indexPath.row == 11) {
        return self.remarksH;
    }else {
        return self.placeholderH;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.03*kScreenWidth;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5*kScreenWidth;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    if (self.type == 1) {
        if ([self.model.spellStatus isEqualToString:@"1"]) {
            [view addSubview:[self createView]];
        }
    }
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 9) {
        [[ZWToolActon shareAction]dialTheNumber:self.model.telephone];
    }
}

- (UIView *)createView {
    
    CGFloat btnWith = (0.94*kScreenWidth-2)/3;
    CGFloat btnHeight = 0.08*kScreenWidth;
    
    UIView *toolView = [[UIView alloc]initWithFrame:CGRectMake(0, 0.05*kScreenWidth, 0.94*kScreenWidth, 0.08*kScreenWidth)];
    toolView.layer.cornerRadius = 3;
    toolView.layer.masksToBounds = YES;
    toolView.layer.borderWidth = 1;
    toolView.layer.borderColor = skinColor.CGColor;
    
    UIButton *undoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    undoBtn.frame = CGRectMake(1, 1, btnWith-1, btnHeight-2);
    [undoBtn setTitle:@"撤销" forState:UIControlStateNormal];
    [undoBtn setImage:[UIImage imageNamed:@"undo_icon"] forState:UIControlStateNormal];
    [undoBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15,0,0)];
    [undoBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15,0,0)];
    undoBtn.titleLabel.font = normalFont;
    [undoBtn setTitleColor:skinColor forState:UIControlStateNormal];
    [undoBtn addTarget:self action:@selector(undoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:undoBtn];
    
    UIView *lineOne = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(undoBtn.frame), 0, 1, btnHeight)];
    lineOne.backgroundColor = skinColor;
    [toolView addSubview:lineOne];
    
    UIButton *successfulBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    successfulBtn.frame = CGRectMake(CGRectGetMaxX(lineOne.frame), 1, btnWith-1, btnHeight-2);
    [successfulBtn setTitle:@"拼单成功" forState:UIControlStateNormal];
    [successfulBtn setImage:[UIImage imageNamed:@"sepll_list_icon"] forState:UIControlStateNormal];
    [successfulBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15,0,0)];
    [successfulBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15,0,0)];
    successfulBtn.titleLabel.font = normalFont;
    [successfulBtn setTitleColor:skinColor forState:UIControlStateNormal];
    [successfulBtn addTarget:self action:@selector(successfulBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:successfulBtn];
    
    UIView *lineTwo = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(successfulBtn.frame), 0, 1, btnHeight)];
    lineTwo.backgroundColor = skinColor;
    [toolView addSubview:lineTwo];
    
    UIButton *topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    topBtn.frame = CGRectMake(CGRectGetMaxX(lineTwo.frame), 1, btnWith-1, btnHeight-2);
    if ([self.model.topRemaining isEqualToString:@"1"]) {
        [topBtn setTitle:@"置顶(1)" forState:UIControlStateNormal];
    }else {
        [topBtn setTitle:@"置顶(0)" forState:UIControlStateNormal];
    }
    [topBtn setImage:[UIImage imageNamed:@"thetop_icon"] forState:UIControlStateNormal];
    [topBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15,0,0)];
    [topBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15,0,0)];
    topBtn.titleLabel.font = normalFont;
    [topBtn setTitleColor:skinColor forState:UIControlStateNormal];
    [topBtn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:topBtn];

    return toolView;
}

- (void)undoBtnClick:(UIButton *)btn {
    __weak typeof (self) weakSelf = self;
    [[ZWAlertAction sharedAction]showTwoAlertTitle:@"提示" message:@"撤销即是删除该拼单，是否确认撤销？" cancelTitle:@"否" confirmTitle:@"是" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf deleteSepllList];
    } actionCancel:^(UIAlertAction * _Nonnull actionCancel) {
        
    } showInView:self.ff_navViewController];
}

- (void)deleteSepllList {
    NSDictionary *myParametes =@{
        @"spellId":self.model.spellId
    };
    if (myParametes) {
        __weak typeof (self) weakSelf = self;
        [[ZWDataAction sharedAction]postReqeustWithURL:zwDeleteMySpellList parametes:myParametes successBlock:^(NSDictionary * _Nonnull data) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            if (zw_issuccess) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshSepllListData" object:nil];
                [strongSelf.ff_navViewController popViewControllerAnimated:YES];
            }
        } failureBlock:^(NSError * _Nonnull error) {
            
        } showInView:self];
    }
}

- (void)successfulBtnClick:(UIButton *)btn {
    
    __weak typeof (self) weakSelf = self;
    [[ZWAlertAction sharedAction]showTwoAlertTitle:@"提示" message:@"是否确认拼单成功？" cancelTitle:@"否" confirmTitle:@"是" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf createSpellingSuccess];
    } actionCancel:^(UIAlertAction * _Nonnull actionCancel) {
        
    } showInView:self.ff_navViewController];
    
}

- (void)createSpellingSuccess {
    NSDictionary *myParametes =@{
        @"spellId":self.model.spellId,
        @"spellStatus":@"2"
    };
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]postReqeustWithURL:zwSuccessfulMySpellList parametes:myParametes successBlock:^(NSDictionary * _Nonnull data) {
        __weak typeof (weakSelf) strongSelf = weakSelf;
        if (zw_issuccess) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshSepllListData" object:nil];
            self.model.spellStatus = @"2";
            [strongSelf.tableView reloadData];
        }
    } failureBlock:^(NSError * _Nonnull error) {

    } showInView:self];
}

- (void)topBtnClick:(UIButton *)btn {
    if ([self.model.topRemaining isEqualToString:@"0"]) {
        [self showAlertWithMessage:@"每个拼单每天只能置顶一次"];
        return;
    }
    NSDictionary *myParametes =@{
        @"spellId":self.model.spellId,
    };
    if (myParametes) {
        __weak typeof (self) weakSelf = self;
        [[ZWDataAction sharedAction]postReqeustWithURL:zwSetTopMySpellList parametes:myParametes successBlock:^(NSDictionary * _Nonnull data) {
            __weak typeof (weakSelf) strongSelf = weakSelf;
            if (zw_issuccess) {
                strongSelf.model.topRemaining = @"0";
                [strongSelf showAlertWithMessage:@"置顶成功"];
                [strongSelf.tableView reloadData];
            }
        } failureBlock:^(NSError * _Nonnull error) {
            
        } showInView:self];
    }
}


- (void)showAlertWithMessage:(NSString *)message {
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:message confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        
    } showInView:self.ff_navViewController];
}





-(NSString *)timeTransformation:(NSString *)time {
    NSString *string = [NSString stringWithFormat:@"%@",time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [dateFormatter dateFromString:string];
    dateFormatter.dateFormat = @"yyyy.MM.dd";
    NSTimeInterval interval = [date timeIntervalSince1970];
    NSDate *dateOne = [NSDate dateWithTimeIntervalSince1970:interval];
    NSString *dateString = [dateFormatter stringFromDate:dateOne];
    NSLog(@"我的日期：%@",dateString);
    return [NSString stringWithFormat:@"%@",dateString];
}


-(NSString *)timeOtherTransformation:(NSString *)time {
    NSString *string = [NSString stringWithFormat:@"%@",time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [dateFormatter dateFromString:string];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSTimeInterval interval = [date timeIntervalSince1970];
    NSDate *dateOne = [NSDate dateWithTimeIntervalSince1970:interval];
    NSString *dateString = [dateFormatter stringFromDate:dateOne];
    NSLog(@"我的日期：%@",dateString);
    return [NSString stringWithFormat:@"%@",dateString];
}

-(NSString *)valueText:(NSString *)text {
    if (text.length == 0) {
        return @"无";
    }else {
        return text;
    }
}

-(NSString *)timeWithStr:(NSString *)time {
    if (time.length == 0) {
        return @"～";
    }else {
       return [self timeOtherTransformation:time];
    }
}

@end
