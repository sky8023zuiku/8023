//
//  ZWEditExhibitionVC.m
//  YLJ.ZW
//
//  Created by G G on 2019/8/30.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWEditExhibitionVC.h"
#import "ZWExhibitorsInfomationVC.h"
#import "ZWCompanyProfileVC.h"
#import "ZWProductDisplayVC.h"
#import "ZWContactUsVC.h"
#import "ZWContactAddVC.h"
#import "ZWEditReleaseShufflingVC.h"
#import "ZWMineRqust.h"
#import "DCCycleScrollView.h"


#import "JhScrollActionSheetView.h"
#import "JhPageItemModel.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>


@interface ZWEditExhibitionVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,DCCycleScrollViewDelegate>

@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)UIScrollView *mainScrollView;

@property(nonatomic, strong)UISegmentedControl *segmentedControl;

@property(nonatomic, strong)NSDictionary *dataDic;

@property(nonatomic, strong)NSString *type;//编辑or完成

@property(strong, nonatomic)UIView *showView;//底部

@property(assign, nonatomic)NSInteger selectIndex;//切换按钮

@property(nonatomic, strong)UIButton *editorBtn;

@property(nonatomic, strong)DCCycleScrollView *banner;

@property(nonatomic, strong)NSString *myexhibitorId;//展商id

@property(nonatomic, strong)NSArray *titleImages;//标题轮播图

@property(nonatomic, strong)NSString *exhibitorsProperties;//展商属性

@property(nonatomic, strong)NSArray *imageData;

@property(nonatomic, strong)NSMutableArray *shareArray;

@property(nonatomic, strong)NSString *merchantName;//公司名称

@end

@implementation ZWEditExhibitionVC

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) style:UITableViewStylePlain];
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    _tableView.bounces = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNavigationBar];
    [self setupChildViewController];
    [self requestData];
    [self createNotice];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(10, 80, 100, 100);
    shareBtn.backgroundColor = [UIColor redColor];
    [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBtn];
}

- (void)shareBtnClick:(UIButton *)btn {
    
    [JhScrollActionSheetView showShareActionSheetWithTitle:@"分享" shareDataArray:self.shareArray handler:^(JhScrollActionSheetView *actionSheet, NSInteger index) {
        NSLog(@" 点击分享 index %ld ",(long)index);
        switch (index) {
            case 0:
                [self createShare:SSDKPlatformTypeWechat];
                break;
            case 1:
                [self createShare:SSDKPlatformSubTypeWechatTimeline];
                break;
            case 2:
                [self createShare:SSDKPlatformTypeSinaWeibo];
                break;
            case 3:
                [self createShare:SSDKPlatformSubTypeQQFriend];
                break;
            case 4:
                [self createShare:SSDKPlatformSubTypeQZone];
                break;
            default:
                break;
        }
        
    }];
   
}

- (void)createShare:(SSDKPlatformType)type {
        
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSString *text;
    if (type == SSDKPlatformTypeSinaWeibo) {
//        text = @"http://www.csnum.com/share/html/share_exhibitors.html";
        text = [NSString stringWithFormat:@"http://www.csnum.com/share/html/share_exhibitors.html?exhibitorId=%@",self.exhibitorId];
    }else {
        text = self.shareData[@"exhibitionName"];
    }
    [shareParams SSDKSetupShareParamsByText:text
                                     images:[NSString stringWithFormat:@"%@%@",httpImageUrl,self.shareData[@"coverImages"]]
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.csnum.com/share/html/share_exhibitors.html?exhibitorId=%@",self.exhibitorId]]
                                      title:self.merchantName
                                       type:SSDKContentTypeAuto];
    [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                NSLog(@"分享成功");
                break;
            }
            case SSDKResponseStateFail:
            {
                NSLog(@"分享失败");
                break;
            }
            default:
                break;
        }
    }];
}




-(NSMutableArray *)shareArray{
    if (!_shareArray) {
        _shareArray = [NSMutableArray new];
        
        NSArray *data = @[
                          @{
                              @"text" : @"微信",
                              @"img" : @"weixing",
                              },
                          @{
                              @"text" : @"朋友圈",
                              @"img" : @"friends",
                              },
                          @{
                              @"text" : @"微博",
                              @"img" : @"sina",
                              },
                          @{
                              @"text" : @"QQ",
                              @"img" : @"qq",
                              },
                          @{
                              @"text" : @"QQ空间",
                              @"img" : @"kongjian",
                              }];
        
        for (NSDictionary *mydic in data) {
            JhPageItemModel *model = [JhPageItemModel parseJSON:mydic];
            [self.shareArray addObject:model];
        }
    }
    return _shareArray;
}

