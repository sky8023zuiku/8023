//
//  ZWEditCompanyIntroductionVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/5.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWEditCompanyIntroductionVC.h"
#import "ZWLicenseUploadVC.h"
#import "ZWCollectionViewCell.h"
#import "ZWCollectionViewAddCell.h"
#import <TZImagePickerController.h>
#import "ZWMineRqust.h"

@interface ZWEditCompanyIntroductionVC ()<UICollectionViewDelegate,UICollectionViewDataSource,TZImagePickerControllerDelegate,UITextViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    UIImagePickerController *_imagePickerController;
}
@property(nonatomic, strong)UICollectionView *collectView;
@property(nonatomic, strong)UICollectionViewFlowLayout *layout;
@property(nonatomic, strong)NSMutableArray *imageArray;//图片数组
@property(nonatomic, strong)NSMutableArray *httpImages;//网络图片
@property(nonatomic, strong)ZWTextView *companyProfile;//
@end

@implementation ZWEditCompanyIntroductionVC
-(UICollectionView *)collectView
{
    if (!_collectView) {
        _collectView=[[UICollectionView alloc]initWithFrame:CGRectMake(10, 0.3*kScreenWidth+50, kScreenWidth-20, kScreenWidth) collectionViewLayout:_layout];
    }
    _collectView.delegate=self;
    _collectView.dataSource=self;
    _collectView.backgroundColor = [UIColor whiteColor];
    [_collectView registerClass:[ZWCollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
    [_collectView registerClass:[ZWCollectionViewAddCell class] forCellWithReuseIdentifier:@"addCell"];
    _collectView.showsVerticalScrollIndicator=YES;
    _collectView.showsHorizontalScrollIndicator=YES;
    return _collectView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNavigationBar];
    if (self.merchantStatus == 3) {
        [self createValue];
    }
    NSLog(@"%@",self.parameter);
}
- (void)createValue {
    self.companyProfile.text = self.parameter[@"profile"];
    
    if ([self.companyProfile.text isEqualToString:@""]) {
        self.companyProfile.placeHolderLabel.text = @"请上传公司简介";
    }else {
        self.companyProfile.placeHolderLabel.text = @"";
    }
    
    self.httpImages = [NSMutableArray array];
    NSArray *images = self.parameter[@"profileList"];
    [self.httpImages addObjectsFromArray:images];
    NSLog(@"%lu",(unsigned long)images);
    [self.collectView reloadData];
}
- (void)createNavigationBar {
    UIBarButtonItem *leftOne = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack:)];
    leftOne.tintColor = [UIColor whiteColor];
    UIBarButtonItem *leftTwo = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ren_bianji_icon_topshang"] style:UIBarButtonItemStylePlain target:self action:@selector(goBackUser:)];
    leftTwo.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItems = @[leftOne,leftTwo];
    
    [[YNavigationBar sharedInstance]createRightBarWithTitle:@"下一步" barItem:self.navigationItem target:self action:@selector(rightItemClcik:)];
}
- (void)goBack:(UIBarButtonItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)goBackUser:(UIBarButtonItem *)item {
    UIViewController *vc = self.navigationController.viewControllers[1];
    [self.navigationController popToViewController:vc animated:YES];
}
- (void)rightItemClcik:(UIBarButtonItem *)item {
    if ([self.companyProfile.text isEqualToString:@""]) {
        [self showOneAlertWithTitle:@"请上传公司简介"];
        return;
    }
    NSInteger imageCount = self.httpImages.count+self.imageArray.count;
    
    if (imageCount == 0) {
        [self showOneAlertWithTitle:@"请上传公司简介图片"];
        return;
    }
    
    self.model.profile = self.companyProfile.text;
    self.model.profileFiles = self.imageArray;
    
    ZWLicenseUploadVC *uploadVC = [[ZWLicenseUploadVC alloc]init];
    uploadVC.title = @"营业执照上传";
    uploadVC.model = self.model;
    uploadVC.coverImage = self.coverImage;
    uploadVC.merchantStatus = self.merchantStatus;
    if (self.merchantStatus == 3) {
        uploadVC.parameter = @{@"licenseFile":self.parameter[@"licenseFile"],
                               @"authenticationId":self.parameter[@"authenticationId"],
                               @"coverFile":self.parameter[@"coverFile"]};
    }
    [self.navigationController pushViewController:uploadVC animated:YES];
    
}
- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.imageArray = [NSMutableArray array];
    
    self.companyProfile = [[ZWTextView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 0.3*kScreenWidth)];
    self.companyProfile.font = normalFont;
    self.companyProfile.delegate = self;
    [self.view addSubview:self.companyProfile];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.companyProfile.frame)+10, CGRectGetWidth(self.companyProfile.frame), 30)];
    titleLabel.text = @"请上传公司简介图片";
    titleLabel.font = smallMediumFont;
    titleLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    [self.view addSubview:titleLabel];
    
    _layout=[[UICollectionViewFlowLayout alloc]init];
    [_layout prepareLayout];
    //设置每个cell与相邻的cell之间的间距
    _layout.minimumInteritemSpacing = 1;
    _layout.minimumLineSpacing=3;
    
    [self.view addSubview:self.collectView];
}
#pragma mark textChange事件
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSLog(@"@@@@@@@");
    if (textView.text == nil||[textView.text isEqualToString:@""]) {
        self.companyProfile.placeHolderLabel.text = @"请上传公司简介";
    }else {
        self.companyProfile.placeHolderLabel.text = @"";
    }
    return YES;
}
/*上传图片*/

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.merchantStatus == 3) {
        return self.httpImages.count+self.imageArray.count+1;
    }else {
        return self.imageArray.count+1;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId=@"cellID";
    
    NSInteger itemCount;
    NSLog(@"-----%ld",(long)self.merchantStatus);
    if (self.merchantStatus == 3) {
        itemCount = self.httpImages.count+self.imageArray.count;
    }else {
        itemCount = self.imageArray.count ;
    }
    NSLog(@"-----%ld",(long)itemCount);
    if (indexPath.row == itemCount) {
        ZWCollectionViewAddCell *addCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"addCell" forIndexPath:indexPath];
        return addCell;
    }else {
        ZWCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
        if (indexPath.row>=self.httpImages.count) {
            cell.mianImageView.image = self.imageArray[indexPath.item-self.httpImages.count];
        }else {
            [cell.mianImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,self.httpImages[indexPath.row][@"url"]]] placeholderImage:[UIImage imageNamed:@"fu_img_no_02"]];
        }
        
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        deleteBtn.frame = CGRectMake((kScreenWidth-20)/5-28, 5, 20, 20);
        deleteBtn.layer.cornerRadius = 10;
        deleteBtn.layer.masksToBounds = YES;
        deleteBtn.backgroundColor = [UIColor whiteColor];
        deleteBtn.tag = indexPath.row;
        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete_icon"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteBtnClcik:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:deleteBtn];
        
        return cell;
    }
}

