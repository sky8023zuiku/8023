//
//  ZWAreaManager.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/6/3.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWAreaManager.h"
#import "ZWCPCitiesModel.h"
#import "ZWAreaCountriesSelectionVC.h"

@implementation ZWAreaManager

static ZWAreaManager *shareManager = nil;
+ (instancetype)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[self alloc] init];
    });
    return shareManager;
}

- (void)areaSelectionShow:(UIViewController *)viewController {
    [[ZWDataAction sharedAction]postReqeustWithURL:zwSelectCPC parametes:@{@"areaId":@"",@"level":@"0"} successBlock:^(NSDictionary * _Nonnull data) {
        if (zw_issuccess) {
            NSArray *myData = data[@"data"];
            NSMutableArray *myArray = [NSMutableArray array];
            for (NSDictionary *myDic in myData) {
                ZWCPCitiesModel *model = [ZWCPCitiesModel parseJSON:myDic];
                [myArray addObject:model];
            }
            ZWAreaCountriesSelectionVC *vc = [[ZWAreaCountriesSelectionVC alloc]init];
            vc.title = @"选择国家";
            vc.dataArray = myArray;
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
            [viewController yc_bottomPresentController:nav presentedHeight:kScreenHeight completeHandle:nil];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    } showInView:viewController.view];
}


@end
