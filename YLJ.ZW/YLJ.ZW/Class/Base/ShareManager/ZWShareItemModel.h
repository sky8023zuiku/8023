//
//  ZWShareItemModel.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/5/14.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWShareItemModel : NSObject
@property(nonatomic,copy) NSString *text;
@property(nonatomic,copy) NSString *img;
+ (id)parseJSON:(NSDictionary *)jsonDic;
@end

NS_ASSUME_NONNULL_END
