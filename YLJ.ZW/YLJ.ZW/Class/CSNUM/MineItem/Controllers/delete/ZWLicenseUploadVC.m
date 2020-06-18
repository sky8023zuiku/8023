//
//  ZWLicenseUploadVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/5.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWLicenseUploadVC.h"
#import "ZWMineRqust.h"
#import <UIButton+WebCache.h>

@interface ZWLicenseUploadVC ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    UIImagePickerController *_imagePickerController;
}
@property(nonatomic, strong)UIButton *imageBtn;
@property(nonatomic, strong)UIImage *licenseImages;
@end

@implementation ZWLicenseUploadVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNavigationBar];
    
    NSLog(@"%@",self.model.coverFile);
    NSLog(@"%@",self.model.profile);
    NSLog(@"%@",self.model.profileFiles);
    NSLog(@"%@",self.parameter);
    
}
- (void)createNavigationBar {
    UIBarButtonItem *leftOne = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack:)];
    leftOne.tintColor = [UIColor whiteColor];
    UIBarButtonItem *leftTwo = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ren_bianji_icon_topshang"] style:UIBarButtonItemStylePlain target:self action:@selector(goBackUser:)];
    leftTwo.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItems = @[leftOne,leftTwo];
    
    [[YNavigationBar sharedInstance]createRightBarWithTitle:@"提交" barItem:self.navigationItem target:self action:@selector(rightItemClcik:)];
}
- (void)goBack:(UIBarButtonItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)goBackUser:(UIBarButtonItem *)item {
    UIViewController *vc = self.navigationController.viewControllers[1];
    [self.navigationController popToViewController:vc animated:YES];
}
- (void)rightItemClcik:(UIBarButtonItem *)item {
    if (self.merchantStatus != 3) {
        if (!self.licenseImages) {
            [self showOneAlertWithTitle:@"请上传营业执照"];
            return;
        }
    }
    __weak typeof (self) weakSelf = self;
    [[ZWAlertAction sharedAction]showTwoAlertTitle:@"提示" message:@"是否确认提交认证信息" cancelTitle:@"否" confirmTitle:@"是" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf uploadLogo];
    } actionCancel:^(UIAlertAction * _Nonnull actionCancel) {
        
    } showInView:self];
}
- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.imageBtn.frame = CGRectMake(0.08*kScreenWidth, 10, 0.2*kScreenWidth, 0.2*kScreenWidth);
    [self.imageBtn setBackgroundImage:[UIImage imageNamed:@"ren_bianji_icon_chuan"] forState:UIControlStateNormal];
    self.imageBtn.adjustsImageWhenHighlighted = NO;
    [self.imageBtn addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.imageBtn];
    
    if (self.merchantStatus == 3) {
        [self.imageBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,self.parameter[@"licenseFile"]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"ren_bianji_icon_chuan"]];
    }
    UILabel *noticeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.imageBtn.frame), CGRectGetMaxY(self.imageBtn.frame), 0.84*kScreenWidth, 30)];
    noticeLabel.text = @"注：此处为营业执照照片上传";
    noticeLabel.font = smallFont;
    noticeLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    [self.view addSubview:noticeLabel];
}
- (void)imageBtnClick:(UIButton *)btn {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof (self) weakSelf = self;
    UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf openPhotoLibrary];
    }];
    [alertController addAction:actionOne];
    UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf openCamera];
    }];
    [alertController addAction:actionTwo];
    UIAlertAction *actionThree = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:actionThree];
    [self presentViewController:alertController animated:YES completion:nil];
}
/**
 *  打开相册
 */
-(void)openPhotoLibrary{
    [self createImagePicker];
    // 进入相册
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:_imagePickerController animated:YES completion:^{
            NSLog(@"打开相册");
        }];
    }else{
        NSLog(@"不能打开相册");
    }
}
/**
 *  调用照相机
 */
- (void)openCamera
{
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
    self.licenseImages = ima;
    [self.imageBtn setImage:ima forState:UIControlStateNormal];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
//进入拍摄页面点击取消按钮
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)showOneAlertWithTitle:(NSString *)title {
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:title confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        
    } showInView:self];
}
- (void)createImagePicker {
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.navigationBar.tintColor = [UIColor whiteColor];
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    _imagePickerController.allowsEditing = YES;
}


//******************************************************************网络请求*********************************************************************/

