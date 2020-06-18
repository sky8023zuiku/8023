//
//  ZWSelectExIntIndustriesVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/5/9.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWSelectExIntIndustriesVC.h"
#import "ZWLevel3SelectView.h"
#import "ZWIndustriesModel.h"
#import "ZWChosenIndustriesModel.h"
#import "ZWLabelView.h"
#import "ZWEditCompanyIntroductionVC.h"
#import <MBProgressHUD.h>

@interface ZWSelectExIntIndustriesVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)UIView *topView;

@property(nonatomic, strong)UICollectionViewFlowLayout *layout;

@property(nonatomic, strong)ZWLevel3SelectView *selectView;

@property(nonatomic, strong)NSArray *dataSource;

@property(nonatomic, strong)NSMutableDictionary *industriesDic;

@property(nonatomic, strong)NSMutableArray *GroupTempArray;

@property(nonatomic, strong)NSMutableArray *industriesArray;

@property(nonatomic, strong)ZWLabelView *labelView;

@property(nonatomic, strong)NSArray *industriesIds;

@end

@implementation ZWSelectExIntIndustriesVC

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0.3*kScreenWidth, kScreenWidth, kScreenHeight-zwNavBarHeight-0.3*kScreenWidth) style:UITableViewStylePlain];
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNavigationBar];
    [self createNotice];
}
- (void)createNotice {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(takeIndustriesModel:) name:@"takeIndustriesModel" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteIndustriesItem:) name:@"deleteIndustriesItem" object:nil];
}

- (void)takeIndustriesModel:(NSNotification *)notice {
    
    ZWChosenIndustriesModel *model = notice.object;
    if (self.industriesArray.count <= 5) {
        if (self.industriesArray.count>0) {
            for (int i = 0; i<self.industriesArray.count; i++) {
                ZWChosenIndustriesModel *myModel = self.industriesArray[i];
                if ([model.industries2Id isEqualToNumber:myModel.industries2Id]) {
                    [self.industriesArray replaceObjectAtIndex:i withObject:model];
                    NSLog(@"---我的值---%@",self.industriesArray);
                    [self createTopItem:self.industriesArray];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"mySelectIndustries" object:self.industriesArray];
                    return;
                }
            }
        }
        if (self.industriesArray.count<5) {
            [self.industriesArray addObject:model];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"mySelectIndustries" object:self.industriesArray];
        }else {
            [self showOneAlertWithMessage:@"每个用户只能选择五个行业"];
            [self.tableView reloadData];
        }
    }
    NSLog(@"-----%@",self.industriesArray);
    [self createTopItem:self.industriesArray];
}
- (void)deleteIndustriesItem:(NSNotification *)notice {
    self.industriesArray = notice.object;
    [self createTopItem:self.industriesArray];
    NSLog(@"---333--%@",self.industriesArray);
}

- (void)createTopItem:(NSArray *)array {
    
    [self.labelView removeFromSuperview];
    self.labelView = [[ZWLabelView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 0.3*kScreenWidth-40) dataArr:array];
    __weak typeof(self) weakSelf = self;
    [self.labelView btnClickBlock:^(NSInteger index) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.industriesArray removeObjectAtIndex:index];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"mySelectIndustries" object:self.industriesArray];
        [strongSelf.tableView reloadData];
        [strongSelf createTopItem:strongSelf.industriesArray];
    }];
    
    NSMutableArray *industriesIdArr = [NSMutableArray array];
    for (ZWChosenIndustriesModel *model in array) {
        NSNumber *industriesId = model.industries3Id;
        [industriesIdArr addObject:industriesId];
    }
    self.model.industryIdList = industriesIdArr;
    self.industriesIds = industriesIdArr;
    NSLog(@"======%@",self.model.industryIdList);
    
    [self.topView addSubview:self.labelView];
    
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"takeIndustriesModel" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"deleteIndustriesItem" object:nil];
}

- (void)createNavigationBar {
    
    UIBarButtonItem *leftOne = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] style:UIBarButtonItemStylePlain target:self action:@selector(go1Back:)];
    leftOne.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItems = @[leftOne];
    [[YNavigationBar sharedInstance]createRightBarWithTitle:@"提交" barItem:self.navigationItem target:self action:@selector(right2ItemClcik:)];

}
- (void)go1Back:(UINavigationItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)right2ItemClcik:(UINavigationItem *)item {
    
    NSLog(@"%@",self.industriesIds);
    if (self.industriesIds.count == 0) {
        [self showOneAlertWithMessage:@"您所涉及到的行业不能为空，请选择后提交"];
        return;
    }
    __weak typeof (self) weakSelf = self;
    [[ZWAlertAction sharedAction]showTwoAlertTitle:@"提示" message:@"是否确提交所选择的行业" cancelTitle:@"否" confirmTitle:@"是" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf submitIndustriesInformation];
    } actionCancel:^(UIAlertAction * _Nonnull actionCancel) {
        
    } showInView:self];
    
}

- (void)submitIndustriesInformation {
    
    NSDictionary *parametes;
    if (self.industriesIds) {
        parametes = @{@"idList":self.industriesIds,
                      @"type":self.type};
    }
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]postReqeustWithURL:zwUpdateMyInterestIndustriesList parametes:parametes successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (zw_issuccess) {
            [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:@"您感兴趣的行业变更成功" confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
                __strong typeof (weakSelf) strongSelf = weakSelf;
                [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshIndustryDataInterest" object:nil];
                [strongSelf.navigationController popViewControllerAnimated:YES];
            } showInView:strongSelf];
        }else {
            [strongSelf showOneAlertWithMessage:@"您感兴趣的行业变更失败，请稍后再试或联系客服"];
        }
    } failureBlock:^(NSError * _Nonnull error) {

    } showInView:self.view];
    
}