//**********************************************************以上是分享********************************************************************/
    

- (void)createNotice {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:@"ZWEditExhibitionVC" object:nil];
}
- (void)refreshData{
    [self requestData];
}
- (void)requestData {
    ZWExhibitorsDeltailRequst *request = [[ZWExhibitorsDeltailRequst alloc]init];
    request.exhibitorId = self.exhibitorId;
    __weak typeof (self) weakSelf = self;
    [request postRequestCompleted:^(YHBaseRespense *respense) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (respense.isFinished) {
            NSLog(@"%@",respense.data);
            strongSelf.exhibitorsProperties = respense.data[@"exhibitor"][@"nature"];
            strongSelf.myexhibitorId = respense.data[@"exhibitor"][@"id"];
            strongSelf.merchantName = respense.data[@"exhibitor"][@"merchantName"];
            strongSelf.titleImages = respense.data[@"images"];
            int imagesStatus = [respense.data[@"imagesStatus"] intValue];
            NSMutableArray *imgaeArr = [NSMutableArray array];
            for (NSDictionary *myDic in strongSelf.titleImages) {
                if (imagesStatus == 2) {
                    NSString *url = [NSString stringWithFormat:@"%@%@",httpImageUrl,myDic[@"url"]];
                    [imgaeArr addObject:url];
                }
            }
            strongSelf.banner.imgArr = imgaeArr;
            NSLog(@"--------%@",strongSelf.banner.imgArr);
            strongSelf.imageData = imgaeArr;
        }
    }];
}

- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
    [[YNavigationBar sharedInstance]createRightBarWithTitle:@"编辑" barItem:self.navigationItem target:self action:@selector(rightItemClcik:)];
    
}
- (void)goBack:(UIBarButtonItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightItemClcik:(UIBarButtonItem *)item {
    if ([item.title isEqualToString:@"编辑"]) {
        self.type = @"完成";
        self.navigationItem.rightBarButtonItem.title = @"完成";
        self.editorBtn.alpha = 1;
    }else {
        self.type = @"编辑";
        self.navigationItem.rightBarButtonItem.title = @"编辑";
        self.editorBtn.alpha = 0;
    }
    [self showBottomView:self.type withSwitchIndex:self.selectIndex];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"pageThatNeedsAResponse" object:@{@"type":self.type}];
}