- (void)uploadLogo {
    __weak typeof (self) weakSelf = self;
    [ZWOSSConstants syncUploadImage:self.coverImage complete:^(NSArray<NSString *> * _Nonnull names, UploadImageState state) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (state) {
            [strongSelf uploadImagesWithLogoImage:names[0]];
        }else {
            [strongSelf showOneAlertWithTitle:@"企业认证资料提交失败，请检查网络或稍后再试"];
        }
    }];
}

- (void)uploadImagesWithLogoImage:(NSString *)logoImage {
    if (self.model.profileFiles != 0) {
        __weak typeof (self) weakSelf = self;
        [ZWOSSConstants syncUploadImages:self.model.profileFiles complete:^(NSArray<NSString *> * _Nonnull names, UploadImageState state) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            if (state == 1) {
                NSLog(@"我的简介图片%@",names);
                [strongSelf uploadImagesWithLogoImage:logoImage withImages:names];
            }else {
                [strongSelf showOneAlertWithTitle:@"企业认证资料提交失败，请检查网络或稍后再试"];
                [strongSelf deleteImages:@[logoImage] where:@"logo图片"];
            }
        }];
    }else {
        [self uploadImagesWithLogoImage:logoImage withImages:@[]];
    }
}

- (void)uploadImagesWithLogoImage:(NSString *)logoImage withImages:(NSArray *)images {
    
    __weak typeof (self) weakSelf = self;
    [ZWOSSConstants syncUploadImage:self.imageBtn.imageView.image complete:^(NSArray<NSString *> * _Nonnull names, UploadImageState state) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (state == 1) {
            [strongSelf uploadImagesWithLogoImage:logoImage withImages:images withLicense:names[0]];
        }else {
            [strongSelf showOneAlertWithTitle:@"企业认证资料提交失败，请检查网络或稍后再试"];
            NSMutableArray *myArray = [NSMutableArray array];
            [myArray addObjectsFromArray:images];
            [myArray addObject:logoImage];
            [strongSelf deleteImages:myArray where:@"logo图片和简介图片"];
        }
    }];
}
- (void)uploadImagesWithLogoImage:(NSString *)logoImage withImages:(NSArray *)images withLicense:(NSString *)licenseImage {
    
    ZWEnterpriseCertificationRequst *request = [[ZWEnterpriseCertificationRequst alloc]init];
    if (self.merchantStatus == 3) {
        request.authenticationId = self.parameter[@"authenticationId"];
    }
    request.name = self.model.name;//公司名称
    request.industryIdList = self.model.industryIdList;
    request.identityId = self.model.identityId;
    request.email = self.model.email;//公司邮箱
    request.website = self.model.website;//公司网址
    request.telephone = self.model.telephone;
    request.address = self.model.address;
    request.product = self.model.product;
    request.requirement = self.model.requirement;
    request.profile = self.model.profile;
    request.coverFile = logoImage;
    request.profileFiles = images;
    request.licenseFile = licenseImage;
    __weak typeof (self) weakSelf = self;
    [request postRequestCompleted:^(YHBaseRespense *respense) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (respense.isFinished) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshUserInformation" object:nil];
            [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:@"企业认证信息上传成功，我们将在两个工作日内为您审核，请耐心等待" confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
                __strong typeof (weakSelf) strongSelf = weakSelf;
                UIViewController *vc = strongSelf.navigationController.viewControllers[1];
                [strongSelf.navigationController popToViewController:vc animated:YES];
            } showInView:strongSelf];
            
            if (self.merchantStatus == 3) {
                NSArray *oldImages = @[self.parameter[@"coverFile"],self.parameter[@"licenseFile"]];
                [self deleteImages:oldImages where:@"老logo和老图片删除成功"];
            }
        }else {
            [strongSelf showOneAlertWithTitle:@"企业认证资料提交失败，请检查网络或稍后再试"];
            NSMutableArray *myArray = [NSMutableArray array];
            [myArray addObjectsFromArray:images];
            [myArray addObject:logoImage];
            [myArray addObject:licenseImage];
            [strongSelf deleteImages:myArray where:@"全部图片"];
        }
    }];
}
- (void)deleteImages:(NSArray *)images where:(NSString *)message {
    [ZWOSSConstants syncDeleteImages:images complete:^(DeleteImageState state) {
        if (state == 1) {
            NSLog(@"%@删除成功",message);
        }else {
            NSLog(@"%@删除失败",message);
        }
    }];
}

- (void)showOneAlertWithMessage:(NSString *)message {
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:message confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        
    } showInView:self];
}

@end