- (void)createUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.industriesArray = [NSMutableArray array];
    
    [self.industriesArray addObjectsFromArray:self.industriesArr];
        
    _layout=[[UICollectionViewFlowLayout alloc]init];
    [_layout prepareLayout];
    //设置每个cell与相邻的cell之间的间距
    _layout.minimumInteritemSpacing = 1;
    _layout.sectionInset = UIEdgeInsetsMake(0, 0.03*kScreenWidth, 0.03*kScreenWidth, 0.03*kScreenWidth);
    _layout.minimumLineSpacing=0.03*kScreenWidth;
    _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    NSMutableArray *myArray = [NSMutableArray array];
    for (NSDictionary *myDic in self.myIndustries) {
        ZWIndustriesModel *model = [ZWIndustriesModel parseJSON:myDic];
        [myArray addObject:model];
    }
    self.dataSource = myArray;

    [self.view addSubview:self.tableView];
    
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.3*kScreenWidth)];
    [self.view addSubview:self.topView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0.3*kScreenWidth-30, kScreenWidth-40, 20)];
    label.text = @"提示：每个用户最多只可以选择五个行业（点击已选项可删除）";
    label.font = smallFont;
    label.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    [self.topView addSubview:label];
    
    
    NSLog(@"------%@",self.industriesArray);
    
    [self createTopItem:self.industriesArray];
    
    [self SortData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.GroupTempArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *Array = [self.industriesDic objectForKey:self.GroupTempArray[section]];
    return Array.count;
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
    [self createTableViewCell:cell cellForRowAtIndexPath:indexPath];
    return cell;
    
}

- (void)createTableViewCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *Array = [self.industriesDic objectForKey:self.GroupTempArray[indexPath.section]];
    ZWIndustriesModel *model = Array[indexPath.row];
    
    NSInteger a = model.thirdIndustryList.count%4;
    NSInteger b = model.thirdIndustryList.count/4;
    CGFloat height;
    if (a!=0) {
        height = 0.03*kScreenWidth*(b+2) +0.08*kScreenWidth*(b+1)+0.1*kScreenWidth;
    }else {
        height = 0.03*kScreenWidth*(b+1) +0.08*kScreenWidth*b+0.1*kScreenWidth;
    }
    self.selectView = [[ZWLevel3SelectView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, height) collectionViewLayout:_layout];
    self.selectView.model = model;
    self.selectView.selectArray = self.industriesArray;
    [cell.contentView addSubview:self.selectView];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *Array = [self.industriesDic objectForKey:self.GroupTempArray[indexPath.section]];
    ZWIndustriesModel *model = Array[indexPath.row];
    NSInteger a = model.thirdIndustryList.count%4;
    NSInteger b = model.thirdIndustryList.count/4;
    
    CGFloat height;
    if (a!=0) {
        height = 0.03*kScreenWidth*(b+2) +0.08*kScreenWidth*(b+1)+0.1*kScreenWidth;
    }else {
        height = 0.03*kScreenWidth*(b+1) +0.08*kScreenWidth*b+0.1*kScreenWidth;
    }
    return height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSLog(@"111--111");
    return 0.08*kScreenWidth;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = zwGrayColor;
    
    UILabel *wordLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.025*kScreenWidth, 0, 0.5*kScreenWidth, 0.08*kScreenWidth)];
    wordLabel.text = self.GroupTempArray[section];
    wordLabel.font = boldNormalFont;
    [view addSubview:wordLabel];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView reloadData];
}

//快速索引
- (NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.GroupTempArray;
}

- (NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}

-(void)SortData{
    _industriesDic = [NSMutableDictionary dictionary];
    NSMutableArray *arr=nil;
    for (int i = 0; i < self.dataSource.count; i++) {
        /*取出每个model*/
        ZWIndustriesModel *model = self.dataSource[i];
        NSString *T = [self firstCharactorWithString:model.secondIndustryName];
        if([[_industriesDic allKeys] containsObject:T]){
            arr=[_industriesDic objectForKey:T];
            [arr addObject:model];
            [_industriesDic setObject:arr forKey:T];
        }else{
            arr= [[NSMutableArray alloc]initWithObjects:model, nil];
            [_industriesDic setObject:arr forKey:T];
        }
    }
    self.GroupTempArray= [NSMutableArray arrayWithArray:[[_industriesDic allKeys] sortedArrayUsingSelector:@selector(compare:)]];
    [self.tableView reloadData];
//    NSString *str = [[ZWToolActon shareAction]transformArr:self.GroupTempArray];
//    NSLog(@"----0000---%@",str);
}

- (NSString *)firstCharactorWithString:(NSString *)string
{
    NSMutableString *str = [NSMutableString stringWithString:string];
    CFStringTransform((CFMutableStringRef) str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    NSString *pinYin = [str capitalizedString];
    return [pinYin substringToIndex:1];
}


- (void)showOneAlertWithMessage:(NSString *)message {
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:message confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        
    } showInView:self];
}

@end
