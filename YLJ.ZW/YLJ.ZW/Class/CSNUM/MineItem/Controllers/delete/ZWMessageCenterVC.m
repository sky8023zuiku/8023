//
//  ZWMessageCenterVC.m
//  YLJ.ZW
//
//  Created by G G on 2019/8/26.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWMessageCenterVC.h"
#import "ZWMessageListCell.h"
#import "ZWMineRqust.h"
#import "ZWMineResponse.h"
#import <MJRefresh.h>

@interface ZWMessageCenterVC ()<UITableViewDelegate,UITableViewDataSource,ZWMessageListCellDelegate>

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign)NSInteger seletedIndex;
@property(nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic ,strong)NSMutableArray *deleteArray;//需要被删除的数据
@property(nonatomic, assign)NSInteger page;
@property(strong, nonatomic)UIView *showView;
@property(nonatomic, assign)NSInteger type;//0 or 1
@property(nonatomic, strong)UIButton *allSelectedBtn;

@end

@implementation ZWMessageCenterVC

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) style:UITableViewStyleGrouped];
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:246/255.0 blue:248/255.0 alpha:1.0];
    return _tableView;
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    [self createNavigationBar];
    self.page = 1;
    [self createRequest:self.page];
    [self refreshHeader];
    [self refreshFooter];
    
}
- (void)createUI {
    self.type = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataSource = [NSMutableArray array];
    self.deleteArray = [NSMutableArray array];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.showView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.showView.mas_top);
    }];

    [self.showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@zwTabBarHeight);
        make.bottom.equalTo(self.view).offset(zwTabBarHeight);
    }];
}
//- (void)createNavigationBar {
//    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, zwNavBarHeight-1)];
//    navView.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1];
//    [self.view addSubview:navView];
//
//    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(navView.frame), kScreenWidth, 1)];
//    lineView.backgroundColor = [UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1];
//    [self.view addSubview:lineView];
//
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(15, zwStatusBarHeight+7, 30, 30);
//    [backBtn setBackgroundImage:[UIImage imageNamed:@"left_black_arrow"] forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [navView addSubview:backBtn];
//
//    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2-75, zwStatusBarHeight, 150, zwNavBarHeight-zwStatusBarHeight)];
//    titleLabel.text = @"消息中心";
//    titleLabel.font = [UIFont systemFontOfSize:19];
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.textColor = [UIColor blackColor];
//    [navView addSubview:titleLabel];
//
//    CGFloat btnWidth = [[ZWToolActon shareAction]adaptiveTextWidth:@"管理" labelFont:[UIFont systemFontOfSize:16]];
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightBtn.frame = CGRectMake(kScreenWidth-15-btnWidth, zwStatusBarHeight, btnWidth, zwNavBarHeight-zwStatusBarHeight);
//    [rightBtn setTitle:@"管理" forState:UIControlStateNormal];
//    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [navView addSubview:rightBtn];
//
//}
//- (void)backBtnClick:(UIButton *)btn {
//    [self.navigationController popViewControllerAnimated:YES];
//}
//- (void)rightBtnClick:(UIButton *)btn {
//    if ([btn.titleLabel.text isEqualToString:@"管理"]) {
//        self.type = 1;
//        [btn setTitle:@"完成" forState:UIControlStateNormal];
//        [self.tableView setEditing:YES animated:YES];
//        [self showEitingView:YES];
//        if (self.allSelectedBtn.selected) {
//            self.allSelectedBtn.selected = !self.allSelectedBtn.selected;
//            [self.allSelectedBtn setBackgroundImage:[UIImage imageNamed:@"message_guanli"] forState:UIControlStateNormal];
//        }
//    }else {
//        self.type = 0;
//        [self.deleteArray removeAllObjects];
//        [btn setTitle:@"管理" forState:UIControlStateNormal];
//        [self.tableView setEditing:NO animated:YES];
//        [self showEitingView:NO];
//    }
//}

- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
    [[YNavigationBar sharedInstance]createRightBarWithTitle:@"管理" barItem:self.navigationItem target:self action:@selector(rightItemClick:)];
}
- (void)goBack:(UINavigationItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightItemClick:(UINavigationItem *)item {
    if ([item.title isEqualToString:@"管理"]) {
        self.type = 1;
        self.navigationItem.rightBarButtonItem.title = @"完成";
        [self.tableView setEditing:YES animated:YES];
        [self showEitingView:YES];
        if (self.allSelectedBtn.selected) {
            self.allSelectedBtn.selected = !self.allSelectedBtn.selected;
            [self.allSelectedBtn setBackgroundImage:[UIImage imageNamed:@"message_guanli"] forState:UIControlStateNormal];
        }
    }else {
        self.type = 0;
        [self.deleteArray removeAllObjects];
        self.navigationItem.rightBarButtonItem.title = @"管理";
        [self.tableView setEditing:NO animated:YES];
        [self showEitingView:NO];
    }

}
//刷新
- (void)refreshHeader {
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page = 1;
        [strongSelf.dataSource removeAllObjects];
        [strongSelf createRequest:self.page];
    }];
}
//加载
- (void)refreshFooter {
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page += 1;
        [strongSelf createRequest:self.page];
    }];
}
#pragma UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
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
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.contentView.backgroundColor = [UIColor colorWithRed:245/255.0 green:246/255.0 blue:248/255.0 alpha:1.0];
    [self createTableViewCell:cell cellForRowAtIndexPath:indexPath];
    
    return cell;
}
- (void)createTableViewCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZWMessageListModel *model = self.dataSource[indexPath.row];
    if (model.isOpen == 0) {
        UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 0.2*kScreenWidth-30, 0.2*kScreenWidth-30)];
        headImage.image = [UIImage imageNamed:@"h1.jpg"];
        headImage.layer.cornerRadius = 0.1*kScreenWidth-15;
        headImage.layer.masksToBounds = YES;
        [cell.contentView addSubview:headImage];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headImage.frame)+10, 0, 0.4*kScreenWidth, 0.2*kScreenWidth)];
        nameLabel.text = model.name;
        nameLabel.font = normalFont;
        [cell.contentView addSubview:nameLabel];
        
        CGPoint point = CGPointMake(kScreenWidth-30, 0.1*kScreenWidth);
        CAShapeLayer *layer = [self createIndicatorWithPosition:point color:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]];
        [cell.contentView.layer addSublayer:layer];
        
        
        UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-0.2*kScreenWidth-50, 0, 0.2*kScreenWidth, 0.2*kScreenWidth)];
        dateLabel.text = @"2019/05/06";
        dateLabel.textAlignment = NSTextAlignmentRight;
        dateLabel.font = smallMediumFont;
        dateLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        [cell.contentView addSubview:dateLabel];
    }else {
        
        ZWMessageListCell *messageListCell = [[ZWMessageListCell alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 0.8*kScreenWidth-10)];
        messageListCell.backgroundColor = [UIColor whiteColor];
        messageListCell.layer.cornerRadius = 5;
        messageListCell.layer.shadowColor = [UIColor blackColor].CGColor;
        messageListCell.layer.shadowOffset = CGSizeZero; //设置偏移量为0,四周都有阴影
        messageListCell.layer.shadowRadius = 5.0f;//阴影半径，默认3
        messageListCell.layer.shadowOpacity = 0.2f;
        messageListCell.tag = indexPath.row;
        messageListCell.delegate = self;
        messageListCell.model = model;
        [cell.contentView addSubview:messageListCell];
    }
}

