//
//  SQPhotosManager.m
//  JHTDoctor
//
//  Created by yangsq on 2017/5/23.
//  Copyright © 2017年 yangsq. All rights reserved.
//

#import "SQPhotosManager.h"
#import "SQPhotosView.h"

@implementation SQPhotosManager
+ (instancetype)sharedManager
{
    static SQPhotosManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SQPhotosManager alloc]init];
    });
    return instance;
}

- (void)showPhotosWithfromViews:(NSArray *)fromViews images:(NSArray *)images imageUrls:(NSArray *)imageUrls describtion:(NSArray *)describes index:(NSInteger)index {
    
    NSMutableArray *tempArray = @[].mutableCopy;
    NSInteger arrayCount = 0;
    if (fromViews.count) {
        arrayCount = fromViews.count;
    }else if (imageUrls.count){
       arrayCount = imageUrls.count;
    }else if (images.count){
        arrayCount = images.count;
    }else if (describes.count) {
        arrayCount = describes.count;
    }
    for (NSInteger i=0; i<arrayCount; i++) {
        SQPhotoItem *item = [SQPhotoItem new];
        
        if (fromViews.count) {
            item.thumbView = fromViews[i];
        }
        if (images.count) {
            item.thumbImage = images[i];
        }
        if (imageUrls.count) {
            item.largeImageURL = [NSURL URLWithString:imageUrls[i]];
        }
        if (describes.count) {
            item.describeStr = describes[i];
        }
        [tempArray addObject:item];
    }
    
    SQPhotosView *photoView = [[SQPhotosView alloc]initWithPhotoItems:tempArray];
    [photoView showViewFromIndex:index];
}

@end
