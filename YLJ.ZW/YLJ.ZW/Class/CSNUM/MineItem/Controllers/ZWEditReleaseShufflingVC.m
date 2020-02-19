//
//  ZWEditReleaseShufflingVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/19.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWEditReleaseShufflingVC.h"
#import "ZWCollectionViewCell.h"
#import "ZWCollectionViewAddCell.h"
#import "ZWTextView.h"
#import <TZImagePickerController.h>
#import "ZWMineRqust.h"

@interface ZWEditReleaseShufflingVC ()<UICollectionViewDelegate,UICollectionViewDataSource,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic, strong)UICollectionView *collectView;

@property(nonatomic, strong)UICollectionViewFlowLayout *layout;

@property(nonatomic, strong)NSMutableArray *imageData;
@property(nonatomic, strong)NSMutableArray *httpImageData;
@property(nonatomic, strong)NSString *deleteImage;

@end

@implementation ZWEditReleaseShufflingVC
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
    _collectView.showsVerticalScrollIndicator=YES;
    _collectView.showsHorizontalScrollIndicator=YES;
    _collectView.showsVerticalScrollIndicator = NO;
    return _collectView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNavigationBar];
}

- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
    [[YNavigationBar sharedInstance]createRightBarWithTitle:@"上传" barItem:self.navigationItem target:self action:@selector(rightItemClick:)];
}

- (void)goBack:(UIBarButtonItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightItemClick:(UIBarButtonItem *)item {
    if (self.imageData.count == 0) {
        [self showOneItemWithMessage:@"没有需要新增的图片信息"];
        return;
    }
    __weak typeof (self) weakSelf = self;
    [[ZWAlertAction sharedAction]showTwoAlertTitle:@"提示" message:@"是否确认提交图片信息" cancelTitle:@"否" confirmTitle:@"是" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf uploadData];
    } actionCancel:^(UIAlertAction * _Nonnull actionCancel) {
        
    } showInView:self];
}
- (void)uploadData {
    if (self.imageData.count != 0) {
        __weak typeof (self) weakSelf = self;
        [ZWOSSConstants syncUploadImages:self.imageData complete:^(NSArray<NSString *> * _Nonnull names, UploadImageState state) {
            if (state == 1) {
                __strong typeof (weakSelf) strongSelf = weakSelf;
                [strongSelf uploadImage:names];
            }
        }];
    }
}
- (void)uploadImage:(NSArray *)images {
    ZWMyExhibitorsDetailsEditorRequest *request = [[ZWMyExhibitorsDetailsEditorRequest alloc]init];
    request.exhibitorId = self.exhibitorId;
    request.exhibitorFiles = images;
    request.nature = self.nature;
    __weak typeof (self) weakSelf = self;
    [request postRequestCompleted:^(YHBaseRespense *respense) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (respense.isFinished) {
            NSLog(@"%@",respense.data);
            [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:@"图片信息上传成功" confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"ZWEditExhibitionVC" object:nil];
                [strongSelf.navigationController popViewControllerAnimated:YES];
            } showInView:strongSelf];
        }else  {
            [strongSelf deleteOSSImage:images];
        }
    }];
}
- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.imageData = [NSMutableArray array];
    self.httpImageData = [NSMutableArray array];
    _layout=[[UICollectionViewFlowLayout alloc]init];
    [_layout prepareLayout];
    //设置每个cell与相邻的cell之间的间距
    _layout.minimumInteritemSpacing = 1;
    _layout.minimumLineSpacing=5;
    [self.view addSubview:self.collectView];
    for (NSDictionary *myDic in self.httpImages) {
        [self.httpImageData addObject:myDic];
    }
    [self.collectView reloadData];
}
/*上传图片*/

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSInteger imageCount = self.httpImageData.count + self.imageData.count;
    
    if (imageCount<9) {
        NSLog(@"%ld",(long)imageCount);
        return imageCount+1;
    }else {
        return imageCount;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId=@"cellID";
    NSInteger imageCount = self.httpImageData.count + self.imageData.count;
    NSLog(@"%ld",(long)imageCount);
    NSLog(@"%@",self.httpImageData);
    if (imageCount <9) {
        if (indexPath.row == imageCount) {
            ZWCollectionViewAddCell *addCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AddCell" forIndexPath:indexPath];
            return addCell;
        }else {
            ZWCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
            if (indexPath.row >= self.httpImageData.count) {
                cell.mianImageView.image = self.imageData[indexPath.row-self.httpImageData.count];
            }else {
                [cell.mianImageView sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",httpImageUrl,self.httpImageData[indexPath.row][@"url"]]] placeholderImage:[UIImage imageNamed:@"fu_img_no_02"]];
            }
            [self createOtherCollectionViewCell:cell cellForItemAtIndexPath:indexPath];
            return cell;
        }
    }else {
        ZWCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
        if (indexPath.row > self.httpImageData.count) {
            cell.mianImageView.image = self.imageData[indexPath.item-self.httpImageData.count];
        }else {
            [cell.mianImageView sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",httpImageUrl,self.httpImageData[indexPath.row][@"url"]]] placeholderImage:[UIImage imageNamed:@"fu_img_no_02"]];
        }
        [self createOtherCollectionViewCell:cell cellForItemAtIndexPath:indexPath ];
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
    if (btn.tag<self.httpImageData.count) {
        self.deleteImage = self.httpImageData[btn.tag][@"url"];
        [self deleteImages:btn.tag];
    }else {
        [self.imageData removeObjectAtIndex:btn.tag-self.httpImageData.count];
        [self.collectView reloadData];
    }
}
- (void)deleteImages:(NSInteger )index {
    ZWDeleteBoothPicturesRequest *request = [[ZWDeleteBoothPicturesRequest alloc]init];
    request.exhibitorId = self.exhibitorId;
    request.imagesId = self.httpImageData[index][@"id"];
    __weak typeof (self) weakSelf = self;
    [request postFormDataWithProgress:nil RequestCompleted:^(YHBaseRespense *respense) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (respense.isFinished) {
            NSLog(@"图片删除成功");
            [strongSelf deleteOSSImage:@[strongSelf.deleteImage]];
            [strongSelf.httpImageData removeObjectAtIndex:index];
            [strongSelf.collectView reloadData];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ZWEditExhibitionVC" object:nil];
            
        }
    }];
}
- (void)deleteOSSImage:(NSArray *)images {
    [ZWOSSConstants syncDeleteImages:images complete:^(DeleteImageState state) {
        if (state == 1) {
            NSLog(@"OSS图片删除成功");
        }
    }];
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
    NSInteger imageCount = self.imageData.count + self.httpImageData.count;
    if (indexPath.item == imageCount) {
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
