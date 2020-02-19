//
//  ZWCompanyDetailsVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/19.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWCompanyDetailsVC.h"
#import "DCCycleScrollView.h"

#import "ZWExhibitorsInfomationVC.h"
#import "ZWProductDisplayVC.h"
#import "ZWContactUsVC.h"
#import "ZWShowDynamicVC.h"
#import "ZWExhibitorsDetailVC.h"

@interface ZWCompanyDetailsVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,DCCycleScrollViewDelegate>

@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)UIScrollView *mainScrollView;

@property(nonatomic, strong)UISegmentedControl *segmentedControl;

@property(nonatomic, strong)DCCycleScrollView *banner;

@property(assign, nonatomic)NSInteger selectIndex;//切换按钮

@end

@implementation ZWCompanyDetailsVC

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) style:UITableViewStylePlain];
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBar];
    [self createUI];
    [self setupChildViewController];
    [self createRequest];
}
- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
}
- (void)goBack:(UINavigationItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

#pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
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
    if (indexPath.section == 0) {

        self.banner = [DCCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 0.55*kScreenWidth) shouldInfiniteLoop:YES imageGroups:@[]];
        self.banner.placeholderImage = [UIImage imageNamed:@"fu_img_no_02"];
        self.banner.autoScrollTimeInterval = 5;
        self.banner.autoScroll = YES;
        self.banner.isZoom = NO;
        self.banner.itemSpace = 0;
        self.banner.imgCornerRadius = 0;
        self.banner.itemWidth = kScreenWidth;
        self.banner.delegate = self;
        [cell.contentView addSubview:self.banner];
        
    }else {
        // 创建底部滚动视图
        self.mainScrollView = [[UIScrollView alloc] init];
        self.mainScrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight-0.1*kScreenWidth);
        self.mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width * 4, 0);
        self.mainScrollView.backgroundColor = [UIColor clearColor];
        self.mainScrollView.pagingEnabled = YES;
        self.mainScrollView.bounces = NO;
        self.mainScrollView.showsHorizontalScrollIndicator = NO;
        self.mainScrollView.delegate = self;
        self.mainScrollView.tag = 1000;
        [cell.contentView addSubview:self.mainScrollView];
        
    }
}
//点击图片的代理
-(void)cycleScrollView:(DCCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"index = %ld",(long)index);
}

#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 0.55*kScreenWidth;
    }else {
        return kScreenHeight-zwNavBarHeight-0.1*kScreenWidth;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }else {
        return 0.1*kScreenWidth;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        
        return [self createSeg];
    }else {
        return nil;
    }
}

- (UIView *)createSeg {
    UIView *toolView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.1*kScreenWidth)];
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"展商信息", @"产品展示", @"参展动态", @"联系我们"]];
    self.segmentedControl.frame = CGRectMake(-5, 0, kScreenWidth+10, 0.1*kScreenWidth);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:skinColor,NSForegroundColorAttributeName,smallMediumFont,NSFontAttributeName ,nil];
    [self.segmentedControl setTitleTextAttributes:dic forState:UIControlStateNormal];
    self.segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.backgroundColor = [UIColor whiteColor];
    [self.segmentedControl addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventValueChanged];
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        [self showVc:0];
    }
    [toolView addSubview:self.segmentedControl];
    return toolView;
}

- (void)selectItem:(UISegmentedControl *)seg {
    NSLog(@"---------%ld",(long)seg.selectedSegmentIndex);
    self.selectIndex = seg.selectedSegmentIndex;
    // 1 计算滚动的位置
    CGFloat offsetX = seg.selectedSegmentIndex * self.view.frame.size.width;
    self.mainScrollView.contentOffset = CGPointMake(offsetX, 0);
    // 2.给对应位置添加对应子控制器
    [self showVc:seg.selectedSegmentIndex];
}

- (void)showVc:(NSInteger)index {
    if (index<4) {
        CGFloat offsetX = index * self.view.frame.size.width;
        UIViewController *vc = self.childViewControllers[index];
        if (vc.isViewLoaded) return;
        [self.mainScrollView addSubview:vc.view];
        vc.view.frame = CGRectMake(offsetX, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
}

#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.tag == 1000) {
        // 计算滚动到哪一页
        NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
        // 1.添加子控制器view
        [self showVc:index];
        // 2.把对应的标题选中
        self.segmentedControl.selectedSegmentIndex = index;
    }
}

-(void)setupChildViewController {

    ZWExhibitorsDetailVC *ExhibitorVC = [[ZWExhibitorsDetailVC alloc] init];
    ExhibitorVC.exhibitorId = self.merchantId;
    [self addChildViewController:ExhibitorVC];

    ZWProductDisplayVC *productDisplayVC = [[ZWProductDisplayVC alloc] init];
    productDisplayVC.exhibitorId = self.merchantId;
    productDisplayVC.exhibitorType = 1;
    productDisplayVC.enterType = self.enterType;
    [self addChildViewController:productDisplayVC];
    
    ZWShowDynamicVC *dynamicVC = [[ZWShowDynamicVC alloc] init];
    dynamicVC.exhibitorId = self.merchantId;
    [self addChildViewController:dynamicVC];

    ZWContactUsVC *contactUsVC = [[ZWContactUsVC alloc] init];
    contactUsVC.exhibitorId = self.merchantId;
    contactUsVC.exhibitorType = 1;
    productDisplayVC.enterType = self.enterType;
    [self addChildViewController:contactUsVC];

}

- (void)createRequest {
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]postFormDataReqeustWithURL:zwExhibitorsDetails parametes:@{@"merchantId":self.merchantId} successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (zw_issuccess) {
            
            NSArray *myData = data[@"data"][@"images"];
            NSMutableArray *myArray = [NSMutableArray array];
            for (NSString *imageStr in myData) {
                NSString *url = [NSString stringWithFormat:@"%@%@",httpImageUrl,imageStr];
                [myArray addObject:url];
            }
            strongSelf.banner.imgArr = myArray;
            
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    } showInView:self.view];
}
    
@end
