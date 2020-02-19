//
//  ZWProductAddVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/16.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWProductAddVC.h"
#import "ZWCollectionViewCell.h"
#import "ZWCollectionViewAddCell.h"
#import "ZWTextView.h"
#import <TZImagePickerController.h>
#import "ZWMineRqust.h"
#import "ZWMineResponse.h"
#import <UIImageView+WebCache.h>

@interface ZWProductAddVC ()<UICollectionViewDelegate,UICollectionViewDataSource,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>

@property(nonatomic, strong)UICollectionView *collectView;

@property(nonatomic, strong)UICollectionViewFlowLayout *layout;

@property(nonatomic, strong)NSMutableArray *imageData;

@property(nonatomic, strong)UITextField *titleText;//产品名称

@property(nonatomic, strong)ZWTextView *titleView;//产品简介

@property(nonatomic, strong)NSArray *detailArray;//产品详情

@property(nonatomic, strong)NSMutableArray *httpImages;//网络图片

@end

@implementation ZWProductAddVC
-(UICollectionView *)collectView
{
    if (!_collectView) {
        _collectView=[[UICollectionView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth-20, kScreenHeight-zwNavBarHeight) collectionViewLayout:_layout];
    }
    _collectView.delegate=self;
    _collectView.dataSource=self;
    _collectView.backgroundColor = [UIColor whiteColor];
    [_collectView registerClass:[ZWCollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
    [_collectView registerClass:[ZWCollectionViewAddCell class] forCellWithReuseIdentifier:@"AddCell"];
    [_collectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"detailCell"];
    _collectView.showsVerticalScrollIndicator=YES;
    _collectView.showsHorizontalScrollIndicator=YES;
    _collectView.showsVerticalScrollIndicator = NO;
    return _collectView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNavigationBar];
    if (self.status != 2) {
        [self requestData];
    }
}
- (void)requestData {
    ZWProductDetaileRequest *request = [[ZWProductDetaileRequest alloc]init];
    request.productId = self.productId;
    __weak typeof (self) weakSelf = self;
    [request postFormDataWithProgress:nil RequestCompleted:^(YHBaseRespense *respense) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (respense.isFinished) {
            NSLog(@"%@",respense.data);
            NSArray *myData = @[respense.data];
            NSMutableArray *myArray = [NSMutableArray array];
            ZWProductDetailModel *model;
            for (NSDictionary *myDic in myData) {
                model = [ZWProductDetailModel parseJSON:myDic];
                [myArray addObject:model];
            }
            strongSelf.detailArray = myArray;
            [strongSelf.httpImages addObjectsFromArray:model.productImages];
            [strongSelf.collectView reloadData];
        }
    }];
}
- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
    
    if (self.status == 1) {
        [[YNavigationBar sharedInstance]createRightBarWithTitle:@"完成" barItem:self.navigationItem target:self action:@selector(rightItemClick:)];
    }else if (self.status == 2) {
        [[YNavigationBar sharedInstance]createRightBarWithTitle:@"上传" barItem:self.navigationItem target:self action:@selector(rightItemClick:)];
    }else {
        
    }
}
- (void)goBack:(UIBarButtonItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightItemClick:(UIBarButtonItem *)item {
    
    NSInteger imageCount = self.httpImages.count+self.imageData.count;
    
    if (imageCount == 0) {
        [self showOneItemWithMessage:@"产品图片不能为空"];
        return;
    }
    if ([self.titleText.text isEqualToString:@""]) {
        [self showOneItemWithMessage:@"产品名称不能为空"];
        return;
    }
    if ([self.titleView.text isEqualToString:@""]) {
        [self showOneItemWithMessage:@"产品简介不能为空"];
        return;
    }
    __weak typeof (self) weakSelf = self;
    [[ZWAlertAction sharedAction]showTwoAlertTitle:@"提示" message:@"是否确认提交" cancelTitle:@"否" confirmTitle:@"是" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf uploadImage];
    } actionCancel:^(UIAlertAction * _Nonnull actionCancel) {
        
    } showInView:self];
}
- (void)uploadImage {
    __weak typeof (self) weakSelf = self;
    [ZWOSSConstants syncUploadImages:self.imageData complete:^(NSArray<NSString *> * _Nonnull names, UploadImageState state) {
        __strong typeof (weakSelf) strongSlef = weakSelf;
        if (state == 1) {
            [strongSlef uploadData:names];
        }else {
            NSLog(@"上传图片失败");
        }
    }];
}
- (void)uploadData:(NSArray *)images {
    ZWProductAddRequest *request = [[ZWProductAddRequest alloc]init];
    request.productFiles = images;
    request.exhibitorId = self.exhibitorId;
    if (self.status == 1) {
        request.productId = self.productId;
    }
    request.imagesIntroduce = self.titleView.text;
    request.imagesName = self.titleText.text;
    __weak typeof (self) weakSelf = self;
    [request postRequestCompleted:^(YHBaseRespense *respense) {
        __strong typeof (weakSelf) strongSlef = weakSelf;
        if (respense.isFinished) {
            NSLog(@"数据提交成功");
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshDataAction" object:nil];
            [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:@"产品信息提交成功" confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
                [self.navigationController popViewControllerAnimated:YES];
            } showInView:self];
        }else {
            [strongSlef deleteOSSImage:images];
        }
    }];
}

- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.imageData = [NSMutableArray array];
    self.httpImages = [NSMutableArray array];
    _layout=[[UICollectionViewFlowLayout alloc]init];
    [_layout prepareLayout];
    //设置每个cell与相邻的cell之间的间距
    _layout.minimumInteritemSpacing = 1;
    _layout.minimumLineSpacing=5;
    [self.view addSubview:self.collectView];
}
/*上传图片*/

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.status == 0) {
            return self.httpImages.count;
        }else if (self.status == 1) {
            NSInteger imageCount = self.httpImages.count+self.imageData.count;
            if (imageCount<9) {
                return imageCount+1;
            }else {
                return imageCount;
            }
        }else {
            if (self.imageData.count<9) {
                return self.imageData.count+1;
            }else {
                return self.imageData.count;
            }
        }
    }else {
        return 1;
    }
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId=@"cellID";
    if (indexPath.section == 0) {
        if (self.status == 0) {
            ZWCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
            [cell.mianImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,self.httpImages[indexPath.item][@"url"]]] placeholderImage:[UIImage imageNamed:@"fu_img_no_02"]];
            return cell;
        }else if (self.status == 1) {
            NSInteger imageCount = self.httpImages.count+self.imageData.count;
            if (imageCount < 9) {
              if (indexPath.row == imageCount) {
                    ZWCollectionViewAddCell *addCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AddCell" forIndexPath:indexPath];
                    return addCell;
                }else {
                    ZWCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
                    if (indexPath.row < self.httpImages.count) {
                        [cell.mianImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,self.httpImages[indexPath.item][@"url"]]] placeholderImage:[UIImage imageNamed:@"fu_img_no_02"]];
                    }else {
                        cell.mianImageView.image = self.imageData[indexPath.item-self.httpImages.count];
                    }
                    [self createOtherCollectionViewCell:cell cellForItemAtIndexPath:indexPath];
                    return cell;
                }
            }else {
                ZWCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
                if (indexPath.row < self.httpImages.count) {
                    [cell.mianImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,self.httpImages[indexPath.item][@"url"]]] placeholderImage:[UIImage imageNamed:@"fu_img_no_02"]];
                }else {
                    cell.mianImageView.image = self.imageData[indexPath.item-self.httpImages.count];
                }
                [self createOtherCollectionViewCell:cell cellForItemAtIndexPath:indexPath];
                return cell;
            }
        }else {
            if (self.imageData.count <9) {
                if (indexPath.row == self.imageData.count) {
                    ZWCollectionViewAddCell *addCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AddCell" forIndexPath:indexPath];
                    return addCell;
                }else {
                    ZWCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
                    cell.mianImageView.image = self.imageData[indexPath.item];
                    [self createOtherCollectionViewCell:cell cellForItemAtIndexPath:indexPath];
                    return cell;
                }
            }else {
                ZWCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
                cell.mianImageView.image = self.imageData[indexPath.item];
                [self createOtherCollectionViewCell:cell cellForItemAtIndexPath:indexPath ];
                return cell;
            }
        }
    }else {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"detailCell" forIndexPath:indexPath];
        if (cell) {
            for (UIView *view in cell.contentView.subviews) {
                [view removeFromSuperview];
            }
        }
        [self createCollectionViewCell:cell];
        return cell;
    }
}

- (void)createOtherCollectionViewCell:(ZWCollectionViewCell *)cell cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UIButton *deleteBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(cell.frame.size.width-25, 5, 20, 20);
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete_icon"] forState:UIControlStateNormal];
    deleteBtn.tag = indexPath.row;
    deleteBtn.backgroundColor = [UIColor whiteColor];
    deleteBtn.layer.cornerRadius = 10;
    deleteBtn.layer.masksToBounds = YES;
    [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:deleteBtn];
}
- (void)deleteBtnClick:(UIButton *)btn {
    if (self.status == 0) {
        
    }else if (self.status == 1) {
        if (btn.tag<self.httpImages.count) {
            [self deleteHttpImage:btn.tag];
        }else {
            [self.imageData removeObjectAtIndex:btn.tag-self.httpImages.count];
            [self.collectView reloadData];
        }
    }else {
       [self.imageData removeObjectAtIndex:btn.tag];
       [self.collectView reloadData];
    }
}
- (void)deleteHttpImage:(NSInteger)index {
    ZWProductImageDeleteRequest *request = [[ZWProductImageDeleteRequest alloc]init];
    request.productId = self.productId;
    request.imagesId = self.httpImages[index][@"id"];
    [request postFormDataWithProgress:nil RequestCompleted:^(YHBaseRespense *respense) {
        if (respense.isFinished) {
            NSLog(@"删除成功");
            [self deleteOSSImage:@[self.httpImages[index][@"url"]]];
            [self.httpImages removeObjectAtIndex:index];
            [self.collectView reloadData];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshDataAction" object:nil];
        }
    }];
}
- (void)deleteOSSImage:(NSArray *)images {
    [ZWOSSConstants syncDeleteImages:images complete:^(DeleteImageState state) {
        if (state == 1) {
            NSLog(@"删除图片成功");
        }
    }];
}

