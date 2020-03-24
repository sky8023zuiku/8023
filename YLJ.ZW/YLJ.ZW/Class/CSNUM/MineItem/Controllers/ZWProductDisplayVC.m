//
//  ZWProductDisplayVC.m
//  YLJ.ZW
//
//  Created by G G on 2019/8/30.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWProductDisplayVC.h"
#import "ZWProductDisplayCell.h"
#import "ZWCollectionViewAddCell.h"
#import "ZWProductAddVC.h"
#import "ZWMineRqust.h"
#import "ZWMineResponse.h"
#import <UIImageView+WebCache.h>
#import "ZWProductDetailVC.h"

@interface ZWProductDisplayVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic, strong)UICollectionView *collectView;
@property(nonatomic, strong)UICollectionViewFlowLayout *layout;
@property(nonatomic, strong)NSString *type;//编辑or完成
@property(nonatomic, strong)UIButton *deleteBtn;
@property(nonatomic, strong)NSMutableArray *deleteBtns;
@property(nonatomic, assign)BOOL isDelete;
@property(nonatomic, strong)NSArray *dataArray;

@end

@implementation ZWProductDisplayVC
-(UICollectionView *)collectView
{
    if (!_collectView) {
        _collectView=[[UICollectionView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth-20, kScreenHeight-zwNavBarHeight-64) collectionViewLayout:_layout];
    }
    _collectView.delegate=self;
    _collectView.dataSource=self;
    _collectView.backgroundColor = [UIColor whiteColor];
    [_collectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"oneCell"];
    [_collectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"twoCell"];
    [_collectView registerClass:[ZWCollectionViewAddCell class] forCellWithReuseIdentifier:@"AddCell"];
    _collectView.showsVerticalScrollIndicator=YES;
    _collectView.showsHorizontalScrollIndicator=YES;
    _collectView.showsVerticalScrollIndicator = NO;
    return _collectView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNotice];
    [self createRequest];
}
- (void)createNotice {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(noticeResponse:) name:@"pageThatNeedsAResponse" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshDataAction) name:@"refreshDataAction" object:nil];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"pageThatNeedsAResponse" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refreshDataAction" object:nil];
}
- (void)noticeResponse:(NSNotification *)notice {
//    NSLog(@"----%@",notice.object[@"type"]);
    self.type = notice.object[@"type"];
    [self.collectView reloadData];
}
- (void)refreshDataAction {
    [self createRequest];
}
- (void)createRequest {
    NSLog(@"%@",self.exhibitorId);
    ZWProductListRequest *request = [[ZWProductListRequest alloc]init];
    request.exhibitorId = self.exhibitorId;
    request.status = @"";
    [request postFormDataWithProgress:nil RequestCompleted:^(YHBaseRespense *respense) {
        if (respense.isFinished) {
            NSLog(@"-------%@",respense.data);
            NSArray *myData = respense.data;
            NSMutableArray *myArray = [NSMutableArray array];
            for (NSDictionary *myDic in myData) {
                ZWProductListModel *model = [ZWProductListModel parseJSON:myDic];
                [myArray addObject:model];
            }
            self.dataArray = myArray;
            [self.collectView reloadData];
        }
    }];
}

- (void)createUI {
    self.deleteBtns = [NSMutableArray array];
    _layout=[[UICollectionViewFlowLayout alloc]init];
    [_layout prepareLayout];
    //设置每个cell与相邻的cell之间的间距
    _layout.minimumInteritemSpacing = 1;
    _layout.minimumLineSpacing=5;
    [self.view addSubview:self.collectView];
}
/*上传图片*/

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self.type isEqualToString:@"编辑"]) {
        return self.dataArray.count;
    }else {
        return self.dataArray.count+1;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *oneCell = @"oneCell";
    static NSString *twoCell = @"twoCell";
    if ([self.type isEqual:@"编辑"]) {
        ZWProductListModel *model = self.dataArray[indexPath.row];
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:oneCell forIndexPath:indexPath];
        for (UIView *view  in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (kScreenWidth-20)/3-3, (kScreenWidth-20)/3-3)];
        imageView.image = [UIImage imageNamed:@"h1.jpg"];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,model.url]] placeholderImage:[UIImage imageNamed:@"fu_img_no_02"]];
        [cell.contentView addSubview:imageView];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(imageView.frame), (kScreenWidth-20)/3-3-10, 0.05*kScreenWidth)];
        titleLabel.text = [NSString stringWithFormat:@"%@",model.name];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = smallMediumFont;
        [cell.contentView addSubview:titleLabel];
        return cell;
    }else {
        if (indexPath.row == self.dataArray.count) {
            ZWCollectionViewAddCell *addCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AddCell" forIndexPath:indexPath];
            return addCell;
        }else {
            ZWProductListModel *model = self.dataArray[indexPath.row];
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:twoCell forIndexPath:indexPath];
            for (UIView *view  in cell.contentView.subviews) {
                [view removeFromSuperview];
            }
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (kScreenWidth-20)/3-3, (kScreenWidth-20)/3-3)];
            imageView.image = [UIImage imageNamed:@"h1.jpg"];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,model.url]] placeholderImage:[UIImage imageNamed:@"fu_img_no_02"]];
            [cell.contentView addSubview:imageView];
            
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(imageView.frame), (kScreenWidth-20)/3-3-10, 0.05*kScreenWidth)];
            titleLabel.text = [NSString stringWithFormat:@"%@",model.name];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = smallMediumFont;
            [cell.contentView addSubview:titleLabel];
        
            self.deleteBtn =[UIButton buttonWithType:UIButtonTypeCustom];
            self.deleteBtn.frame = CGRectMake(cell.frame.size.width-25, 5, 20, 20);
            self.deleteBtn.tag = indexPath.row;
            self.deleteBtn.backgroundColor = [UIColor whiteColor];
            self.deleteBtn.layer.cornerRadius = 10;
            self.deleteBtn.layer.masksToBounds = YES;
            [self.deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete_icon"] forState:UIControlStateNormal];
            [self.deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:self.deleteBtn];

            return cell;
        }
    }
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreenWidth-20)/3-3, (1.1*kScreenWidth)/3-3);
}