- (void)createUI {
    self.type = @"编辑";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
//    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 100, kScreenWidth, 300)];
//    btn.backgroundColor = [UIColor redColor];
//    [self.view addSubview:btn];
    
    
//    self.showView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, kScreenWidth, zwTabBarHeight)];
//    self.showView.backgroundColor = [UIColor redColor];
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.backgroundColor = skinColor;
//    [button setTitle:@"添加" forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.showView addSubview:button];
    
    
    [self.view addSubview:self.showView];
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
//        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.55*kScreenWidth)];
//        imageV.image = [UIImage imageNamed:@"h1.jpg"];
//        [cell.contentView addSubview:imageV];
        
        
        
        self.banner = [DCCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 0.55*kScreenWidth) shouldInfiniteLoop:YES imageGroups:@[]];
        self.banner.placeholderImage = [UIImage imageNamed:@"fu_img_no_02"];
        self.banner.autoScrollTimeInterval = 5;
        self.banner.autoScroll = YES;
        self.banner.isZoom = NO;
        self.banner.itemSpace = 0;
        self.banner.imgArr = self.imageData;
        self.banner.imgCornerRadius = 0;
        self.banner.itemWidth = kScreenWidth;
        self.banner.delegate = self;
        [cell.contentView addSubview:self.banner];
        
        self.editorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.editorBtn.frame = CGRectMake(kScreenWidth-0.2*kScreenWidth+3, 0.1*kScreenWidth, 0.2*kScreenWidth, 30);
        self.editorBtn.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
        [self.editorBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [self.editorBtn setImage:[UIImage imageNamed:@"ren_icon_bian_bai"] forState:UIControlStateNormal];
        self.editorBtn.titleLabel.font = normalFont;
        self.editorBtn.layer.cornerRadius = 3;
        self.editorBtn.alpha = 0;
        [self.editorBtn addTarget:self action:@selector(editorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:self.editorBtn];
        
    }else {
        // 创建底部滚动视图
        self.mainScrollView = [[UIScrollView alloc] init];
        self.mainScrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight-0.1*kScreenWidth-0.55*kScreenWidth-zwTabBarStausHeight);
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
        return kScreenHeight-zwNavBarHeight-0.1*kScreenWidth-0.55*kScreenWidth-zwTabBarStausHeight;
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
    
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"展商信息", @"公司简介", @"产品展示", @"联系我们"]];
    self.segmentedControl.frame = CGRectMake(-5, 0, kScreenWidth+10, 0.1*kScreenWidth);
    self.segmentedControl.tintColor = [UIColor colorWithRed:65/255.0 green:163/255.0 blue:255/255.0 alpha:1.0];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:65/255.0 green:163/255.0 blue:255/255.0 alpha:1.0],NSForegroundColorAttributeName,smallMediumFont,NSFontAttributeName ,nil];
    [self.segmentedControl setTitleTextAttributes:dic forState:UIControlStateNormal];
    self.segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.backgroundColor = [UIColor whiteColor];
    [self.segmentedControl setDividerImage:[UIImage imageNamed:@"editor_icon"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefaultPrompt];
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
    
    if (seg.selectedSegmentIndex == 2||seg.selectedSegmentIndex == 3) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"pageThatNeedsAResponse" object:@{@"type":self.type}];
    }
    [self showBottomView:self.type withSwitchIndex:self.selectIndex];
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

    ZWExhibitorsInfomationVC *exhiebitionVC = [[ZWExhibitorsInfomationVC alloc] init];
    exhiebitionVC.exhibitorId = self.exhibitorId;
    exhiebitionVC.exhibitorType = 0;
    [self addChildViewController:exhiebitionVC];

    ZWCompanyProfileVC *companyProfileVC = [[ZWCompanyProfileVC alloc] init];
    companyProfileVC.exhibitorId = self.merchantId;
    [self addChildViewController:companyProfileVC];

    ZWProductDisplayVC *productDisplayVC = [[ZWProductDisplayVC alloc] init];
    productDisplayVC.exhibitorId = self.exhibitorId;
    [self addChildViewController:productDisplayVC];

    ZWContactUsVC *contactUsVC = [[ZWContactUsVC alloc] init];
    contactUsVC.exhibitorId = self.exhibitorId;
    contactUsVC.exhibitorType = 0;
    [self addChildViewController:contactUsVC];

}

-(void)editorBtnClick:(UIButton *)btn {
    ZWEditReleaseShufflingVC *editReleaseShufflingVC = [[ZWEditReleaseShufflingVC alloc]init];
    editReleaseShufflingVC.title = @"编辑图片";
    editReleaseShufflingVC.httpImages = self.titleImages;
    editReleaseShufflingVC.exhibitorId = self.myexhibitorId;
    editReleaseShufflingVC.nature = self.exhibitorsProperties;
    [self.navigationController pushViewController:editReleaseShufflingVC animated:YES];
}

- (void)showBottomView:(NSString *)isEditor withSwitchIndex:(NSInteger)index {
    
    if ([isEditor isEqualToString:@"完成"] && index == 3) {
        [UIView animateWithDuration:0.3 animations:^{
            self.showView.frame = CGRectMake(0, kScreenHeight-zwNavBarHeight-zwTabBarHeight, kScreenWidth, zwTabBarHeight);
        }];
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            self.showView.frame = CGRectMake(0, kScreenHeight-zwNavBarHeight, kScreenWidth, zwTabBarHeight);
        }];
    }
}

- (UIView *)showView{
    if (!_showView) {
        _showView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-zwNavBarHeight, kScreenWidth, zwTabBarHeight)];
        _showView.backgroundColor = [UIColor redColor];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, kScreenWidth, zwTabBarHeight);
        button.backgroundColor = skinColor;
        [button setTitle:@"添加" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_showView addSubview:button];
    }
    return _showView;
}

- (void)buttonClick:(UIButton *)btn {
    ZWContactAddVC *contactAddVC = [[ZWContactAddVC alloc]init];
    contactAddVC.title = @"添加联系人";
    contactAddVC.exhibitorId = self.exhibitorId;
    [self.navigationController pushViewController:contactAddVC animated:YES];
}



@end
