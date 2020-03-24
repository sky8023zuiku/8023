//
//  SQPhotosManager.h
//  JHTDoctor
//
//  Created by yangsq on 2017/5/23.
//  Copyright © 2017年 yangsq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQPhotosManager : NSObject
+ (instancetype)sharedManager;

- (void)showPhotosWithfromViews:(NSArray *)fromViews images:(NSArray *)images imageUrls:(NSArray *)imageUrls describtion:(NSArray *)describes index:(NSInteger)index;
@end