#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZWMessageListModel *model = self.dataSource[indexPath.row];
    if (model.isOpen == 1) {
        return 0.8*kScreenWidth;
    }else {
        return 0.2*kScreenWidth;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZWMessageListModel *model = self.dataSource[indexPath.row];
    if (self.type == 0) {
        model.isOpen = 1;
        [self.tableView reloadData];
    }else {
        [self.deleteArray addObject:model.messageId];
        NSLog(@"选中：%@",self.deleteArray);
        if (self.deleteArray.count == self.dataSource.count) {
            if (!self.allSelectedBtn.selected) {
                self.allSelectedBtn.selected = !self.allSelectedBtn.selected;
                [self.allSelectedBtn setBackgroundImage:[UIImage imageNamed:@"message_guanli_selected"] forState:UIControlStateNormal];
            }
        }
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath  {
    ZWMessageListModel *model = self.dataSource[indexPath.row];
    if (self.type == 1) {
        [self.deleteArray removeObject:model.messageId];
        if (self.allSelectedBtn.selected) {
            self.allSelectedBtn.selected = !self.allSelectedBtn.selected;
            [self.allSelectedBtn setBackgroundImage:[UIImage imageNamed:@"message_guanli"] forState:UIControlStateNormal];
        }
        NSLog(@"撤销：%@",self.deleteArray);
    }else{

    }
}

//指示器
- (CAShapeLayer *)createIndicatorWithPosition:(CGPoint)position color:(UIColor *)color {
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(5, 5)];
    [path moveToPoint:CGPointMake(5, 5)];
    [path addLineToPoint:CGPointMake(10, 0)];
    [path closePath];
    layer.path = path.CGPath;
    layer.lineWidth = 0.8;
    layer.strokeColor = [UIColor blackColor].CGColor;
 
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    CGPathRelease(bound);
    layer.position = position;
    
    return layer;
    
}

- (void)createRequest:(NSInteger)page {
    ZWMessageListRquest * request = [[ZWMessageListRquest alloc]init];
    request.pageNo = page;
    request.pageSize = 10;
    __weak typeof (self) weakSelf = self;
    [request postRequestCompleted:^(YHBaseRespense *respense) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        if (respense.isFinished) {
            NSArray *myData = respense.data;
            NSMutableArray *myArray = [NSMutableArray array];
            for (NSDictionary *myDic in myData) {
                ZWMessageListModel *model = [ZWMessageListModel parseJSON:myDic];
                [myArray addObject:model];
            }
            [strongSelf.dataSource addObjectsFromArray:myArray];
            [strongSelf.tableView reloadData];
            if (strongSelf.dataSource.count == 0) {
                [strongSelf showBlankPagesWithImage:@"qita_img_wu" withDitail:@"暂无消息" withType:1];
            }
        }else {
//            [strongSelf showBlankPagesWithImage:requestFailedBlankPagesImageName withDitail:@"当前网络异常，请检查网络" withType:2];
        }
    }];
}
- (void)showBlankPagesWithImage:(NSString *)imageName withDitail:(NSString *)ditail withType:(NSInteger)type {
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.1*kScreenWidth, 0.1*kScreenHeight+zwNavBarHeight, 0.8*kScreenWidth, 0.5*kScreenWidth)];
    imageView.image = [UIImage imageNamed:imageName];
    [self.view addSubview:imageView];
    
    UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+20, kScreenWidth, 30)];
    myLabel.text = ditail;
    myLabel.font = bigFont;
    myLabel.textColor = [UIColor lightGrayColor];
    myLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:myLabel];
    
//    if (type == 2) {
//        UIButton *reloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        reloadBtn.frame = CGRectMake(0.3*kScreenWidth, CGRectGetMaxY(myLabel.frame)+25, 0.4*kScreenWidth, 0.1*kScreenWidth);
//        [reloadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
//        reloadBtn.layer.borderColor = skinColor.CGColor;
//        reloadBtn.titleLabel.font = normalFont;
//        reloadBtn.layer.cornerRadius = 0.05*kScreenWidth;
//        reloadBtn.layer.masksToBounds = YES;
//        [reloadBtn setTitleColor:skinColor forState:UIControlStateNormal];
//        reloadBtn.layer.borderWidth = 1;
//        [reloadBtn addTarget:self action:@selector(reloadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:reloadBtn];
//    }
}

//- (void)reloadBtnClick:(UIButton *)btn {
//
//}


