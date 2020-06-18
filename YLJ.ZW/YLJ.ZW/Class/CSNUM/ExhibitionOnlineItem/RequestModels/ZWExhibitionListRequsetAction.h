//
//  ZWExhibitionListRequsetAction.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/11/8.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWExhibitionListRequsetAction : NSObject
@property(nonatomic, copy)NSString *city;
@property(nonatomic, copy)NSString *country;
@property(nonatomic, copy)NSString *industryId;
@property(nonatomic, copy)NSString *monthTime;
@property(nonatomic, copy)NSString *yearTime;
@property(nonatomic, copy)NSString *name;
@property(nonatomic, strong)NSDictionary *pageQuery;
@end

NS_ASSUME_NONNULL_END
