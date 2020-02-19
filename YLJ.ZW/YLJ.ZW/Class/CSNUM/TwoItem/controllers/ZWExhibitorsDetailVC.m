//
//  ZWExhibitorsDetailVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/26.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWExhibitorsDetailVC.h"
#include "ZWExhibitorsDetailModel.h"
#import "MBProgressHUD.h"
#import <QuickLook/QuickLook.h>

@interface ZWExhibitorsDetailVC ()<UITableViewDelegate,UITableViewDataSource,QLPreviewControllerDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSArray *dataSource;
@property (strong, nonatomic) QLPreviewController *previewController;
@property (copy, nonatomic) NSURL *fileURL;
@end

@implementation ZWExhibitorsDetailVC

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-0.1*kScreenWidth) style:UITableViewStyleGrouped];
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createRequest];
}
- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    self.previewController  =  [[QLPreviewController alloc]  init];
    self.previewController.dataSource  = self;
}

#pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
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
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1];
    [cell.contentView addSubview:lineView];
    NSArray *titles =@[@"产品手册:",@"主营项目:",@"需求说明:",@"公司简介:"];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 0.16*kScreenWidth, 0.12*kScreenWidth)];
    titleLabel.text = titles[indexPath.row];
    titleLabel.font = smallMediumFont;
    [cell.contentView addSubview:titleLabel];
    
    ZWExhibitorsDetailModel *model = self.dataSource[0];
    
    if (indexPath.row == 0) {
        lineView.frame = CGRectMake(15, 0.24*kScreenWidth-1, kScreenWidth-30, 1);
        
        UIImageView *manualImage = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), 0.03*kScreenWidth, 0.18*kScreenWidth, 0.18*kScreenWidth)];
        manualImage.backgroundColor = [UIColor redColor];
        manualImage.image = [UIImage imageNamed:@"ren_fabu_img_pdf"];
        [cell.contentView addSubview:manualImage];
        
        UILabel *companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(manualImage.frame)+5, 0, 0.66*kScreenWidth-35, CGRectGetHeight(titleLabel.frame))];
        companyLabel.text = model.name;
        companyLabel.font = smallMediumFont;
        [cell.contentView addSubview:companyLabel];
        
        UIButton *browseBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        browseBtn.frame = CGRectMake(CGRectGetMinX(companyLabel.frame), CGRectGetMaxY(manualImage.frame)-0.07*kScreenWidth, 0.1*kScreenWidth, 0.07*kScreenWidth);
        [browseBtn setTitle:@"预览" forState:UIControlStateNormal];
        [browseBtn addTarget:self action:@selector(browseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:browseBtn];
    
    }else if (indexPath.row == 1) {
        lineView.frame = CGRectMake(15, 0.12*kScreenWidth-1, kScreenWidth-30, 1);
        
        UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), 0, 0.84*kScreenWidth-30, CGRectGetHeight(titleLabel.frame))];
        detailLabel.font = smallMediumFont;
        if (model.product.length == 0) {
            detailLabel.text = @"暂无";
        }else {
            detailLabel.text = model.product;
        }
        [cell.contentView addSubview:detailLabel];

    }else if (indexPath.row == 2) {
        lineView.frame = CGRectMake(15, 0.12*kScreenWidth-1, kScreenWidth-30, 1);
            
        UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), 0, 0.84*kScreenWidth-30, CGRectGetHeight(titleLabel.frame))];
        detailLabel.font = smallMediumFont;
        if (model.requirement.length == 0) {
            detailLabel.text = @"暂无";
        }else {
            detailLabel.text = model.requirement;
        }
        [cell.contentView addSubview:detailLabel];
    }else {
        
        CGFloat height = [[ZWToolActon shareAction]adaptiveTextHeight:model.profile font:smallMediumFont];
        UILabel *introduction = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(titleLabel.frame), kScreenWidth-30, height)];
        introduction.text = model.profile;
        introduction.font = smallMediumFont;
        introduction.numberOfLines = 0;
        [cell.contentView addSubview:introduction];
        
    }
}
#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 0.24*kScreenWidth;
    } else if (indexPath.row == 1) {
        return 0.12*kScreenWidth;
    } else if (indexPath.row == 2) {
        return 0.12*kScreenWidth;
    } else {
        return 0.5*kScreenWidth;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (void)browseBtnClick:(UIButton *)btn {
    ZWExhibitorsDetailModel *model = self.dataSource[0];
    if (! model.productUrl||[model.productUrl isEqualToString:@""]) {
        [self showOneAlertWithMessage:@"暂无产品手册"];
        return;
    }
    [self downloadWithUrl:model.productUrl];
}
//下载文件
- (void)downloadWithUrl:(NSString *)URLStr{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

    NSArray *array = [URLStr componentsSeparatedByString:@","];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",httpImageUrl,[array objectAtIndex:1]];
    NSString *fileName = [NSString stringWithFormat:@"%@",[array objectAtIndex:0]]; //获取文件名称
    NSURL *URL = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    //判断是否存在
    if([self isFileExist:fileName]) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        NSURL *url = [documentsDirectoryURL URLByAppendingPathComponent:fileName];
        self.fileURL = url;
        [self presentViewController:self.previewController animated:YES completion:nil];
    }else {
        [MBProgressHUD showHUDAddedTo:[self getCurrentVC].view animated:YES];
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress){
            
        } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            NSURL *url = [documentsDirectoryURL URLByAppendingPathComponent:fileName];
            return url;
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            [MBProgressHUD hideHUDForView:[self getCurrentVC].view animated:YES];
            self.fileURL = filePath;
            [self presentViewController:self.previewController animated:YES completion:nil];
        }];
        [downloadTask resume];
    }
    
}

#pragma mark - QLPreviewControllerDataSource
-(id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    return self.fileURL;
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController{
    return 1;
}


//判断文件是否已经在沙盒中存在
-(BOOL) isFileExist:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    return result;
}
- (UIViewController *)getCurrentVC {
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
    } else {
        result = window.rootViewController;
    }
    return result;
}

- (void)createRequest {
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]postFormDataReqeustWithURL:zwExhibitorsDetails parametes:@{@"merchantId":self.exhibitorId} successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (zw_issuccess) {
            NSDictionary *myData = data[@"data"][@"zwMerchantVo"];
            NSMutableArray *myArray = [NSMutableArray array];
            ZWExhibitorsDetailModel *model = [ZWExhibitorsDetailModel parseJSON:myData];
            [myArray addObject:model];
            strongSelf.dataSource = myArray;
            [strongSelf.tableView reloadData];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    } showInView:self.view];
}



- (void)showOneAlertWithMessage:(NSString *)message {
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:message confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        
    } showInView:self];
}
@end