- (void)deleteBtnClcik:(UIButton *)btn {
    if (btn.tag<self.httpImages.count) {
        [self deleteHttpImage:btn.tag];
        
    }else {
        [self.imageArray removeObjectAtIndex:btn.tag-self.httpImages.count];
        [self.collectView reloadData];
    }
}
- (void)deleteHttpImage:(NSInteger )index {
    ZWDeleteProfileImageRequest *request = [[ZWDeleteProfileImageRequest alloc]init];
    request.authenticationId = self.parameter[@"authenticationId"];
    request.profilesImageId = self.httpImages[index][@"id"];
    [request postRequestCompleted:^(YHBaseRespense *respense) {
        if (respense.isFinished) {
            [ZWOSSConstants syncDeleteImage:self.httpImages[index][@"url"] complete:^(DeleteImageState state) {
                if (state == 1) {
                    NSLog(@"网络图片删除成功");
                }
            }];
            [self.httpImages removeObjectAtIndex:index];
            [self.collectView reloadData];
        }else {
            NSLog(@"删除失败");
        }
    }];
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreenWidth-20)/5-3, (kScreenWidth-20)/5-3);
}

//cell的点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSInteger itemCount = self.httpImages.count +self.imageArray.count;
    NSLog(@"--%lu",(unsigned long)self.httpImages.count);
    NSLog(@"--%lu",(unsigned long)self.imageArray.count);
    if (itemCount < 9) {
        NSLog(@"--%ld",(long)itemCount);
        if (indexPath.row == itemCount) {
            __weak typeof (self) weakSelf = self;
            UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                __strong typeof (weakSelf) strongSelf = weakSelf;
                [strongSelf callTheAlbum];
            }];
            [alertController addAction:actionOne];
            UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                __strong typeof (weakSelf) strongSelf = weakSelf;
                [strongSelf callTheCamera];
            }];
            [alertController addAction:actionTwo];
            UIAlertAction *actionThree = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:actionThree];
            [self presentViewController:alertController animated:YES completion:nil];
        } else {
            NSLog(@"33333");
            
        }
    }else {
        [self showOneAlertWithTitle:@"最多只能上传9张图片"];
    }
}
- (void)callTheAlbum {
    NSInteger number = 9-(self.imageArray.count);
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc]initWithMaxImagesCount:number columnNumber:5 delegate:self];
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    [self.imageArray addObjectsFromArray:photos];
    [self.collectView reloadData];
    NSLog(@"===%@",self.imageArray);
}

- (void)createImagePicker {
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.allowsEditing = YES;
}

- (void)callTheCamera {
    [self createImagePicker];
    //判断是否可以打开照相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        //摄像头
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:_imagePickerController animated:YES completion:nil];
    }
    else{
        NSLog(@"没有摄像头");
    }
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info {

    UIImage *ima = info[UIImagePickerControllerEditedImage];
    [self.imageArray addObject:ima];
    [self.collectView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
//进入拍摄页面点击取消按钮
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)showOneAlertWithTitle:(NSString *)title {
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:title confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        
    } showInView:self];
}


@end
