//
//  CSDrawerIndustiesModel.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/11/20.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CSDrawerIndustiesModel : NSObject
@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *industriesId;
@property(nonatomic, assign)BOOL isSelected;
+ (id)parseJSON:(NSDictionary *)jsonDic;
@end

NS_ASSUME_NONNULL_END