- (void)createCollectionViewCell:(UICollectionViewCell *)cell {
    
    ZWProductDetailModel *model = self.detailArray[0];
    
    UIView *lineOne = [[UIView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 1)];
    lineOne.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
    [cell.contentView addSubview:lineOne];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lineOne.frame), CGRectGetWidth(lineOne.frame), 0.1*kScreenWidth)];
    titleLabel.text = @"产品名称：";
    titleLabel.font = normalFont;
    [cell.contentView addSubview:titleLabel];
    
    self.titleText = [[UITextField alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLabel.frame), kScreenWidth-20, 0.1*kScreenWidth)];
    if (self.status == 0) {
        self.titleText.text = model.name;
        self.titleText.enabled = NO;
    }else if (self.status == 1) {
        self.titleText.text = model.name;
    }else {
       
    }
    self.titleText.placeholder = @"请输入产品名称";
    self.titleText.font = normalFont;
    [cell.contentView addSubview:self.titleText];

    UIView *lineTwo = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleText.frame), kScreenWidth, 1)];
    lineTwo.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
    [cell.contentView addSubview:lineTwo];
    
    
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lineTwo.frame), CGRectGetWidth(lineOne.frame), 0.1*kScreenWidth)];
    detailLabel.text = @"产品简介：";
    detailLabel.font = normalFont;
    [cell.contentView addSubview:detailLabel];
    
    self.titleView = [[ZWTextView alloc]initWithFrame:CGRectMake(6, CGRectGetMaxY(detailLabel.frame), kScreenWidth, kScreenWidth)];
    self.titleView.delegate = self;
    if (self.status == 0) {
        self.titleView.text = model.imagesIntroduce;
        self.titleView.editable = NO;
    }else if (self.status == 1) {
        self.titleView.text = model.imagesIntroduce;
    }else {
        self.titleView.placeHolderLabel.text = @"请输入产品简介";
    }
    self.titleView.font = smallMediumFont;
    [cell.contentView addSubview:self.titleView];
}
#pragma mark textChange事件
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSLog(@"@@@@@@@");
    if (textView.text == nil||[textView.text isEqualToString:@""]) {
        self.titleView.placeHolderLabel.text = @"请输入产品简介";
    }else {
        self.titleView.placeHolderLabel.text = @"";
    }
    return YES;
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake((kScreenWidth-20)/3-3, (kScreenWidth-20)/3-3);
    }else {
        return CGSizeMake(kScreenWidth, 1.5*kScreenWidth);
    }
}

//cell的点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.status == 0) {
        
    }else if (self.status == 1) {
        NSInteger imageCount = self.httpImages.count+self.imageData.count;
        if (indexPath.item == imageCount) {
            [self showActionSheet];
        }
    }else {
        if (indexPath.item == self.imageData.count) {
           [self showActionSheet];
        }
    }
}
- (void)showActionSheet {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openPhotoLibrary];
    }];
    [alertController addAction:actionOne];
    UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openCamera];
    }];
    [alertController addAction:actionTwo];
    UIAlertAction *actionThree = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:actionThree];
    [self presentViewController:alertController animated:YES completion:nil];
}

/**
 *  调用相册
 */
- (void)openPhotoLibrary {
    NSInteger number = 9-self.imageData.count;
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc]initWithMaxImagesCount:number columnNumber:5 delegate:self];
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    [self.imageData addObjectsFromArray:photos];
    [self.collectView reloadData];
}
/**
 *  调用照相机
 */
- (void)openCamera {
    UIImagePickerController *imagePickerC = [[UIImagePickerController alloc] init];
    imagePickerC.delegate = self;
    //跳转动画效果
    imagePickerC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePickerC.allowsEditing = YES;
    //判断是否可以打开照相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        imagePickerC.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerC animated:YES completion:nil];
    }
    else{
        NSLog(@"没有摄像头");
    }
}
#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info {
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    [self.imageData addObject:image];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.collectView reloadData];
    
}
//进入拍摄页面点击取消按钮
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showOneItemWithMessage:(NSString *)message {
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:message confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        
    } showInView:self];
}
@end
