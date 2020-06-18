//
//  ZWPdfManager.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/6/18.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWPdfManager.h"
#import "ZWPdfBreviewVC.h"
#import "UIViewController+YCPopover.h"
#import <MBProgressHUD.h>

@implementation ZWPdfManager

static ZWPdfManager *shareManager = nil;
+ (instancetype)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[self alloc] init];
    });
    return shareManager;
}

- (void)createPdfBreview:(UIViewController *)viewController withUrl:(NSString *)url withFileName:(NSString *)fileName {
    [self downloadWithUrl:url withViewController:viewController withFileName:fileName withType:0];
}

- (void)downloadPdfProfile:(UIViewController *)viewController withUrl:(NSString *)url withFileName:(NSString *)fileName {
    [self downloadWithUrl:url withViewController:viewController withFileName:fileName withType:1];
}

- (void)downloadWithUrl:(NSString *)URLStr withViewController:(UIViewController *)viewController withFileName:(NSString *)fileName withType:(NSInteger)type {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *URL = [NSURL URLWithString:URLStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    //判断是否存在
    if([self isFileExist:fileName]) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        NSURL *url = [documentsDirectoryURL URLByAppendingPathComponent:fileName];
        if (type == 0) {
            ZWPdfBreviewVC *vc = [[ZWPdfBreviewVC alloc]init];
            vc.url = url;
            vc.title = fileName;
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
            [viewController yc_bottomPresentController:nav presentedHeight:kScreenHeight completeHandle:nil];
        }else {
            [self shareLog:url withViewController:viewController];
        }
    }else {
        [MBProgressHUD showHUDAddedTo:viewController.view animated:YES];
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        NSURL *url = [documentsDirectoryURL URLByAppendingPathComponent:fileName];
        __weak typeof (self) weakSelf = self;
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress){
            
        } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            return url;
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [MBProgressHUD hideHUDForView:viewController.view animated:YES];
            if (type == 0) {
                ZWPdfBreviewVC *vc = [[ZWPdfBreviewVC alloc]init];
                vc.url = url;
                vc.title = fileName;
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
                [viewController yc_bottomPresentController:nav presentedHeight:kScreenHeight completeHandle:nil];
            }else {
                [strongSelf shareLog:filePath withViewController:viewController];
            }
        }];
        [downloadTask resume];
    }
    
}

- (void)shareLog:(NSURL *)url withViewController:(UIViewController *)viewController{
    NSArray *urls=@[url];
    UIActivityViewController *activituVC=[[UIActivityViewController alloc]initWithActivityItems:urls applicationActivities:nil];
    NSArray *cludeActivitys=@[UIActivityTypePostToFacebook,
                              UIActivityTypePostToTwitter,
                              UIActivityTypePostToWeibo,
                              UIActivityTypePostToVimeo,
                              UIActivityTypeMessage,
                              UIActivityTypeMail,
                              UIActivityTypeCopyToPasteboard,
                              UIActivityTypePrint,
                              UIActivityTypeAssignToContact,
                              UIActivityTypeSaveToCameraRoll,
                              UIActivityTypeAddToReadingList,
                              UIActivityTypePostToFlickr,
                              UIActivityTypePostToTencentWeibo];
    activituVC.excludedActivityTypes=cludeActivitys;
    //显示分享窗口
    [viewController presentViewController:activituVC animated:YES completion:nil];
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

@end
