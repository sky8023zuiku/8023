//
//  ZWShareManager.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/4/8.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWShareManager.h"
#import "JhScrollActionSheetView.h"
#import "JhPageItemModel.h"

#import "JhScrollActionSheetView.h"
#import "JhPageItemModel.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface ZWShareManager()
@property(nonatomic, strong)NSMutableArray *shareArray;
@property(nonatomic, strong)NSMutableArray *otherArray;
@end

@implementation ZWShareManager

static ZWShareManager *shareManager = nil;

+ (instancetype)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[self alloc] init];
    });
    return shareManager;
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

-(NSMutableArray *)otherArray {
    if (!_otherArray) {
        _otherArray = [NSMutableArray new];
        
        NSArray *data = @[
                          @{
                              @"text" : @"二维码",
                              @"img" : @"QrCode_icon",
                          }];
        
        for (NSDictionary *mydic in data) {
            JhPageItemModel *model = [JhPageItemModel parseJSON:mydic];
            [self.otherArray addObject:model];
        }
    }
    return _otherArray;
}

- (void)shareWithData:(ZWShareModel *)model {
    
    __weak typeof (self) weakSelf = self;
    [JhScrollActionSheetView showShareActionSheetWithTitle:@"分享" shareDataArray:self.shareArray handler:^(JhScrollActionSheetView *actionSheet, NSInteger index) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        NSLog(@" 点击分享 index %ld ",(long)index);
        switch (index) {
            case 0:
                [strongSelf createShare:SSDKPlatformTypeWechat withData:model];
                break;
            case 1:
                [strongSelf createShare:SSDKPlatformSubTypeWechatTimeline withData:model];
                break;
            case 2:
                [strongSelf createShare:SSDKPlatformTypeSinaWeibo withData:model];
                break;
            case 3:
                [strongSelf createShare:SSDKPlatformSubTypeQQFriend withData:model];
                break;
            case 4:
                [strongSelf createShare:SSDKPlatformSubTypeQZone withData:model];
                break;
            default:
                break;
        }
    }];
    
}


- (void)shareTwoActionSheetWithData:(ZWShareModel *)model {
    
    JhScrollActionSheetView *actionSheet = [[JhScrollActionSheetView alloc]initWithTitle:@"分享" shareDataArray:self.shareArray otherDataArray:self.otherArray];
    __weak typeof (self) weakSelf = self;
    actionSheet.clickShareBlock = ^(JhScrollActionSheetView *actionSheet, NSInteger index) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        NSLog(@" 点击分享 index %ld ",(long)index);
        switch (index) {
            case 0:
                [strongSelf createShare:SSDKPlatformTypeWechat withData:model];
                break;
            case 1:
                [strongSelf createShare:SSDKPlatformSubTypeWechatTimeline withData:model];
                break;
            case 2:
                [strongSelf createShare:SSDKPlatformTypeSinaWeibo withData:model];
                break;
            case 3:
                [strongSelf createShare:SSDKPlatformSubTypeQQFriend withData:model];
                break;
            case 4:
                [strongSelf createShare:SSDKPlatformSubTypeQZone withData:model];
                break;
            default:
                break;
        }
    };
    
    actionSheet.clickOtherBlock = ^(JhScrollActionSheetView *actionSheet, NSInteger index) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if ([strongSelf.delegate respondsToSelector:@selector(clickItemWithIndex:)]) {
            [strongSelf.delegate clickItemWithIndex:index];
        }
    };
    [actionSheet show];
}


- (void)createShare:(SSDKPlatformType)type withData:(ZWShareModel *)model {
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSString *text;
    if (type == SSDKPlatformTypeSinaWeibo) {
        text = model.shareUrl;
    }else {
        text = model.shareDetail;
    }
    [shareParams SSDKSetupShareParamsByText:text
                                     images:model.shareTitleImage
                                        url:[NSURL URLWithString:model.shareUrl]
                                      title:model.shareName
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

@end