-(void)tapClose:(NSInteger)index {
    ZWMessageListModel *model = self.dataSource[index];
    model.isOpen = 0;
    [self.tableView reloadData];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"--iiiii--%ld",(long)indexPath.row);
    
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (void)showEitingView:(BOOL)isShow{
    [self.showView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(isShow?0:zwTabBarHeight);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}
- (UIView *)showView{
    if (!_showView) {
        _showView = [[UIView alloc] init];
        _showView.layer.shadowColor = [UIColor blackColor].CGColor;
        _showView.layer.shadowOffset = CGSizeZero; //设置偏移量为0,四周都有阴影
        _showView.layer.shadowRadius = 5.0f;//阴影半径，默认3
        _showView.layer.shadowOpacity = 0.2f;
        
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(kScreenWidth -100, 10, 80, 30);
        deleteBtn.layer.cornerRadius = 15;
        deleteBtn.layer.masksToBounds = YES;
        deleteBtn.layer.borderWidth = 1;
        deleteBtn.layer.borderColor = skinColor.CGColor;
        [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        deleteBtn.titleLabel.font = normalFont;
        [deleteBtn setTitleColor:skinColor forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_showView addSubview:deleteBtn];
        
        self.allSelectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.allSelectedBtn.frame = CGRectMake(20, 15, 20, 20);
        [self.allSelectedBtn setBackgroundImage:[UIImage imageNamed:@"message_guanli"] forState:UIControlStateNormal];
        [self.allSelectedBtn addTarget:self action:@selector(allSelectedBtnClcik:) forControlEvents:UIControlEventTouchUpInside];
        [_showView addSubview:self.allSelectedBtn];
        
        UILabel *selectLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.allSelectedBtn.frame)+10, CGRectGetMinY(self.allSelectedBtn.frame), 80, CGRectGetWidth(self.allSelectedBtn.frame))];
        selectLabel.text = @"全选";
        selectLabel.textAlignment = NSTextAlignmentLeft;
        [_showView addSubview:selectLabel];
        
    }
    return _showView;
}

-(void)allSelectedBtnClcik:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self.allSelectedBtn setBackgroundImage:[UIImage imageNamed:@"message_guanli_selected"] forState:UIControlStateSelected];
        NSMutableArray *messageID = [NSMutableArray array];
        for (int i = 0; i< self.dataSource.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            //全选实现方法
            ZWMessageListModel *model = self.dataSource[indexPath.row];;
            [messageID addObject:model.messageId];
            [_tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
        }
        
        //点击全选的时候需要清除deleteArray里面的数据，防止deleteArray里面的数据和列表数据不一致
        if (self.deleteArray.count >0) {
            [self.deleteArray removeAllObjects];
        }
        [self.deleteArray addObjectsFromArray:messageID];
    }else{
        [self.allSelectedBtn setBackgroundImage:[UIImage imageNamed:@"message_guanli"] forState:UIControlStateNormal];
        //取消选中
        for (int i = 0; i< self.dataSource.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            [_tableView deselectRowAtIndexPath:indexPath animated:NO];
            
        }
        [self.deleteArray removeAllObjects];
    }
}
- (void)deleteBtnClick:(UIButton *)btn {
    NSLog(@"%lu",(unsigned long)self.deleteArray.count);
    if (self.deleteArray.count == 0) {
        [self showAlertWithMessage:@"无可删除的消息"];
        return;
    }
    ZWDeleteListRquest *request = [[ZWDeleteListRquest alloc]init];
    request.idList = self.deleteArray;
    __weak typeof (self) weakSelf = self;
    [[ZWAlertAction sharedAction]showTwoAlertTitle:@"提示" message:@"是否确认删除" cancelTitle:@"否" confirmTitle:@"是" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        [request postRequestCompleted:^(YHBaseRespense *respense) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            if (respense.isFinished) {
                [strongSelf.tableView reloadData];
            }else {
                [strongSelf showAlertWithMessage:@"删除失败，请检查网络或稍后再试"];
            }
        }];
    } actionCancel:^(UIAlertAction * _Nonnull actionCancel) {
        
    } showInView:self];
}

- (void)mySwitchClick:(UISwitch *)uSwitch {
    ZWChildUserListModel *model = self.dataSource[uSwitch.tag];
    ZWChildUserStatusRequest *request = [[ZWChildUserStatusRequest alloc]init];
    request.childrenId = model.childrenId;
    if ([model.status intValue]==1) {
        request.status = @"0";
    }else {
        request.status = @"1";
    }
    [request postFormDataWithProgress:nil RequestCompleted:^(YHBaseRespense *respense) {
        if (respense.isFinished) {
            NSLog(@"%@",respense.data);
        }else {
            NSLog(@"---%@",respense.data);
        }
    }];
}

- (void)showAlertWithMessage:(NSString *)message {
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:message confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        
    } showInView:self];
}


@end
