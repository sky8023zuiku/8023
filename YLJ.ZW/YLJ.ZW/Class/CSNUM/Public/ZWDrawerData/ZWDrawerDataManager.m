//
//  ZWDrawerDataManager.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/12/21.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWDrawerDataManager.h"
#import "ZWMainSaveLocation.h"

@implementation ZWDrawerDataManager

static ZWDrawerDataManager *shareManager = nil;

+ (instancetype)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[self alloc] init];
    });
    return shareManager;
}

- (void)requestScreeningData {
    [self requestCountriesList];
    [self requestCitiesList];
    [self requestIndustriesList];
    
}
- (void)requestCountriesList {
    
    [[ZWDataAction sharedAction]getReqeustWithURL:zwTakeCountriesList parametes:@{} successBlock:^(NSDictionary * _Nonnull data) {
        if (zw_issuccess) {
            [[ZWMainSaveLocation shareAction]saveCountroiesList:data[@"data"]];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];

}
- (void)requestCitiesList {
    
    [[ZWDataAction sharedAction]postReqeustWithURL:zwTakeCitiesList parametes:@{@"parentId":@"1"} successBlock:^(NSDictionary * _Nonnull data) {
        if (zw_issuccess) {
            [[ZWMainSaveLocation shareAction]saveCitiesList:data[@"data"]];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];
    
}
- (void)requestIndustriesList {
    NSDictionary *mydic = @{@"level":@"2"};
    [[ZWDataAction sharedAction]getReqeustWithURL:zwTakeIndustriesList parametes:mydic successBlock:^(NSDictionary * _Nonnull data) {
        if (zw_issuccess) {
            [[ZWMainSaveLocation shareAction]saveIndustriesList:data[@"data"]];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];
}



@end