//cell的点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.type isEqualToString:@"完成"]) {
        if (indexPath.row == self.dataArray.count) {
            ZWProductAddVC *addVC = [[ZWProductAddVC alloc]init];
            addVC.title = @"添加产品";
            addVC.status = 2;
            addVC.exhibitorId = self.exhibitorId;
            [self.navigationController pushViewController:addVC animated:YES];
        }else {
            ZWProductListModel *model = self.dataArray[indexPath.row];
            ZWProductAddVC *addVC = [[ZWProductAddVC alloc]init];
            addVC.title = @"添加产品";
            addVC.status = 1;
            addVC.exhibitorId = self.exhibitorId;
            addVC.productId = model.productId;
            [self.navigationController pushViewController:addVC animated:YES];
        }
    }else {
        ZWProductListModel *model = self.dataArray[indexPath.row];
        ZWProductAddVC *addVC = [[ZWProductAddVC alloc]init];
        addVC.title = @"添加产品";
        addVC.status = 0;
        addVC.exhibitorId = self.exhibitorId;
        addVC.productId = model.productId;
        [self.navigationController pushViewController:addVC animated:YES];
    }
    
}
- (void)deleteBtnClick:(UIButton *)btn {
    __weak typeof (self) weakSelf = self;
    [[ZWAlertAction sharedAction]showTwoAlertTitle:@"提示" message:@"是否确认删除该产品" cancelTitle:@"否" confirmTitle:@"是" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        __weak typeof (self) strongSelf = weakSelf;
        [strongSelf deleteItem:btn.tag];
    } actionCancel:^(UIAlertAction * _Nonnull actionCancel) {
        
    } showInView:self];
}
- (void)deleteItem:(NSInteger)index {
    ZWProductListModel *model = self.dataArray[index];
    ZWProductDetaileRequest *request = [[ZWProductDetaileRequest alloc]init];
    request.productId = model.productId;
    __weak typeof (self) weakSelf = self;
    [request postFormDataWithProgress:nil RequestCompleted:^(YHBaseRespense *respense) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (respense.isFinished) {
            NSLog(@"%@",respense.data);
            NSArray *myData = respense.data[@"productImages"];
            NSMutableArray *myArray = [NSMutableArray array];
            for (NSDictionary *myDic in myData) {
                NSString *url = myDic[@"url"];
                [myArray addObject:url];
            }
            [strongSelf deleteProduct:myArray withProductId:model.productId];
        }
    }];
}
- (void)deleteProduct:(NSArray *)images withProductId:(NSString *)productId {
    ZWProductDeleteRequest *request = [[ZWProductDeleteRequest alloc]init];
    request.productId = productId;
    __weak typeof (self) weakSelf = self;
    [request postFormDataWithProgress:nil RequestCompleted:^(YHBaseRespense *respense) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (respense.isFinished) {
            NSLog(@"成功删除产品");
            [strongSelf refreshDataAction];
            [strongSelf deleteOSSImage:images];
        }
    }];
}
- (void)deleteOSSImage:(NSArray *)images {
    [ZWOSSConstants syncDeleteImages:images complete:^(DeleteImageState state) {
        if (state == 1) {
            NSLog(@"图片删除成功");
        }
    }];
}
@end
