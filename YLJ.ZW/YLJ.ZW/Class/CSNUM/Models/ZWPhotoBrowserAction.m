//
//  ZWPhotoBrowserAction.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/2/11.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWPhotoBrowserAction.h"
#import <YHPhotoBrowser.h>

@implementation ZWPhotoBrowserAction
static ZWPhotoBrowserAction *shareAction = nil;
+ (instancetype)shareAction{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareAction = [[self alloc] init];
    });
    return shareAction;
}

- (void)showImageViewUrls:(NSArray *)images tapIndex:(NSInteger)index {
    YHPhotoBrowser *photoView=[[YHPhotoBrowser alloc]init];
    photoView.urlImgArr= images;
    photoView.indexTag=index;
    [photoView show];
}
@end
